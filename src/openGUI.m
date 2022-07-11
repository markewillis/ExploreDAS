function openGUI

% ***********************************************************************************************************
%  openGUI - creates the user interface with all of the menus, panels, buttons, and features
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
% open the figure for the gui
% ************************************************************************************************************

% set up the default window size of the gui in pixels
xL = 240;        % left x value of the window
yB =  68;        % bottom y valule of the window
xR = 1118;       % right x value of the window
yT = 723;        % top y value of the window
dx = xR - xL;    % width of the window
dy = yT - yB;    % height of the window

% define window size & position
position = [ xL yB dx dy];

% define colors for the buttons
goGreen = [.81 .97 .71];
stopRed = [1 .7 .7];

XDAS.colors.goGreen = goGreen;
XDAS.colors.stopRed = stopRed;

% define sizes of gui items
listBoxDelta = 0;
buttonHeight = 22;


% create the figure window for the gui
XDAS.h.figure1 = uifigure('position',position,'Menubar','none','Color','white','Name',XDAS.compile.title);

% allow for the proper resizing of the gui using a dedicated function
set(XDAS.h.figure1,'AutoResizeChildren','off');
set(XDAS.h.figure1,'SizeChangedFcn',@resizeGUI);

% ************************************************************************************************************
% create the File menu items
% ************************************************************************************************************

fileMenuSetUp

% ************************************************************************************************************
% create the SetUp menu items
% ************************************************************************************************************

setupMenuSetUp

% ************************************************************************************************************
% create the Export menu items
% ************************************************************************************************************

exportMenuSetUp

% ************************************************************************************************************
% create the help menu items
% ************************************************************************************************************

helpMenuSetUp

% ************************************************************************************************************
% create the panel for the simulation information
% ************************************************************************************************************

Sim.xLeftEdge   = 10;
Sim.yBottomEdge = 10;
Sim.xWidth      = 320; 
Sim.yHeight     = 150;

XDAS.h.panel_simulation = uipanel(XDAS.h.figure1,'Title','Simulation','fontsize',14,'fontweight','bold', ...
                               'BackgroundColor','white','Position',[Sim.xLeftEdge Sim.yBottomEdge Sim.xWidth Sim.yHeight]);

yheight = 20;

% create the select wavetype dropdown
XDAS.h.simulation.listbox_waveType = uidropdown(XDAS.h.panel_simulation);
XDAS.h.simulation.listbox_waveType.Items = {'P DAS', 'S DAS', 'P Vertical', 'S Horizontal'};
XDAS.h.simulation.listbox_waveType.ItemsData = [1, 2, 3, 4];
XDAS.h.simulation.listbox_waveType.Value = 1;
XDAS.h.simulation.listbox_waveType.BackgroundColor = [1 1 1];
XDAS.h.simulation.listbox_waveType.Position = [10 (47) 100 (yheight+listBoxDelta)];  
XDAS.h.simulation.listbox_waveType.Tooltip = 'Choose the type of wave to simulate: P- or S-wave, DAS or geophone';

ystart = 45 + yheight + 0;

% create the "select wavetype" text box
XDAS.h.simulation.text_waveType = uilabel(XDAS.h.panel_simulation);
XDAS.h.simulation.text_waveType.Text = 'Select Wave Type';
XDAS.h.simulation.text_waveType.BackgroundColor = [1 1 1];
XDAS.h.simulation.text_waveType.Position = [10 (ystart+5) 110 20];  

% create the select source type listbox
XDAS.h.simulation.listbox_sourceType = uidropdown(XDAS.h.panel_simulation);
XDAS.h.simulation.listbox_sourceType.Items = {'Ricker', 'Klauder'};
XDAS.h.simulation.listbox_sourceType.ItemsData = [1, 2];
XDAS.h.simulation.listbox_sourceType.Value = 1;
XDAS.h.simulation.listbox_sourceType.BackgroundColor = [1 1 1];
XDAS.h.simulation.listbox_sourceType.Position = [10 2 100 (yheight+listBoxDelta)];  
XDAS.h.simulation.listbox_sourceType.Tooltip = 'Select the source spectrum type: Ricker or Klauder wavelets';

ystart = 5 + yheight;

% create the "select source type" text box
XDAS.h.simulation.text_sourceType = uilabel(XDAS.h.panel_simulation);
XDAS.h.simulation.text_sourceType.Text = 'Select Source Type';
XDAS.h.simulation.text_sourceType.BackgroundColor = [1 1 1];
XDAS.h.simulation.text_sourceType.Position = [10 (ystart) 110 20];  

yFifthRow  = 103 -10;

% create the Model button
XDAS.h.simulation.pushbutton_model = uibutton(XDAS.h.panel_simulation);
XDAS.h.simulation.pushbutton_model.Text = 'Run Model';
XDAS.h.simulation.pushbutton_model.BackgroundColor = stopRed;
XDAS.h.simulation.pushbutton_model.Position = [3 yFifthRow 70 buttonHeight];   
XDAS.h.simulation.pushbutton_model.Tooltip = 'Push to start the modeling of all the shots';

% create the "First Break" button
XDAS.h.simulation.pushbutton_firstBreaks = uibutton(XDAS.h.panel_simulation);
XDAS.h.simulation.pushbutton_firstBreaks.Text = 'No First Breaks';
XDAS.h.simulation.pushbutton_firstBreaks.BackgroundColor = stopRed;
XDAS.h.simulation.pushbutton_firstBreaks.Position = [76 yFifthRow 100 buttonHeight];         
XDAS.h.simulation.pushbutton_firstBreaks.Tooltip = 'Toggle to select to include or omit the first breaks';

ystart  = 5;     
yheight = 18;

ySixthRow  = ystart + 5*(yheight + 1);
%yFifthRow  = ystart + 4*(yheight + 1);
yFourthRow = ystart + 3*(yheight + 1);
yThirdRow  = ystart + 2*(yheight + 1);   
ySecondRow = ystart + 1*(yheight + 1);
yFirstRow  = ystart;

% ************** Gaugel Length *************************************

xloc = 185 + 55;

% create the "Use Gauge for DAS" button
XDAS.h.simulation.pushbutton_useGL = uibutton(XDAS.h.panel_simulation);
XDAS.h.simulation.pushbutton_useGL.Text = 'No Gauge';
XDAS.h.simulation.pushbutton_useGL.BackgroundColor = stopRed;
XDAS.h.simulation.pushbutton_useGL.Position = [(179) yFifthRow 70 buttonHeight];   
XDAS.h.simulation.pushbutton_useGL.Tooltip = 'Toggle to select to use the gauge DAS data or omit it';

% create the edit GL
XDAS.h.simulation.edit_GL = uieditfield(XDAS.h.panel_simulation);
XDAS.h.simulation.edit_GL.Value = '10';
XDAS.h.simulation.edit_GL.BackgroundColor = [1 1 1];
XDAS.h.simulation.edit_GL.Position = [xloc yThirdRow 50 yheight];      
XDAS.h.simulation.edit_GL.Tooltip = 'Enter the gauge length to use to simulate DAS data';

% create the GL label
XDAS.h.simulation.text_GL = uilabel(XDAS.h.panel_simulation);
XDAS.h.simulation.text_GL.Text = 'GL (m)';
XDAS.h.simulation.text_GL.BackgroundColor = [1 1 1];
XDAS.h.simulation.text_GL.Position = [(xloc+5) yFourthRow 50 yheight];     

% ***********************************************************************
%
% Spectral ratio gui button
%
% ***********************************************************************

% % create the "Ratios" button
% XDAS.h.simulation.pushbutton_spectralRatios = uibutton(XDAS.h.panel_simulation);
% XDAS.h.simulation.pushbutton_spectralRatios.Text = 'Ratios';
% XDAS.h.simulation.pushbutton_spectralRatios.BackgroundColor = stopRed;
% XDAS.h.simulation.pushbutton_spectralRatios.Position = [(249+3) yFifthRow 50 buttonHeight];   
% XDAS.h.simulation.pushbutton_spectralRatios.Tooltip = 'Push to launch the spectral ratio analysis gui';


yFirstRow   = ystart;
ySecondRow = yFirstRow  + yheight + 1;
yThirdRow  = ySecondRow + yheight + 1;
yFourthRow = yThirdRow  + yheight + 1;


% create the edit Tmax 
XDAS.h.simulation.edit_tmax = uieditfield(XDAS.h.panel_simulation);
XDAS.h.simulation.edit_tmax.Value = '5';
XDAS.h.simulation.edit_tmax.BackgroundColor = [1 1 1];
XDAS.h.simulation.edit_tmax.Position = [185 yFirstRow 50 yheight];   
XDAS.h.simulation.edit_tmax.Tooltip = 'Enter the trace length in seconds';

% create the Tmax label
XDAS.h.simulation.text_tmax = uilabel(XDAS.h.panel_simulation);
XDAS.h.simulation.text_tmax.Text = 'Tmax (s)';
XDAS.h.simulation.text_tmax.BackgroundColor = [1 1 1];
XDAS.h.simulation.text_tmax.Position = [185 ySecondRow 50 yheight];      

% create the edit dt
XDAS.h.simulation.edit_dt = uieditfield(XDAS.h.panel_simulation);
XDAS.h.simulation.edit_dt.Value = '0.001';
XDAS.h.simulation.edit_dt.BackgroundColor = [1 1 1];
XDAS.h.simulation.edit_dt.Position = [185 yThirdRow 50 yheight];   
XDAS.h.simulation.edit_dt.Tooltip = 'Enter the trace sample interval in seconds';

% create the dt label
XDAS.h.simulation.text_dt = uilabel(XDAS.h.panel_simulation);
XDAS.h.simulation.text_dt.Text = 'dt (s)';
XDAS.h.simulation.text_dt.BackgroundColor = [1 1 1];
XDAS.h.simulation.text_dt.Position = [195 yFourthRow 50 yheight];      
 
% create the edit fmin
XDAS.h.simulation.edit_fmin = uieditfield(XDAS.h.panel_simulation);
XDAS.h.simulation.edit_fmin.Value = '9';
XDAS.h.simulation.edit_fmin.BackgroundColor = [1 1 1];
XDAS.h.simulation.edit_fmin.Position = [125 yThirdRow 40 yheight];  
XDAS.h.simulation.edit_fmin.Tooltip = 'Enter the center frequency of the Ricker wavelet in Hertz';

% create the fmin label
XDAS.h.simulation.text_fmin = uilabel(XDAS.h.panel_simulation);
XDAS.h.simulation.text_fmin.Text = 'Fmin (Hz)';
XDAS.h.simulation.text_fmin.BackgroundColor = [1 1 1];
XDAS.h.simulation.text_fmin.Position = [120 yFourthRow 60 yheight];     

% create the edit fmax
XDAS.h.simulation.edit_fmax = uieditfield(XDAS.h.panel_simulation);
XDAS.h.simulation.edit_fmax.Value = '96.';
XDAS.h.simulation.edit_fmax.BackgroundColor = [1 1 1];
XDAS.h.simulation.edit_fmax.Position = [125 yFirstRow 40 yheight];     
XDAS.h.simulation.edit_fmax.Tooltip = 'Enter the maximum frequency of the Klauder wavelet in Hertz';

% create the fmax label
XDAS.h.simulation.text_fmax = uilabel(XDAS.h.panel_simulation);
XDAS.h.simulation.text_fmax.Text = 'Fmax (Hz)';
XDAS.h.simulation.text_fmax.BackgroundColor = [1 1 1];
XDAS.h.simulation.text_fmax.Position = [120 ySecondRow 60 yheight];      

% ************************************************************************************************************
% create the panel for the Source information
% ************************************************************************************************************

Sou.xLeftEdge   = Sim.xLeftEdge;
Sou.yBottomEdge = Sim.yBottomEdge + Sim.yHeight + 10;
Sou.xWidth      = 250;
Sou.yHeight     = 75-10;

XDAS.h.panel_source = uipanel(XDAS.h.figure1,'Title','Source','fontsize',14,'fontweight','bold', ...
                             'BackgroundColor','white','Position',[Sou.xLeftEdge Sou.yBottomEdge Sou.xWidth Sou.yHeight]);

% create the add button
XDAS.h.source.pushbutton_add = uibutton(XDAS.h.panel_source);
XDAS.h.source.pushbutton_add.Text = 'Add';
XDAS.h.source.pushbutton_add.BackgroundColor = stopRed;
XDAS.h.source.pushbutton_add.Position = [10 10 40 buttonHeight];
XDAS.h.source.pushbutton_add.Tooltip = 'Push to add a new source location';
                                          
% create the delete button
XDAS.h.source.pushbutton_delete = uibutton(XDAS.h.panel_source);
XDAS.h.source.pushbutton_delete.Text = 'Delete';
XDAS.h.source.pushbutton_delete.BackgroundColor = stopRed;
XDAS.h.source.pushbutton_delete.Position = [60 10 45 buttonHeight];
XDAS.h.source.pushbutton_delete.Tooltip = 'Push to delete a source position';

% ************************************************************************************************************
% create the digitizing odometer window
% ************************************************************************************************************

% create the odometer label
XDAS.h.digitize.text_odometer = uilabel(XDAS.h.figure1);
XDAS.h.digitize.text_odometer.Text    = 'Dist = Depth =';
XDAS.h.digitize.text_odometer.Visible = 'off';
XDAS.h.digitize.text_odometer.BackgroundColor = [1 1 1];
XDAS.h.digitize.text_odometer.Position = [(Sim.xLeftEdge+Sou.xWidth+10) Sou.yBottomEdge 400 20];  

% ************************************************************************************************************
% create the panel for the Reflector information
% ************************************************************************************************************
        
Ref.xLeftEdge   = Sim.xLeftEdge;
Ref.yBottomEdge = Sou.yBottomEdge + Sou.yHeight + 10;
Ref.xWidth      = Sou.xWidth;
Ref.yHeight     = 150-10;

XDAS.h.panel_reflector = uipanel(XDAS.h.figure1,'Title','Reflector','fontsize',14,'fontweight','bold', ...
                                'BackgroundColor','white','Position',[Ref.xLeftEdge Ref.yBottomEdge Ref.xWidth Ref.yHeight]);
               
% create the start new reflector button
XDAS.h.reflector.pushbutton_startNew = uibutton(XDAS.h.panel_reflector);
XDAS.h.reflector.pushbutton_startNew.Text = 'Start New Reflector';
XDAS.h.reflector.pushbutton_startNew.BackgroundColor = stopRed;
XDAS.h.reflector.pushbutton_startNew.Position = [10 69 120 buttonHeight];
XDAS.h.reflector.pushbutton_startNew.Tooltip = 'Push to add a new reflector in the model';
          
% create the add more points button
XDAS.h.reflector.pushbutton_add = uibutton(XDAS.h.panel_reflector);
XDAS.h.reflector.pushbutton_add.Text = 'Add Point(s)';
XDAS.h.reflector.pushbutton_add.BackgroundColor = stopRed;
XDAS.h.reflector.pushbutton_add.Position = [140 69 95 buttonHeight];   
XDAS.h.reflector.pushbutton_add.Tooltip = 'Push to add more points to the current reflector';

% create the delete more points button
XDAS.h.reflector.pushbutton_delete = uibutton(XDAS.h.panel_reflector);
XDAS.h.reflector.pushbutton_delete.Text = 'Delete Point(s)';
XDAS.h.reflector.pushbutton_delete.BackgroundColor = stopRed;
XDAS.h.reflector.pushbutton_delete.Position = [140 37 95 buttonHeight];  
XDAS.h.reflector.pushbutton_delete.Tooltip = 'Push to delete points from the current reflector';

% create the reorder points button
XDAS.h.reflector.pushbutton_reorder = uibutton(XDAS.h.panel_reflector);
XDAS.h.reflector.pushbutton_reorder.Text = 'Reorder Points';
XDAS.h.reflector.pushbutton_reorder.BackgroundColor = stopRed;
XDAS.h.reflector.pushbutton_reorder.Position = [140 5 95 buttonHeight];  
XDAS.h.reflector.pushbutton_reorder.Tooltip = 'Push to reorder the reflector points to be connected by closest neighbors';

% create the reflector listbox
XDAS.h.reflector.listbox_reflectors = uidropdown(XDAS.h.panel_reflector);
XDAS.h.reflector.listbox_reflectors.Items = {'None'};
XDAS.h.reflector.listbox_reflectors.ItemsData = [1];
XDAS.h.reflector.listbox_reflectors.Value = 1;
XDAS.h.reflector.listbox_reflectors.BackgroundColor = [1 1 1];
XDAS.h.reflector.listbox_reflectors.Position = [10 5 120 20];  
XDAS.h.reflector.listbox_reflectors.Tooltip = 'Select desired layer number to highlight and edit';

% create the "select reflector" text box
XDAS.h.reflector.text_selectReflector = uilabel(XDAS.h.panel_reflector);
XDAS.h.reflector.text_selectReflector.Text = 'Select Reflector';
XDAS.h.reflector.text_selectReflector.BackgroundColor = [1 1 1];
XDAS.h.reflector.text_selectReflector.Position = [20 25 95 25];  


% ************************************************************************************************************
% create the panel for the Well information
% ************************************************************************************************************

Well.xLeftEdge   = Sim.xLeftEdge;
Well.yBottomEdge = Ref.yBottomEdge + Ref.yHeight + 10;
Well.xWidth      = Sou.xWidth;
Well.yHeight     = Sou.yHeight;

XDAS.h.panel_well = uipanel(XDAS.h.figure1,'Title','Well','fontsize',14,'fontweight','bold', ...
                            'BackgroundColor','white','Position',[Well.xLeftEdge Well.yBottomEdge Well.xWidth Well.yHeight]);
 
% create the add button
XDAS.h.well.pushbutton_add = uibutton(XDAS.h.panel_well);
XDAS.h.well.pushbutton_add.Text = 'Add';
XDAS.h.well.pushbutton_add.BackgroundColor = stopRed;
XDAS.h.well.pushbutton_add.Position = [10 10 35 buttonHeight];
XDAS.h.well.pushbutton_add.Tooltip = 'Push to add a new well path location';
                                          
% create the delete button
XDAS.h.well.pushbutton_delete = uibutton(XDAS.h.panel_well);
XDAS.h.well.pushbutton_delete.Text = 'Delete';
XDAS.h.well.pushbutton_delete.BackgroundColor = stopRed;
XDAS.h.well.pushbutton_delete.Position = [60 10 45 buttonHeight];
XDAS.h.well.pushbutton_delete.Tooltip = 'Push to delete a point from the well path';

% create the reorder button
XDAS.h.well.pushbutton_reorder = uibutton(XDAS.h.panel_well);
XDAS.h.well.pushbutton_reorder.Text = 'Reorder Points';
XDAS.h.well.pushbutton_reorder.BackgroundColor = stopRed;
XDAS.h.well.pushbutton_reorder.Position = [120 10 95 buttonHeight];
XDAS.h.well.pushbutton_reorder.Tooltip = 'Push to reorder the well path to be connected by closest neighbors';

% ************************************************************************************************************
% create the panel for the Model information
% ************************************************************************************************************

Mod.xLeftEdge   = Sim.xLeftEdge;
Mod.yBottomEdge = Well.yBottomEdge + Well.yHeight + 10;
Mod.xWidth      = Sou.xWidth;
Mod.yHeight     = 150;

XDAS.h.panel_model = uipanel(XDAS.h.figure1,'Title','Model','fontsize',14,'fontweight','bold', ...
                            'BackgroundColor','white','Position',[Mod.xLeftEdge Mod.yBottomEdge Mod.xWidth Mod.yHeight]);

ystart  = 5;     
yheight = 20;
xwidth  = 55;
xcol1   = 5;
xcol2   = 70;
xcol3   = 135;

yFirstRow = ystart;

% create the edit p velocity 
XDAS.h.model.edit_pvel = uieditfield(XDAS.h.panel_model);
XDAS.h.model.edit_pvel.Value = '4000';
XDAS.h.model.edit_pvel.BackgroundColor = [1 1 1];
XDAS.h.model.edit_pvel.Position = [xcol1 yFirstRow xwidth yheight];     
XDAS.h.model.edit_pvel.Tooltip = 'Enter the P wave velocity in m/s';

ySecondRow = yFirstRow + yheight + 1;

% create the p velocity label
XDAS.h.model.text_pvel = uilabel(XDAS.h.panel_model);
XDAS.h.model.text_pvel.Text = 'P Velocity';
XDAS.h.model.text_pvel.BackgroundColor = [1 1 1];
XDAS.h.model.text_pvel.Position = [xcol1 ySecondRow xwidth yheight];      

% create the edit s velocity 
XDAS.h.model.edit_svel = uieditfield(XDAS.h.panel_model);
XDAS.h.model.edit_svel.Value = '2600';
XDAS.h.model.edit_svel.BackgroundColor = [1 1 1];
XDAS.h.model.edit_svel.Position = [xcol2 yFirstRow xwidth yheight];   
XDAS.h.model.edit_svel.Tooltip = 'Enter the S-wave velocity in m/s';

% create the s velocity label
XDAS.h.model.text_svel = uilabel(XDAS.h.panel_model);
XDAS.h.model.text_svel.Text = 'S Velocity';
XDAS.h.model.text_svel.BackgroundColor = [1 1 1];
XDAS.h.model.text_svel.Position = [xcol2 ySecondRow xwidth yheight];     

yThirdRow = ySecondRow + yheight + 1;

% create the edit zmin
XDAS.h.model.edit_zmin = uieditfield(XDAS.h.panel_model);
XDAS.h.model.edit_zmin.Value = '0';
XDAS.h.model.edit_zmin.BackgroundColor = [1 1 1];
XDAS.h.model.edit_zmin.Position = [xcol1 yThirdRow xwidth yheight];    
XDAS.h.model.edit_zmin.Tooltip = 'Enter the minimum depth of the model in m';

yForthRow = yThirdRow + yheight + 1;

% create the zmin label
XDAS.h.model.text_zmin = uilabel(XDAS.h.panel_model);
XDAS.h.model.text_zmin.Text = 'Zmin (m)';
XDAS.h.model.text_zmin.BackgroundColor = [1 1 1];
XDAS.h.model.text_zmin.Position = [xcol1 yForthRow xwidth yheight];      


% create the edit zmax
XDAS.h.model.edit_zmax = uieditfield(XDAS.h.panel_model);
XDAS.h.model.edit_zmax.Value = '4000';
XDAS.h.model.edit_zmax.BackgroundColor = [1 1 1];
XDAS.h.model.edit_zmax.Position = [xcol2 yThirdRow xwidth yheight];      
XDAS.h.model.edit_zmax.Tooltip = 'Enter the maximum depth of the model in m';


% create the zmin label
XDAS.h.model.text_zmax = uilabel(XDAS.h.panel_model);
XDAS.h.model.text_zmax.Text = 'Zmax (m)';
XDAS.h.model.text_zmax.BackgroundColor = [1 1 1];
XDAS.h.model.text_zmax.Position = [xcol2 yForthRow xwidth yheight];      


yFifthRow = yForthRow + yheight + 1;

% create the edit xmin
XDAS.h.model.edit_xmin = uieditfield(XDAS.h.panel_model);
XDAS.h.model.edit_xmin.Value = '0';
XDAS.h.model.edit_xmin.BackgroundColor = [1 1 1];
XDAS.h.model.edit_xmin.Position = [xcol1 yFifthRow xwidth yheight];     
XDAS.h.model.edit_xmin.Tooltip = 'Enter the minimum (left) model x position in m';

ySixthRow = yFifthRow + yheight + 1;

% create the xmin label
XDAS.h.model.text_xmin = uilabel(XDAS.h.panel_model);
XDAS.h.model.text_xmin.Text = 'Xmin (m)';
XDAS.h.model.text_xmin.BackgroundColor = [1 1 1];
XDAS.h.model.text_xmin.Position = [xcol1 ySixthRow xwidth yheight];      


% create the edit xmax
XDAS.h.model.edit_xmax = uieditfield(XDAS.h.panel_model);
XDAS.h.model.edit_xmax.Value = '4000';
XDAS.h.model.edit_xmax.BackgroundColor = [1 1 1];
XDAS.h.model.edit_xmax.Position = [xcol2 yFifthRow xwidth yheight];      
XDAS.h.model.edit_xmax.Tooltip = 'Enter the maximum (right) model x position in m';

% create the xmax label
XDAS.h.model.text_xmax = uilabel(XDAS.h.panel_model);
XDAS.h.model.text_xmax.Text = 'Xmax (m)';
XDAS.h.model.text_xmax.BackgroundColor = [1 1 1];
XDAS.h.model.text_xmax.Position = [xcol2 ySixthRow xwidth yheight];      


% create the select constant/gradient listbox
XDAS.h.model.listbox_velocityType = uidropdown(XDAS.h.panel_model);
XDAS.h.model.listbox_velocityType.Items = {'Constant', 'Gradient',};
XDAS.h.model.listbox_velocityType.ItemsData = [1, 2];
XDAS.h.model.listbox_velocityType.Value = 1;
XDAS.h.model.listbox_velocityType.BackgroundColor = [1 1 1];
XDAS.h.model.listbox_velocityType.Position = [xcol3 yThirdRow 100 (yheight+listBoxDelta)];  
XDAS.h.model.listbox_velocityType.Tooltip = 'Select the type of velocity model - constant or linear gradient with depth';

% create the "select reflector" text box
XDAS.h.model.text_velocityType = uilabel(XDAS.h.panel_model);
XDAS.h.model.text_velocityType.Text = 'Select Model Type';
XDAS.h.model.text_velocityType.BackgroundColor = [1 1 1];
XDAS.h.model.text_velocityType.Position = [xcol3 (yForthRow+5) 110 yheight];  

% create the edit kz
XDAS.h.model.edit_kz = uieditfield(XDAS.h.panel_model);
XDAS.h.model.edit_kz.Value = '0.7';
XDAS.h.model.edit_kz.BackgroundColor = [1 1 1];
XDAS.h.model.edit_kz.Position = [xcol3 yFirstRow xwidth yheight];      
XDAS.h.model.edit_kz.Tooltip = 'Enter the linear velocity gradient with depth';

% create the kz label
XDAS.h.model.text_kz = uilabel(XDAS.h.panel_model);
XDAS.h.model.text_kz.Text = 'kZ (1/s)';
XDAS.h.model.text_kz.BackgroundColor = [1 1 1];
XDAS.h.model.text_kz.Position = [xcol3 ySecondRow xwidth yheight];     

% create the show Image button
XDAS.h.well.pushbutton_showImage = uibutton(XDAS.h.panel_model);
XDAS.h.well.pushbutton_showImage.Text = 'No Image';
XDAS.h.well.pushbutton_showImage.BackgroundColor = stopRed;
XDAS.h.well.pushbutton_showImage.Position = [xcol3 (yFifthRow+13) (xwidth+10) buttonHeight];
XDAS.h.well.pushbutton_showImage.Tooltip = 'Push to display the background image or no image';

% ************************************************************************************************************
% create the panel for the DAS Noise information
% ************************************************************************************************************

DAS.xLeftEdge   = Sim.xLeftEdge + Sim.xWidth + 10;
DAS.yBottomEdge = Sim.yBottomEdge;
DAS.xWidth      = 350;
DAS.yHeight     = Sim.yHeight;

XDAS.h.panel_DAS = uipanel(XDAS.h.figure1,'Title','Noise Parameters','fontsize',14,'fontweight','bold', ...
                          'BackgroundColor','white','Position',[DAS.xLeftEdge DAS.yBottomEdge DAS.xWidth DAS.yHeight]);
                     
ystart  = 5;     
yheight = 18;

ySixthRow  = ystart + 5*(yheight + 1);
yFifthRow  = ystart + 4*(yheight + 1);
yFourthRow = ystart + 3*(yheight + 1);
yThirdRow  = ystart + 2*(yheight + 1);   
ySecondRow = ystart + 1*(yheight + 1);
yFirstRow  = ystart;


% ************** Optical Noise ************************************* 

% create the "Add Optical Noise" button
XDAS.h.DAS.pushbutton_addOpticalNoise = uibutton(XDAS.h.panel_DAS);
XDAS.h.DAS.pushbutton_addOpticalNoise.Text = '+ Optical Noise';
XDAS.h.DAS.pushbutton_addOpticalNoise.BackgroundColor = stopRed;
XDAS.h.DAS.pushbutton_addOpticalNoise.Position = [10 yThirdRow 100 buttonHeight];    
XDAS.h.DAS.pushbutton_addOpticalNoise.Tooltip = 'Push to add optical noise or not';

% create the edit Optical Noise SNR
XDAS.h.DAS.edit_opticalSNR = uieditfield(XDAS.h.panel_DAS);
XDAS.h.DAS.edit_opticalSNR.Value = '10';
XDAS.h.DAS.edit_opticalSNR.BackgroundColor = [1 1 1];
XDAS.h.DAS.edit_opticalSNR.Position = [20 yFirstRow 60 yheight];    
XDAS.h.DAS.edit_opticalSNR.Tooltip = 'Enter the optical noise SNR in dB';

% create the optical SNR label
XDAS.h.DAS.text_opticalSNR = uilabel(XDAS.h.panel_DAS);
XDAS.h.DAS.text_opticalSNR.Text = 'Optical SNR';
XDAS.h.DAS.text_opticalSNR.BackgroundColor = [1 1 1];
XDAS.h.DAS.text_opticalSNR.Position = [20 ySecondRow 70 yheight];     

% create the "Replot" button
XDAS.h.DAS.pushbutton_displaySourceNum = uibutton(XDAS.h.panel_DAS);
XDAS.h.DAS.pushbutton_displaySourceNum.Text = 'Replot';
XDAS.h.DAS.pushbutton_displaySourceNum.BackgroundColor = stopRed;
XDAS.h.DAS.pushbutton_displaySourceNum.Position = [10 (yFifthRow+20) 50 buttonHeight];     
XDAS.h.DAS.pushbutton_displaySourceNum.Tooltip = 'Push to display the currently modeled data';

% create the "FK Plot" button
XDAS.h.DAS.pushbutton_displayfk = uibutton(XDAS.h.panel_DAS);
XDAS.h.DAS.pushbutton_displayfk.Text = 'FK Plot';
XDAS.h.DAS.pushbutton_displayfk.BackgroundColor = stopRed;
XDAS.h.DAS.pushbutton_displayfk.Position = [70 (yFifthRow+20) 50 buttonHeight];     
XDAS.h.DAS.pushbutton_displayfk.Tooltip = 'Push to display the fk transform of currently modeled data';

% create the gain up button
XDAS.h.DAS.pushbutton_gainUp = uibutton(XDAS.h.panel_DAS);
XDAS.h.DAS.pushbutton_gainUp.Text = 'Gain Up';
XDAS.h.DAS.pushbutton_gainUp.BackgroundColor = stopRed;
XDAS.h.DAS.pushbutton_gainUp.Position = [(260-45+65) (ySixthRow) 60 20];
XDAS.h.DAS.pushbutton_gainUp.Tooltip = 'Push to gain up image';

% create the gain down button
XDAS.h.DAS.pushbutton_gainDown = uibutton(XDAS.h.panel_DAS);
XDAS.h.DAS.pushbutton_gainDown.Text = 'Gain Dn';
XDAS.h.DAS.pushbutton_gainDown.BackgroundColor = stopRed;
XDAS.h.DAS.pushbutton_gainDown.Position = [(260-45+65) (ySixthRow-25) 60 20];
XDAS.h.DAS.pushbutton_gainDown.Tooltip = 'Push to gain down image';

% **************

% create the select source number listbox
XDAS.h.simulation.listbox_sourceNumber = uidropdown(XDAS.h.panel_DAS);
XDAS.h.simulation.listbox_sourceNumber.Items = {'1', '2'};
XDAS.h.simulation.listbox_sourceNumber.ItemsData = [1, 2];
XDAS.h.simulation.listbox_sourceNumber.Value = 1;
XDAS.h.simulation.listbox_sourceNumber.BackgroundColor = [1 1 1];
XDAS.h.simulation.listbox_sourceNumber.Position = [133 (yFifthRow-7) 55 (25+listBoxDelta)];
set(XDAS.h.simulation.listbox_sourceNumber,'visible','off')
XDAS.h.simulation.listbox_sourceNumber.Tooltip = 'Select the shot number to display';

% create the "select source number" text box
XDAS.h.simulation.text_sourceNumber = uilabel(XDAS.h.panel_DAS);
XDAS.h.simulation.text_sourceNumber.Text = 'Source';
XDAS.h.simulation.text_sourceNumber.BackgroundColor = [1 1 1];
XDAS.h.simulation.text_sourceNumber.Position = [(145-3) (ySixthRow+5) 45 20];
set(XDAS.h.simulation.text_sourceNumber,   'visible','off')

% create the select channel number listbox (changed to distance)
XDAS.h.simulation.listbox_channelNumber = uidropdown(XDAS.h.panel_DAS);
XDAS.h.simulation.listbox_channelNumber.Items = {'1', '2'};
XDAS.h.simulation.listbox_channelNumber.ItemsData = [1, 2];
XDAS.h.simulation.listbox_channelNumber.Value = 1;
XDAS.h.simulation.listbox_channelNumber.BackgroundColor = [1 1 1];
XDAS.h.simulation.listbox_channelNumber.Position = [(193+60-45-10) (yFifthRow-7) (55+10) (25+listBoxDelta)];
set(XDAS.h.simulation.listbox_channelNumber,'visible','off')
XDAS.h.simulation.listbox_channelNumber.Tooltip = 'Select the channel number to display';

% create the "select channel number" text box (changed to distance)
XDAS.h.simulation.text_channelNumber = uilabel(XDAS.h.panel_DAS);
XDAS.h.simulation.text_channelNumber.Text = 'Distance';
XDAS.h.simulation.text_channelNumber.BackgroundColor = [1 1 1];
XDAS.h.simulation.text_channelNumber.Position = [(260-45-5) (ySixthRow+5) 60 20];
set(XDAS.h.simulation.text_channelNumber,   'visible','off')

% **************

% create the "Flip Polarity" button
XDAS.h.DAS.pushbutton_polarity = uibutton(XDAS.h.panel_DAS);
XDAS.h.DAS.pushbutton_polarity.Text = 'Normal Polarity';
XDAS.h.DAS.pushbutton_polarity.BackgroundColor = stopRed;
XDAS.h.DAS.pushbutton_polarity.Position = [220 yThirdRow 120 buttonHeight];     
XDAS.h.DAS.pushbutton_polarity.Tooltip = 'Push to select between normal and reverse polarity for the DAS data';

% create the "Signal+Noise / Noise Only" button
XDAS.h.DAS.pushbutton_noiseOnly = uibutton(XDAS.h.panel_DAS);
XDAS.h.DAS.pushbutton_noiseOnly.Text = 'Sig & Noise';
XDAS.h.DAS.pushbutton_noiseOnly.BackgroundColor = stopRed;
XDAS.h.DAS.pushbutton_noiseOnly.Position = [10 (yFifthRow-8) 100 buttonHeight];     
XDAS.h.DAS.pushbutton_noiseOnly.Tooltip = 'Push to select between signal only or signal with noise';

% ************** CMN Noise ************************************* 

% create the "Add CMN Noise" button
XDAS.h.DAS.pushbutton_addCMN = uibutton(XDAS.h.panel_DAS);
XDAS.h.DAS.pushbutton_addCMN.Text = 'No CMN Noise';
XDAS.h.DAS.pushbutton_addCMN.BackgroundColor = stopRed;
XDAS.h.DAS.pushbutton_addCMN.Position = [120 yThirdRow 90 buttonHeight];    
XDAS.h.DAS.pushbutton_addCMN.Tooltip = 'Push to add common mode noise (CMN) to the data';

% create the edit CMN SNR
XDAS.h.DAS.edit_CMNSNR = uieditfield(XDAS.h.panel_DAS);
XDAS.h.DAS.edit_CMNSNR.Value = '10';
XDAS.h.DAS.edit_CMNSNR.BackgroundColor = [1 1 1];
XDAS.h.DAS.edit_CMNSNR.Position = [140 yFirstRow 60 yheight];     
XDAS.h.DAS.edit_CMNSNR.Tooltip = 'Enter the signal to noise ratio of the common mode noise (CMN) in dB';

% create the CMN SNR label
XDAS.h.DAS.text_CMNSNR = uilabel(XDAS.h.panel_DAS);
XDAS.h.DAS.text_CMNSNR.Text = 'CMN SNR';
XDAS.h.DAS.text_CMNSNR.BackgroundColor = [1 1 1];
XDAS.h.DAS.text_CMNSNR.Position = [140 ySecondRow 60 yheight];     

% % create the "extra CMN Noise" button
% XDAS.h.DAS.pushbutton_extraCMN = uibutton(XDAS.h.panel_DAS);
% XDAS.h.DAS.pushbutton_extraCMN.Text = 'Extra CMN Noise';
% XDAS.h.DAS.pushbutton_extraCMN.BackgroundColor = stopRed;
% XDAS.h.DAS.pushbutton_extraCMN.Position = [270 yFirstRow 120 30];         

% ************** remove CMN Noise *************************************

% create the "Remove CMN Noise" button
XDAS.h.DAS.pushbutton_removeCMN = uibutton(XDAS.h.panel_DAS);
XDAS.h.DAS.pushbutton_removeCMN.Text = 'Process CMN Noise';
XDAS.h.DAS.pushbutton_removeCMN.BackgroundColor = stopRed;
XDAS.h.DAS.pushbutton_removeCMN.Position = [220 yFirstRow 120 buttonHeight];  
XDAS.h.DAS.pushbutton_removeCMN.Tooltip = 'Push to leave in the common mode noise (CMN) or process it out';
 
% ************************************************************************************************************
% create the panel for the Migration information
% ************************************************************************************************************

Mig.xLeftEdge   = DAS.xLeftEdge + DAS.xWidth + 10;
% Mig.xLeftEdge   = Sim.xLeftEdge + Sim.xWidth + 10;
Mig.yBottomEdge = DAS.yBottomEdge;
Mig.xWidth      = 246;
Mig.yHeight     = DAS.yHeight;

XDAS.h.panel_migration = uipanel(XDAS.h.figure1,'Title','Migration','fontsize',14,'fontweight','bold', ...
                                'BackgroundColor','white','Position',[Mig.xLeftEdge Mig.yBottomEdge Mig.xWidth Mig.yHeight]);
                     
ystart  = 5;     
yheight = 18;
xcol1   = 5;
xcol2   = 70;
xcol3   = 135;
xcol4   = 184;

ySixthRow  = ystart + 5*(yheight + 1);
yFifthRow  = ystart + 4*(yheight + 1);
yFourthRow = ystart + 3*(yheight + 1);
yThirdRow  = ystart + 2*(yheight + 1);   
ySecondRow = ystart + 1*(yheight + 1);
yFirstRow  = ystart;


% create the "Migrate" button
XDAS.h.migration.pushbutton_migrate = uibutton(XDAS.h.panel_migration);
XDAS.h.migration.pushbutton_migrate.Text = 'Migrate';
XDAS.h.migration.pushbutton_migrate.BackgroundColor = stopRed;
XDAS.h.migration.pushbutton_migrate.Position = [30 87 80 buttonHeight];  
XDAS.h.migration.pushbutton_migrate.Tooltip = 'Push to migrate the currently modeled data';

% create the "CDP" button
XDAS.h.migration.pushbutton_CDP = uibutton(XDAS.h.panel_migration);
XDAS.h.migration.pushbutton_CDP.Text = 'CDP';
XDAS.h.migration.pushbutton_CDP.BackgroundColor = stopRed;
XDAS.h.migration.pushbutton_CDP.Position = [175 87 60 buttonHeight];         
XDAS.h.migration.pushbutton_CDP.Tooltip = 'Push to create a migrated common depth point (CDP) record';

% create the edit dz 
XDAS.h.migration.edit_dz = uieditfield(XDAS.h.panel_migration);
XDAS.h.migration.edit_dz.Value = '10';
XDAS.h.migration.edit_dz.BackgroundColor = [1 1 1];
XDAS.h.migration.edit_dz.Position = [xcol3 yFirstRow 40 yheight];    
XDAS.h.migration.edit_dz.Tooltip = 'Enter the depth increment of the migrated data in m';

% create the dz label
XDAS.h.migration.text_dz = uilabel(XDAS.h.panel_migration);
XDAS.h.migration.text_dz.Text = 'dZ (m)';
XDAS.h.migration.text_dz.BackgroundColor = [1 1 1];
XDAS.h.migration.text_dz.Position = [xcol3 ySecondRow 60 yheight];     

% create the edit dx
XDAS.h.migration.edit_dx = uieditfield(XDAS.h.panel_migration);
XDAS.h.migration.edit_dx.Value = '15.';
XDAS.h.migration.edit_dx.BackgroundColor = [1 1 1];
XDAS.h.migration.edit_dx.Position = [xcol3 yThirdRow 40 yheight];      
XDAS.h.migration.edit_dx.Tooltip = 'Enter the trace spacing in the migrated image in m';

% create the dx label
XDAS.h.migration.text_dx = uilabel(XDAS.h.panel_migration);
XDAS.h.migration.text_dx.Text = 'dX (m)';
XDAS.h.migration.text_dx.BackgroundColor = [1 1 1];
XDAS.h.migration.text_dx.Position = [xcol3 yFourthRow 60 yheight];     

% create the edit zmin
XDAS.h.migration.edit_migZmin = uieditfield(XDAS.h.panel_migration);
XDAS.h.migration.edit_migZmin.Value = '0';
XDAS.h.migration.edit_migZmin.BackgroundColor = [1 1 1];
XDAS.h.migration.edit_migZmin.Position = [xcol1 yFirstRow xwidth yheight];   
XDAS.h.migration.edit_migZmin.Tooltip = 'Enter the shallowest depth in the migrated image in m';

% create the zmin label
XDAS.h.migration.text_migZmin = uilabel(XDAS.h.panel_migration);
XDAS.h.migration.text_migZmin.Text = 'Zmin (m)';
XDAS.h.migration.text_migZmin.BackgroundColor = [1 1 1];
XDAS.h.migration.text_migZmin.Position = [xcol1 ySecondRow xwidth yheight];      


% create the edit zmax
XDAS.h.migration.edit_migZmax = uieditfield(XDAS.h.panel_migration);
XDAS.h.migration.edit_migZmax.Value = '4000';
XDAS.h.migration.edit_migZmax.BackgroundColor = [1 1 1];
XDAS.h.migration.edit_migZmax.Position = [xcol2 yFirstRow xwidth yheight];      
XDAS.h.migration.edit_migZmax.Tooltip = 'Enter the deepest depth in the migrated image in m';

% create the zmin label
XDAS.h.migration.text_migZmax = uilabel(XDAS.h.panel_migration);
XDAS.h.migration.text_migZmax.Text = 'Zmax (m)';
XDAS.h.migration.text_migZmax.BackgroundColor = [1 1 1];
XDAS.h.migration.text_migZmax.Position = [xcol2 ySecondRow xwidth yheight];      


% create the edit xmin
XDAS.h.migration.edit_migXmin = uieditfield(XDAS.h.panel_migration);
XDAS.h.migration.edit_migXmin.Value = '0';
XDAS.h.migration.edit_migXmin.BackgroundColor = [1 1 1];
XDAS.h.migration.edit_migXmin.Position = [xcol1 yThirdRow xwidth yheight];      
XDAS.h.migration.edit_migXmin.Tooltip = 'Enter the minimum (left) most x position in the migrated image in m';

% create the xmin label
XDAS.h.migration.text_migXmin = uilabel(XDAS.h.panel_migration);
XDAS.h.migration.text_migXmin.Text = 'Xmin (m)';
XDAS.h.migration.text_migXmin.BackgroundColor = [1 1 1];
XDAS.h.migration.text_migXmin.Position = [xcol1 yFourthRow xwidth yheight];      


% create the edit xmax
XDAS.h.migration.edit_migXmax = uieditfield(XDAS.h.panel_migration);
XDAS.h.migration.edit_migXmax.Value = '4000';
XDAS.h.migration.edit_migXmax.BackgroundColor = [1 1 1];
XDAS.h.migration.edit_migXmax.Position = [xcol2 yThirdRow xwidth yheight];      
XDAS.h.migration.edit_migXmax.Tooltip = 'Enter the maximum (right) most x position in the migrated image in m';

% create the xmax label
XDAS.h.migration.text_migXmax = uilabel(XDAS.h.panel_migration);
XDAS.h.migration.text_migXmax.Text = 'Xmax (m)';
XDAS.h.migration.text_migXmax.BackgroundColor = [1 1 1];
XDAS.h.migration.text_migXmax.Position = [xcol2 yFourthRow xwidth yheight];      


% create the edit CDPx
XDAS.h.migration.edit_CDPx = uieditfield(XDAS.h.panel_migration);
XDAS.h.migration.edit_CDPx.Value = '0';
XDAS.h.migration.edit_CDPx.BackgroundColor = [1 1 1];
XDAS.h.migration.edit_CDPx.Position = [xcol4 yThirdRow xwidth yheight];      
XDAS.h.migration.edit_CDPx.Tooltip = 'Enter the common depth point (CDP) x position to create';

% create the xmin label
XDAS.h.migration.text_CDPx = uilabel(XDAS.h.panel_migration);
XDAS.h.migration.text_CDPx.Text = 'CDPx (m)';
XDAS.h.migration.text_CDPx.BackgroundColor = [1 1 1];
XDAS.h.migration.text_CDPx.Position = [xcol4 yFourthRow xwidth yheight];     

% ************************************************************************************************************
% create the plotting area for the model
% ************************************************************************************************************

Ax.xLeftEdge   = Sou.xLeftEdge + Sou.xWidth + 50;
Ax.yBottomEdge = Sou.yBottomEdge + 50;
Ax.xWidth      = xR - Ax.xLeftEdge - 20;
Ax.yHeight     = yT - Ax.yBottomEdge - 40;

XDAS.h.axes_model = uiaxes(XDAS.h.figure1,'fontsize',14,'fontweight','bold','BackgroundColor','white', ...
                                          'Position',[Ax.xLeftEdge Ax.yBottomEdge Ax.xWidth Ax.yHeight]);
                                          
createCallBacks

function fileMenuSetUp

global XDAS

% ************************************************************************************************************
% create the File menu items
% ************************************************************************************************************

% main File menu
XDAS.h.menu_file = uimenu(XDAS.h.figure1,'Text','&File');

% set the data directory
XDAS.h.menu_setDataDirectory = uimenu(XDAS.h.menu_file,'Text','&Set Data Directory','Checked','off'); 
XDAS.h.menu_setDataDirectory.MenuSelectedFcn = @menuSetDataDirectory_Callback;
XDAS.h.menu_setDataDirectory.Tooltip = 'Select a different directory to use as the data directory for computations (default uses ''data'' in current directory)';

% Model Open menu
XDAS.h.menu_modelOpen = uimenu(XDAS.h.menu_file,'Text','&Model Open');
XDAS.h.menu_modelOpen.MenuSelectedFcn = @menuModelOpen_Callback;
XDAS.h.menu_modelOpen.Tooltip = 'Open an existing model from disk (JSON formatted)';

% Model Save menu
XDAS.h.menu_modelSave = uimenu(XDAS.h.menu_file,'Text','&Model Save');
XDAS.h.menu_modelSave.MenuSelectedFcn = @menuModelSave_Callback;
XDAS.h.menu_modelSave.Tooltip = 'Save the current model on disk (in JSON format)';

% Clear current model menu
XDAS.h.menu_clearModel = uimenu(XDAS.h.menu_file,'Text','&Clear Current Model');
XDAS.h.menu_clearModel.MenuSelectedFcn = @menuClearModel_Callback;
XDAS.h.menu_clearModel.Tooltip = 'Clear current model and start new model from scratch';

% Save session menu
XDAS.h.menu_saveSession = uimenu(XDAS.h.menu_file,'Text','&Save Session','Separator','on');
XDAS.h.menu_saveSession.MenuSelectedFcn = @menuSaveSession_Callback;
XDAS.h.menu_saveSession.Tooltip = 'Save the current session to disk (in matlab format)';

% Retore session menu
XDAS.h.menu_restoreSession = uimenu(XDAS.h.menu_file,'Text','&Retore Session');
XDAS.h.menu_restoreSession.MenuSelectedFcn = @menuRestoreSession_Callback;
XDAS.h.menu_restoreSession.Tooltip = 'Restore a session that was saved to disk (in matlab format)';

% quit menu
XDAS.h.menu_quit = uimenu(XDAS.h.menu_file,'Text','&Quit','Separator','on');
XDAS.h.menu_quit.MenuSelectedFcn = @menuQuit_Callback;
XDAS.h.menu_quit.Tooltip = 'Quit ExploreDAS and don''t save anything new';

function setupMenuSetUp

global XDAS 

% main File menu
XDAS.h.menu_advanced = uimenu(XDAS.h.figure1,'Text','&Set Up');

% show status of all selections
XDAS.h.menu_status = uimenu(XDAS.h.menu_advanced,'Text','&Status of All Selections');
XDAS.h.menu_status.MenuSelectedFcn = @menuStatus_Callback;
XDAS.h.menu_status.Tooltip = 'Display all user selections in a popup';

% import image to put behind model
XDAS.h.menu_readInImage = uimenu(XDAS.h.menu_advanced,'Text','&Read In Image Behind Model','Checked','off','Separator','on');
XDAS.h.menu_readInImage.MenuSelectedFcn = @menuReadImage_Callback;
XDAS.h.menu_readInImage.Tooltip = 'Read in an image (jpg, png, etc) to display behind the model';


% % set whether to use random noise for optical measurements
% XDAS.h.menu_setGenerateNoise = uimenu(XDAS.h.menu_advanced,'Text','&Generate Random Optical Noise','Checked','on','Separator','on');
% XDAS.h.menu_setGenerateNoise.MenuSelectedFcn = @menuGenerateOpticalNoise_Callback;
% XDAS.h.menu_setGenerateNoise.Tooltip = 'Generate random optical noise measurements instead of actual field measurements';

% % set the resources directory
% XDAS.h.menu_setRSRCSDirectory = uimenu(XDAS.h.menu_advanced,'Text','&Set Directory with Optical Noise Measurement (rsrcs)','Checked','off');
% XDAS.h.menu_setRSRCSDirectory.MenuSelectedFcn = @menuSetRSRCSDirectory_Callback;
% XDAS.h.menu_setRSRCSDirectory.Tooltip = 'Select a directory containing optical noise measurements (default uses ''rsrcs'' in current directory)';

% Migrate Geophone data in reference channel
XDAS.h.menu_migGeophone = uimenu(XDAS.h.menu_advanced,'Text','&Migrate Geophone in reference panel','Checked','on','Separator','on');
XDAS.h.menu_migGeophone.MenuSelectedFcn = @menuMigGeophone_Callback;
XDAS.h.menu_migGeophone.Tooltip = 'Normal operation - migrate the geophone data in the first panel';

% Migrate noise only in the reference channel
XDAS.h.menu_migNoise = uimenu(XDAS.h.menu_advanced,'Text','&Migrate only noise in reference panel','Checked','off');
XDAS.h.menu_migNoise.MenuSelectedFcn = @menuMigNoise_Callback;
XDAS.h.menu_migNoise.Tooltip = 'Migrate noise only in the first panel (no signal)';


% % Data in Memory menu
% XDAS.h.menu_inMemory = uimenu(XDAS.h.menu_advanced,'Text','&Data In Memory','Checked','on');
% XDAS.h.menu_inMemory.MenuSelectedFcn = @menuInMemory_Callback;
% 
% % Data on Disk menu
% XDAS.h.menu_onDisk = uimenu(XDAS.h.menu_advanced,'Text','&Data On Disk','Checked','off');
% XDAS.h.menu_onDisk.MenuSelectedFcn = @menuOnDisk_Callback;

% Select 10m channel spacing
XDAS.h.menu_channelSpacing10m = uimenu(XDAS.h.menu_advanced,'Text','&10m Channel Spacing','Checked','on','Separator','on');
XDAS.h.menu_channelSpacing10m.MenuSelectedFcn = @menuChannelSpacing10m_Callback;
XDAS.h.menu_channelSpacing10m.Tooltip = 'Select 10m channel spacing for fast execution';

% Select 2.5m channel spacing
XDAS.h.menu_channelSpacing2p5m = uimenu(XDAS.h.menu_advanced,'Text','&2.5m Channel Spacing','Checked','off');
XDAS.h.menu_channelSpacing2p5m.MenuSelectedFcn = @menuChannelSpacing2p5m_Callback;
XDAS.h.menu_channelSpacing2p5m.Tooltip = 'Select 2.5m channel spacing for less aliasing';

% Select 10m scattering spacing
XDAS.h.menu_scatteringSpacing10m = uimenu(XDAS.h.menu_advanced,'Text','&10m Scatter Spacing','Checked','on','Separator','on');
XDAS.h.menu_scatteringSpacing10m.MenuSelectedFcn = @menuScatteringSpacing10m_Callback;
XDAS.h.menu_scatteringSpacing10m.Tooltip = 'Select 10m reflector scattering spacing for fast execution';

% Select 1m scattering spacing
XDAS.h.menu_scatteringSpacing2p5m = uimenu(XDAS.h.menu_advanced,'Text','&1m Scatter Spacing','Checked','off');
XDAS.h.menu_scatteringSpacing2p5m.MenuSelectedFcn = @menuScatteringSpacing2p5m_Callback;
XDAS.h.menu_scatteringSpacing2p5m.Tooltip = 'Select 1m reflector scattering spacing for less aliasing';

function exportMenuSetUp

global XDAS 

% main File menu
XDAS.h.menu_export = uimenu(XDAS.h.figure1,'Text','&Export');

% Export Shots in SEGY format menu
XDAS.h.menu_exportShotsSEGY = uimenu(XDAS.h.menu_export,'Text','&Export Shots in SEGY');
XDAS.h.menu_exportShotsSEGY.MenuSelectedFcn = @menuExportShotsSEGY_Callback;
XDAS.h.menu_exportShotsSEGY.Tooltip = 'Export shot records to disk (in SEGY file format';

% Export Migration in SEGY format menu
XDAS.h.menu_exportMigrationSEGY = uimenu(XDAS.h.menu_export,'Text','&Export Migrated Images in SEGY');
XDAS.h.menu_exportMigrationSEGY.MenuSelectedFcn = @menuExportMigrationSEGY_Callback;
XDAS.h.menu_exportMigrationSEGY.Tooltip = 'Export the migrated image to disk (in SEGY file format)';

% Export CDP in SEGY format menu
XDAS.h.menu_exportCDPSEGY = uimenu(XDAS.h.menu_export,'Text','&Export Migrated CDP in SEGY');
XDAS.h.menu_exportCDPSEGY.MenuSelectedFcn = @menuExportCDPSEGY_Callback;
XDAS.h.menu_exportCDPSEGY.Tooltip = 'Export the migrated CDP to disk (in SEGY file format)';

% ***************************

% Export Shots menu
XDAS.h.menu_exportShots = uimenu(XDAS.h.menu_export,'Text','&Export Shots','Separator','on');
XDAS.h.menu_exportShots.MenuSelectedFcn = @menuExportShots_Callback;
XDAS.h.menu_exportShots.Tooltip = 'Export shot records to disk (in matlab file format';

% Export Migration menu
XDAS.h.menu_exportMigration = uimenu(XDAS.h.menu_export,'Text','&Export Migrated Images','Separator','off');
XDAS.h.menu_exportMigration.MenuSelectedFcn = @menuExportMigration_Callback;
XDAS.h.menu_exportMigration.Tooltip = 'Export the migrated image to disk (in matlab format)';

% Export CDP menu
XDAS.h.menu_exportCDP = uimenu(XDAS.h.menu_export,'Text','&Export Migrated CDP','Separator','off');
%XDAS.h.menu_modelOpen.Accerator = 'o';
XDAS.h.menu_exportCDP.MenuSelectedFcn = @menuExportCDP_Callback;
XDAS.h.menu_exportCDP.Tooltip = 'Export the migrated CDP to disk (in matlab format)';


function helpMenuSetUp

global XDAS 

% main File menu
XDAS.h.menu_help = uimenu(XDAS.h.figure1,'Text','&Help');

% Export Shots menu
XDAS.h.menu_helpAbout = uimenu(XDAS.h.menu_help,'Text','&About');
XDAS.h.menu_helpAbout.MenuSelectedFcn = @menuMkAbout_Callback;
XDAS.h.menu_helpAbout.Tooltip = 'Show information about this release';
