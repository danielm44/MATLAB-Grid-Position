clear
close all

v = VideoReader('IMG_0727.MOV');

%%

totalFrames = v.FrameRate*v.Duration;

theseFramesIndices = 1:15:totalFrames;

theseFrames = zeros(1476,1920,length(theseFramesIndices));
for iF = 1:length(theseFramesIndices)
    thisFrame = mean(read(v,theseFramesIndices(iF)),3);
    theseFrames(:,:,iF) = thisFrame;
end


%%
thisFrame = read(v,1200);
iXstart = 835; % crop from here
image(thisFrame(:,iXstart:end,:))
Icropped = thisFrame(:,iXstart:end,:);
shg

%% Look at RGB individually
figure
%Icropped = thisFrame(:,iXstart:end,:);
%imagesc(Icropped(:,:,1))
%%
% Icropped = mean(Icropped,3);
imagesc(Icropped(:,:,2)) %?
%%
imagesc(Icropped(:,:,3))


%% Convert to grayscale

Icropped = mean(Icropped,3);
imagesc(Icropped)
colormap(summer)

%%

hs = surf(Icropped);
hs.EdgeColor = 'none';
axis vis3d
xlabel('y Position')
ylabel('x Position')
xticks(0)
yticks(0)

%%

brightestValue = max(thisFrame(:));

[x,y] = find(thisFrame == brightestValue,1);

hold on
plot(y,x,'rx','linewidth',2)

%%

v = VideoReader('IMG_0727.MOV');

for iF = 1:v.Duration*v.FrameRate
    thisFrame = read(v,iF);
    thisFrame = mean(thisFrame,3);
    brightestValue = max(thisFrame(:));
    if brightestValue > 150
    startTime = (v.CurrentTime);
    break
    end
end

%%

microbitVidReadings = readtable('MagnetFieldVTest1.csv');


% for iC = startTime:0.1:v.Duration
%     F(iC) = microbitVidReadings.Var6(find(microbitVidReadings.sep_ == v.CurrentTime));
%     %thisFrame = read(v,iC);
%     %adjTime = v.CurrentTime - startTime;
% end 

figure
plot(microbitVidReadings.sep_, microbitVidReadings.Var6)
title('Measured Magnetic Field Strength Over Time')
xlabel('Time (s)')
ylabel('Magnetic Field Strength (µT)')

% magneticField when time in table = new adjusted time


% sync measured data with video
% By finding first frame where brightestValue > 150
% find magnetic reading at each timing
   

imagesc(theseFrames(:,:,1))
colormap(gray)
imagesc(theseFrames(:,:,10))
imagesc(mean(theseFrames(:,:,10),3))
imagesc(mean(theseFrames,3))
imagesc(mean(theseFrames(:,:,1),3))
imagesc(mean(theseFrames(:,:,200),3))
imagesc(std(theseFrames,[],3))

% Function that would enable dot to move across
% graph as video plays
% Show red cross at each position every __ seconds/frames
% Show magnetic field value / something that represents
% it at each cross

%%

microbitVidReadings = readtable('MagnetFieldVTest1.csv');


figure(2)
clf

p1 = subplot(1,2,1);
p2 = subplot(1,2,2);


t_microbit = microbitVidReadings.sep_;
y = microbitVidReadings.Var6;

subplot(p1)
plot(t_microbit,y)
hold on

p = plot(t_microbit(1),y(1),'o','MarkerFaceColor','red');
hold off
axis manual

subplot(p2)
im2 = imagesc(Icropped);
axis equal tight off

t_video = 0:1/v.FrameRate:v.Duration;
t_video = t_video(1:v.NumFrames);
t_video = t_video-startTime;


for i = 2:3:length(t_microbit)

    p.XData = t_microbit(i);
    p.YData = y(i);

    iFrame = round(interp1(t_video,1:v.NumFrames,t_microbit(i)));

    thisFrame = read(v,iFrame);
    this_Icropped = mean(thisFrame(:,iXstart:end,:),3);

    im2.CData = this_Icropped;

    drawnow
end


% 
% thisFrame = read(v,iF);
% thisFrame = read(v,600);
% iXstart = 835; % crop from here
% image(thisFrame(:,iXstart:end,:))


