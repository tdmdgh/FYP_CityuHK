N = 5000;
HG = createHenneberg(N);
num_edges = numedges(HG);
avg_d = num_edges*2/N;
[RG,p] = createRandomGraph(N,num_edges);
%% Create Network

% [RG1,p1] = createRandomGraph_avgd(N,avg_d);

%%Degree Distribution
figure('NumberTitle', 'off', 'Name', 'Degree distribution');
for cycle = 1 : 2
    switch cycle
        case 1 
            G = RG;
            N = numedges(RG);
            name = 'Random Graph';
        
        case 2 
            G = HG;   
            N = numedges(HG);
            name = 'Henneberg Graph ';
    end
    subplot(1,2,cycle); degreedistribution(G);title(name);
end
%% Removal Node
% Strategy1: random attacks (RND)
figure('NumberTitle', 'off', 'Name', 'RND');
for cycle = 1 : 2
    switch cycle
        case 1 
            G = RG;
            N = numnodes(RG);
            name = 'Random Graph';
        case 2 
            G = HG;   
            N = numnodes(HG);
            name = 'Henneberg Graph ';
    end

    y = zeros(1,N+1);
    x = 0 : 1/N : 1;
    G1 = G;
    for i = 1 : N
        rm_node = getRND(G1,1);
        G1= rmnode(G1,rm_node);
        percent = getProb(G1);
        y(1,i+1) = percent;
    end
    area = trapz(x,y);    
    name = append(name,newline,'area : ',num2str(area));
    subplot(2,2,cycle); plot(x,y);title(name);
    subplot(2,2,cycle+2); plot(G);title(name);
end

% Strategy2: targeted betweenness-based attacks (TBA)
figure('NumberTitle', 'off', 'Name', 'TBA');
for cycle = 1 : 2
    switch cycle
        case 1 
            G = RG;
            N = numnodes(RG);
            name = 'Random Graph';
        case 2 
            G = HG;   
            N = numnodes(HG);
            name = 'Henneberg Graph ';
    end
    y = zeros(1,N+1);
    x = 0 : 1/N : 1;
    G1 = G;
    for i = 1 : N
        rm_node = getTBA(G1,1);
        G1= rmnode(G1,rm_node);
        percent = getProb(G1);
        y(1,i+1) = percent;
    end
    %The larger area at the bottom, the more robust 
    area = trapz(x,y);    
    name = append(name,newline,'area : ',num2str(area));
    subplot(2,2,cycle); plot(x,y);title(name);
    subplot(2,2,cycle+2); plot(G);title(name);
end

% Strategy3: targeted degree-based attacks (TDA)
figure('NumberTitle', 'off', 'Name', 'TDA');
for cycle = 1 : 2
    switch cycle
        case 1 
            G = RG;
            N = numnodes(RG);
            name = 'Random Graph';
        case 2 
            G = HG;   
            N = numnodes(HG);
            name = 'Henneberg Graph ';
    end
    y = zeros(1,N+1);
    x = 0 : 1/N : 1;
    G1 = G;
    for i = 1 : N
        rm_node = getTDA(G1,1);
        G1= rmnode(G1,rm_node);
        percent = getProb(G1);
        y(1,i+1) = percent;
    end
    
    %The larger area at the bottom, the more robust 
    area = trapz(x,y);    
    name = append(name,newline,'area : ',num2str(area));
    subplot(2,2,cycle); plot(x,y);title(name);
    subplot(2,2,cycle+2); plot(G);title(name);
end


% The probability that a node is part of the giant component
function p = getProb(G)
    if numnodes(G) == 0
        p = 0;
    else
        components = conncomp(G);
        giantComp = mode(components);
        I = find(components == giantComp);
        p = size(I,2) / numnodes(G);
    end
end




function outputnodes = getRND(G,k)
outputnodes=[];
if k > numnodes(G)
    k = numnodes(G);
end
for i = 1 : k       
    new = randi(numnodes(G));
    while find(outputnodes == new) 
        new = randi(numnodes(G));
    end
    outputnodes(end+1)=new;    
end
end

function outputnodes = getTBA(G,k)
outputnodes=[];
if k > numnodes(G)
    k = numnodes(G);
end
wbc = centrality(G,'betweenness','Cost',ones(numedges(G),1))';
for i = 1 : k
    new = find(wbc == max(wbc));
    size_new = size(new);
    if size_new(2) >1
        outputnodes(end+1) = new(1);
        wbc(new(1)) = 0;
    else
        outputnodes(end+1) = new;
        wbc(new) = 0;
    end
end
end

function outputnodes = getTDA(G,k)
outputnodes = [];
degrees = degree(G)';
if k > numnodes(G)
    k = numnodes(G);
end
for i = 1 : k
    new = find(degrees == max(degrees));
    size_new = size(new);
    if size_new(2) >1
        outputnodes(end+1) = new(1);
        degrees(new(1)) = 0;
    else
        outputnodes(end+1) = new;
        degrees(new) = 0;    
    end
end
end

