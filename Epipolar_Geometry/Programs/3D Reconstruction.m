%Read the first image
Original_Image=imread('C:\NYU_SEM_2\Computer Vision\Assignment 2\Straight.jpg');
imshow(Original_Image);
%select the 6 definite boundary points in the image
[X_Original,Y_Original]=ginput(6)
%Read the second image
Shifted_Image=imread('C:\NYU_SEM_2\Computer Vision\Assignment 2\Shift.jpg');
imshow(Shifted_Image)
%select the 6 definite boundary points in the image
[X_Shifted,Y_Shifted]=ginput(6)
format long g
% disparity horizontal nnd vertical in pixel units
disparity_in_X=(X_Shifted-X_Original)
disparity_in_Y=(Y_Shifted-Y_Original)
%depth Z= fB/d
Depth_Z=(3.6*228.6)./disparity_in_X;
%calculating the world co-ordinates from the depth and the pixel
%co-ordinates
[World_Xp_Original]=(X_Original.*Depth_Z)./4.15
[World_Yp_Original]=(Y_Original.*Depth_Z)./4.15
[World_Xp_Shifted]=(X_Shifted.*Depth_Z)./4.15
[World_Yp_Shifted]=(Y_Shifted.*Depth_Z)./4.15

% disparity horizontal nnd vertical in mm units
disparity_in_X_World=(World_Xp_Shifted-World_Xp_Original)
disparity_in_Y_World=(World_Yp_Shifted-World_Yp_Original)

%plotting the World co-oridates of the image in the original position
plot3(World_Xp_Original,World_Yp_Original,Depth_Z,'k-')
grid on
%make a matrix containing the X,Y,Z world co-ordinates to help in plotting
%lines using them
Matrix_of_All_Coordinates=[World_Xp_Original,World_Yp_Original,Depth_Z];
plot3(Matrix_of_All_Coordinates(:,1),Matrix_of_All_Coordinates(:,2),Matrix_of_All_Coordinates(:,3),'.')
hold on;
k = boundary(Matrix_of_All_Coordinates,0);
j = boundary(Matrix_of_All_Coordinates,1);
plot3(Matrix_of_All_Coordinates(:,1),Matrix_of_All_Coordinates(:,2),Matrix_of_All_Coordinates(:,3),'.','MarkerSize',10)
trisurf(k,Matrix_of_All_Coordinates(:,1),Matrix_of_All_Coordinates(:,2),Matrix_of_All_Coordinates(:,3),'Facecolor','blue')



