function [RG,p] = createRandomGraph_1(num_nodes,num_edges)
%Given the number of nodes and the number of edges, a random graph
%corresponding to these inputs is generated.
%This graph can be disconnected.
%The maximum number of edges can't be larger than num_nodes * (num_nodes - 1 ) / 2

if num_edges > num_nodes * (num_nodes - 1 ) / 2
    num_edges = num_nodes * (num_nodes - 1 ) / 2;
end
for p = 0.0001 : 0.00001 : 1
    G = rand(num_nodes,num_nodes) < p;
    G = triu(G,1);
    G = G + G';
    RG = graph(G);
	
	if numedges(RG) >= num_edges 
		break
    end
    
end

end

