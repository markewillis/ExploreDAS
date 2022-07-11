function createStatusSummaryTables

% ***********************************************************************************************************
%  createStatusSummaryTables - this function creates display of all the modeling & migration parameters
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

% ************************************************************
% display shot information
% ************************************************************

nrows = XDAS.obj.sources.nsource;
if nrows > 0
    % create the source (shot) location table
    shotInfo = zeros(XDAS.obj.sources.nsource,2);
    shotInfo(:,1)  = XDAS.obj.sources.x;
    shotInfo(:,2)  = XDAS.obj.sources.z;
    viz = true;
else
    % create the source (shot) location table
    shotInfo = zeros(1,2);
    shotInfo(:,1) = 0;
    shotInfo(:,2) = 0;
    viz = false;
end

XDAS.h.fig2.shotInfoTable.Data = shotInfo;

if viz
    XDAS.h.fig2.shotInfoTable.Visible = 'on';
    XDAS.h.fig2.sourceLabel.Text = 'Source Locations';     

else
    XDAS.h.fig2.shotInfoTable.Visible = 'off';
    XDAS.h.fig2.sourceLabel.Text = 'No Source Locations Entered';     
end

% ************************************************************
% display well information
% ************************************************************


nrows = XDAS.obj.well.nwell;

if nrows > 0
    % create the well path points
    wellInfo = zeros(nrows,2);
    wellInfo(:,1) = XDAS.obj.well.x;
    wellInfo(:,2) = XDAS.obj.well.z;
    viz = true;
else
    wellInfo = zeros(1,2);
    wellInfo(:,1) = 0;
    wellInfo(:,2) = 0;
    viz = false;
end

XDAS.h.fig2.wellInfoTable.Data = wellInfo;

if viz
    XDAS.h.fig2.wellLabel.Text    = 'Well Trajectory Control Points';     
    XDAS.h.fig2.wellInfoTable.Visible = 'on';
else
    XDAS.h.fig2.wellLabel.Text = 'No Well Trajectory Control Points Entered';     
    XDAS.h.fig2.wellInfoTable.Visible = 'off';
end

% ************************************************************
% display reflector segments
% ************************************************************


nrows = XDAS.obj.reflectors.nsegments;
if nrows > 0
    % create the well path points
    refInfo = zeros(nrows,1);
    refInfo(:,1) = 1:XDAS.obj.reflectors.nsegments;
    viz = true;
else
    refInfo = zeros(1,1);
    refInfo(:,1) = 0;
    viz = false;
end

XDAS.h.fig2.reflInfoTable.Data = refInfo;

if viz
    XDAS.h.fig2.reflectorLabel.Text = 'Reflector Numbers';
    XDAS.h.fig2.reflInfoTable.Visible = 'on';
else
    XDAS.h.fig2.reflectorLabel.Text = 'No Reflectors Entered';
    XDAS.h.fig2.reflInfoTable.Visible = 'off';
end

% ************************************************************
% display segment information
% ************************************************************

if XDAS.obj.reflectors.nsegments > 0
    
    % there is at least one reflector segment in the model
    nrows = XDAS.obj.reflectors.segments(1).np;
    
    if nrows > 0
        % there are one or more points in this reflector segment
        segInfo = zeros(nrows,2);
        segInfo(:,1) = XDAS.obj.reflectors.segments(1).x;
        segInfo(:,2) = XDAS.obj.reflectors.segments(1).z;
        viz = true;
    else
        % there are no points in this reflector segment
        segInfo = zeros(1,2);
        segInfo(:,1) = 0;
        segInfo(:,2) = 0;
        viz = false;
    end
    
    XDAS.h.fig2.segInfoTable.Data = segInfo;
    
else
    % there are no reflector segments in the model - make reflector segment table invisible
    viz = false;
end

if viz
    % make the table visible
    XDAS.h.fig2.segInfoTable.Visible = 'on';
    XDAS.h.fig2.segmentLabel.Text = 'Segment 1 Locations';
else
    % make the table invisible
    XDAS.h.fig2.segInfoTable.Visible = 'off';
    XDAS.h.fig2.segmentLabel.Text = 'No Segments Entered';
end
