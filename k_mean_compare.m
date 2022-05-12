% [ C1, C2 ]= distinguishCommunity(HG_5_0);
% 

 HG_4 = createHennebergGraph(150, 4, 4,0);
% [RG,p] = createRandomGraph_1(numnodes(HG_4),numedges(HG_4));
[RG,p] = createRandomGraph_avgd(numnodes(HG_4),4);

[ C1, C2 ]= distinguishCommunity(RG);
G = RG;
num = 0;
for i = C1'
    for j = C2'
        if hasedge(G,i,j)
            num = num +1;
        end
    end
end
rC = num
G = Hgraph;
num = 0;
for i = C1'
    for j = C2'
        if hasedge(G,i,j)
            num = num +1;
        end
    end
end
rH = num