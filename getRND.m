function outputnodes = getRND(G,k)
outputnodes=[];
if k > numnodes(G)
    k = numnodes(G);
end
for i = 1 : k       
    new = randi(numnodes(G));
    while find(outputnodes == new) 
        new = randi(numnodes(G));
    end
    outputnodes(end+1)=new;    
end
end

