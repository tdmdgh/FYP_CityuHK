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

