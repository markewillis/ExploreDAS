function [savedWavelet ] = mkKlauderWavelet(fmin,fmax,dt)

% ***********************************************************************************************************
%  mkKlauderWavelet - this function makes a Klauder Wavelet
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
%
% function mkKlauderWavelet
%
% this function create Klauder Wavelet
%
% *****************************************************************

savedWavelet.wavelet    = [];
savedWavelet.zeroSample = [];
savedWavelet.zeroTime   = [];

% create a 16 sec chirp from 6 to 96 HZ

t = 0:dt:16;    % sweep that is 16 seconds long
f1 = fmin;      % lower frequency limit of chirp in HZ
t1 = 16;        % length of chirp in seconds
f2 = fmax;      % upper frequency limit of chirp in HZ

% compute the center frequency of pulse
f0 = mean([f1 f2]);

trace = chirp(t,f1,t1,f2);

% create a taper for the chip

win = tukeywin(length(trace),0.05);
trace = trace .* win';

% the spectrum for the windowed trace

fftTrace = fft(trace);

% compute the correlated wavelet (using the complex conjugate)

wavelet = ifft(fftTrace .* conj(fftTrace));

% normalize it
wavelet = wavelet./(max(abs(wavelet)));

% determine the number of samples of the wavelet to save
%  - make it 16 times the trough to trough time
twavelet = 16.* 1 / (1.3 *f0);
%  - now make it an odd number of samples
nsave = round( twavelet / dt); 
nsave = floor(nsave/2)*2 + 1;

% now extract the portion we want to save
nleft  = floor(nsave/2);
nright = nsave - nleft;
newWavelet = [ wavelet(end-nleft+1:end) wavelet(1:nright)];

% remove the mean
meanVal = mean(newWavelet);
newWavelet = newWavelet - meanVal;

% taper the edges to make it smooth
win = tukeywin(length(newWavelet),0.5);
savedWavelet.wavelet = newWavelet .* win';

% save parameters about the zero time value of the wavelet
savedWavelet.zeroSample = nleft+1;
savedWavelet.zeroTime   =(nleft+1)*dt;


