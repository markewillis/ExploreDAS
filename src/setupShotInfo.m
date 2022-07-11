function setupShotInfo(waveType)

% ***********************************************************************************************************
%  setupShotInfo - this function sets shot (source) information
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
global XDAS
global createShotsInfo

createShotsInfo.waveType = waveType;

createShotsInfo.depthTolerance = CM.simulation.depthTolerance;


switch waveType
    case {'VPZ', 'VPDAS'}
        createShotsInfo.velocity = CM.model.Pvelocity;
        createShotsInfo.plottitle = 'P Wave ';
    case {'VSH', 'VSDAS'}
        createShotsInfo.velocity = CM.model.Svelocity;
        createShotsInfo.plottitle = 'S Wave ';
end

% check to see if we need to compute the gauge length effect
createShotsInfo.useGauge = false;
createShotsInfo.DAScase  = false;
switch waveType
    case {'VPDAS', 'VSDAS'}
        createShotsInfo.DAScase = true;
        if CM.fiber.ifGauge
            % user selected both a DAS measurement and a Gauge Length to be used
            createShotsInfo.useGauge = true;
        end
    case {'VPZ', 'VSH'}
end

createShotsInfo.nsamples  = CM.model.nsamples;
createShotsInfo.nchannels = length(get(XDAS.obj.well,'interpx'));
createShotsInfo.dt        = CM.model.dt;
createShotsInfo.f0        = CM.model.f0;

createShotsInfo.fmin      = CM.model.fmin;
createShotsInfo.fmax      = CM.model.fmax;

switch get(XDAS.h.simulation.listbox_sourceType,'Value')
    case 1
        % Ricker
        createShotsInfo.ifRicker = true;
    case 2 
        % Klauder
        createShotsInfo.ifRicker = false;
        [createShotsInfo.savedKlauderWavelet ] = mkKlauderWavelet(createShotsInfo.fmin,createShotsInfo.fmax,createShotsInfo.dt);
end

switch get(XDAS.h.model.listbox_velocityType,'Value')
    case 1
        % constant velocity model
        createShotsInfo.ifConstant = true;
    case 2 
        % gradient velocity model
        createShotsInfo.ifConstant = false;
        switch waveType
            case {'VPZ', 'VPDAS'}
                createShotsInfo.v0 = CM.model.Vp0;
                createShotsInfo.kz = CM.model.kz;
                createShotsInfo.plottitle = 'P Wave (Gradient)';
            case {'VSH', 'VSDAS'}
                createShotsInfo.v0 = CM.model.Vs0;
                createShotsInfo.kz = CM.model.kz;
                createShotsInfo.plottitle = 'S Wave (Gradient)';
        end
end

