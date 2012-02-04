% Assignment 2 - Intensity transformation and filtering
% TDT4195 - Image Techniques
% ================================================
% Add code to this file where indicated and deliver on Itslearning before deadline


%!!!!!!!!!!!!!!FOR EACH CREATED/RESTORED IMAGE: SAVE IT AND UPLOAD ON ITSLEARNING!!!!!!!!!!

% === 1 - Intensity and Histogram processing ===

% Task 1.1 - Load the image dark.tif. Display the histogram on the screen. 
% Then use the imadjust function to make the image more visible, 

im_dark = imread('images/dark.tif');
%figure('Name', 'Original'), imshow(im_dark);
%figure('Name', 'Original Hist'), imhist(im_dark);

% show the new image and its histogram on screen
im_adj = imadjust(im_dark);
%figure('Name', 'Adjusted'), imshow(im_adj);
%figure('Name', 'Adjusted Hist'), imhist(im_adj);


% Task 1.2 - Use the built-in Histogram Equalization function on the
% dark.png image
hist_eq = histeq(im_dark);
%figure('Name', 'Histogram Equalization'), imshow(hist_eq);

% Task 1.3 - Create a 4x4 image with random values from 0 to 7. Make a
% program that performs Histogram Equalization on this image. (do not use
% the built-in HE function) See 3.2.2 in the book. Tip: first create a
% histogram, then normalize it, create cumulative distribution function and
% then do the intensity transformation.

image = ceil(rand(4,4)*8) - 1; % Creates a 4x4 random image with values 0 to 7
output = zeros(4,4); % the output image after HE
n = 4*4; % total size of image

% Make Histogram
histogram = zeros(1,8); 
%figure, imshow(image);
%disp('Image');
%disp(image);

% Because of MATLAB-indexing starting at 1,
% not 0, we have to put all values at index
% value + 1 (since lowest value is 0, not 1)
for i = 1 : 4
    for j = 1 : 4
        histogram(image(i,j) + 1) = histogram(image(i,j) + 1) + 1;
    end
end
%disp('Histogram');
%disp(histogram);

% Normalize histogram
norm_histogram = histogram/sum(histogram);
%disp('Normalized histogram');
%disp(norm_histogram);

% Make cumulative distribution function (CDF)
cdf = zeros(1,8);
for i = 1:8
  for j = i:-1:1
    cdf(i) = cdf(i) + norm_histogram(j);
    end
end
%disp('CDF');
%disp(cdf);

% Do intensity transformation based on CDF
t_img = zeros(4,4);
for i = 1:4
  for j = 1:4
    t_img(i,j) = image(i,j).*cdf(image(i,j) + 1);
  end
end
%figure, imshow(t_img);
%disp('Intensity transformed Image');
%disp(t_img);

% Task 1.4 - Load the image mamm.tif and perform Histogram matching on this
% image with a gaussian with mean 0.5 and std 0.25. You can use the
% supplied gaussian function

mamm = imread('images/mamm.tif');
% Create histogram for this image 
mamm_hist = zeros(1,256);
for i = 1 : length(mamm(:,1,1))
    for j = 1 : length(mamm(1,:,1))
        mamm_hist(mamm(i,j) + 1) = mamm_hist(mamm(i,j) + 1) + 1;
    end
end

mamm_pref = gaussian(0.5, 0.25);
img_histmatch = histeq(mamm, mamm_pref);
%figure('Name', 'mamm.tif'), imshow(mamm);
%figure('Name', 'mamm.tif Adjusted'), imshow(img_histmatch);


% Task 1.5 - Load the image space.tif. Show the histogram and use HE to try
% to spread the intensity values. Look at both images. What happens? 
% Try to use Local adaptive Histogram Equalization instead and experiment 
% with the number of tiles to create the best result. Show the histogram 
% after local adaptive HE. What was best? Why?
space = imread('images/space.tif');
figure('Name', 'Space.tif'), imshow(space);
figure('Name', 'Space.tif Histogram'), imhist(space);

% === 2 - Spatial filtering ===

% Task 2.1 - Implement a filter with an averaging mask for images as a function 
% and make it possible to set the size of the filtering area (do not use the 
% built-in filtering functions) Tip: Use the matlab function sum() to 
% retrieve the sum of all values in an array

% Task 2.2 - Implement the median filter for images as a function
% and make it possible to set the size of the filtering area (do not use the 
% built-in filtering/median functions). Tip: Use the matlab function 
% median() to retrieve the median value of an array

% Task 2.3 - Create a gaussian mask with standard deviation = 1.0 and size 3x3


% Task 2.4 - Load image assignment.png and convert it to grayscale and double 
% (values from 0.0 to 1.0)


% Task 2.5 - Filter the image with the gaussian mask in task 3 and show the
% image on screen


% Task 2.6 - Create a copy of the image in task 4 with salt-and-pepper noise 
% and another copy of the image with gaussian noise. Show both images on
% screen


% Task 2.7 - For each noise type use an appropriate spatial filtering method to remove the noise 
% and experiment with different parameter values for the filtering methods


% Task 2.8 - Calculate the image gradients of assingment.png (task 2.4)


% Task 2.9 - Show the vector field of the image gradients on top of the image 
% by using the quiver function after the following statement: 
% figure; imshow(<original image>), axis image; hold on; (zoom in to
% see all the vectors properly)



% Task 2.10 - Calculate the magnitude of this vector field and display it


% Task 2.11 - Blur assignment.png and then sharpen(improve the edges/remove
% blur) the blurred image. Show the images on screen

% === 3 - Frequency filtering ===

% !!! Functions from the book can be downloaded from: 
% http://www.gatesmark-orders.com/student_application_dipum2e_support_package.php

% Task 3.1 - Perform blurring and find edges of the same image as in task 
% 2.4 by filtering in the Frequency domain. You can use the lpfilter and 
% hpfilter functions from the book, but not dftfilt. You can also use the
% lpfilter2 and hpfilter2 functions uploaded on itslearning


% Task 3.2 - (optional) Load the image clown.png convert it to double(0.0 to 1.0) and
% remove the periodic noise using a reject filter in the frequency domain.
% You can use the cnotch function from the book or you can make the filter 
% yourself in paint or something equivilant. 
% Tip: use % tools->data cursor to find coordinates in the image displayed with imshow



