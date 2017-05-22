%% Split video to images
vid = VideoReader(video_name);
numFrames = vid.NumberOfFrames;
n = numFrames;
%n = 10;
mkdir Video2Images;
currentFolder = pwd;

for i = 1:5:n
frames = read(vid, i);
imwrite(frames,[currentFolder '/Video2Images/image' int2str(i), '.jpeg']);
im(i) = image(frames);
end