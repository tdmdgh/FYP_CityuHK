function G = createHenneberg(N)
    G = graph;
    G = addnode(G,3);
    G = addedge(G,[1 2 3],[2 3 1]);
    for i = 4:1:N
        if rand(1) > 0.5
            %h1s
            V = randi(i-1,1,2);
            while numel(V) ~= numel(unique(V))
                V = randi(i-1,1,2);
            end
            G = addnode(G,1);
            G = addedge(G, V, [i , i]);
        else
           %h2s
           [sOut,tOut] = findedge(G);
           idx = randi(numel(sOut));
           v1 = sOut(idx);
           v2 = tOut(idx);
           G = rmedge(G, v1,v2);
           v3 = randi(i-1);
           while v3 == v1 || v3==v2
               v3 = randi(i-1);
           end
           G = addedge(G, [v1, v2, v3],[i,i,i]);
        end
        
    end
end

function G = H1S(G)

end

function G = H2S(G)

end