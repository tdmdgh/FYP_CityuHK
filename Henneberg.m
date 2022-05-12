n_0 = 10; 
total_node = 200;
p = 0.03;
n= 3;
r1=0.001;
r2=0.001;
%%Initialize
%%initial full-conn
H = zeros(n_0);
i= n_0;
j=1;
while i >0
    r = randi(i);
    c = create_complete(r);
    H(j:r+j-1,j:r+j-1)=c;
    j=j+r;
    i = i - r;
end

%develop network
Hgraph = graph(H); % H is matrix, Hgraph is graph
% plot(Hgraph);%pause(1);
for new = n_0+1 : total_node
    new;
    Hgraph = addnode( Hgraph, 1);
%%Step1
%새로운 참가자가 오면, 무작위로 한 명을 연결하고, 그 무작위의 한 명이 속한 커뮤니티와 새로운 참가자를 연결.
sparse =[];
dense = [];
[sparse , dense ]= distinguishCommunity(Hgraph);
N_1 = size(sparse,1);
N_2 = size(dense,1);
randomNode1 = randi(new-1);
if find(sparse == randomNode1) >=1
    %addedge b/w randomNode1 & new
    if ~hasedge(Hgraph, randomNode1, new)
    Hgraph = addedge(Hgraph, randomNode1, new,1);plot(Hgraph);%pause(1);
    end
    %sparse에 속한 new와 randomNode1을 제외한 새로운 노드(randomNode2)
    randomNode2 = sparse(randi(N_1));
    %todo: sparse가 두개이하면 예외처리
    if N_1 > 2
    while randomNode2 == randomNode1 | randomNode2 == new
        randomNode2 = sparse(randi(N_1));
    end     
    %addedge b/w randomNode2 & new 
    if ~hasedge(Hgraph, randomNode2, new)
    Hgraph = addedge(Hgraph, randomNode2, new,1);   plot(Hgraph); %pause(1);
    end
    end
    %%Step2확률 p로 랜덤하게 선택된 커뮤니티 중에서 랜덤하게 link를 하나 지운다
    %delete edge
    if binornd(1,p)
        [removeNode1,removeNode2] = pairfromCommunity(Hgraph,sparse);
        %delete edge b/w removeNode1 & removeNode2
        if removeNode1 ~= 0 & removeNode2 ~= 0
        Hgraph = rmedge(Hgraph,removeNode1,removeNode2);plot(Hgraph);%pause(1);
        end
    end
    %Step3 커뮤니티에서 무작위로 선택된 사람과 연결. 
    %이과정을 r1*N_1(t) 번 반복
    %N_1(t)는 희소 커뮤니티의 현재 individual 수
    %%%%%%%
    
    for step3_1 = 1 : r1*N_1
        randomNode3 = sparse(randi(N_1));
        %addedges b/w new & randomeNode3  
        if ~hasedge(Hgraph, randomNode3, new)
        Hgraph = addedge(Hgraph, randomNode3, new,1);plot(Hgraph);%pause(1);
        end
    end
    
    %r2*N_1(t)개의 individual pair를 선택해서 연결
    %individual pair는 최소 하나이상의 이웃이 잇지만 서로 연결되어 있지 않다 /making triangle
    for step3_2 = 1 : r2*N_1
        Hgraph = createTriangleinCommunity(Hgraph, sparse);plot(Hgraph);%pause(1);
    end    
else
    %addedge b/w randomNode1 & new
    if ~hasedge(Hgraph, randomNode1, new)
    Hgraph = addedge(Hgraph, randomNode1, new,1);plot(Hgraph);%pause(1);
    end
    
    %sparse에 속한 new와 randomNode1을 제외한 새로운 노드(randomNode2)
    randomNode2 = dense(randi(N_2));
    if N_2 > 2
    while randomNode2 == randomNode1 | randomNode2 == new
        randomNode2 = dense(randi(N_2));
    end     
    %addedge b/w randomNode2 & new 
    if ~hasedge(Hgraph, randomNode2, new)
    Hgraph = addedge(Hgraph, randomNode2, new,1);    plot(Hgraph);%pause(1);
    end
    end
    %%Step2확률 p로 랜덤하게 선택된 커뮤니티 중에서 랜덤하게 link를 하나 지운다
    %delete edge
    if binornd(1,p)
        [removeNode1,removeNode2] = pairfromCommunity(Hgraph,dense);
        %delete edge b/w removeNode1 & removeNode2
        Hgraph = rmedge(Hgraph,removeNode1,removeNode2);plot(Hgraph);%pause(1);
    end
    %Step3 커뮤니티에서 무작위로 선택된 사람과 연결. 
    %이과정을 r1*N_2(t) 번 반복
    %N_2(t)는 밀집 커뮤니티의 현재 individual 수
    %%%%%%%
    %N_2 = size(dense,1);
    for step3_1 = 1 : r1*N_2
        randomNode3 = dense(randi(N_2));
        %addedges b/w new & randomeNode3  
        if hasedge(Hgraph, randomNode3, new)
        Hgraph = addedge(Hgraph, randomNode3, new,1);plot(Hgraph);%pause(1);
        end
    end
    
    %r2*N_2(t)개의 individual pair를 선택해서 연결
    %individual pair는 최소 하나이상의 이웃이 잇지만 서로 연결되어 있지 않다 /making triangle
    for step3_2 = 1 : r2*N_2
        Hgraph = createTriangleinCommunity(Hgraph, dense);plot(Hgraph);%pause(1);
    end
end


%%Step4 - global
%n번 반복
sparse =[];
dense = [];
[sparse , dense ]= distinguishCommunity(Hgraph);
N_1 = size(sparse,1);
N_2 = size(dense,1);
if N_1 ~= 0 & N_2 ~= 0
for step4 = 1 : n
    [randomNode4,randomNode5] = pairfromCommunity(Hgraph,sparse);
    randomNode6 = dense(randi(size(dense,1)));
    if randomNode4 ~= 0 & randomNode5 ~= 0
        
        
    %addedge b/w 6 & 4, 6 & 5
    if ~hasedge(Hgraph, randomNode6, randomNode4) & ~hasedge(Hgraph, randomNode6, randomNode5)
    Hgraph = addedge(Hgraph, randomNode6, [randomNode4,randomNode5],1);plot(Hgraph);%pause(1);
    else
        step4=step4-1;
    end
    else
        step4=step4-1;
    end
end
end
end
plot(Hgraph)
