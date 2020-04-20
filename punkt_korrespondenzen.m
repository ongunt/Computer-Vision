function [Korrespondenzen] = punkt_korrespondenzen(I1,I2,Mpt1,Mpt2,varargin)
  Korrespondenzen = {0, 0, 0, 0, 0};
    
   p=inputParser;
   
argName='I1';
validation=@(x) validateattributes( x,{'numeric'}, {'nonempty'},1 );  
p.addRequired( argName,validation);

argName='I2';
validation=@(x) validateattributes( x,{'numeric'}, {'nonempty'},2 );  
p.addRequired( argName,validation);

argName='Mpt1';
validation=@(x) validateattributes( x,{'numeric'}, {'nonempty'},3);  
p.addRequired( argName,validation);

argName='Mpt2';
validation=@(x) validateattributes( x,{'numeric'}, {'nonempty'},4 );  
p.addRequired( argName,validation);


argName = 'window_length';
default = 25;
validation = @(x) validateattributes( x, {'numeric'},{'odd','>',1},5 );
p.addOptional( argName, default, validation );


argName = 'min_corr';
default = 0.95;
validation = @(x) validateattributes( x, {'numeric'}, {'>=',0,'<',1},6 );
p.addOptional( argName, default, validation );


argName = 'do_plot';
default = false;
validation = @(x) validateattributes( x, {'logical'},{'nonnan'},7 );
p.addOptional( argName, default, validation );
  
  parse(p,I1,I2,Mpt1,Mpt2,varargin{:});

window_length=p.Results.window_length;
min_corr=p.Results.min_corr;

do_plot=p.Results.do_plot;

I1=double(I1)
I2=double(I2)
  %%%%%%%ex2
Korrespondenzen={0,0,0,0}
 I1=double(I1);
 I2=double(I2);
size1=size(I1);
size2=size(I2);
% 
% Mpt1=harris_detektor3(I1);
% Mpt2=harris_detektor3(I2);
 m1=Mpt1;
 m2=Mpt2;
index1=[];
index2=[];
%half_way=(window_length-1)/2;

first_end=ceil(window_length/2);
last_end=floor(window_length/2);


for i=1:size(Mpt1,2)
   if (((Mpt1(1,i)+last_end)>size1(2))||((Mpt1(1,i)-first_end)<0)||((Mpt1(2,i)+last_end)>size1(1))||((Mpt1(2,i)-first_end)<0))
       index1=[index1,i];
   end
end

for j=1:size(Mpt2,2)
   if (((Mpt2(1,j)+last_end)>size2(2))||((Mpt2(1,j)-first_end)<0)||((Mpt2(2,j)+last_end)>size2(1))||((Mpt2(2,j)-first_end)<0))
      index2=[index2,j];
   end
   
end

m1(:,index1)=[];
m2(:,index2)=[];

size(Mpt1,2)
size(Mpt2,2)
(index1)
(index2)
no_pts1=size(m1,2);
no_pts2=size(m2,2);
Korrespondenzen{1}=no_pts1
Korrespondenzen{2}=no_pts2
Korrespondenzen{3}=m1;
Korrespondenzen{4}=m2;
%%%%%
  Mat_feat_1=[];
Mat_feat_2=[];
%     
    f_end=floor(window_length/2)
   
   for i=1:size(m1,2)
   x_cor=(m1(1,i)-f_end):(m1(1,i)+f_end);
    y_cor=(m1(2,i)-f_end):(m1(2,i)+f_end);
    W_M1=I1(y_cor,x_cor);
    W_L1=double(W_M1(:));
    Wn1=(W_L1-mean(W_L1))/std(W_L1);
     Mat_feat_1=[Mat_feat_1 Wn1];
   end
   
    for i=1:size(m2,2)
    x_cor=(m2(1,i)-f_end):(m2(1,i)+f_end);
    y_cor=(m2(2,i)-f_end):(m2(2,i)+f_end);
    W_M2=I2(y_cor,x_cor);
    W_L2=double(W_M2(:));
    Wn2=(W_L2-mean(W_L2))/std(W_L2);
    Mat_feat_2=[Mat_feat_2 Wn2];
   end
 

   Korrespondenzen{1}=Mat_feat_1;
   Korrespondenzen{2}=Mat_feat_2;
    %%%%%%%%

Korrespondenzen={0,0};
    NCC=((Mat_feat_1)'*Mat_feat_2)'/(window_length^2-1);
     
     for i=1:size(NCC,1)
         for j=1:size(NCC,2)
           if NCC(i,j)<min_corr
               NCC(i,j)=0;
           end
         end
     end


   [sorted_list,sorted_index] = sort(NCC(:),'descend');
        sorted_index(sorted_list==0)=[]; 
    NCC_matrix=NCC;
    Korrespondenzen{2}=sorted_index;

%%%%%%%
  Korrespondenzen = 0;
    Kor=[];
    [sorted_list,sorted_index] = sort(NCC(:),'descend');
    sorted_list(sorted_list==0)=[]; 
    
    
  size( sorted_list)
    
     for i=1:size(sorted_list,1)
          
         [i2,i1]=find(NCC_matrix==sorted_list(i,1));
    
         NCC_matrix(:,i1)=0;
         
        p1=m1(:,i1);
        p2=m2(:,i2);
     
        E=[p1;p2];
     Kor=[Kor E];
          
     end
     
    Korrespondenzen=Kor;
    
    
end