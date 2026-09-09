function render_tracking_frame(fig,image,cloud_mask,eye_centers,rotation_phase,areas,translation_speed,omega,time,k)
clf(fig)
layout = tiledlayout(fig,2,3,'TileSpacing','compact','Padding','compact');

nexttile(layout,[2 1])
imshow(image)
hold on
plot(eye_centers(1:k,1),eye_centers(1:k,2),'y','LineWidth',2)
plot(eye_centers(k,1),eye_centers(k,2),'r+','MarkerSize',16,'LineWidth',2)
vector_length = 80;
u = vector_length*cosd(rotation_phase(k));
v = -vector_length*sind(rotation_phase(k));
quiver(eye_centers(k,1),eye_centers(k,2),u,v,0,'c','LineWidth',2,'MaxHeadSize',0.5)
hold off
title(sprintf('Eye Tracking - Frame %d',k),'FontSize',13)

nexttile(layout,2)
imshow(cloud_mask)
hold on
plot(eye_centers(k,1),eye_centers(k,2),'r+','MarkerSize',16,'LineWidth',2)
hold off
title('Hurricane Segmentation','FontSize',13)

nexttile(layout,3)
axis off

if k == 1
    info = {
        sprintf('FRAME %d',k)
        ''
        'TIME'
        sprintf('%.2f h',time(k))
        ''
        'STORM AREA'
        sprintf('%.0f km^2',areas(k))
        ''
        'TRANSLATION SPEED'
        'N/A'
        ''
        'ROTATION SPEED'
        'N/A'
    };
else
    info = {
        sprintf('FRAME %d',k)
        ''
        'TIME'
        sprintf('%.2f h',time(k))
        ''
        'STORM AREA'
        sprintf('%.0f km^2',areas(k))
        ''
        'TRANSLATION SPEED'
        sprintf('%.2f km/h',translation_speed(k))
        ''
        'ROTATION SPEED'
        sprintf('%.2f deg/h',omega(k))
    };
end

text(0.5,0.5,info,'Units','normalized','HorizontalAlignment','center','VerticalAlignment','middle','FontSize',13,'FontWeight','bold')

nexttile(layout,5)
plot(time(1:k),areas(1:k),'LineWidth',2)
xlabel('Time (h)')
ylabel('Area (km^2)')
xlim([time(1) time(end)])
area_max = max(areas(1:k));

if area_max > 0
    ylim([0 area_max*1.15])
end

grid on
title('Storm Area Evolution','FontSize',13)

nexttile(layout,6)
plot(time(1:k),translation_speed(1:k),'LineWidth',2)
xlabel('Time (h)')
ylabel('Translation speed (km/h)')
xlim([time(1) time(end)])
grid on
title('Eye Translation Speed','FontSize',13)
drawnow
end
