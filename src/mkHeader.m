function [TextualFileHeader] = mkHeader(messageOut, time,space,typeOutput)

% ***********************************************************************************************************
%  mkHeader - this function makes the ASCII header for an SEGY data file
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
%
% 40 rows of 80 columns of data
parameterString = sprintf('%80s','ExploreDAS - Courtesy Mark E. Willis');
parameterString = [ parameterString sprintf('%80s','  ')];
parameterString = [ parameterString sprintf('%80s','  ')];

parameterString = [ parameterString sprintf('%80s',messageOut)];

parameterString = [ parameterString sprintf('%80s','  ')];
parameterString = [ parameterString sprintf('%80s','  ')];

parameterString = [ parameterString sprintf('%80s',typeOutput)];

parameterString = [ parameterString sprintf('%80s','  ')];

parameterString = [ parameterString sprintf('%80s','Trace "sample" increment values: ')];
parameterString = [ parameterString sprintf('%80s',[' dsample     = ' num2str(abs(time(2)-time(1)))])];
parameterString = [ parameterString sprintf('%80s',[' sample(1)   = ' num2str(time(1))])];
parameterString = [ parameterString sprintf('%80s',[' sample(end) = ' num2str(time(end))])];

parameterString = [ parameterString sprintf('%80s','  ')];

parameterString = [ parameterString sprintf('%80s','Trace distance increment values ')];
parameterString = [ parameterString sprintf('%80s',[' dtrace  = '    num2str(abs(space(2)-space(1)))])];
parameterString = [ parameterString sprintf('%80s',[' trace(1) = '   num2str(space(1))])];
parameterString = [ parameterString sprintf('%80s',[' trace(end) = ' num2str(space(end))])];

parameterString = [ parameterString sprintf('%80s','  ')];
parameterString = [ parameterString sprintf('%80s','  ')];
parameterString = [ parameterString sprintf('%80s','  ')];
parameterString = [ parameterString sprintf('%80s','  ')];
parameterString = [ parameterString sprintf('%80s','  ')];
parameterString = [ parameterString sprintf('%80s','  ')];

parameterString = [ parameterString sprintf('%80s',datestr(now,'yyyy-mm-dd'))];


TextualFileHeader =sprintf('%3200s',parameterString);