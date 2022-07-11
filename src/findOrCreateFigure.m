function [obj] = findOrCreateFigure(tag,name,datadir)

% ***********************************************************************************************************
%  findOrCreateFigure - this function finds the object handle for a figure with Tag = tag, 
%                       if that tag cannot be found it creates a new figure with that name
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

hfound = findobj('Tag',tag);
if ~isempty(hfound)
    % found a figure with the correct tag
    obj = hfound(1);
    % set focus on this figure
    figure(obj)
else
    % no figure was found with that tag - create a figure
    if nargin > 2
        % create figure showing the title with the data directory included
        obj = figure('Name',[name ' (' datadir ')'],'Tag',tag);
    else
        % create figure showing the name in the title
        obj = figure('Name',[name],'Tag',tag);
    end
end
