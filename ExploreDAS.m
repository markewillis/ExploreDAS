function ExploreDAS
%
% This function starts the ExploreDAS software package 
%
% This software allows for the:
%    - simulation of DAS and geophone seismic shot record data
%    - the simple Kirchhoff migration of the seismic shot records
%
% The purpose of this software is to teach the basic concepts of DAS seismic data
%
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

% **********************************************************************************************
% Create the default title of the gui
% **********************************************************************************************

releaseName = [];

if isempty(releaseName)
    XDAS.releaseTitle = 'ExploreDAS - by Mark E. Willis ';
else
    XDAS.releaseTitle = ['ExploreDAS - Exclusively released to ' releaseName ' by Mark E. Willis for testing. '];
end

XDAS.compile.title = XDAS.releaseTitle;


% **********************************************************************************************
% add the proper paths to the matlab path for the classes and source files - if not going to compile it
% **********************************************************************************************

XDAS.compile.on = false;

if ~XDAS.compile.on
    XDAS.paths.old = addpath('classes','src',fullfile('SegyMAT-1.5.1','SegyMAT'));
end


% **********************************************************************************************
% create the gui with objects in default locations
% **********************************************************************************************

openGUI;

% **********************************************************************************************
% update the control objects to make it look nice
% **********************************************************************************************

resizeGUI;

% **********************************************************************************************
% set up the model and the current states
% **********************************************************************************************

openingFunction;

