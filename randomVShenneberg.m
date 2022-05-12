N=1000;
for k = [5]%[3,5,10]
    H_RT = createPolygonHenneberg(N,k,3,0);
    [R_RT,p_1] = createRandomGraph(N,numedges(H_RT));
    
    H_RR = createPolygonHenneberg(N,k,4,0);
     [R_RR,p_2]= createRandomGraph(N,numedges(H_RR));
    
    H_RP_C = createPolygonHenneberg(N,k,5,0);
     [R_RP_C,p_3]= createRandomGraph(N,numedges(H_RP_C));
    
    H_RP_L = createPolygonHenneberg(N,k,5,1);
     [R_RP_L,p_4]= createRandomGraph(N,numedges(H_RP_L));   
    
    subplot(2,4,1);plot(H_RT);title('H_RT');
    subplot(2,4,2);plot(R_RT);title(p_1);
    
    subplot(2,4,3);plot(H_RR);title('H_RR');
    subplot(2,4,4);plot(R_RR);title(p_2);
    
    subplot(2,4,5);plot(H_RP_C);title('H_RP_C');
    subplot(2,4,6);plot(R_RP_C);title(p_3);
    
    subplot(2,4,7);plot(H_RP_L);title('H_RP_L');
    subplot(2,4,8);plot(R_RP_L);title(p_4);
    
    numedges(H_RT)
    numedges(H_RR)
    numedges(H_RP_C)
    numedges(H_RP_L)
    
    numedges(R_RT)
    numedges(R_RR)
    numedges(R_RP_C)
    numedges(R_RP_L)
    
end