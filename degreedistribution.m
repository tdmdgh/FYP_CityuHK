function degreedist = degreedistribution(G)

    degrees = degree(G)';
    maxd = max(degrees)+1;
    degreedist = zeros(1,maxd);
    for i = degrees
        degreedist(1,i+1) = degreedist(1,i+1)+1;
    end
    x = [0: maxd-1];
    y = degreedist/numnodes(G);
    bar(x,y);
    xlim([0 30]);
    ylim([0 0.5])
end

