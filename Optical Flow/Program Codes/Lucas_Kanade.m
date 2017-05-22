%% Weighted Lucas and Kanade
sigma=1.2;
%generate Gaussian Kernel
for l=-(ceil(3*sigma)):1:ceil(3*sigma)
    g(l+(ceil(3*sigma))+1)=(1/(sqrt(2*pi)*sigma))*(exp(-0.5*((l-0)/sigma)^2));
end
G=g/sum(g);
weight1=G';
weight2=G;
gaussian_kernel = weight1*weight2;
%gaussian_kernel = reshape(gaussian_kernel,1,49);
for i = ceil(size(kernel,1)/2)+1 :1: size(I2,1)-size(kernel,1)+ceil(size(kernel,1)/2)-1
for j = ceil(size(kernel,2)/2)+1 :1: size(I2,2)-size(kernel,2)+ceil(size(kernel,2)/2)-1
t=1;
for(a=-ceil(size(kernel,1)/2)+1:1:ceil(size(kernel,1)/2))-1
for(b=-ceil(size(kernel,1)/2)+1:1:ceil(size(kernel,1)/2))-1
A(t,1) = gaussian_kernel(a+4,b+4)*Ix(i+a,j+b);
A(t,2) = gaussian_kernel(a+4,b+4)*Iy(i+a,j+b);
bb(t) = -gaussian_kernel(a+4,b+4)*time_gradient(i+a,j+b);
t=t+1;
end
end
vecteur2(i,j,:) = inv(A'*(A))*A'*bb';
end
end