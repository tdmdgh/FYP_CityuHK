function G = createTriangleinCommunity(G, community)
[i,j] =find (distances(G)==2);
if i
flag = 1;
else
    flag = 0;
end
while(flag)
num =randi(size(i,1));
community
i(num)
j(num)
if find(community == i(num)) > 0 & find(community == j(num)) > 0
    %addedge b/w i & j
    G = addedge(G,i(num),j(num),1);
    flag = 0;
end
end
end

