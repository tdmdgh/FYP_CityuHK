function p = getProb2(G,N)
    components = conncomp(G);
    giantComp = mode(components);
    I = find(components == giantComp);
    p = size(I,2) / N;
end

