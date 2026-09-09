clear
clc
close all

project_root = fileparts(mfilename('fullpath'));
addpath(fullfile(project_root,'src'));

data_dir = fullfile(project_root,'data','frames');
output_dir = fullfile(project_root,'assets');

n_frames = 35;
dt = 10/60;
time = (0:n_frames-1)*dt;

radii = 140:170;
angles = -15:15;
shifts = -40:40;

areas = zeros(n_frames,1);
eye_centers = zeros(n_frames,2);
translation_speed = NaN(n_frames,1);
delta_theta = NaN(n_frames,1);
omega = NaN(n_frames,1);
rotation_phase = zeros(n_frames,1);

tracking_gif = fullfile(output_dir,'tracking.gif');
rotation_gif = fullfile(output_dir,'rotation.gif');
summary_png = fullfile(output_dir,'summary.png');

if ~exist(output_dir,'dir')
    mkdir(output_dir)
end

if exist(tracking_gif,'file')
    delete(tracking_gif)
end

if exist(rotation_gif,'file')
    delete(rotation_gif)
end

tracking_figure = figure('Position',[80 60 1500 800],'Color','w');
rotation_figure = figure('Position',[80 60 1400 800],'Color','w');

previous_center = [];
first_image = imread(fullfile(data_dir,'Frame_1.png'));

for k = 1:n_frames
    image = imread(fullfile(data_dir,sprintf('Frame_%d.png',k)));

    [cloud_mask,hole_mask] = segment_hurricane(image);
    [eye_mask,eye_center] = detect_eye(hole_mask,previous_center);

    eye_centers(k,:) = eye_center;
    previous_center = eye_center;

    cloud_mask = imfill(cloud_mask,'holes') & ~eye_mask;
    area_props = regionprops(cloud_mask,'Area');
    areas(k) = area_props.Area;

    if k > 1
        displacement = eye_centers(k,:) - eye_centers(k-1,:);
        translation_speed(k) = norm(displacement)/dt;

        previous_image = imread(fullfile(data_dir,sprintf('Frame_%d.png',k-1)));

        [delta_theta(k),errors,pattern_reference,pattern_best] = estimate_rotation( ...
            previous_image, ...
            image, ...
            eye_centers(k-1,:), ...
            eye_centers(k,:), ...
            radii, ...
            angles, ...
            shifts);

        omega(k) = delta_theta(k)/dt;
        rotation_phase(k) = rotation_phase(k-1) + delta_theta(k);
    else
        previous_image = [];
        errors = [];
        pattern_reference = [];
        pattern_best = [];
    end

    render_tracking_frame( ...
        tracking_figure, ...
        image, ...
        cloud_mask, ...
        eye_centers, ...
        rotation_phase, ...
        areas, ...
        translation_speed, ...
        omega, ...
        time, ...
        k);

    append_gif_frame(tracking_figure,tracking_gif,k == 1,0.25)

    if k > 1
        render_rotation_frame( ...
            rotation_figure, ...
            previous_image, ...
            image, ...
            eye_centers(k-1,:), ...
            eye_centers(k,:), ...
            radii, ...
            angles, ...
            delta_theta(k), ...
            shifts, ...
            errors, ...
            pattern_reference, ...
            pattern_best, ...
            omega(k), ...
            k);

        append_gif_frame(rotation_figure,rotation_gif,k == 2,0.25)
    end
end

mean_translation_speed = mean(translation_speed,'omitnan');
mean_rotation_speed = mean(omega,'omitnan');
maximum_area = max(areas);
minimum_area = min(areas);

fprintf('\nHURRICANE DORIAN ANALYSIS\n\n')
fprintf('Mean translation speed: %.2f km/h\n',mean_translation_speed)
fprintf('Mean rotation speed: %.2f deg/h\n',mean_rotation_speed)
fprintf('Maximum segmented area: %.0f km^2\n',maximum_area)
fprintf('Minimum segmented area: %.0f km^2\n',minimum_area)

render_summary( ...
    first_image, ...
    eye_centers, ...
    time, ...
    areas, ...
    translation_speed, ...
    omega, ...
    summary_png)
