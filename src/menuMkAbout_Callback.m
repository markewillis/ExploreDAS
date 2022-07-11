function menuMkAbout_Callback(~,~)

% ***********************************************************************************************************
%  menuMkAbout_Callback - this function brings up the "about" window
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

global XDASabout

XDASabout.fromFile = false;

% make sure there is only one instance of this figure
if isfield(XDASabout,'h')
    % delete the existing figure
    delete(XDASabout.h.figure1)
end

% set up the default window size of the gui
xL = 240;        % left x value of the window
yB =  68;        % bottom y valule of the window
xR = 1118;       % right x value of the window
yT = 723;        % top y value of the window
dx = xR - xL;    % width of the window
dy = yT - yB;    % height of the window

position = [ xL yB dx dy];

% create the figure window for the gui
XDASabout.h.figure1 = uifigure('position',position,'Menubar','none','Color','white','Name','ExploreDAS About');

% turn off interpreting backslashes as commands in text fields of plots
set(XDASabout.h.figure1,'defaultTextInterpreter','none')

XDASabout.h.list = uilistbox(XDASabout.h.figure1);
XDASabout.h.list.Position = [10 10 dx-20 dy-20];


if XDASabout.fromFile
    
    % open the help file
    fid=fopen('about.m','r');
    
    % set the maximum number of lines to read in the file
    maxlines = 500;
    
    % start the counter
    i=0;
    
    while 1
        
        % read in next line of text from file
        s=fgets(fid);
        
        % look for end of file
        if ~ischar(s)
            break;
        end
        
        % handle weird characters - by ignorning them
        s(s<32|s>127)=32;
        
        % increment the counter
        i=i+1;
        
        % save this line of text into the items list
        Items{i}=(s);
        
        
        if i>maxlines
            break;
        end
        
    end
    
    % close the text file
    fclose(fid);
else
    
    % get file contents from function
    Items = mkAboutItems;
    
end

% create the test list in the figure
XDASabout.h.list.Items = Items;

