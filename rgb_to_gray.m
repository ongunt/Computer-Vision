function gray_image = rgb_to_gray(input_image)
    [k,l,m]=size(input_image);
  
  if m==3
         image=double(input_image);

          R=image(:, :, 1);
          G=image(:, :, 2);
          B=image(:, :, 3);
   
       
        
         [k, l]=size(R);
        for i=1:k
           for j=1:l
           gray_image(i, j)=uint8((R(i, j)*0.299)+(G(i, j)*0.587)+(B(i, j)*0.114));
            end
        end
  else
      gray_image=input_image;
  end  