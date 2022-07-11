function [trace]= mkTraceRicker(eventTimes,nsamples,dt,f0,amps)

% ***********************************************************************************************************
%  mkTraceRicker - this function makes an output trace with Ricker Wavelets at times eventTimes
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
% function [trace]= mkTraceRicker(eventTimes,nsamples,dt,f0,amps,nsave)
% 
% *****************************************************************

    trace = zeros(1,nsamples);
    
    % limit the events to only be in the time window desired
    mask       = eventTimes < nsamples*dt;
    if sum(mask) < 1
        % no events within the time window
        return
    end
    eventTimes = eventTimes(mask);
    amps       = amps(mask);

   % make the ricker wavelet
   wavelet = mkRicker(f0,dt,nsamples);
    
    % allocate space for the spike trace
    spikes = zeros(1,nsamples);  
    
    % find the nearest samples to the left and right of all of the events
    ileft = floor(eventTimes/dt);
    iright = ileft +1;
    
    % determine the fractional portion of the sample that the events 
    dtleft = eventTimes/dt - ileft;
    dtright= 1 - dtleft;
    
   % place spikes at the right times (interpolating when its between samples)
    for ievent = 1:length(eventTimes)
        spikes(ileft( ievent) ) = spikes(ileft(ievent) ) + dtright(ievent).*amps(ievent);
        spikes(iright(ievent))  = spikes(iright(ievent)) + dtleft(ievent) .*amps(ievent);
    end
          
    % convolve the spikes with the ricker wavelet
    trace = conv(spikes,wavelet);
         
    % remove half of the ricker wavelet time delay from the output trace
    nhalf = floor(length(wavelet)/2);
    trace = trace(nhalf+1:end-nhalf);

function [ savedWavelet ] = mkRicker( f0,dt,np )
%
% create a ricker wavelet
%
%
% create the frequency increment along the axis
df    = 1./(np * dt);

% define the location of the folding frequency
nfold = floor(np/2) + 1;

% create positive frequencies
freq  = (0:np-1).* df;

% correct the negative frequecies (past the folding point)
freq(nfold+1:end) = freq(nfold+1:end) - np*df;

% create the Ricker wavelet
fsquared =  (freq/f0).^2;   
spec =  fsquared.* exp( 1 - fsquared);
wavelet = real(ifft(complex(spec,zeros(1,np))));
% normalize it
wavelet = wavelet./(max(abs(wavelet)));

% determine the number of samples of the wavelet to save
%  - make it 3 times the trough to trough time
twavelet = 3.* 1 / (1.3 *f0);
%  - now make it an odd number of samples
nsave = round( twavelet / dt); 
nsave = floor(nsave/2)*2 + 1;

% now extract the portion we want to save
nleft  = floor(nsave/2);
nright = nsave - nleft;
savedWavelet = [ wavelet(end-nleft+1:end) wavelet(1:nright)];

