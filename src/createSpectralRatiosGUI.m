function createSpectralRatiosGUI

% ***********************************************************************************************************
%  createSpectralRatiosGUI - this function creates the gui for the spectral ratios
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

% this function creates a popup gui for the spectral ratio gui

global CM
global XDAS

% ************************************************************************************************************
% open the figure for the gui
% ************************************************************************************************************

% set up the default window size of the gui
xL = 240;        % left x value of the window
yB =  68;        % bottom y value of the window
xR = 1118;       % right x value of the window
yT = 723;        % top y value of the window
dx = xR - xL;    % width of the window
dy = yT - yB;    % height of the window

position = [ xL yB dx dy];

yheight = 25;
ystart  = 24*abs(yheight);

% define colors for the buttons
goGreen = XDAS.colors.goGreen;
stopRed = XDAS.colors.stopRed;


% create the figure window for the gui
XDAS.h.figure3 = uifigure('position',position,'Color','white','Name','DAS Explorer Spectral Ratios','Tag','Status List');
set(XDAS.h.figure3,'AutoResizeChildren','off');

% ************************************************************
% display shot information
% ************************************************************

% create the source (shot) location label
XDAS.h.fig3.sourceLabel = uilabel(XDAS.h.figure3,'fontweight','bold');
XDAS.h.fig3.sourceLabel.BackgroundColor = [1 1 1];
XDAS.h.fig3.sourceLabel.Position = [10 makeYup(15) 200 yheight];     
XDAS.h.fig3.sourceLabel.Text = 'Source Locations';     


XDAS.h.fig3.shotInfoTable = uitable(XDAS.h.figure3);
XDAS.h.fig3.shotInfoTable.BackgroundColor = [1 1 1];
XDAS.h.fig3.shotInfoTable.Position = [10 makeYup(11) 240 yheight*4];    
XDAS.h.fig3.shotInfoTable.ColumnName = { 'X', 'Z'};
XDAS.h.fig3.shotInfoTable.CellSelectionCallback = @shotSelectionRatioCallback;


% ************************************************************
% display well information
% ************************************************************

% create the well path label
XDAS.h.fig3.wellLabel = uilabel(XDAS.h.figure3,'fontweight','bold');
XDAS.h.fig3.wellLabel.BackgroundColor = [1 1 1];
XDAS.h.fig3.wellLabel.Position = [10 makeYup(20) 200 yheight];      
XDAS.h.fig3.wellLabel.Text = 'Well Trajectory';     

XDAS.h.fig3.wellInfoTable = uitable(XDAS.h.figure3);
XDAS.h.fig3.wellInfoTable.BackgroundColor = [1 1 1];
XDAS.h.fig3.wellInfoTable.Position = [10 makeYup(16) 240 yheight*4];    
XDAS.h.fig3.wellInfoTable.ColumnName = { 'MD','X', 'Z'};
XDAS.h.fig3.wellInfoTable.CellSelectionCallback = @wellSelectionRatioCallback;

% ************************************************************
% display reflector segment number
% ************************************************************

% create the reflector number label
XDAS.h.fig3.reflectorLabel = uilabel(XDAS.h.figure3,'fontweight','bold');
XDAS.h.fig3.reflectorLabel.BackgroundColor = [1 1 1];
XDAS.h.fig3.reflectorLabel.Position = [20 makeYup(10) 150 yheight];     
XDAS.h.fig3.reflectorLabel.Text = 'Reflector Numbers';     

XDAS.h.fig3.reflInfoTable = uitable(XDAS.h.figure3);
XDAS.h.fig3.reflInfoTable.BackgroundColor = [1 1 1];
XDAS.h.fig3.reflInfoTable.Position = [10 makeYup(6) 180 yheight*4];    
XDAS.h.fig3.reflInfoTable.ColumnName = { 'Reflector Number'};
XDAS.h.fig3.reflInfoTable.CellSelectionCallback = @reflectorSegmentSelectionRatioCallback;

% ************************************************************
% display segment information
% ************************************************************

% create the reflector Segment label
XDAS.h.fig3.segmentLabel = uilabel(XDAS.h.figure3,'fontweight','bold');
XDAS.h.fig3.segmentLabel.BackgroundColor = [1 1 1];
XDAS.h.fig3.segmentLabel.Position = [10 makeYup(5) 200 yheight];      
XDAS.h.fig3.segmentLabel.Text = 'Reflector Segment Locations';     

XDAS.h.fig3.segInfoTable = uitable(XDAS.h.figure3);
XDAS.h.fig3.segInfoTable.BackgroundColor = [1 1 1];
XDAS.h.fig3.segInfoTable.Position = [10 makeYup(1) 240 yheight*4];    
XDAS.h.fig3.segInfoTable.ColumnName = { 'X', 'Z'};

% ************************************************************
% create run button for spectral ratios
% ************************************************************

% create the "spectral ratio Shot" button
XDAS.h.fig3.pushbutton_spectralRatiosRecord = uibutton(XDAS.h.figure3);
XDAS.h.fig3.pushbutton_spectralRatiosRecord.Text = 'DAS/Geophone';
XDAS.h.fig3.pushbutton_spectralRatiosRecord.BackgroundColor = stopRed;
XDAS.h.fig3.pushbutton_spectralRatiosRecord.Position = [10 makeYup(24) 93 yheight];
XDAS.h.fig3.pushbutton_spectralRatiosRecord.Tooltip = 'Push to compare DAS versus Geophone ratios';
XDAS.h.fig3.pushbutton_spectralRatiosRecord.ButtonPushedFcn = @pushbutton_DAS2GeoSpectralRatios;

% create the "spectral ratio channel" button
XDAS.h.fig3.pushbutton_spectralRatiosChannel = uibutton(XDAS.h.figure3);
XDAS.h.fig3.pushbutton_spectralRatiosChannel.Text = 'Spec Ratio';
XDAS.h.fig3.pushbutton_spectralRatiosChannel.BackgroundColor = stopRed;
XDAS.h.fig3.pushbutton_spectralRatiosChannel.Position = [10 (makeYup(23)-5) 93 yheight];
XDAS.h.fig3.pushbutton_spectralRatiosChannel.Tooltip = 'Push to perform spectral ratios of DAS to DAS, and Geophone to Geophone';
XDAS.h.fig3.pushbutton_spectralRatiosChannel.ButtonPushedFcn = @pushbutton_DAS2DASSpectralRatios;

% create the edit source number
XDAS.h.fig3.edit_sourceNumber = uilabel(XDAS.h.figure3);
XDAS.h.fig3.edit_sourceNumber.Text = '1';
XDAS.h.fig3.edit_sourceNumber.HorizontalAlignment = 'center';
XDAS.h.fig3.edit_sourceNumber.BackgroundColor = [1 1 1];
XDAS.h.fig3.edit_sourceNumber.Position = [140 (makeYup(24)+2) 60 yheight];
XDAS.h.fig3.edit_sourceNumber.Tooltip = 'The source number to use - click a row in the source table to select a new source';

% create the source number label
XDAS.h.fig3.text_sourceNumber = uilabel(XDAS.h.figure3);
XDAS.h.fig3.text_sourceNumber.Text = 'Source';
XDAS.h.fig3.text_sourceNumber.BackgroundColor = [1 1 1];
XDAS.h.fig3.text_sourceNumber.Position = [110 (makeYup(24)+2) 45 yheight];

% create the edit reflector segment number
XDAS.h.fig3.edit_segmentNumber = uilabel(XDAS.h.figure3);
XDAS.h.fig3.edit_segmentNumber.Text = '1';
XDAS.h.fig3.edit_segmentNumber.HorizontalAlignment = 'center';
XDAS.h.fig3.edit_segmentNumber.BackgroundColor = [1 1 1];
XDAS.h.fig3.edit_segmentNumber.Position = [140 (makeYup(23)+4+3) 60 yheight];
XDAS.h.fig3.edit_segmentNumber.Tooltip = 'The reflector segment number to use - click a row in the Reflector table to select a new reflector';

% create the reflector segment number label
XDAS.h.fig3.text_segmentNumber = uilabel(XDAS.h.figure3);
XDAS.h.fig3.text_segmentNumber.Text = 'Refl';
XDAS.h.fig3.text_segmentNumber.BackgroundColor = [1 1 1];
XDAS.h.fig3.text_segmentNumber.Position = [110 (makeYup(23)+4+3) 45 yheight];

% create the edit channel number
XDAS.h.fig3.edit_channelNumber = uilabel(XDAS.h.figure3);
XDAS.h.fig3.edit_channelNumber.Text = '1';
XDAS.h.fig3.edit_channelNumber.HorizontalAlignment = 'center';
XDAS.h.fig3.edit_channelNumber.BackgroundColor = [1 1 1];
XDAS.h.fig3.edit_channelNumber.Position = [140 (makeYup(22)+10+3) 60 yheight];
XDAS.h.fig3.edit_channelNumber.Tooltip = 'The channel number to use - click a row in the Well Trajectory table to select a new receiver location';

% create the channel number label
XDAS.h.fig3.text_channelNumber = uilabel(XDAS.h.figure3);
XDAS.h.fig3.text_channelNumber.Text = 'Chan';
XDAS.h.fig3.text_channelNumber.BackgroundColor = [1 1 1];
XDAS.h.fig3.text_channelNumber.Position = [110 (makeYup(22)+10+3) 45 yheight];

% ************************************************************
% create axis for spectral ratio values
% ************************************************************


Ax.xLeftEdge   = 280;
Ax.yBottomEdge = 50;
Ax.xWidth      = xR - Ax.xLeftEdge - 20;
Ax.yHeight     = yT - Ax.yBottomEdge - 70;

XDAS.h.fig3.axes_model = uiaxes(XDAS.h.figure3,'fontsize',14,'fontweight','bold','BackgroundColor','white', ...
                                              'Position',[Ax.xLeftEdge Ax.yBottomEdge Ax.xWidth Ax.yHeight]);
                                          

function [yyy] = makeYup(irow)

yheight = 25;
ystart  = 24*(yheight);

yyy = 10 + irow*yheight;