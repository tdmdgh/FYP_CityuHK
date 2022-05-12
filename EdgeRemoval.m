N = 100;
% avg_d = 8;
HG = createHenneberg(N);
avg_d = numedges(HG)*2/N;

%% Create Network
% HG_3 = createHennebergGraph(N, avg_d, 3,0);
% HG_4 = createHennebergGraph(N, avg_d, 4,0);
% % HG_4=Hgraph;
% HG_5_0 = createHennebergGraph(N, avg_d, 5,0);
% HG_5_1 = createHennebergGraph(N, avg_d, 5,1);
% [RG,p] = createRandomGraph_avgd(N,avg_d);
HG_3 = createHenneberg(500);
HG_4 = createHenneberg(1000);
HG_5_0 = createRandomGraph(500, numedges(HG_3));
HG_5_1 = createRandomGraph(1000, numedges(HG_4));
[RG,p] = createRandomGraph(N,numedges(HG));
%%Degree Distribution
figure('NumberTitle', 'off', 'Name', 'Degree distribution');
for cycle = 1 : 6
    switch cycle
        case 1 
            G = RG;
            N = numedges(RG);
            name = 'Random Graph';
        case 2 
            G = HG_3;
            N = numedges(HG_3);
            name = 'Henneberg Graph - triangle';
        case 3 
            G = HG_4;
            N = numedges(HG_4);
            name = 'Henneberg Graph - square';
        case 4 
            G = HG_5_0;   
            N = numedges(HG_5_0);
            name = 'Henneberg Graph - Pentagon w/o internal connection';
        case 5 
            G = HG_5_1;   
            N = numedges(HG_5_1);
            name = 'Henneberg Graph - Pentagon w/ internal connection';
        case 6 
            G = HG;   
            N = numedges(HG);
            name = 'Henneberg Graph ';
    end
    subplot(1,6,cycle); degreedistribution(G);title(name);
end
% %% Removal Edges
% % Strategy1: random attacks (RND)
% figure('NumberTitle', 'off', 'Name', 'RND _ edge');
% for cycle = 1 : 6
%     switch cycle
%         case 1 
%             G = RG;
%             N = numedges(RG);
%             name = 'Random Graph';
%         case 2 
%             G = HG_3;
%             N = numedges(HG_3);
%             name = 'Henneberg Graph - triangle';
%         case 3 
%             G = HG_4;
%             N = numedges(HG_4);
%             name = 'Henneberg Graph - square';
%         case 4 
%             G = HG_5_0;   
%             N = numedges(HG_5_0);
%             name = 'Henneberg Graph - Pentagon w/o internal connection';
%         case 5 
%             G = HG_5_1;   
%             N = numedges(HG_5_1);
%             name = 'Henneberg Graph - Pentagon w/ internal connection';
%         case 6 
%             G = HG;   
%             N = numedges(HG);
%             name = 'Henneberg Graph ';
%     end
%     [sOut,tOut] = findedge(G);
%     y = zeros(1,N+1);
%     x = 0 : 1/N : 1;
% 
%     G1 = G;
%     for i = 1 : N
%         idx = getRND(G,1);
%         G1= rmedge(G1,sOut(i),tOut(i));
%         percent = getProb(G1);
%         y(1,i+1) = percent;
%     end
% 
% %     G1 = G;
% %     for i = 1 : N
% %         idx = getRND(G,i);
% %         G1 = G;
% %         for j = idx
% %             G1= rmedge(G1,sOut(j),tOut(j));
% %         end
% %         percent = getProb(G1);
% %         y(1,i+1) = percent;
% %     end
%     %The larger area at the bottom, the more robust 
%     area = trapz(x,y);    
%     name = append(name,newline,'area : ',num2str(area));
%     subplot(2,6,cycle); plot(x,y);title(name);
%     subplot(2,6,cycle+6); plot(G);title(name);
% end

% Strategy2: targeted Max Flow - based attacks (MFA)
figure('NumberTitle', 'off', 'Name', 'Max flow _ edge');
for cycle = 1 : 6
    switch cycle
        case 1 
            G = RG;
            N = numedges(RG);
            name = 'Random Graph';
        case 2 
            G = HG_3;
            N = numedges(HG_3);
            name = 'Henneberg Graph - triangle';
        case 3 
            G = HG_4;
            N = numedges(HG_4);
            name = 'Henneberg Graph - square';
        case 4 
            G = HG_5_0;   
            N = numedges(HG_5_0);
            name = 'Henneberg Graph - Pentagon w/o internal connection';
        case 5 
            G = HG_5_1;   
            N = numedges(HG_5_1);
            name = 'Henneberg Graph - Pentagon w/ internal connection';
        case 6 
            G = HG;   
            N = numedges(HG);
            name = 'Henneberg Graph ';
    end
    [sOut,tOut] = findedge(G);
    maxflows = getMaxflow(G);
    
    
    
    y = zeros(1,N+1);
    x = 0 : 1/N : 1;
    
    G1 = G;
%     for i = 1 : N
%         idx = getRND(G,1);
%         G1= rmedge(G1,sOut(i),tOut(i));
%         percent = getProb(G1);
%         y(1,i+1) = percent;
%     end
    
%     for i = 1 : N
%         [mValue , vIndex] = max(maxflows);
%         G= rmedge(G,sOut(vIndex),tOut(vIndex));
%         percent = getProb(G);
%         y(1,i+1) = percent;
%         maxflows(vIndex,1) = -1;
%     end
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
    subplot(2,6,cycle); plot(x,y);title(name);
    subplot(2,6,cycle+6); plot(G);title(name);
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

