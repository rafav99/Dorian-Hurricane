function append_gif_frame(fig,path,is_first,delay)
drawnow
frame = getframe(fig);
rgb = frame2im(frame);
[indexed,map] = rgb2ind(rgb,256);

if is_first
    imwrite(indexed,map,path,'gif','LoopCount',inf,'DelayTime',delay)
else
    imwrite(indexed,map,path,'gif','WriteMode','append','DelayTime',delay)
end
end
