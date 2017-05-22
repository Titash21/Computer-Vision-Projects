
close;

%read the four images
Image4=(imread('D:\NYU_SEM_2\Computer Vision\dog-png\dog3.png'));
Image3=(imread('D:\NYU_SEM_2\Computer Vision\dog-png\dog3.png'));
Image2=(imread('D:\NYU_SEM_2\Computer Vision\dog-png\dog3.png'));
Image1=(imread('D:\NYU_SEM_2\Computer Vision\dog-png\dog3.png'));

Gray_Image4=mat2gray(Image4);
Gray_Image3=mat2gray(Image3);
Gray_Image2=mat2gray(Image2);
Gray_Image1=mat2gray(Image1);

% %Normalize the images so that the intensity values are between 0-1
% Normalize_Image1 =(Gray_Image1)./255;
% Normalize_Image2 =(Gray_Image2)./255;
% Normalize_Image3 =(Gray_Image3)./255;
% Normalize_Image4 =(Gray_Image4)./255;


%Normalize the source vectors
v1 = [16;19;30];
Norm_v1=v1/norm(v1,2);
v2 = [13;16;30];
Norm_v2=v2/norm(v2,2);
v3 = [-17;10.5;26.5];
Norm_v3=v3/norm(v3,2);
v4 = [9;-25;4];
Norm_v4=v4/norm(v4,2);

%stack the input vectors of the 4 images in another vector
V = [v2'; v3'; v4'];

%calculate the number of rows and columns of the images. It is the same
%value for the four images.
rows = size(Gray_Image4,1);
cols = size(Gray_Image4,2);
 
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
   i = [ Gray_Image1(r,c); Gray_Image3(r,c); Gray_Image4(r,c)];
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

[ X, Y ] = meshgrid( 1:rows, 1:cols );
figure;
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