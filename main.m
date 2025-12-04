% this is the main driver file

% preprocess
% find trailmarkers
% bright orange circle 2x marker diameter

img_path = 'ADK_Images_Batch_A/IMG_20251004_152341611_HDR.jpg';
img = imread(img_path);

processed_img = preprocess_image(img);

%find_marker()

%draw_circle()

figure;
subplot(1,2,1);
imshow(img);
subplot(1,2,2);
imshow(processed_img);
