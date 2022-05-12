function G = createPolygonHenneberg(Node,Avg_degree, q, e)
    %%condition
    % Avg_degree = 3 or 5 or 10
    % 3 <= q <= 5
    % 0 <= e <= 1
    Initial = [ 0 1; 1 0];
    G = graph(Initial);
    n = numnodes(G); % temporal number of nodes
    m = numedges(G); % temporal number of edges
    aa = q - 1;

    %Step1. Add nodes
    while n < Node
        %randomly choose a 2-clique in the network        
        [randomNode1,randomNode2]= getPairfromGraph(G);

        %connect aa newcomers as a group using e edges
        G = addnode(G, aa);
        n = numnodes(G);
        for i = 1 : aa-1
            G = addedge(G, n, n-1,1);
            n = n -1;
        end
        if e == 1
            G = addedge(G, numnodes(G)-2, numnodes(G),1);
        end

        %connect aa-newcomer group to the 2-clique, forming a q-size polygon
        if aa-1 > 0
            G = addedge(G, numnodes(G), randomNode1, 1);
            G = addedge(G, numnodes(G)-(aa-1), randomNode2, 1);
        else
            G = addedge(G, numnodes(G), randomNode1, 1);
            G = addedge(G, numnodes(G), randomNode2, 1);
        end
    end
    %Step2. Add edges
    avg_d = numedges(G) * 2 / numnodes(G);
    while avg_d < Avg_degree 
        %randomly choose a 2-clique in the network
        [randomNode3,randomNode4]= getPairfromGraph(G);
        
        %randomly choose aa non-adjacent nodes in the network
        %// as if they were new comers
        nodes = [];
        for i = 1 : aa
            newcomer = getNonAdjacentNode(G,randomNode3,randomNode4);
            if i > 1
                if newcomer ~= nodes(end)
                    nodes(end+1) = newcomer;
                else
                    i = i-1;
                    continue;
                end
            else
                nodes(end+1) = newcomer;
            end
        end
        
        %connect the aa nodes as a group using e edges
        for i = 1 : length(nodes)-1
            if findedge(G,nodes(i),nodes(i+1)) == 0
                G = addedge(G, nodes(i), nodes(i+1), 1);
            end
        end
        
        %connect the aa-group to the 2-clique
        G = addedge(G, nodes(1), randomNode3, 1);
        G = addedge(G, nodes(end), randomNode4, 1);
        
        
        avg_d = numedges(G) * 2 / numnodes(G);
    end
    %delete edges
    while avg_d > Avg_degree
        %randomly pick an edge and remove it
        [deleteNode1,deleteNode2] = getPairfromGraph(G);
        G= rmedge(G,deleteNode1,deleteNode2);
        avg_d = numedges(G) * 2 / numnodes(G);
    end
end

function [n1,n2] = getPairfromGraph(G)
    flag = 1;
    while flag
        n1 = randi(numnodes(G));
        n2 = randi(numnodes(G));
        if n1 ~= n2
            if edgecount(G,n1,n2)>0
                flag = 0;
            end
        end
    end
end

function n = getNonAdjacentNode(G,n1,n2)
    flag = 1;
    while flag
        n = randi(numnodes(G));
        if n ~= n1 && n ~= n2
           if edgecount(G,n,n1) == 0 &&  edgecount(G,n,n2) == 0
               flag = 0;
           end
        end
    end
end

