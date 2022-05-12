function[ C1, C2 ]= distinguishCommunity(G)%A)
%DISTINGUISHCOMMUNITY 이 함수의 요약 설명 위치
% G = graph(A);
L = laplacian(G);
[V,D] = eigs(L,numnodes(G),'smallestabs');
%sigma=1e-10
%[V1,D1] = eigs(L,3,sigma);
w = V(:,2);
%pause(1);
w_med = w - median(w);
C1 = find(w_med<0);
C2 = find (w_med>=0);%B2 = find(w>0);
%C3= find(w==0);
if size(C1,1) > size(C2,1)
    temp = C1;
    C1= C2;
    C2 = temp;
end
% figure;
c= plot(G);
%  c= plot(G,'Layout','layered');
 highlight(c,C1.','NodeColor','r')
 highlight(c,C2.','NodeColor','g')
 %highlight(c,C3.','NodeColor','k')
 %pause(1);
%  layout(c,'subspace')
%  layout(c,'force','UseGravity',true)
end


