function updateStatusSummary

% ***********************************************************************************************************
%  updateStatusSummary - this function updates the status summary
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


createStatusSummaryTables;

if isfield(CM.paths,'data')
    XDAS.h.fig2.dirData.Text       = ['Data Directory: ' CM.paths.data];
else
    XDAS.h.fig2.dirData.Text       = ['No Data Directory Specified' ];
end    
if isfield(CM.paths,'rsrcs')
    XDAS.h.fig2.dirRsrcs.Text      = ['Resources Directory: ' CM.paths.rsrcs];
else
    XDAS.h.fig2.dirRsrcs.Text      = ['No Resources Directory Specified'];
end
if isfield(CM.paths,'modelFile')
    XDAS.h.fig2.modelFileName.Text = ['Model File Name: ' CM.paths.modelFile];
else
    XDAS.h.fig2.modelFileName.Text = ['No Model File Name Specified'];
end

    XDAS.h.fig2.modelX.Text        = ['Model X: min = ' num2str(CM.model.xmin) ', max = ' num2str(CM.model.xmax)];
    XDAS.h.fig2.modelZ.Text        = ['Model Z: min = ' num2str(CM.model.zmin) ', max = ' num2str(CM.model.zmax)];

    switch XDAS.h.model.listbox_velocityType.Value
        case 1
            switch XDAS.h.simulation.listbox_waveType.Value
                % constant velocity
                case 1
                    % P wave DAS
                    XDAS.h.fig2.velocityInfo.Text = ['Constant P Wave Velocity DAS = ' num2str(CM.model.Pvelocity)];
                case 2
                    % S wave DAS
                    XDAS.h.fig2.velocityInfo.Text = ['Constant S Wave Velocity DAS = ' num2str(CM.model.Svelocity)];
                case 3
                    % P wave Vz geophone
                    XDAS.h.fig2.velocityInfo.Text = ['Constant P Wave Velocity Vz Geophone = ' num2str(CM.model.Pvelocity)];
                case 4
                    % S wave Vz geophone
                    XDAS.h.fig2.velocityInfo.Text = ['Constant S Wave Velocity Vz Geophone = ' num2str(CM.model.Svelocity)];
            end
            
        case 2
            % gradient velocity
            switch XDAS.h.simulation.listbox_waveType.Value
                case 1
                    % P wave DAS
                    XDAS.h.fig2.velocityInfo.Text = ['Gradient P Wave Velocity DAS = ' num2str(CM.model.Vp0) ', gradient = ' num2str(CM.model.kz)];
                case 2
                    % S wave DAS
                    XDAS.h.fig2.velocityInfo.Text = ['Gradient S Wave Velocity DAS = ' num2str(CM.model.Vs0) ', gradient = ' num2str(CM.model.kz)];
                case 3
                    % P wave Vz geophone
                    XDAS.h.fig2.velocityInfo.Text = ['Gradient P Wave Velocity Vz Geophone = ' num2str(CM.model.Vp0) ', gradient = ' num2str(CM.model.kz)];
                case 4
                    % S wave Vz geophone
                    XDAS.h.fig2.velocityInfo.Text = ['Gradient S Wave Velocity Vz Geophone = ' num2str(CM.model.Vs0) ', gradient = ' num2str(CM.model.kz)];
            end
    end

    switch XDAS.h.simulation.listbox_sourceType.Value
        case 1
            % Ricker wavelet
            XDAS.h.fig2.sourceInfo.Text = ['Source Wavelet Ricker, f0 = ' num2str(XDAS.h.simulation.edit_fmin.Value) ' Hz'];
        case 2
            % Klauder wavelet
            XDAS.h.fig2.sourceInfo.Text = ['Klauder Wavelet Ricker, fmin = ' num2str(XDAS.h.simulation.edit_fmin.Value) ' Hz, fmax = ' num2str(XDAS.h.simulation.edit_fmax.Value)];
    end

    
XDAS.h.fig2.traceInfo.Text = ['dt = ' num2str(CM.model.dt) ' sec, Tmax = ' num2str(CM.model.tmax) ' sec'];

if CM.fiber.ifGauge
    XDAS.h.fig2.GLInfo.Text = ['Using Gauge Length = ' num2str(CM.fiber.GL) 'm'];
else
    XDAS.h.fig2.GLInfo.Text = ['No Guage Length being used'];
end

if CM.simulation.ifFirstBreaks
    XDAS.h.fig2.firstbreaksInfo.Text = ['Using first breaks'];
else
    XDAS.h.fig2.firstbreaksInfo.Text = ['Not using first breaks'];
end

if CM.fiber.ifOpticalNoise
    XDAS.h.fig2.opticalNoiseInfo.Text = ['Adding Optical Noise - SNR = ' num2str(CM.fiber.opticalNoiseSNR)];
else
    XDAS.h.fig2.opticalNoiseInfo.Text = ['Not adding optical noise'];
end

if CM.fiber.ifCMN
    XDAS.h.fig2.CMNInfo.Text = ['Adding Common Mode Noise - SNR = ' num2str(CM.fiber.CMNSNR)];
else
    XDAS.h.fig2.CMNInfo.Text = ['Not adding common mode noise'];
end

if CM.fiber.ifPolarity
    XDAS.h.fig2.polarityInfo.Text = ['Reverse polarity for the DAS response'];
else
    XDAS.h.fig2.polarityInfo.Text = ['Normal polarity for the DAS response'];
end

% migration parameters
XDAS.h.fig2.migXInfo.Text = ['Migration X: min = ' num2str(CM.model.migXmin) ', max = ' num2str(CM.model.migXmax) ', inc = ' num2str(CM.model.xinc)];
XDAS.h.fig2.migZInfo.Text = ['Migration Z: min = ' num2str(CM.model.migZmin) ', max = ' num2str(CM.model.migZmax) ', inc = ' num2str(CM.model.zinc)];

% cdp parameters
XDAS.h.fig2.cdpInfo.Text = ['CDP X location = ' num2str(CM.model.CDPx)];

