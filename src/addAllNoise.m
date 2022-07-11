function addAllNoise(copySource,cmnNoise)

% ***********************************************************************************************************
%  addAllNoise - add the different sources of optical noise to the data 
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

global CM

nsamples  = get(copySource,'nsamples');
nchannels = get(copySource,'nchannels');

    
% extract signal level of the synthetic - two options using rms of signal or max value of signal
%rmsSyn = copySource.rms('Other');
rmsSyn = copySource.max('Other');

% save the rms value of the signal in the record
set(copySource,'rmsSignal',rmsSyn)


% **************************************************************************
% clear out the noise traces for new noise data
% **************************************************************************

set(copySource,'tracesOtherNoise',zeros(nsamples,nchannels));

% ************************************************************************************************
% create optical noise
% ************************************************************************************************

noiseInstance = opticalNoiseRecord(CM.fiber.nNoiseFiles,nchannels,nsamples,CM.paths.rsrcs);

% extract signal levels of the noise
[opticalNoise, rmsOpticalNoise] = noiseInstance.createNoise(get(copySource,'opticalNoiseSeeds'),CM.fiber.ifNoiseFromFile);

% add the noise to shot record
set(copySource,'tracesOtherNoise', opticalNoise);
set(copySource,'rmsOpticalNoise', rmsOpticalNoise);

% delete the noise selected noise record to save space
clear opticalNoise;


% ************************************************************************************************
% create CMN
% ************************************************************************************************

% extract signal levels of the noise with no scaling
[selectedNoise, rmsCMN] = cmnNoise.mkCMNunscaled(nsamples,get(copySource,'CMNSeeds'));

% save the common mode noise into the shot record
set(copySource,'traceCMN',selectedNoise);
% save the rms of the common mode noise into the shot record
set(copySource,'rmsCMN',rmsCMN);
        
    
