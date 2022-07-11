function reflectorSegmentSelectionRatioCallback(~,eventdata)

% ***********************************************************************************************************
%  reflectorSegmentSelectionRatioCallback - this function replots the selected reflector spectral ratios
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

% the selected row and column are given by eventdata.Indices[row,col]
%  decrement the row by one to account for the direct wave in the first row
selectedSegment = eventdata.Indices(1) - 1;

% update the gui with the selected shot number
XDAS.h.fig3.edit_segmentNumber.Text = num2str(selectedSegment);

% now update the segment data

% ************************************************************
% display segment information
% ************************************************************

if selectedSegment < 1
    % the direct wave was selected
    
    % check the well number of points
    if XDAS.obj.well.nwell > 1 && length(XDAS.obj.well.interpx)>2
        % there are points digitized for the well
        nrows = length(XDAS.obj.well.interpx);
        segInfo = zeros(nrows,2);
        segInfo(:,1) = XDAS.obj.well.interpx;
        segInfo(:,2) = XDAS.obj.well.interpz;
        viz = true;
    else
        % there are no points to display
        segInfo = zeros(1,2);
        segInfo(:,1) = 0;
        segInfo(:,2) = 0;
        viz = false;        
    end    
    
    % fill the gui table with the new direct arrival info
    XDAS.h.fig3.segInfoTable.Data = segInfo;

elseif XDAS.obj.reflectors.nsegments > selectedSegment-1
    
    % there is at least one reflector segment in the model
    nrows = XDAS.obj.reflectors.segments(selectedSegment).np;
    
    if nrows > 0
        % there are one or more points in this reflector segment
        segInfo = zeros(nrows,2);
        segInfo(:,1) = XDAS.obj.reflectors.segments(selectedSegment).x;
        segInfo(:,2) = XDAS.obj.reflectors.segments(selectedSegment).z;
        viz = true;
    else
        % there are no points in this reflector segment
        segInfo = zeros(1,2);
        segInfo(:,1) = 0;
        segInfo(:,2) = 0;
        viz = false;
    end
    
    % fill the gui table with the segment info
    XDAS.h.fig3.segInfoTable.Data = segInfo;
    
else
    % there are no reflector segments in the model - make reflector segment table invisible
    viz = false;
end

if viz
    % make the table visible
    XDAS.h.fig3.segInfoTable.Visible = 'on';
    XDAS.h.fig3.segmentLabel.Text = ['Segment ' num2str(selectedSegment) ' Locations'];
else
    % make the table invisible
    XDAS.h.fig3.segInfoTable.Visible = 'off';
    XDAS.h.fig3.segmentLabel.Text = 'No Segments Entered';
end