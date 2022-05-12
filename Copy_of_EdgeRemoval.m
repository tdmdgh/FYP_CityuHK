N = 100;
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
%% Removal Edges
% Strategy1: random attacks (RND)
figure('NumberTitle', 'off', 'Name', 'RND _ edge');
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
    [sOut,tOut] = findedge(G);
    y = zeros(1,N+1);
    x = 0 : 1/N : 1;

    G1 = G;
    for i = 1 : N
        idx = getRND(G,1);
        G1= rmedge(G1,sOut(i),tOut(i));
        percent = getProb(G1);
        y(1,i+1) = percent;
    end
    area = trapz(x,y);    
    name = append(name,newline,'area : ',num2str(area));
    subplot(2,2,cycle); plot(x,y);title(name);
    subplot(2,2,cycle+2); plot(G);title(name);
end


% Strategy2: targeted Max Flow - based attacks (MFA)
figure('NumberTitle', 'off', 'Name', 'Max flow _ edge');
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
    [sOut,tOut] = findedge(G);
    maxflows = getMaxflow(G);
    
    
    
    y = zeros(1,N+1);
    x = 0 : 1/N : 1;
    
    G1 = G;
    for i = 1 : N
        index = find(maxflows == max(maxflows));
        G= rmedge(G,sOut(index),tOut(index));
        percent = getProb(G);
        y(1,i+1) = percent;
        maxflows(index) = -1;
    end

    %The larger area at the bottom, the more robust 
    area = trapz(x,y);    
    name = append(name,newline,'area : ',num2str(area));
    subplot(2,2,cycle); plot(x,y);title(name);
    subplot(2,2,cycle+2); plot(G1);title(name);
end

function maxflows = getMaxflow(G)
nodes = numnodes(G);
edges = numedges(G);
[sOut,tOut] = findedge(G);
maxflows = zeros(edges,1);
for k = 1 : nodes
    for l = k : nodes
        if k~=l
            [mf,GF] = maxflow(G,k,l);
            flows_table = GF.Edges(:,1);
            flows_array = table2array(flows_table);
            num_flows = size(flows_array);
            for m = 1 : num_flows(1,1)
                s = flows_array(m,1);
                t = flows_array(m,2);
                for o = 1 : edges
                    if s == sOut(o) && t == tOut(o)
                        maxflows(o,1) = maxflows(o,1) + 1;
                        continue;
                    end
                    if t == sOut(o) && s == tOut(o)                            
                            maxflows(o,1) = maxflows(o,1) + 1;
                            continue;
                    end
                end
                
            end
        end
    end
end

            
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
if k > numedges(G)
    k = numedges(G);
end
for i = 1 : k       
    new = randi(numedges(G));
    while find(outputnodes == new) 
        new = randi(numedges(G));
    end
    outputnodes(end+1)=new;    
end
end


