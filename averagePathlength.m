G= createHennebergGraph(500, 8, 3,0);
% [RandomGraph,p] = createRandomGraph_1(numnodes(G),numedges(G));
% G= RandomGraph;
size = numnodes(G);
x = [];
for c = 1:size
      for dest=1:size
          if(c~=dest)
              [P,d] = shortestpath(G,c,dest);
               x = [x, d];
          end
      end
end
answer = mean(x)
% [RandomGraph,p] = createRandomGraph_1(numnodes(G),numedges(G));
G= createRandomGraph_avgd(500,8);
size = numnodes(G);
x = [];
for c = 1:size
      for dest=1:size
          if(c~=dest)
              [P,d] = shortestpath(G,c,dest);
               x = [x, d];
          end
      end
end
answer = mean(x)