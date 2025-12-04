% this is the main driver file

% preprocess
% find trailmarkers
% bright orange circle 2x marker diameter

files = dir('ADK_Images_Batch_A/*.jpg');
i = 0;
for file = files'
    if i==10 
        break 
    end
    img_path = file.name;
    fprintf("Running %s\n", img_path);
    %img_path = 'ADK_Images_Batch_A/IMG_20251004_152341611_HDR.jpg';

    img = imread(img_path);
    
    processed_img = preprocess_image(img);
    
    [centers, radii] = find_marker(processed_img);
    
    figure;
    title(img_path);
    imagesc(img);
    viscircles(centers, radii*2, Color='#FFA500');
    i = i+1;
end