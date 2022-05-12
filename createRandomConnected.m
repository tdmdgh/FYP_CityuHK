function [RG,p] = createRandomConnected(num_nodes)

for p = 0.0001 : 0.0001 : 1
    rand('seed',100); % reseed so you get a similar picture
    G = rand(num_nodes,num_nodes) < p;
    G = triu(G,1);
    G = G + G';
    RG = graph(G);
	
    if max(conncomp(RG)) == 1
        break
    end
end

end

