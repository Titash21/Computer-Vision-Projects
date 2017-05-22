% Read original image
function gauss_filtered_image1=demo_gaussian_filter(original_image1,original_image2)
gauss_filtered_image1 = gaussian_filter(original_image1, 2.0);
gauss_filtered_image2 = gaussian_filter(original_image2, 5.0);

figure('Position', [100, 100, 800, 800]);
subplot(3,1,1);
imshow(original_image1);
title('Original image');

subplot(3,1,2);
imshow(gauss_filtered_image1);
title('Gaussian filter sigma=2.0');

subplot(3,1,3);
imshow(gauss_filtered_image2);
title('Gaussian filter sigma=2.0');