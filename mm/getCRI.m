function criticalnodes = getCRI(G , k)
    priority = ones(1,numnodes(G)); % no priority
    MIS= findMIS ( logical(adjacency(G)), priority); %form of [ 1 0 1 ]
    organizedMIS = find(MIS>0);
    MIS_sub = find(MIS == 0);
    str = string(missing);
    for i = 1:numnodes(G)
       str(i) = num2str(i); 
    end
    cellstring = cellstr(str);
     G.Nodes.Name =cellstring';
    
    while numel(organizedMIS)< numnodes(G) - k
        addMSI = numnodes(G)* (numnodes(G)-1) /2;
        for i = MIS_sub'%find(MIS == 0 ) %[ 1 2 4 9] mis가 아닌거, organizedMIS가 아닌 것
            Temp_MSI_sub = find(MIS == 0 );
            Temp_MSI_sub(find (Temp_MSI_sub == i ), :)= [] ;
            Temp_G = rmnode(G,Temp_MSI_sub');
            components = conncomp(Temp_G);
            %subplot(1,2,1);plot(Temp_G);subplot(1,2,2);plot(G);pause(5);

            ni = findnode(Temp_G, num2str(i));
            i_component = numel(find(components == components(ni)));
            i_component = i_component * (i_component-1) /2;
            if  addMSI > i_component
                 addMSI = i_component;
                 addMSInode = i;
            end
        end
%         MSI에 addMSI노드 추가
        organizedMIS(end+1) = addMSInode;
        MIS_sub (find (MIS_sub == addMSInode ), :)= [];
    end
    criticalnodes=1:numnodes(G);
    for i = organizedMIS
        criticalnodes(:,i)= [];
    end
end

