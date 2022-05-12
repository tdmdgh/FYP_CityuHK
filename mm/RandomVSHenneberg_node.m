N = 500;
% avg_d = 8;
avg_d = 3.988;
Edge = avg_d * N / 2;

%% Create Network
HG_3 = createHennebergGraph(N, avg_d, 3,0);
HG_4 = createHennebergGraph(N, avg_d, 4,0);
HG_5_0 = createHennebergGraph(N, avg_d, 5,0);
% HG_5_1 = createHennebergGraph(N, avg_d, 5,1);
HG_5_1 = createHenneberg(500);
% [RG,p] = createRandomGraph_1(N,Edge);
[RG,p] = createRandomGraph_avgd(N,avg_d);
% 
% %% Removal Node
% % Strategy1: random attacks (RND)
% figure('NumberTitle', 'off', 'Name', 'RND');
% for cycle = 1 : 5
%     switch cycle
%         case 1 
%             G = RG;
%             N = numnodes(RG);
%             name = 'Random Graph';
%         case 2 
%             G = HG_3;
%             N = numnodes(HG_3);
%             name = 'Henneberg Graph - triangle';
%         case 3 
%             G = HG_4;
%             N = numnodes(HG_4);
%             name = 'Henneberg Graph - square';
%         case 4 
%             G = HG_5_0;   
%             N = numnodes(HG_5_0);
%             name = 'Henneberg Graph - Pentagon w/o internal connection';
%         case 5 
%             G = HG_5_1;   
%             N = numnodes(HG_5_1);
%             name = 'Henneberg Graph - Pentagon w/ internal connection';
%     end
% 
%     y = zeros(1,N+1);
%     x = 0 : 1/N : 1;
%     for i = 1 : N
%         rm_node = getRND(G,i);
%         G1= rmnode(G,rm_node);
%         percent = getProb(G1);
%         y(1,i+1) = percent;
%     end
%     %The larger area at the bottom, the more robust 
%     area = trapz(x,y);    
%     name = append(name,newline,'area : ',num2str(area));
%     subplot(2,5,cycle); plot(x,y);title(name);
%     subplot(2,5,cycle+5); plot(G);title(name);
% end
% 
% % Strategy2: targeted betweenness-based attacks (TBA)
% figure('NumberTitle', 'off', 'Name', 'TBA');
% for cycle = 1 : 5
%     switch cycle
%         case 1 
%             G = RG;
%             N = numnodes(RG);
%             name = 'Random Graph';
%         case 2 
%             G = HG_3;
%             N = numnodes(HG_3);
%             name = 'Henneberg Graph - triangle';
%         case 3 
%             G = HG_4;
%             N = numnodes(HG_4);
%             name = 'Henneberg Graph - square';
%         case 4 
%             G = HG_5_0;   
%             N = numnodes(HG_5_0);
%             name = 'Henneberg Graph - Pentagon w/o internal connection';
%         case 5 
%             G = HG_5_1;   
%             N = numnodes(HG_5_1);
%             name = 'Henneberg Graph - Pentagon w/ internal connection';
%     end
%     y = zeros(1,N+1);
%     x = 0 : 1/N : 1;
%     for i = 1 : N
%         rm_node = getTBA(G,i);
%         G1= rmnode(G,rm_node);
%         percent = getProb(G1);
%         y(1,i+1) = percent;
%     end
%     %The larger area at the bottom, the more robust 
%     area = trapz(x,y);    
%     name = append(name,newline,'area : ',num2str(area));
%     subplot(2,5,cycle); plot(x,y);title(name);
%     subplot(2,5,cycle+5); plot(G);title(name);
% end

% Strategy3: targeted degree-based attacks (TDA)
figure('NumberTitle', 'off', 'Name', 'TDA');
for cycle = 1 : 5
    switch cycle
        case 1 
            G = RG;
            N = numnodes(RG);
            name = 'Random Graph';
        case 2 
            G = HG_3;
            N = numnodes(HG_3);
            name = 'Henneberg Graph - triangle';
        case 3 
            G = HG_4;
            N = numnodes(HG_4);
            name = 'Henneberg Graph - square';
        case 4 
            G = HG_5_0;   
            N = numnodes(HG_5_0);
            name = 'Henneberg Graph - Pentagon w/o internal connection';
        case 5 
            G = HG_5_1;   
            N = numnodes(HG_5_1);
            name = 'Henneberg Graph - Pentagon w/ internal connection';
    end
    y = zeros(1,N+1);
    x = 0 : 1/N : 1;
    for i = 1 : N
        rm_node = getTDA(G,i);
        G1= rmnode(G,rm_node);
        percent = getProb(G1);
        y(1,i+1) = percent;
    end
    %The larger area at the bottom, the more robust 
    area = trapz(x,y);    
    name = append(name,newline,'area : ',num2str(area));
    subplot(2,5,cycle); plot(x,y);title(name);
    subplot(2,5,cycle+5); plot(G);title(name);
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
wbc = centrality(G,'betweenness','Cost',G.Edges.Weight)';
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

