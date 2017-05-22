clc;
clear;
close all;

%read the images.
Original_Image1 = imread('toy_formatted2.png');
Original_Image2 = imread('toy_formatted4.png');

[row ,col]=size(Original_Image1);
temporal=zeros(row,col);
for i=1:row
    for j=1:col
        temporal(i,j)=Original_Image2(i,j)-Original_Image1(i,j);
    end
end
%get the number of rows and columns of the image


%initialize the spatial gradients in X and Y axis
Ex=zeros(row, col);
Ey=zeros(row, col);

%Caculate the Spatial Gradient in X axis
for i=1:row-1
    for j=1:col
        Ex(i+1,j)=Original_Image2(i+1,j)-Original_Image1(i,j);
        
    end
end
%Caculate the Spatial Gradient in Y axis

for i=1:row
    for j=1:col-1
        Ey(i,j+1)=Original_Image2(i,j+1)-Original_Image1(i,j);
    end
end 

%Display the vectors

figure,imshow(Ex);
title('Spatial Gradient in X');

figure,imshow(temporal);
title('Time Gradient');

figure,imshow(Ey);
title('Spatial Gradient in Y');

 velocity_vector=zeros(row,col,2);
%calculating the optical flow of the neighborhood.
for i=1:row-1
    for j=1:col-1
        A=[ Ex(i,j),Ey(i,j);
            Ex(i,j+1),Ey(i,j+1);
            Ex(i+1,j),Ey(i+1,j);
            Ex(i+1,j+1),Ey(i+1,j+1)
           ];
       b=[
           temporal(i,j);
           temporal(i,j+1);
           temporal(i+1,j);
           temporal(i+1,j+1)
       ];
     Result=pinv(A'*A);
     velocity_vector(i,j,:)=-Result*A'*b;
    end
end

 velocity_vector(isnan( velocity_vector))=0;

figure(3);
title('Original Image');
imshow(Original_Image1);
hold on;
quiver( velocity_vector(:,:,1), velocity_vector(:,:,2),5);
hold off;