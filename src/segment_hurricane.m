function [cloud_mask,hole_mask] = segment_hurricane(image)
hsv_image = rgb2hsv(image);
saturation = hsv_image(:,:,2);
cloud_mask = saturation > 0.4;
se = strel('disk',3);
cloud_mask = imclose(cloud_mask,se);
cloud_mask = imopen(cloud_mask,se);
cloud_mask = bwareafilt(cloud_mask,1);
filled_mask = imfill(cloud_mask,'holes');
hole_mask = filled_mask & ~cloud_mask;
end
