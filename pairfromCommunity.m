function [n1,n2] = pairfromCommunity(G,community)
flag = 1;
n1 =0;
n2 = 0;
N = size(community,1);
community;
if N >=2 & numedges(G)>0
while flag
n1 = community(randi(N));
n2 = community(randi(N));
if n1 ~=n2
 if edgecount(G,n1,n2)>0
     flag = 0;
 
 end
end
end
end
end



