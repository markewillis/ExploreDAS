function ratioDAS2DAS(waveType,sourceType,shotNumber,segmentNumber,channelNumber)

% ***********************************************************************************************************
%  ratioDAS2DAS - this function computes the spectral rations between DAS channels
% ***********************************************************************************************************
%
% MIT License
% 
% Copyright (c) 2022 Mark E. Willis
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.
%
% ***********************************************************************************************************

global XDAS

% FIXME add option to gui to allow user to select the distance for the attenuation computation instead of hardwiring it
gapDistance = 4;

% *************************************************************************
% create the spectra of the two sets of data
% *************************************************************************

% create the spectral ratio plot
[freq] = mkFFTfreq(XDAS.obj.shotRecordRatio.dt,XDAS.obj.shotRecordRatio.nsamples);

fmax = 100;
[~,index] = min(abs(fmax-freq));
nplot = index(1);

fftOther = abs(fft(XDAS.obj.shotRecordRatio.tracesOther,XDAS.obj.shotRecordRatio.nsamples,1));
fftRef   = abs(fft(XDAS.obj.shotRecordRatio.tracesRef,  XDAS.obj.shotRecordRatio.nsamples,1));

% *************************************************************************
% plot out the spectral ratios map between the reference Geo and Geo data
% *************************************************************************

hfigRatioMapsG = findOrCreateFigure('RatioMapsGeo2Geo','Geophone to Geophone Spectral Ratio Maps');

subplot(1,2,1)
imagesc(XDAS.obj.shotRecordRatio.wellMD,freq(1:nplot),fftRef(1:nplot,:))
xlabel('Measured Depth (m)','fontweight','bold','fontsize',16)
ylabel('Freq (Hz)','fontweight','bold','fontsize',16)
% title([ 'Ref, Shot ' num2str(shotNumber) ' Reflector ' num2str(segmentNumber)],'fontweight','bold','fontsize',16)
title([ sourceType 'Geo (S ' num2str(shotNumber) ', Refl ' num2str(segmentNumber) ')'],'fontweight','bold','fontsize',16)
colormap(gca,jet)
set(gca,'fontweight','bold','fontsize',16)
axis xy
colorbar

geoRatios = 20*log10(fftRef(1:nplot,1+gapDistance:end) ./ fftRef(1:nplot,1:end-gapDistance));

subplot(1,2,2)
imagesc(XDAS.obj.shotRecordRatio.wellMD,freq(1:nplot),geoRatios)
colormap(jet)
xlabel('Measured Depth (m)','fontweight','bold','fontsize',16)
ylabel('Freq (Hz)','fontweight','bold','fontsize',16)
title([ 'Geo Ratio (S ' num2str(shotNumber) ', Refl ' num2str(segmentNumber) ')'],'fontweight','bold','fontsize',16)
set(gca,'fontweight','bold','fontsize',16)
colormap(gca,jet)
axis xy
colorbar

% *************************************************************************
% plot out the spectral ratios map between the reference DAS and DAS data
% *************************************************************************

hfigRatioMapsD = findOrCreateFigure('RatioMapsDAS2DAS','DAS to DAS Spectral Ratio Maps');

subplot(1,2,1)
imagesc(XDAS.obj.shotRecordRatio.wellMD,freq(1:nplot),fftOther(1:nplot,:))
xlabel('Measured Depth (m)','fontweight','bold','fontsize',16)
ylabel('Freq (Hz)','fontweight','bold','fontsize',16)
% title([ 'Ref, Shot ' num2str(shotNumber) ' Reflector ' num2str(segmentNumber)],'fontweight','bold','fontsize',16)
title([ sourceType 'DAS (S ' num2str(shotNumber) ', Refl ' num2str(segmentNumber) ')'],'fontweight','bold','fontsize',16)
colormap(gca,jet)
set(gca,'fontweight','bold','fontsize',16)
axis xy
colorbar

DASRatios = 20*log10(fftOther(1:nplot,1+gapDistance:end) ./ fftOther(1:nplot,1:end-gapDistance));

subplot(1,2,2)
imagesc(XDAS.obj.shotRecordRatio.wellMD,freq(1:nplot),DASRatios)
colormap(jet)
xlabel('Measured Depth (m)','fontweight','bold','fontsize',16)
ylabel('Freq (Hz)','fontweight','bold','fontsize',16)
title([ 'DAS Ratio (S ' num2str(shotNumber) ', Refl ' num2str(segmentNumber) ')'],'fontweight','bold','fontsize',16)
set(gca,'fontweight','bold','fontsize',16)
colormap(gca,jet)
axis xy
colorbar


return

