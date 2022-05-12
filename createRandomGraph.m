function [RG,p] = createRandomGraph(num_nodes,num_edges)
    for p = 0.0001 : 0.0001 : 1
%         rand('seed',100); % reseed so you get a similar picture
        G = rand(num_nodes,num_nodes) < p;
        G = triu(G,1);
        G = G + G';
        RG = graph(G);
        if num_edges < numedges(RG)
            break
        end
    end
end

