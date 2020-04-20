    
function merkmale = harris_detektor(input_image, varargin)

p=inputParser;

argName='input_image';

validation=@(x) validateattributes( x,{'numeric'}, {'nonempty'},1 );  
p.addRequired( argName,validation);


argName = 'segment_length';
default = 15;
validation = @(x) validateattributes( x, {'numeric'},{'odd','>',1},2 );
p.addOptional( argName, default, validation );


argName = 'k';
default = 0.05;
validation = @(x) validateattributes( x, {'numeric'}, {'>=',0,'<=',1},3 );
p.addOptional( argName, default, validation );

argName = 'tau';
default = 1e6;
validation = @(x) validateattributes( x, {'numeric'}, {'>',0},4);
p.addOptional( argName, default, validation );

argName = 'do_plot';
default = false;
validation = @(x) validateattributes( x, {'logical'},{'nonnan'},5 );
p.addOptional( argName, default, validation );



argName = 'min_dist';
default = 20;
validation = @(x) validateattributes( x, {'numeric'},{'>=',1},2 );
p.addOptional( argName, default, validation );


argName = 'tile_size';
default =  [200,200];
%validation = @(x) validateattributes( x, {'numeric'}, {'nonempty'},3);
%p.addOptional(argName,default, validation);

p.addOptional(argName,default, @isnumeric);
argName = 'N';
default = 5;
validation = @(x) validateattributes( x, {'numeric'}, {'>=',1},4);
p.addOptional( argName, default, validation );


parse(p,input_image,varargin{:});

min_dist=p.Results.min_dist;
tile_size=p.Results.tile_size;


if numel(tile_size) == 1
    tile_size=[tile_size,tile_size];
end


N=p.Results.N;
segment_length=p.Results.segment_length;
k=p.Results.k;
tau=p.Results.tau;
do_plot=p.Results.do_plot;
%%%%%

  [~,~,m]=size(input_image);
  
  if m==1
         Img=double(input_image);
    % Approximation des Bildgradienten
          [Ix,Iy]=sobel_xy(Img);
    % Gewichtung
% 
% sigma = segment_length/10;
% 
% n= -(segment_length-1)/2 : (segment_length-1)/2;
% 
% g = (1/sqrt(2*pi*sigma^2))*exp(-(n.^2)/(2*sigma^2));
%     % Harris Matrix G
%     
%     
% 
%      G=zeros(size(Img,1),size(Img,2),4);
%      
%      Fx2 = conv2(double(Ix.^2),g,'same');
%      G11 = conv2(double(Fx2),g','same');
%      Fxy = conv2(double(Ix.*Iy),g,'same');
%      G12 = conv2(double(Fxy),g','same');
%      G21 = G12; 
%      Fyy = conv2(double(Iy.^2),g,'same');
%      G22 = conv2(double(Fyy),g','same');
% 
g          = fspecial('gaussian',[segment_length,1],segment_length/5);


G11          = double(conv2(g,g,Ix.^2, 'same'));

G22         = double(conv2(g,g,Iy.^2, 'same'));
 
G12         = double(conv2(g,g,Ix.*Iy, 'same'));
G21       = double(conv2(g,g,Ix.*Iy, 'same'));
 
 


  else
      error( "Image format has to be NxMx1")
      
  end

  
%      merkmale = {0, 0, 0};
      H=G11.*G22-G12.*G12-k*(G11+G22).^2;
corners1=H
      H=double(H);
    
        B=zeros(size(H));
       
     for i=(ceil(segment_length/2)+1):(size(H,1)-ceil(segment_length/2))
              for j=(ceil(segment_length/2)+1):(size(H,2)-ceil(segment_length/2))
               B(i,j)=1;
              end 
         end   
 
        corners = H.*B;   
  
      corners(corners<=tau)=0;

      [R,C]=find(corners~=0);
      merkmale=[C';R'];
      
     size(corners)
     size(m)
%       merkmale{1}=H;
%       merkmale{2}=corners;
%       merkmale{3}=merkmale;
     
  %%%%
%  plot(merkmale(1,:),merkmale(2,:),'.')
%%%%

%%%%

      
        A= [zeros(size(corners,1),min_dist) corners zeros(size(corners,1),min_dist)]
        corners=[zeros(min_dist,size(A,2)); A; zeros(min_dist,size(A,2))];
        

[sorted_list,sorted_index] = sort(corners(:),'descend');
        sorted_index(sorted_list==0)=[];
%         merkmale{1}=corners;
%         merkmale{2}=sorted_index;
    %%%%%%

[i_r,i_c,~]=size(input_image);
ts1=tile_size(1);
ts2=tile_size(2);
AKKA=zeros(ceil(i_r/ts1),ceil(i_c/ts2));
% merkmale{1}=AKKA;



if numel(AKKA)*N>numel(sorted_index)
% merkmale{2}=zeros(2,numel(sorted_index));
m=zeros(2,numel(sorted_index));

else
%     merkmale{2}=zeros(2,numel(AKKA)*N);
 m=zeros(2,numel(AKKA)*N);
end
%%%%%%

   count=1;
     
     
for  k = 1:numel(sorted_index)
   
    if(corners(sorted_index(k))~=0)
         [r1,c1]=ind2sub(size(corners),sorted_index(k));   
    else
        continue;
    end
   
     
     kuchen=cake(min_dist);
     corner=zeros(r1-min_dist,r1+min_dist);
     for i=r1-min_dist:r1+min_dist
         for j=c1-min_dist:c1+min_dist
             corner((i-(r1-min_dist))+1,(j-(c1-min_dist))+1)=corners(i,j)*kuchen((i-(r1-min_dist))+1,(j-(c1-min_dist))+1);
         end
     end
      
     for i=r1-min_dist:r1+min_dist
         for j=c1-min_dist:c1+min_dist
             corners(i,j)=corner((i-(r1-min_dist))+1,(j-(c1-min_dist))+1);
         end
     end
    
    
    

    
   
    AKKA(floor((r1-min_dist-1)/(tile_size(1)))+1,floor((c1-min_dist-1)/(tile_size(2)))+1)=...
        AKKA(floor((r1-min_dist-1)/(tile_size(1)))+1,floor((c1-min_dist-1)/(tile_size(2)))+1)+1;
    if AKKA(floor((r1-min_dist-1)/(tile_size(1)))+1,floor((c1-min_dist-1)/(tile_size(2)))+1)==N
        
        for i=(((floor((r1-min_dist-1)/(tile_size(1)))+1-1)*tile_size(1))+1+min_dist):min(size(corners,1))
         for j=(((floor((c1-min_dist-1)/(tile_size(2)))+1-1)*tile_size(2))+1+min_dist):min(size(corners,2),...
             (floor((c1-min_dist-1)/(tile_size(2)))+1)*tile_size(2)+min_dist)
         corners(i,j)=0;   
         end
        end
          
    end
    
   
    m(:,count)=[c1-min_dist;r1-min_dist];
    count = count+1;
end


merkmale = m(:,1:count-1);

end