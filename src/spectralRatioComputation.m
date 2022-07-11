function spectralRatioComputation(hObject, ratioType)

% ***********************************************************************************************************
%  spectralRatioComputation - this function performs the spectral ratio computation
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

goGreen = [.81 .97 .71];
stopRed = [1 .7 .7];

% get the selected shot number
shotNumber = str2double(XDAS.h.fig3.edit_sourceNumber.Text);

% get the selected reflector segment number
segmentNumber = str2double(XDAS.h.fig3.edit_segmentNumber.Text);

% get the selected reflector segment number
channelNumber = str2double(XDAS.h.fig3.edit_channelNumber.Text);


set(hObject,'BackgroundColor',goGreen)
drawnow

switch get(XDAS.h.simulation.listbox_waveType,'value')
    case 3
        waveType = 'VPZ';
        sourceType = 'VP';
    case 1
        waveType = 'VPDAS';
        sourceType = 'VP';
    case 4
        waveType = 'VSH';
        sourceType = 'VS';
    case 2
        waveType = 'VSDAS';
        sourceType = 'VS';
end

% create the shot record
[problems] = createOneShotForRatios(shotNumber,segmentNumber,waveType);

if problems
    disp(['Do something here about failure to run create the data for spectral ratios'])
    return
end

% *************************************************************************
% crude solution - if direct wave selected - just copy the direct over
% *************************************************************************

if segmentNumber < 1
    % direct wave wanted - replace (empty) reflection data with direct data
    XDAS.obj.shotRecordRatio.tracesRef   = XDAS.obj.shotRecordRatio.tracesRefDirect;
    XDAS.obj.shotRecordRatio.tracesOther = XDAS.obj.shotRecordRatio.tracesOtherDirect;
end

% *************************************************************************
% plot out the two seismic records - reference & DAS
% *************************************************************************

hfigSeismic = findOrCreateFigure('RatioSeismic','Records for Spectral Ratios');

subplot(1,2,1)
imagesc(XDAS.obj.shotRecordRatio.wellMD,XDAS.obj.shotRecordRatio.timeAxis,XDAS.obj.shotRecordRatio.tracesRef)
colormap(gca,bone)
xlabel('Measured Depth (m)','fontweight','bold','fontsize',16)
ylabel('Time (s)','fontweight','bold','fontsize',16)
title([ sourceType 'Geo (S ' num2str(shotNumber) ', Refl ' num2str(segmentNumber) ')'],'fontweight','bold','fontsize',16)
set(gca,'fontweight','bold','fontsize',16)

subplot(1,2,2)
imagesc(XDAS.obj.shotRecordRatio.wellMD,XDAS.obj.shotRecordRatio.timeAxis,XDAS.obj.shotRecordRatio.tracesOther)
colormap(gca,bone)
xlabel('Measured Depth (m)','fontweight','bold','fontsize',16)
ylabel('Time (s)','fontweight','bold','fontsize',16)
title([ waveType ' (S ' num2str(shotNumber) ', Refl ' num2str(segmentNumber) ')'],'fontweight','bold','fontsize',16)
set(gca,'fontweight','bold','fontsize',16)

% *************************************************************************
% perform the spectral ratio computations
% *************************************************************************

switch ratioType
    case 'DAS2Geo'
        
        ratioDAS2Geo(waveType,sourceType,shotNumber,segmentNumber,channelNumber)

        
    case 'DAS2DAS'
        
        ratioDAS2DAS(waveType,sourceType,shotNumber,segmentNumber,channelNumber)
        
end



set(hObject,'BackgroundColor',stopRed)
drawnow

