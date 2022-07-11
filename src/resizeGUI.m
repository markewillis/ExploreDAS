function resizeGUI(~,~)

% ***********************************************************************************************************
%  resizeGUI - allows the gui to be resized and still maintain a reasonable aspect ratio of the controls
%              In particular - it expands the image area, while maintaining the same size for the controls
%
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

% ************************************************************************************************************
% resize the gui window to the new dimensions
% ************************************************************************************************************

position = get(XDAS.h.figure1,'position');

xL = position(1);   % the left x position of the window
yB = position(2);   % the bottom y position of the window
dx = position(3);   % the width x of the window
dy = position(4);   % the height y of the window

dx = max(998,dx);   % don't allow the width to be less than 400 pixels
dy = max(657,dy);   % don't allow the height to be less than 400 pixels
 
xR = dx + xL;       % the right x edge of the window
yT = dy + yB;       % the top y edge of the window

position = [xL yB dx dy];

set(XDAS.h.figure1,'position',position);

% ************************************************************************************************************
% update the panel for the simulation information
% ************************************************************************************************************

Sim.xLeftEdge   = 10;
Sim.yBottomEdge = 10;
Sim.xWidth      = 320; 
Sim.yHeight     = 150;

set(XDAS.h.panel_simulation,'Position',[Sim.xLeftEdge Sim.yBottomEdge Sim.xWidth Sim.yHeight]);


% ************************************************************************************************************
% create the panel for the Source information
% ************************************************************************************************************

Sou.xLeftEdge   = Sim.xLeftEdge;
Sou.yBottomEdge = Sim.yBottomEdge + Sim.yHeight + 10;
Sou.xWidth      = 250;
Sou.yHeight     = 75-10;

set(XDAS.h.panel_source,'Position',[Sou.xLeftEdge Sou.yBottomEdge Sou.xWidth Sou.yHeight]);
  
% ************************************************************************************************************
% move the odometer appropriately
% ************************************************************************************************************

XDAS.h.digitize.text_odometer.Position = [(Sim.xLeftEdge+Sou.xWidth+10) Sou.yBottomEdge 400 20];     

% ************************************************************************************************************
% create the panel for the Reflector information
% ************************************************************************************************************
                                          
Ref.xLeftEdge   = Sim.xLeftEdge;
Ref.yBottomEdge = Sou.yBottomEdge + Sou.yHeight + 10;
Ref.xWidth      = Sou.xWidth;
Ref.yHeight     = 150-10;

set(XDAS.h.panel_reflector,'Position',[Ref.xLeftEdge Ref.yBottomEdge Ref.xWidth Ref.yHeight]);
                                          
% ************************************************************************************************************
% create the panel for the Well information
% ************************************************************************************************************

Well.xLeftEdge   = Sim.xLeftEdge;
Well.yBottomEdge = Ref.yBottomEdge + Ref.yHeight + 10;
Well.xWidth      = Sou.xWidth;
Well.yHeight     = Sou.yHeight;

set(XDAS.h.panel_well,'Position',[Well.xLeftEdge Well.yBottomEdge Well.xWidth Well.yHeight]);
                                          
% ************************************************************************************************************
% create the panel for the Model information
% ************************************************************************************************************

Mod.xLeftEdge   = Sim.xLeftEdge;
Mod.yBottomEdge = Well.yBottomEdge + Well.yHeight + 10;
Mod.xWidth      = Sou.xWidth;
Mod.yHeight     = 150;

set(XDAS.h.panel_model,'Position',[Mod.xLeftEdge Mod.yBottomEdge Mod.xWidth Mod.yHeight]);

% ************************************************************************************************************
% create the panel for the DAS information
% ************************************************************************************************************

DAS.xLeftEdge   = Sim.xLeftEdge + Sim.xWidth + 10;
DAS.yBottomEdge = Sim.yBottomEdge;
DAS.xWidth      = 350;
DAS.yHeight     = Sim.yHeight;

set(XDAS.h.panel_DAS,'Position',[DAS.xLeftEdge DAS.yBottomEdge DAS.xWidth DAS.yHeight]);
                                          

% ************************************************************************************************************
% create the panel for the Migration information
% ************************************************************************************************************

Mig.xLeftEdge   = DAS.xLeftEdge + DAS.xWidth + 10;
Mig.yBottomEdge = DAS.yBottomEdge;
Mig.xWidth      = 246;
Mig.yHeight     = DAS.yHeight;

set(XDAS.h.panel_migration,'Position',[Mig.xLeftEdge Mig.yBottomEdge Mig.xWidth Mig.yHeight]);


% ************************************************************************************************************
% create the plotting area for the model
% ************************************************************************************************************

Ax.xLeftEdge   = Sou.xLeftEdge + Sou.xWidth + 50;
Ax.yBottomEdge = Sou.yBottomEdge            + 50;
Ax.xWidth      = dx - Ax.xLeftEdge          - 20;
Ax.yHeight     = dy - Ax.yBottomEdge        - 40;

set(XDAS.h.axes_model,'Position',[Ax.xLeftEdge Ax.yBottomEdge Ax.xWidth Ax.yHeight]);