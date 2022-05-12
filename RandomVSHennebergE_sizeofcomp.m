N = 300;
avg_d = 3.98;
Edge = avg_d * N / 2;

%% Create Network
HG_3 = createHennebergGraph(N, avg_d, 3,0);
HG_4 = createHennebergGraph(N, avg_d, 4,0);
HG_5_0 = createHennebergGraph(N, avg_d, 5,0);
% HG_5_1 = createHennebergGraph(N, avg_d, 5,1);
HG_5_1 = createHenneberg(N);
[RG,p] = createRandomGraph_avgd(N,avg_d);

figure('NumberTitle', 'off', 'Name', 'Degree Distribution');
subplot(1,5,1);degreedistribution(RG);
subplot(1,5,2);degreedistribution(HG_3);
subplot(1,5,3);degreedistribution(HG_4);
subplot(1,5,4);degreedistribution(HG_5_0);
subplot(1,5,5);degreedistribution(HG_5_1);
accr = avgClusteringCoefficient(RG)
acc3 = avgClusteringCoefficient(HG_3)
acc4 = avgClusteringCoefficient(HG_4)
acc5_0 = avgClusteringCoefficient(HG_5_0)
acc5_1 = avgClusteringCoefficient(HG_5_1)
%% Removal Node
% Strategy1: random attacks (RND)
figure('NumberTitle', 'off', 'Name', 'RND');
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
    G1= G;
    y = zeros(1,N+1);
    x = 0 : 1/N : 1;
    for i = 1 : N
        rm_node = getRND(G1,1);
        G1= rmnode(G1,rm_node);
        percent = getSizeofComp(G1,N);
        y(1,i+1) = percent;
    end
    %The larger area at the bottom, the more robust 
    area = trapz(x,y);    
    name = append(name,newline,'area : ',num2str(area));
    subplot(2,5,cycle); plot(x,y);title(name);
    subplot(2,5,cycle+5); plot(G);title(name);
end
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

function p = getSizeofComp(G,N)
    mode(conncomp(G));
    p = numel(find(conncomp(G) == mode(conncomp(G))))/N;
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

function [B] = largestcomponent(A)
% INPUT
% A ... adjecency matrix

% OUTPUT
% B ... indices of nodes belonging to the largest component

% n ... number of nodes
% mz .. set of neighbors
% x ... for each node: index of the connected component it belongs to
% v ... set of nodes of these current component, whose neighbors have to be checked still
% c ... for each component: number of its nodes

% deterimine number of nodes
n=length(A);

% loop over all nodes to get list of neighbors
for i=1:n
mz{i}=find(A(i,:));
end

x(1:n)=0;
z=0; % number of components detected so far
k=0; % set of nodes already dealt with
for i=1:n
% node i does not yet belong to any component?
if x(i)==0;
z=z+1; % increase number of detected components
clear v
v(1)=i;
while nnz(v)>0 % while v not empty
x(v(1))=z; % update component entry for current node v(1)
k=union(k,v(1)); % flag current node v(1) as done
b=setdiff(mz{v(1)},k); % neighbors of node v(1) that still have to be taken care of
v=setdiff(v,v(1)); % delete current node from stack
v=union(v,b); % add newly detected nodes to interim list of nodes of current component
end
end
end

% size of components
c(1:max(x))=0;
% loop over components
for i=1:max(x)
c(i)=length(find(x==i)); % determine size of components
end

% size of the largest component(s)
cm=find(c==max(c));

% pick largest component
B=find(x==cm(1));

end