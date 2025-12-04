function [centers, radii] = find_marker(img)

    [centers, radii] = imfindcircles(img, [50 100], Sensitivity=.95);

    % check if they are surrounded by brown?
end