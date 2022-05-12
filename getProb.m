function p = getProb(G)
    components = conncomp(G);
    giantComp = mode(components);
    I = find(components == giantComp);
    p = size(I,2) / numnodes(G);
end

