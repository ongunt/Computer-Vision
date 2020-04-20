 function ilumImg = disparity(im0, im1, disp_value)

I1=rgb_to_gray(im0);
I2=rgb_to_gray(im1);

disp_value=30
shiftedWin = 5 %any odd number
windowSize = (shiftedWin-1)/2;

lImage = (I1)
rImage = (I2)
disp2 = uint8((I1));


% 
% lImage = im2double(I1)
% rImage = im2double(I2)
% disp2 = uint8((I1));

[lRow , lCol] = size(lImage);
DispImg = zeros(lRow,lCol);

for i = windowSize+1 :1: lRow-windowSize
   lRow-windowSize-i
    for j = windowSize+1 :1:  lCol-windowSize-disp_value

        previousScore = Inf;
        bestDisparity = 0;

        lReg = lImage(i-windowSize:i+windowSize,j-windowSize:j+windowSize);

        for cDisparity = 1:disp_value

                rReg = rImage(i-windowSize:i+windowSize,j+cDisparity-windowSize:j+windowSize+cDisparity); %% correlated shifted window

                %%SAD method%%
                tempScore = abs(rReg - lReg);
                curScore = sum(tempScore(:));        
                %lineSums = [lineSums, corrScore];

            if (previousScore > curScore)                
                previousScore = curScore;
                bestDisparity = cDisparity;
            end
        end

        DispImg(i,j) = bestDisparity;

    end
 end

ilumImg = DispImg *4;
imagesc(ilumImg)
colorbar
 end
% 
% diffImg = imabsdiff(uint8(ilumImg),disp2);
% figure
% imshow(diffImg,[])    