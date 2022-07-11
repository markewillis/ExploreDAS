function pushbutton_migrate_Callback(~, ~)

% ***********************************************************************************************************
%  pushbutton_migrate_Callback - this function start the migration
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

set(XDAS.h.migration.pushbutton_migrate,'BackgroundColor',goGreen)
drawnow

switch get(XDAS.h.simulation.listbox_waveType,'value')
    case 3
        waveType = 'VPZ';
    case 1
        waveType = 'VPDAS';
    case 4
        waveType = 'VSH';
    case 2
        waveType = 'VSDAS';
end
migrateShots(waveType)

set(XDAS.h.migration.pushbutton_migrate,'BackgroundColor',stopRed)
drawnow
