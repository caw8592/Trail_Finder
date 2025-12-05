% this function will preprocess the given image

function new_img = preprocess_image(img)
    img_lab = rgb2lab(img);

    img_b_channel = img_lab(:,:,3);

    binary_img = imbinarize(img_b_channel, 35);


    seSmall = strel('disk', 8);
    seMid   = strel('disk', 20);
    seLarge = strel('disk', 35);
    

    im = imopen(binary_img, seSmall);
    

    im = imclose(im, seLarge);
    

    im = imfill(im, 'holes');

    im = bwareaopen(im, 200);
    
    im = imclose(im, seMid);


    labeled = bwlabel(im);
    props = regionprops(labeled, 'Centroid', 'EquivDiameter');

    keepMask = false(size(im));

    for i = 1:length(props)
        c = props(i).Centroid;              % [x,y]
        r = props(i).EquivDiameter/2;       % approximate radius

        if isSurroundedByBrown(img, c, r)
            keepMask(labeled == i) = true;  % keep this region
        end
    end

    new_img = im;

end

function tf = isSurroundedByBrown(img, center, radius)
    % Slightly outside the detected yellow region
    rOuter = radius * 1.4;

    angles = linspace(0, 2*pi, 36);
    xs = center(1) + rOuter*cos(angles);
    ys = center(2) + rOuter*sin(angles);

    % Clamp to valid pixels
    xs = min(max(xs,1), size(img,2));
    ys = min(max(ys,1), size(img,1));

    % Sample pixel ring around circle
    samples = zeros(length(xs),3);
    for k = 1:length(xs)
        samples(k,:) = double(img(round(ys(k)), round(xs(k)), :));
    end

    % Convert to LAB for stable color classification
    lab = rgb2lab(uint8(samples));
    L = lab(:,1);  % lightness
    a = lab(:,2);  % red-green
    b = lab(:,3);  % yellow-blue



    barkDark  = (L >= 5 & L < 40)  & (a >= 0 & a <= 25) & (b >= 0 & b <= 30);
    barkMid   = (L >= 40 & L < 70)  & (a >= 5 & a <= 35) & (b >= 0 & b <= 35);
    barkBright= (L >= 70 & L <= 95) & (a >= 0 & a <= 30) & (b >= 0 & b <= 40);

    barkMask = barkDark | barkMid | barkBright;

    % More permissive threshold because wood can have cracks or highlights
    tf = mean(barkMask) > 0.35;
end

