function [delta_theta,errors,pattern_reference,pattern_best] = estimate_rotation(previous_image,current_image,previous_center,current_center,radii,angles,shifts)
previous_image = im2double(previous_image);
current_image = im2double(current_image);

pattern_reference = sample_pattern(previous_image,previous_center,radii,angles);
errors = zeros(numel(shifts),1);
pattern_best = [];
best_error = inf;

for index = 1:numel(shifts)
    shifted_angles = angles + shifts(index);
    candidate = sample_pattern(current_image,current_center,radii,shifted_angles);
    errors(index) = mean((pattern_reference(:)-candidate(:)).^2);

    if errors(index) < best_error
        best_error = errors(index);
        pattern_best = candidate;
    end
end

[~,best_index] = min(errors);
delta_theta = shifts(best_index);
end

function pattern = sample_pattern(image,center,radii,angles)
pattern = zeros(numel(radii),numel(angles),3);
height = size(image,1);
width = size(image,2);

for angle_index = 1:numel(angles)
    theta = angles(angle_index);
    x = round(center(1) + radii*cosd(theta));
    y = round(center(2) - radii*sind(theta));
    x = max(1,min(width,x));
    y = max(1,min(height,y));

    for radius_index = 1:numel(radii)
        pattern(radius_index,angle_index,:) = image(y(radius_index),x(radius_index),:);
    end
end
end
