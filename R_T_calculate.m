function [R,T] =R_T_calculate(T1, T2, R1, R2, Korrespondenzen)
K=eye(3);
    x1 = K\[Korrespondenzen(1:2,:);ones(1,size(Korrespondenzen,2))];
     x2 = K\[Korrespondenzen(3:4,:);ones(1,size(Korrespondenzen,2))];
%      d1=zeros(size(x1,2),2);
%      d2=zeros(size(x1,2),2);
%      d3=zeros(size(x1,2),2);
%      d4=zeros(size(x1,2),2);
% d_cell={d1,d2,d3,d4};
%%%%%%%
 
n = size(Korrespondenzen,2);


l = zeros(n, 2, 4);

d=[];
TE = cat(2, T1, T2, T1, T2);
RE = cat(3, R1, R1, R2, R2);

for i=1:4
    M1 = zeros(3*n,n);
    M2 = zeros(3*n,n);
    m1=[];
    m2=[];
    for j=1:n
        
        x1i= x1(:,j);
        x2i=x2(:,j);
        
         x1a=[0 -x1i(3) x1i(2); x1i(3) 0 -x1i(1); -x1i(2) x1i(1) 0];
         x2a=[0 -x2i(3) x2i(2); x2i(3) 0 -x2i(1); -x2i(2) x2i(1) 0];
         M1(3*j-2:3*j,j)  = x2a * RE(:,:,i) * x1(:,j);
         m1  =[m1; x2a * TE(:,i)];
        
         M2(3*j-2:3*j,j)= x1a*RE(:,:,i)' * x2(:,j);
         m2  = [m2;-x1a *RE(:,:,i)' * TE(:,i)];
    end
    M1=[M1 m1];
    M2=[M2 m2];
 
    [~,~,V1] = svd(M1);
    [~,~,V2] = svd(M2);
    
    l1 = V1(:,n+1);
    l1 = l1 ./ l1(length(l1));   
    l2 = V2(:,n+1);
    l2 = l2 ./ l2(length(l2));   

    d =[d sum(sign(l1(1:length(l1)-1))) + sum(sign(l2(1:length(l2)-1)))];
    l(:, 1, i)= l1(1:length(l1)-1);
    l(:, 2, i)= l2(1:length(l2)-1);
end

[~, ix] = max(d);
T= TE(:,ix);
R = RE(:,:,ix);
lambda=l(:,:,ix);
end