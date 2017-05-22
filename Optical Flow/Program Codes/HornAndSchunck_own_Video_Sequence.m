clc;
clear;
close all;
% Read original image
image_1 = rgb2gray(imread('ball_1.jpg'));
image_2 = rgb2gray(imread('ball_2.jpg'));

filtered_image1 = double(gaussian_filter(image_1, 3.0));
filtered_image2 = double(gaussian_filter(image_2, 3.0));

gauss_filtered_image1=demo_gaussian_filter(image_1,image_2);


row=size(filtered_image1,1);
col=size(filtered_image2,2);

temporal_gradient=zeros(row,col);
% calculating the temporal gradient
for i=1:row
    for j=1:col
        temporal_gradient(i,j)=filtered_image2(i,j)-filtered_image1(i,j);
    end
end
spatial_gradient_x=zeros(row,col);
spatial_gradient_y=zeros(row,col);
u=zeros(row,col);
v=zeros(row,col);

%Caculate the Spatial Gradient in X axis
for i=1:row-1
    for j=1:col
        Ex(i+1,j)=filtered_image2(i+1,j)-filtered_image1(i,j);
    end
end
%Caculate the Spatial Gradient in Y axis

for i=1:row
    for j=1:col-1
        Ey(i,j+1)=filtered_image2(i,j+1)-filtered_image1(i,j);
    end
end 

%Display the vectors
figure,imshow(Ex);
title('Horn and Schnuk X spatial');


figure,imshow(Ey);
title('Horn and Schnuk Y spatial');



lamda=10;
for n=1:8
    for i=2:row-1
        for j=2:col-1
            mean_u=1/4*(u(i-1,j)+u(i+1,j)+u(i,j-1)+u(i,j+1));
            mean_v=1/4*(v(i-1,j)+v(i+1,j)+v(i,j-1)+v(i,j+1));
            alpha=lamda*(Ex(i,j)*mean_u+Ey(i,j)*mean_v+temporal_gradient(i,j))/(1+lamda*(Ex(i,j).^2+Ey(i,j).^2));
            u(i,j)=mean_u-alpha*Ex(i,j);
            v(i,j)=mean_v-alpha*Ey(i,j);
        end
    end
end

figure();
imshow(image_2);
hold on
[x,y] = meshgrid(1:1:col, 1:1:row);
quiver(x,y,u(1:1:end, 1:1:end),v(1:1:end, 1:1:end),3);
hold off;


