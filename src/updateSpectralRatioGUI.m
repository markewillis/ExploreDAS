function updateSpectralRatioGUI

% ***********************************************************************************************************
%  updateSpectralRatioGUI - this function updates the spectral ratio GUI
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
    shotInfo(:,1)  = oneDecimalPlace(XDAS.obj.sources.x);
    shotInfo(:,2)  = oneDecimalPlace(XDAS.obj.sources.z);
    viz = true;
else
    % create the source (shot) location table
    shotInfo = zeros(1,2);
    shotInfo(:,1) = 0;
    shotInfo(:,2) = 0;
    viz = false;
end

XDAS.h.fig3.shotInfoTable.Data = shotInfo;

if viz
    XDAS.h.fig3.shotInfoTable.Visible = 'on';
    XDAS.h.fig3.sourceLabel.Text = 'Source Locations';     

else
    XDAS.h.fig3.shotInfoTable.Visible = 'off';
    XDAS.h.fig3.sourceLabel.Text = 'No Source Locations Entered';     
end

% ************************************************************
% display well information
% ************************************************************

nrows = XDAS.obj.well.nwell;

if nrows > 0
    % there are control points for the well, so get the interpolated values
    nrows = length(XDAS.obj.well.interpx);

    % create the well path points
    wellInfo = zeros(nrows,3);
    wellInfo(:,1) = oneDecimalPlace(XDAS.obj.well.MD);
    wellInfo(:,2) = oneDecimalPlace(XDAS.obj.well.interpx);
    wellInfo(:,3) = oneDecimalPlace(XDAS.obj.well.interpz);
    viz = true;
else
    wellInfo = zeros(1,3);
    viz = false;
end

XDAS.h.fig3.wellInfoTable.Data = wellInfo;

if viz
    XDAS.h.fig3.wellLabel.Text    = 'Well Trajectory Channels';     
    XDAS.h.fig3.wellInfoTable.Visible = 'on';
else
    XDAS.h.fig3.wellLabel.Text = 'No Well Trajectory Channels Entered';     
    XDAS.h.fig3.wellInfoTable.Visible = 'off';
end

% ************************************************************
% display reflector segments
% ************************************************************


nrows = XDAS.obj.reflectors.nsegments + 1;
if nrows > 0
    % create the well path points
    refInfo = zeros(nrows,1);
    refInfo(:,1) = 0:XDAS.obj.reflectors.nsegments;
    viz = true;
else
    refInfo = zeros(1,1);
    refInfo(:,1) = 0;
    viz = true;
end

XDAS.h.fig3.reflInfoTable.Data = refInfo;

if viz
    XDAS.h.fig3.reflectorLabel.Text = 'Reflector Numbers';
    XDAS.h.fig3.reflInfoTable.Visible = 'on';
else
    XDAS.h.fig3.reflectorLabel.Text = 'No Reflectors Entered';
    XDAS.h.fig3.reflInfoTable.Visible = 'off';
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
        segInfo(:,1) = oneDecimalPlace(XDAS.obj.reflectors.segments(1).x);
        segInfo(:,2) = oneDecimalPlace(XDAS.obj.reflectors.segments(1).z);
        viz = true;
    else
        % there are no points in this reflector segment
        segInfo = zeros(1,2);
        segInfo(:,1) = 0;
        segInfo(:,2) = 0;
        viz = false;
    end
    
    XDAS.h.fig3.segInfoTable.Data = segInfo;
    
else
    % there are no reflector segments in the model - make reflector segment table invisible
    viz = false;
end

if viz
    % make the table visible
    XDAS.h.fig3.segInfoTable.Visible = 'on';
    XDAS.h.fig3.segmentLabel.Text = 'Segment 1 Locations';
else
    % make the table invisible
    XDAS.h.fig3.segInfoTable.Visible = 'off';
    XDAS.h.fig3.segmentLabel.Text = 'No Segments Entered';
end



