clc;
clear;
close all;

% Read the original image
Original_Image1 = rgb2gray(imread('ball_1.jpg'));
Original_Image2 = rgb2gray(imread('ball_2.jpg'));
% Apply smoothening to the original image
filtered_image1 = double(gaussian_filter(Original_Image1, 2.0));
filtered_image2 = double(gaussian_filter(Original_Image2, 1.0));

% displaying the orginal image along with the filtered image
figure('Position', [100, 100, 800, 800]);
subplot(3,1,1);
imshow(Original_Image1);
title('Original image 1');

subplot(3,1,2);
imshow(Original_Image2);
title('Original Image 2');

subplot(3,1,3);
imshow(filtered_image1);
title('Gaussian filter sigma=2.0');


row=size(filtered_image1,1);
col=size(filtered_image2,2);

temporal_gradient=zeros(row,col);
% calculating the temporal gradient
for i=1:row
    for j=1:col
        temporal_gradient(i,j)=filtered_image2(i,j)-filtered_image1(i,j);
    end
end
        

% initializing the variables 
%The spatial gradient in the x axis is called Ex
%The spatial gradient in the y axis is called Ey
% u denotes the velocity vector in X axis
% v denotes the velocity vector in Y axis

Ex=zeros(row,col);
Ey=zeros(row,col);
u=zeros(row,col);
v=zeros(row,col);


% calculate spatial gradient
for i=2:row
    for j=1:col
        Ex(i,j)=filtered_image2(i,j)-filtered_image2(i-1,j);
      end
end

for i=1:row
    for j=2:col
        Ey(i,j)=filtered_image2(i,j)-filtered_image2(i,j-1);
    end
end

Spatial_gradient_vector=zeros(row,col,2);
Spatial_gradient_vector(:,:,1)=Ex;
Spatial_gradient_vector(:,:,2)=Ey;

Normal_vector=zeros(row,col);
%calculating the 
for i=1:row-1
    for j=1:col-1
        Normal_vector(i,j,:)=-temporal_gradient(i,j)*Spatial_gradient_vector(i,j)./(norm(Spatial_gradient_vector(i,j))^2);
    end
end    
figure,imshow(Ex);
title('Spatial Gradient in X');


figure,imshow(temporal_gradient);
title('Time Gradient');


figure,imshow(Ey);
title('Spatial Gradient in Y');
figure,imshow(temporal_gradient);
title('Time Gradient');


spatial=zeros(row,col,2);
spatial(:,:,1)=Ex;
spatial(:,:,2)=Ey;
normal_vector=zeros(row,col,2);

for i=1:row
    for j=1:col
        spatial_temp = [spatial(i,j,1);spatial(i,j,2)];
        normal_vector(i,j,:)=-temporal_gradient(i,j)*(spatial(i,j,:)./(norm(spatial_temp))^2);
    end
end

figure(3);
title('Original Image');
imshow(Original_Image1);
hold on;
quiver(normal_vector(:,:,1),normal_vector(:,:,2),5);
hold off;