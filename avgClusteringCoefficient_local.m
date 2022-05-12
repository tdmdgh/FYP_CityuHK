function [acc, c] = avgClusteringCoefficient_local(graph)
c = zeros(numnodes(graph),1);
for i = 1 : 1:numnodes(graph)
    d= degree(graph,i);
    if d <=1
        continue;
    end
    links = 0;
    for j = neighbors(graph,i)'
        for k = neighbors(graph,i)'
            if hasedge(graph,j,k)
                links = links +1;
            end
        end
    end
    c(i,1) = links/(d*d-1);
end
acc = mean(c);

% %% Clustering coefficient computation
% 
% %Make sure the graph unweighted!!!
% graph(graph ~= 0) = 1; 
% 
% deg = sum(graph, 2); %Determine node degrees
% cn = diag(graph*triu(graph)*graph); %Number of triangles for each node
% 
% %The local clustering coefficient of each node
% c = zeros(size(deg));
% c(deg > 1) = 2 * cn(deg > 1) ./ (deg(deg > 1).*(deg(deg > 1) - 1)); 
% 
% %Average clustering coefficient of the graph
% acc = mean(c(deg > 1)); 