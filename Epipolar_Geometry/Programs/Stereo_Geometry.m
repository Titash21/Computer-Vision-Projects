%Reading the images from the directory.
FrameofReference=imread('C:\NYU_SEM_2\Computer Vision\Assignment 2\Original.jpg');
FrameofRef=imrotate(FrameofReference,-90);
imshow(FrameofRef);
%Calculating the eight set of points from the first image
[X,Y]=ginput(8);
 
 %Following the same steps for the second image
RotatedTranslatedImage=imread('C:\NYU_SEM_2\Computer Vision\Assignment 2\Rotated.jpg');
RotatedTranslatedImage=imrotate(RotatedTranslatedImage,-90);
imshow(RotatedTranslatedImage);
[XP,YP]=ginput(8);
 
%Creating an 8*2 Matrix using the (u,v) coordinates from the first and second image.
Original_Pixels=[X,Y];
Shifted_Pixels=[XP,YP];
 
%calling the function to calculate the 8 point matrix with corresponding points
EightPointsMatrixReturned=EightPointsMatrix(X,Y,XP,YP);
[U,S,V]=svd(EightPointsMatrixReturned); 
 
%Calculating the Fundamental Matrix 
Fundamental_Matrix = reshape(V(:,9),3,3)';
 
F=[Fundamental_Matrix(1,:),Fundamental_Matrix(2,:),Fundamental_Matrix(3,1:2)];
%To check to see if the equation holds and we get a 8*1 matrix of only 1’s
EightPointsMatrixReturned*F'
 
%estimating the epipolar lines corresponding to the points
[F_formula,inliers] = estimateFundamentalMatrix(Original_Pixels,Shifted_Pixels,'Method','Norm8Point');
imshow(FrameofRef);
hold on;
plot(Original_Pixels(inliers,1),Original_Pixels(inliers,2),'go')
 
%plotting epipolar lines on the Rotated and Translated image
imshow(RotatedTranslatedImage);
hold on;
plot(Shifted_Pixels(inliers,1),Shifted_Pixels(inliers,2),'go')
epiLines = epipolarLine(F_formula,Original_Pixels(inliers,:));
points = lineToBorderPoints(epiLines,size(RotatedTranslatedImage));
line(points(:,[1,3])',points(:,[2,4])');
truesize;
 
%plotting epipolar lines on the Original image
[F_formula,inliers] = estimateFundamentalMatrix(Shifted_Pixels,Original_Pixels,'Method','Norm8Point');
imshow(RotatedTranslatedImage);
hold on;
plot(Shifted_Pixels(inliers,1),Shifted_Pixels(inliers,2),'go')

%plotting epipolar lines on the Rotated and Translated image
imshow(FrameofRef);
hold on;
plot(Original_Pixels(inliers,1),Original_Pixels(inliers,2),'go')
epiLines = epipolarLine(F_formula,Shifted_Pixels(inliers,:));
points = lineToBorderPoints(epiLines,size(FrameofRef));
line(points(:,[1,3])',points(:,[2,4])');
truesize;

%Epipole of the first camera’s optical center into the second image plane.
[U,V] =eigs(Fundamental_Matrix*Fundamental_Matrix');
e1 = U(:,1)./V(3,1);
%Epipole of the first camera’s optical center into the second image plane.
[U,V] =eig(Fundamental_Matrix'*Fundamental_Matrix);
e2 = U(:,1)./V(3,1);
