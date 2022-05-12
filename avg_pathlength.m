function answer = avg_pathlength(G)
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
answer = mean(x);
end

