function statusSummary

% ***********************************************************************************************************
%  statusSummary - this function displays the status of all the data in the modeling session
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

% this function creates a popup gui that summarizes all the data in modeling session

global XDAS

% ************************************************************************************************************
% open the figure for the gui
% ************************************************************************************************************

% set up the default window size of the gui
xL = 240;        % left x value of the window
yB =  68;        % bottom y valule of the window
xR = 1118;       % right x value of the window
yT = 723;        % top y value of the window
dx = xR - xL;    % width of the window
dy = yT - yB;    % height of the window

position = [ xL yB dx dy];

yheight = 25;
ystart  = 24*abs(yheight);

% create the figure window for the gui
XDAS.h.figure2 = uifigure('position',position,'Color','white','Name','DAS Explorer Status','Tag','Status List');
set(XDAS.h.figure2,'AutoResizeChildren','off');

% ************************************************************
% display the current directory/folder options
% ************************************************************

% create the data directory
XDAS.h.fig2.directoryInfo = uilabel(XDAS.h.figure2,'fontweight','bold');
XDAS.h.fig2.directoryInfo.Text = ['Files and Directories'];
XDAS.h.fig2.directoryInfo.BackgroundColor = [1 1 1];
XDAS.h.fig2.directoryInfo.Position = [10 makeY(1) 800 yheight];     

% create the model file name
XDAS.h.fig2.modelFileName = uilabel(XDAS.h.figure2);
XDAS.h.fig2.modelFileName.BackgroundColor = [1 1 1];
XDAS.h.fig2.modelFileName.Position = [10 makeY(2) 800 yheight];     

% create the data directory
XDAS.h.fig2.dirData = uilabel(XDAS.h.figure2);
XDAS.h.fig2.dirData.BackgroundColor = [1 1 1];
XDAS.h.fig2.dirData.Position = [10 makeY(3) 800 yheight];     

% create the resources directory
XDAS.h.fig2.dirRsrcs = uilabel(XDAS.h.figure2);
XDAS.h.fig2.dirRsrcs.BackgroundColor = [1 1 1];
XDAS.h.fig2.dirRsrcs.Position = [10 makeY(4) 800 yheight];     


% ************************************************************
% display the model parameters
% ************************************************************

% create the model info
XDAS.h.fig2.modelInfo = uilabel(XDAS.h.figure2,'fontweight','bold');
XDAS.h.fig2.modelInfo.Text = ['Model Information'];
XDAS.h.fig2.modelInfo.BackgroundColor = [1 1 1];
XDAS.h.fig2.modelInfo.Position = [10 makeY(5) 380 yheight];     

% create the model x extent 
XDAS.h.fig2.modelX = uilabel(XDAS.h.figure2);
XDAS.h.fig2.modelX.BackgroundColor = [1 1 1];
XDAS.h.fig2.modelX.Position = [10 makeY(6) 380 yheight];     

% create the model z extent 
XDAS.h.fig2.modelZ = uilabel(XDAS.h.figure2);
XDAS.h.fig2.modelZ.BackgroundColor = [1 1 1];
XDAS.h.fig2.modelZ.Position = [10 makeY(7) 380 yheight];     


% create the velocity information 
XDAS.h.fig2.velocityInfo = uilabel(XDAS.h.figure2);
XDAS.h.fig2.velocityInfo.BackgroundColor = [1 1 1];
XDAS.h.fig2.velocityInfo.Position = [10 makeY(8) 380 yheight];


% create the source  information 
XDAS.h.fig2.sourceInfo = uilabel(XDAS.h.figure2);
XDAS.h.fig2.sourceInfo.BackgroundColor = [1 1 1];
XDAS.h.fig2.sourceInfo.Position = [10 makeY(9) 380 yheight];

% create the trace record information 
XDAS.h.fig2.traceInfo = uilabel(XDAS.h.figure2);
XDAS.h.fig2.traceInfo.BackgroundColor = [1 1 1];
XDAS.h.fig2.traceInfo.Position = [10 makeY(10) 380 yheight];

% **************************************************************
% create the Fiber info
% **************************************************************

XDAS.h.fig2.fiberInfo = uilabel(XDAS.h.figure2,'fontweight','bold');
XDAS.h.fig2.fiberInfo.Text = ['DAS Information'];
XDAS.h.fig2.fiberInfo.BackgroundColor = [1 1 1];
XDAS.h.fig2.fiberInfo.Position = [10 makeY(11) 380 yheight];     

% create the gauge length information 
XDAS.h.fig2.GLInfo = uilabel(XDAS.h.figure2);
XDAS.h.fig2.GLInfo.BackgroundColor = [1 1 1];
XDAS.h.fig2.GLInfo.Position = [10 makeY(12) 380 yheight];

% create the first breaks information 
XDAS.h.fig2.firstbreaksInfo = uilabel(XDAS.h.figure2);
XDAS.h.fig2.firstbreaksInfo.BackgroundColor = [1 1 1];
XDAS.h.fig2.firstbreaksInfo.Position = [10 makeY(13) 380 yheight];

% create the optical noise information 
XDAS.h.fig2.opticalNoiseInfo = uilabel(XDAS.h.figure2);
XDAS.h.fig2.opticalNoiseInfo.BackgroundColor = [1 1 1];
XDAS.h.fig2.opticalNoiseInfo.Position = [10 makeY(14) 380 yheight];

% create the common mode noise information 
XDAS.h.fig2.CMNInfo = uilabel(XDAS.h.figure2);
XDAS.h.fig2.CMNInfo.BackgroundColor = [1 1 1];
XDAS.h.fig2.CMNInfo.Position = [10 makeY(15) 380 yheight];

% create the polarity information 
XDAS.h.fig2.polarityInfo = uilabel(XDAS.h.figure2);
XDAS.h.fig2.polarityInfo.BackgroundColor = [1 1 1];
XDAS.h.fig2.polarityInfo.Position = [10 makeY(16) 380 yheight];


% *****************************************************************
% display the migration parameters
% *****************************************************************

XDAS.h.fig2.migrationInfo = uilabel(XDAS.h.figure2,'fontweight','bold');
XDAS.h.fig2.migrationInfo.Text = ['Migration Information'];
XDAS.h.fig2.migrationInfo.BackgroundColor = [1 1 1];
XDAS.h.fig2.migrationInfo.Position = [10 makeY(17) 380 yheight];     

% create the model x extent 
XDAS.h.fig2.migXInfo = uilabel(XDAS.h.figure2);
XDAS.h.fig2.migXInfo.BackgroundColor = [1 1 1];
XDAS.h.fig2.migXInfo.Position = [10 makeY(18) 380 yheight];     

% create the model z extent 
XDAS.h.fig2.migZInfo = uilabel(XDAS.h.figure2);
XDAS.h.fig2.migZInfo.BackgroundColor = [1 1 1];
XDAS.h.fig2.migZInfo.Position = [10 makeY(19) 380 yheight];     

% create the cdp info
XDAS.h.fig2.cdpInfo = uilabel(XDAS.h.figure2);
XDAS.h.fig2.cdpInfo.BackgroundColor = [1 1 1];
XDAS.h.fig2.cdpInfo.Position = [10 makeY(20) 380 yheight];     


% ************************************************************
% display shot information
% ************************************************************

% create the source (shot) location label
XDAS.h.fig2.sourceLabel = uilabel(XDAS.h.figure2,'fontweight','bold');
XDAS.h.fig2.sourceLabel.BackgroundColor = [1 1 1];
XDAS.h.fig2.sourceLabel.Position = [400 makeY(5) 200 yheight];     
XDAS.h.fig2.sourceLabel.Text = 'Source Locations';     


XDAS.h.fig2.shotInfoTable = uitable(XDAS.h.figure2);
XDAS.h.fig2.shotInfoTable.BackgroundColor = [1 1 1];
XDAS.h.fig2.shotInfoTable.Position = [350 makeY(9) 240 yheight*4];    
XDAS.h.fig2.shotInfoTable.ColumnName = { 'X', 'Z'};

% ************************************************************
% display well information
% ************************************************************

% create the well path label
XDAS.h.fig2.wellLabel = uilabel(XDAS.h.figure2,'fontweight','bold');
XDAS.h.fig2.wellLabel.BackgroundColor = [1 1 1];
XDAS.h.fig2.wellLabel.Position = [620 makeY(5) 200 yheight];      
XDAS.h.fig2.wellLabel.Text = 'Well Trajectory Control Points';     

XDAS.h.fig2.wellInfoTable = uitable(XDAS.h.figure2);
XDAS.h.fig2.wellInfoTable.BackgroundColor = [1 1 1];
XDAS.h.fig2.wellInfoTable.Position = [600 makeY(9) 240 yheight*4];    
XDAS.h.fig2.wellInfoTable.ColumnName = { 'X', 'Z'};

% ************************************************************
% display reflector segments
% ************************************************************

% create the reflector number label
XDAS.h.fig2.reflectorLabel = uilabel(XDAS.h.figure2,'fontweight','bold');
XDAS.h.fig2.reflectorLabel.BackgroundColor = [1 1 1];
XDAS.h.fig2.reflectorLabel.Position = [400 makeY(10) 150 yheight];     
XDAS.h.fig2.reflectorLabel.Text = 'Reflector Numbers';     

XDAS.h.fig2.reflInfoTable = uitable(XDAS.h.figure2);
XDAS.h.fig2.reflInfoTable.BackgroundColor = [1 1 1];
XDAS.h.fig2.reflInfoTable.Position = [350 makeY(14) 180 yheight*4];    
XDAS.h.fig2.reflInfoTable.ColumnName = { 'Ref Number'};
XDAS.h.fig2.reflInfoTable.CellSelectionCallback = @reflectorSegmentSelectionCallback;

% ************************************************************
% display segment information
% ************************************************************

% create the well path label
XDAS.h.fig2.segmentLabel = uilabel(XDAS.h.figure2,'fontweight','bold');
XDAS.h.fig2.segmentLabel.BackgroundColor = [1 1 1];
XDAS.h.fig2.segmentLabel.Position = [620 makeY(10) 200 yheight];      
XDAS.h.fig2.segmentLabel.Text = 'Segment Locations';     

XDAS.h.fig2.segInfoTable = uitable(XDAS.h.figure2);
XDAS.h.fig2.segInfoTable.BackgroundColor = [1 1 1];
XDAS.h.fig2.segInfoTable.Position = [600 makeY(14) 240 yheight*4];    
XDAS.h.fig2.segInfoTable.ColumnName = { 'X', 'Z'};

function [yyy] = makeY(irow)

yheight = 25;
ystart  = 24*(yheight);

yyy = ystart + 10 - irow*yheight;