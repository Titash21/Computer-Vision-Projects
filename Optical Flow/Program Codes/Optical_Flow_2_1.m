clc;
clear;
close all;

%read the images.
Original_Image1 = imread('toy_formatted2.png');
Original_Image2 = imread('toy_formatted4.png');
% Apply smoothening to the original image
filtered_image1 = (gaussian_filter(Original_Image1, 2.0));
filtered_image2 =(gaussian_filter(Original_Image2, 2.0));


[row ,col]=size(Original_Image1);
temporal_gradient=zeros(row,col);
% calculating the temporal gradient
for i=1:row
    for j=1:col
        temporal_gradient(i,j)=filtered_image2(i,j)-filtered_image1(i,j);
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
title(' X spatial');
figure,imshow(Ey);
title(' Y spatial');
figure,imshow(temporal_gradient);
title('Time Gradient');


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
           temporal_gradient(i,j);
           temporal_gradient(i,j+1);
           temporal_gradient(i+1,j);
           temporal_gradient(i+1,j+1)
       ];
     Result=pinv(A'*A);
     velocity_vector(i,j,:)=-Result*A'*b;
    end
end

 velocity_vector(isnan( velocity_vector))=0;

figure();
title('Original Image');
imshow(Original_Image1);
hold on;
quiver( velocity_vector(:,:,1), velocity_vector(:,:,2),7);
hold off;
title('NORMAL VECTORS');