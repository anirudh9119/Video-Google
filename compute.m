function compute(image1,image2)

%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

image1='/var/www/auto_gallery/train/001.jpg';
   image2='/var/www/auto_gallery/train/ans.jpg';
im = imread(image1);
im2 = imread(image2);

im = single(rgb2gray(im)); % Conversion to single is recommended
im2 = single(rgb2gray(im2)); % in the documentation

[f d] = vl_sift(im);
[f2 d2] = vl_sift(im2);

    % Where 1.5 = ratio between euclidean distance of NN2/NN1
[matches score] = vl_ubcmatch(d,d2,1.5); 

%subplot(1,2,1);
%imshow(uint8(I));
%hold on;
%plot(f(1,matches(1,:)),f(2,matches(1,:)),'b*');

%subplot(1,2,2);
%imshow(uint8(J));
%hold on;
%plot(f2(1,matches(2,:)),f2(2,matches(2,:)),'r*')


anirudh=3

if (size(im,1) > size(im2,1))
    longestWidth = size(im,1);       
else
    longestWidth = size(im2,1);
end

if (size(im,2) > size(im2,2))
    longestHeight = size(im,2);
else
    longestHeight = size(im2,2);
end


% create new matrices with longest width and longest height
newim = uint8(zeros(longestWidth, longestHeight, 3)); %3 cuz image is RGB
newim2 = uint8(zeros(longestWidth, longestHeight, 3));

% transfer both images to the new matrices respectively.
newim(1:size(im,1), 1:size(im,2)) = im;
newim2(1:size(im2,1), 1:size(im2,2)) = im2;

% with the same proportion and dimension, we can now show both
% images. Parts that are not used in the matrices will be black
imshow([newim newim2]);

hold on;

    X = zeros(2,1);
    Y = zeros(2,1);

    % draw line from the matched point in one image to the respective matched point in another image.
    for k=1:numel(matches(1,:))

        X(1) = f(1, matches(1, k));
        Y(1) = f(2, matches(1, k));
        X(2) = f2(1, matches(2, k)) + longestHeight; % for placing matched point of 2nd image correctly.
        Y(2) = f2(2, matches(2, k));

        line(X,Y);

    end
    a=4


end

