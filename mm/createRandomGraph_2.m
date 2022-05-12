function [RG,p] = createRandomGraph_2(num_nodes)
%Given only the number of nodes, a connected random graph with smallest
%probability is generated
for p = 0.0001 : 0.0001 : 1
    G = rand(num_nodes,num_nodes) < p;
    G = triu(G,1);
    G = G + G';
    RG = graph(G);
	
    if max(conncomp(RG)) == 1
        break
    end
end

end

