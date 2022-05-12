function [RG,p] = createRandomGraph_avgd(num_nodes,avg_d)
for p = 0.0001 : 0.0001 : 1
%     rand('seed',100); % reseed so you get a similar picture
    G = rand(num_nodes,num_nodes) < p;
    G = triu(G,1);
    G = G + G';
    RG = graph(G);
	
	if mean(degree(RG)) > avg_d
		break
    end
end
end

