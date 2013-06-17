%% Introduction
%  This program crops a rectangular portion of a given image
%    % Submitted By : Chiranjit Bordoloi & Hemashree Bordoloi
%  Date : 18-Jul-2010

%% Get Image
   clc; close all; clear all;               %clean board
   a = imread('143.jpg');                %read image
   [m n]= size(a);                          %get no of rows and column of the image matrix
   imshow(a)                                %display original image

%% Crop Image Using Submatrix Operation
   [y,x] = ginput(2);                       %select two cursor points
   r1 = x(1,1); c1 = y(1,1);                %get first cursor point = first corner of the rectangle
   r2 = x(2,1); c2 = y(2,1);                %get second cursor point = second corner of the rectangle
   b = a(r1:r2,c1:c2,:);                    %create the sub-matrix
   imshow(b)                                %display croped image
   imwrite(b,['../Video-Google/','ans.jpg'],'JPG');
   a='done'
