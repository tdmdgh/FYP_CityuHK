% C_graph = create_complete(4);
% G = graph(C_graph);
% G=rmedge(G,1,4);G=rmedge(G,2,3);%G=rmedge(G,2,1);

HG_5_0 = createHennebergGraph(300, 8, 3,0);
% G = HG_5_0;
G = Hgraph;
figure;plot(G,'-.dr')
L = laplacian(G);
[V,D1] = eigs(L,numnodes(G),'smallestabs');
resistance =0;
for i =2:1:numnodes(G)
   resistance = resistance + 1/D1(i,i);
end
e_r_h = resistance * numnodes(G)

[RandomGraph,p] = createRandomGraph_1(numnodes(G),numedges(G));
G = RandomGraph;
% while numedges(HG_5_0) ~= numedges(G)
%     i = randi(numnodes(G));
%     j = randi(numnodes(G));
%     if hasedge(G,i,j)
%         G = rmedge(G,i,j);
%     end
% end

figure;plot(G,'-.dr')
L = laplacian(G);
[V,D2] = eigs(L,numnodes(G),'smallestabs');
resistance =0;
for i =2:1:numnodes(G)
   resistance = resistance + 1/D2(i,i);
end
e_r_r = resistance * numnodes(G)