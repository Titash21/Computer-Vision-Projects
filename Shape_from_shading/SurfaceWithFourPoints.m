function Assignment3()

%Take image data
Img1 = double(imread('D:\NYU_SEM_2\Computer Vision\Assignment-3\synth-images\im1.png'));
Img2 = double(imread('D:\NYU_SEM_2\Computer Vision\Assignment-3\synth-images\im2.png'));
Img3 = double(imread('D:\NYU_SEM_2\Computer Vision\Assignment-3\synth-images\im3.png'));
Img4 = double(imread('D:\NYU_SEM_2\Computer Vision\Assignment-3\synth-images\im4.png'));

%Normalize image 
  NormalsImg1 =(Img1)./255;
  NormalsImg2 =(Img2)./255;
  NormalsImg3 =(Img3)./255;
  NormalsImg4 =(Img4)./255;
     v1 = [0 0 1]';
	 v2 = [-0.2 0 1]';
     v3 = [0.2 0 1]';
     v4 = [0 -0.2 1]';

%Combine all the Lightsource into a matrix
LightSource = [v1';v2'; v3'; v4'];

%Get the size of an image
[NRows, NCols] = size(NormalsImg1); 

%Initialize G, Albedo, Normals and P,Q
g = zeros(NRows,NCols,3);
albedo = zeros(NRows,NCols);
Normals = zeros(NRows,NCols, 3);
p =  zeros(NRows,NCols);
q =  zeros(NRows,NCols);

%Algorithm to calculate the Depth (Z)
for i = 1:NRows;
    for j = 1:NCols;
       
       %Compute small i
       iv = [NormalsImg1(i,j); NormalsImg2(i,j); NormalsImg3(i,j); NormalsImg4(i,j)]/255;

       %Compute I to Multiply on both side of equation i(x,y) = V * g(x,y)
       I = diag(iv);
       A = I * iv;
       B = I * LightSource;
       
       %Compute G, ALbedo(Rho) and Normals where Rho(x,y) = |g(x,y)| and N(x,y) = g(x,y)/|g(x,y)| 
       temp = B\A;
       g(i,j,:) = temp;
       albedo(i,j) = norm(temp);
       Normals(i,j,:) = temp/norm(temp);

       %Compute P and Q where P = dz/dx and Q = dz/dy
       p(i,j) = Normals(i,j,1)/Normals(i,j,3);
       q(i,j) = Normals(i,j,2)/Normals(i,j,3);

    end
end

%Normalize the albedo
MaxAlbedo = max(max(albedo));
if( MaxAlbedo > 0)
    albedo = albedo/MaxAlbedo;
end

%Calculate the depth (Z values) using normal method
Depth=zeros(NRows,NCols);
for i = 2:size(Img1,1)
    for j = 2:size(Img1,1)
        Depth(i,j) = Depth(i-1,j-1)+q(i,j)+p(i,j);
    end
end

%Albedo Figure
figure(1);
imagesc(albedo);
figure(2)
imagesc(albedo);
colormap(gray);


%Depth gray image
figure(3);
surfl(-Depth);
colormap(gray);
grid off;
shading interp

%Normal vectors
[X, Y] = meshgrid( 1:NRows, 1:NCols );
figure(4);
quiver3(X,Y,-Depth, Normals(:,:,1),Normals(:,:,2),Normals(:,:,3))

%Wireframe of depth map
[X, Y] = meshgrid( 1:NRows, 1:NCols );
figure(5);
quiver3(X,Y,-Depth, Normals(:,:,1),Normals(:,:,2),Normals(:,:,3))
hold on;
surf( X, Y, -Depth, 'EdgeColor', 'none' );
camlight left;
lighting phong;
hold off;

%Calculate depth using Frankotchellappa function
FunctionalDepth = frankotchellappa(p,q);

%Depth gray image
figure(6);
surfl(-FunctionalDepth);
colormap(gray);
grid off;
shading interp

%Normal vectors
[X, Y] = meshgrid( 1:NRows, 1:NCols );
figure(7);
quiver3(X,Y,-FunctionalDepth, Normals(:,:,1),Normals(:,:,2),Normals(:,:,3))

%Wireframe of depth map
[X, Y] = meshgrid( 1:NRows, 1:NCols );
figure(8);
quiver3(X,Y,-FunctionalDepth, Normals(:,:,1),Normals(:,:,2),Normals(:,:,3))
hold on;
surf( X, Y, -FunctionalDepth, 'EdgeColor', 'none' );
camlight left;
lighting phong;
hold off;

end
