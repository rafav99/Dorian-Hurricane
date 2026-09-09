function render_summary(first_image,eye_centers,time,areas,translation_speed,omega,path)
fig = figure('Position',[100 60 1200 850],'Color','w');

subplot(2,2,1)
imshow(first_image)
hold on
plot(eye_centers(:,1),eye_centers(:,2),'y','LineWidth',2)
plot(eye_centers(1,1),eye_centers(1,2),'g+','MarkerSize',14,'LineWidth',2)
plot(eye_centers(end,1),eye_centers(end,2),'r+','MarkerSize',14,'LineWidth',2)
hold off
title('Eye Trajectory')

subplot(2,2,2)
plot(time,areas,'LineWidth',2)
xlabel('Time (h)')
ylabel('Area (km^2)')
title('Storm Area Evolution')
grid on

subplot(2,2,3)
plot(time,translation_speed,'LineWidth',2)
xlabel('Time (h)')
ylabel('Translation speed (km/h)')
title('Eye Translation Speed')
grid on

subplot(2,2,4)
plot(time,omega,'LineWidth',2)
xlabel('Time (h)')
ylabel('\omega (deg/h)')
title('Estimated Rotation Speed')
grid on

exportgraphics(fig,path,'Resolution',200)
end
