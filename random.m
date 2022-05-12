num_node = 10;
num_edges = 100;
p = 0.3;
%%if num_edges > num_node*(num_node-1)/2
    
%%A = zeros(num_node);
A = create_random(5, 8, p)

%
% function R = create_complete(node,edges, p)
% 
% if edges >= node*(node-1)/2
%     R = ones(node);    
%     R = R - eye(node);
% else
%     R = zeros(node);
%     
%     
%     
%     R =addedge_random(R,i,j,p);
%     
% end
% end