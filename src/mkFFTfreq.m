function [freq] = mkFFTfreq(dt,nt)

% ***********************************************************************************************************
%  mkFFTfreq - this function makes create the list of frequencies for an FFT
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
% function [freq] = mkFFTfreq(dt,nt)
%
% This routine creates the frequency axis for an fft
%
%   dt - the sample interval of the data
%   nt - the number of samples in the fft
%
%   freq - the output frequency axis
%
% *****************************************************************

% create the frequency increment along the axis
df    = 1./(nt * dt);

% define the location of the folding frequency
nfold = floor(nt/2) + 1;

% create positive frequencies
freq  = (0:nt-1).* df;

% correct the negative frequecies (past the folding point)
freq(nfold+1:end) = freq(nfold+1:end) - nt*df;
