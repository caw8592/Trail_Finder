% this function will preprocess the given image

function new_img = preprocess_image(img)
    img_lab = rgb2lab(img);

    img_b_channel = img_lab(:,:,3);

    binary_img = imbinarize(img_b_channel, 35);

    im = imopen(binary_img, strel('disk', 15)); 
    im = imclose(im, strel('disk', 150)); 
    im = imfill(im, 'holes'); 

    new_img = im;
end