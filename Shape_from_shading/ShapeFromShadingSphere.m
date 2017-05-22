
close;

%read the four images
Image4=double(imread('D:\NYU_SEM_2\Computer Vision\Assignment-3\sphere-images (2)\real1.bmp'));
Image3=double(imread('D:\NYU_SEM_2\Computer Vision\Assignment-3\sphere-images (2)\real2.bmp'));
Image2=double(imread('D:\NYU_SEM_2\Computer Vision\Assignment-3\sphere-images (2)\real3.bmp'));
Image1=double(imread('D:\NYU_SEM_2\Computer Vision\Assignment-3\sphere-images (2)\real4.bmp'));

% %Normalize the images so that the intensity values are between 0-1
  Normalize_Image1 =(Image1)./255;
  Normalize_Image2 =(Image2)./255;
  Normalize_Image3 =(Image3)./255;
  Normalize_Image4 =(Image4)./255;


%Normalize the source vectors
v1 = [0.38359;0.236647;0.89266];
Norm_v1=v1/norm(v1,2);
v2 = [0.372825;-0.303914;0.87672];
Norm_v2=v2/norm(v2,2);
v3 = [-0.250814;-0.34752;0.903505];
Norm_v3=v3/norm(v3,2);
v4 = [-0.203844;0.096308;0.974255];
Norm_v4=v4/norm(v4,2);

%stack the input vectors of the 4 images in another vector
V = [Norm_v2'; Norm_v3'; Norm_v4'];

%calculate the number of rows and columns of the images. It is the same
%value for the four images.
rows = size( Normalize_Image1,1);
cols = size( Normalize_Image1,2);
 
%initialize the g(x,y) vector where g(x,y)= albedo(x,y).N(x,y)
%initialzie the p , q and the normal Vector N
g = zeros(rows,cols,3);
albedo = zeros(rows,cols);
p = zeros(rows,cols);
q = zeros(rows,cols);
N = zeros(rows,cols, 3);

%running through the entire image we calculate the g(x,y) by solving the
%linear system of equations
for r = 1:rows;
for c = 1:cols;
   i = [  Normalize_Image2(r,c); Normalize_Image3(r,c); Normalize_Image4(r,c)];
   Ivector = diag(i);
   A = Ivector * i;
   B = Ivector * V;
   rank_of_B=rank(B);
   if (rank_of_B<3)
       continue;
   end   
        X = B\A;
        g(r,c,:) = X;   
        albedo(r,c) = norm(X);
        N(r,c,:) = X/norm(X);
        p(r,c) = N(r,c,1)/N(r,c,3);
        q(r,c) = N(r,c,2)/N(r,c,3);
   
end
end

%To caculate the albedo of the given image whose values should be
%between 0-1
maximumAlbedo = max(max(albedo) );
if(maximumAlbedo > 0)
albedo = albedo/maximumAlbedo;
end

%To calculate Depth Map
depth=frankotchellappa(p,q);
%{
for i = 2:size(Image4,1)
for j = 2:size(Image4,2)
depth(i,j) = depth(i-1,j-1)+q(i,j)+p(i,j);
end
end
%}

%Albedo Figure
figure(1);
imagesc(albedo);
figure(2)
imagesc(albedo);
colormap(gray);

%Depth gray image
figure(3);
surfl(-depth);
colormap(gray);
grid off;
shading interp

figure(15);
surfl(-depth);
colormap(gray);
title('Mesh grid ');
grid off;
shading interp

%– Creating a new shaded image by choosing a new light source position vector and calculating
%the dot product of surface normals and light source vector (both normalized)
%at each pixel, resulting in a new image showing a light source not originally used for
%reconstruction
[ X, Y ] = meshgrid( 1:rows, 1:cols );
figure;
% Surf- creates a three-dimensional surface plot. 
%The function plots the values in matrix Z as heights above a grid in the x-y plane defined by X and Y. 
surf( X, Y, -depth, 'EdgeColor', 'none' );
camlight left;
title('Depth Map');
lighting phong

%Constructing the Needle Map which shows the normals pointing on the
%surface
figure
spacing = 1;
[X Y] = meshgrid(1:spacing:rows, 1:spacing:cols);
quiver3(X,Y,-depth,N(:,:,1),N(:,:,2),N(:,:,3))
hold on;
title('Needle Map');
hold off