% test loading in some data into MATLAB from microbit logging

microbitReadings = readtable('MagnetLargeGrid.csv');

fullGridMeasurements = zeros(6,5,4);

iRotCount = 1;
iX = 4;                                 % These will select what position/orientation to create graph of.
iY = 1;

 iMatch = microbitReadings.data_5==iX & microbitReadings.data_6==iY; % & microbitReadings.data_7==iRotCount;
% iMatch = microbitReadings.data_6==iY;       

% The 1st version plots the measurements for a specific x,y and rot value.
% The orientation can been commented out so that its not taken into account.
% The 2nd version will plot all the measurements at that specific y axis value

figure
plot(microbitReadings.data_1(iMatch))       % Magnetic field in x
hold on
plot(microbitReadings.data_2(iMatch))       % Magnetic field in y   
plot(microbitReadings.data_3(iMatch))       % Magnetic field in z
plot(microbitReadings.data_4(iMatch))       % Magnitude of magnetic field
title('Variation of Magnetic Field Strength at Position (4,1)')
ylabel('Magnetic Field Strength / µT')
legend('Strength X','Strength in Y','Strength in Z','Magnitude')
xticks([0])

%%

for iX = 1:6
    for iY = 1:5
      %   for iOri = 1:4
            iMatch = microbitReadings.data_5==iX & microbitReadings.data_6==iY; % & microbitReadings.data_7==iOri;
            if sum(iMatch) > 0
                thisTime = microbitReadings.data_0(iMatch);
                thisData = [microbitReadings.data_1(iMatch), ...
                    microbitReadings.data_2(iMatch),...
                    microbitReadings.data_3(iMatch),...
                    microbitReadings.data_4(iMatch)];
                    rmoutliers(thisData);

                nSamples = length(thisTime);
                if nSamples < 10
                    disp("For this location, not enough samples found")
                else
                    iKeep = 6:nSamples;
                    fullGridMeasurements(iX,iY,:) = mean(thisData(iKeep,:),1);
                end
            end
      %   end
    end
end

%%
figure
imagesc(fullGridMeasurements(:,:,3)')     % 4 = magnitude, 1 = FieldX
colorbar
colormap(flipud(winter))
title('Magnetic field around a bar magnet (z)')
xticks([1 2 3 4 5 6])
yticks([1 2 3 4 5])
ylabel(colorbar, 'Magnetic Field Strength / µT','Rotation',90)
axis xy

%%
quiver(fullGridMeasurements(:,:,1)', fullGridMeasurements(:,:,2)')
title('Magnetic vector field around a bar magnet')
xticks([1 2 3 4 5 6])
yticks([1 2 3 4 5])
grid on

%% plot all vectors in 3D at their specific location
figure
iZ=0;

for iX = 1:6
    for iY = 1:5
        thisVec = squeeze(fullGridMeasurements(iX,iY,1:3));
      % thisVec = thisVec/5000; % scaled vectors
        thisVec = 0.25 * thisVec/fullGridMeasurements(iX,iY,4);% normalised vectors

        line([iX iX+thisVec(2)],[iY iY+thisVec(1)],[iZ iZ+thisVec(3)]) % x and y are swapped
        hold on
        plot3(iX,iY,iZ,'ro')
    end
end
title('3D Vectors at Specific Location')
yticks([1 2 3 4 5])
axis equal vis3d

%% look at streamlines in 2D

% figure
l = streamslice(1:6,1:5,fullGridMeasurements(:,:,2)',fullGridMeasurements(:,:,1)');
xticks([0])
yticks([0])

