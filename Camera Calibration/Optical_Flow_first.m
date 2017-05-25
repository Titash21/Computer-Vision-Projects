%read the image from the location of the computer
	img1=imread('C:\Users\ Computer Vision\CV Assignment\original.jpg');
	imshow(img1);
%estimation of the pixel co-ordinates from the selected points on the image
	[xa,ya]=ginput();
	[xb,yb]=ginput();
	[xc,yc]=ginput();
	[xd,yd]=ginput();
	[xe,ye]=ginput();
	[xf,yf]=ginput();
%estimation of the P matrix and storing it in a excel sheet and copying it to MATLAB by extracting it.
	P=xlsread('C: \Desktop\CV Assignment\pmatrix.xlsx');
	Format long g
%estimating camera calibration
	[U,S,V]=svd(P);
	[min_val,min_index]=min(diag(S(1:12,1:12)));
	m=V(1:12,min_index);
% converting the matrix to a 3×4 matrix
	M=[m(1:4)';m(5:8)';m(9:12)';]
	tz=M(4,3);
	r3t=[M(3,1:3)];
	a1=[M(1,1:3)]';
	a2=[M(2,1:3)]';
	a3=[M(3,1:3)]';
% estimating the intrinsic parameters
	roh=1/(norm(a3));
	u_0=(roh*roh)*(dot(a1,a3));
	v_0=(roh*roh)*(dot(a2,a3));
	r3=roh*a3;
	a1crossa3=cross(a1,a3);
	a2crossa3=cross(a2,a3);
	costheta=-(dot(a1crossa3,a2crossa3))/(norm(a1crossa3)*norm(a2crossa3));
	theta=acosd(costheta);
	alpha=(roh*roh)*(norm(a1crossa3))*sind(theta);
	beta=(roh*roh)*(norm(a2crossa3))*sind(theta);
% estimating the extrinsic parameters
	r1=a2crossa3/norm(a2crossa3);
	r2=cross(r3,r1);
	K=[alpha, -1*alpha*cot(theta),u_0;0,beta/sin(theta),v_0;0,0,1];
	b=M(1:3,4);
	t=roh*(inv(K)*b);
	Intrinsic=[alpha,beta,theta,u_0,v_0];
	Extrinsic=[r1,r2,r3,t];
	my_X=[xa,xb,xc,xd,xe,xf];
	my_Y=[ya,yb,yc,yc,ye,yf];
	worldX=[121,65,121,0,0,0];
	worldY=[124,68,209,97,154,210];
	worldZ=[0,0,0,66,121,150];
%reconstruction of the image coordinates and estimation of error
for i=1:6
	temporary(1:4)=[worldX(i) worldY(i) worldZ(i) 1];
	recon=M*temporary';
	reconsX(i)=recon(1)/recon(3);
	reconsY(i)=recon(2)/recon(3);
	error(i)=norm([reconsX(i)-my_X(i) reconsY(i)-my_Y(i)]);
end