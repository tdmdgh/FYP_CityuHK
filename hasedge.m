function exist = hasedge(G,node1,node2)
if findedge(G,node1,node2)>0
    exist = true;
else
    exist = false;
end

