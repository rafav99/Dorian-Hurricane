function render_rotation_frame(fig,previous_image,current_image,previous_center,current_center,radii,angles,delta_theta,shifts,errors,pattern_reference,pattern_best,omega,k)
clf(fig)
layout = tiledlayout(fig,2,2,'TileSpacing','compact','Padding','compact');

nexttile(layout,1)
imshow(previous_image)
hold on
plot(previous_center(1),previous_center(2),'r+','MarkerSize',16,'LineWidth',2)
draw_sector(previous_center,radii,angles,'y')
hold off
title(sprintf('Reference Sector - Frame %d',k-1),'FontSize',13)

nexttile(layout,2)
imshow(current_image)
hold on
plot(current_center(1),current_center(2),'r+','MarkerSize',16,'LineWidth',2)
draw_sector(current_center,radii,angles + delta_theta,'c')
hold off
title(sprintf('Best Match - Frame %d | \\Delta\\theta = %.0f deg',k,delta_theta),'FontSize',13)

nexttile(layout,3)
separator = ones(8,size(pattern_reference,2),3);
comparison = cat(1,pattern_reference,separator,pattern_best);
image(comparison)
axis image
axis off
title('RGB Annular Pattern Matching','FontSize',13)

nexttile(layout,4)
plot(shifts,errors,'LineWidth',2)
hold on
plot(delta_theta,min(errors),'r+','MarkerSize',14,'LineWidth',2)
hold off
xlabel('\Delta\theta (deg)')
ylabel('Mean Squared Error')
grid on
title(sprintf('Rotation Estimate: %.0f deg | \\omega = %.1f deg/h',delta_theta,omega),'FontSize',13)
drawnow
end

function draw_sector(center,radii,angles,color)
inner_radius = min(radii);
outer_radius = max(radii);
inner_x = center(1) + inner_radius*cosd(angles);
inner_y = center(2) - inner_radius*sind(angles);
outer_x = center(1) + outer_radius*cosd(angles);
outer_y = center(2) - outer_radius*sind(angles);
plot(inner_x,inner_y,color,'LineWidth',2)
plot(outer_x,outer_y,color,'LineWidth',2)
first_angle = angles(1);
last_angle = angles(end);
plot(center(1) + [inner_radius outer_radius]*cosd(first_angle),center(2) - [inner_radius outer_radius]*sind(first_angle),color,'LineWidth',2)
plot(center(1) + [inner_radius outer_radius]*cosd(last_angle),center(2) - [inner_radius outer_radius]*sind(last_angle),color,'LineWidth',2)
end
