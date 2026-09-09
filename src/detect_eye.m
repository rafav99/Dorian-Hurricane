function [eye_mask,eye_center] = detect_eye(hole_mask,previous_center)
if isempty(previous_center)
    eye_mask = bwareafilt(hole_mask,1);
    props = regionprops(eye_mask,'Centroid');

    if isempty(props)
        error('No eye candidate was detected in the first frame.')
    end

    eye_center = props.Centroid;
    return
end

labels = bwlabel(hole_mask);
props = regionprops(labels,'Centroid');

if isempty(props)
    error('No eye candidate was detected in the current frame.')
end

centers = cat(1,props.Centroid);
distances = vecnorm(centers - previous_center,2,2);
[~,index] = min(distances);
eye_mask = labels == index;
eye_center = props(index).Centroid;
end
