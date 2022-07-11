function updateNoiseGUI

% ***********************************************************************************************************
%  updateNoiseGUI - this function updates the noise gui 
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
global CM

goGreen = XDAS.colors.goGreen;
stopRed = XDAS.colors.stopRed;

opticalNoiseColor      = stopRed;
CMNColor               = stopRed;
displayNoiseColor      = stopRed;
removeCMNColor         = stopRed;
useGaugeColor          = stopRed;
polarityColor          = stopRed;
noiseOnlyColor         = stopRed;
firstBreaksColor       = stopRed;

if CM.fiber.ifOpticalNoise
    XDAS.h.DAS.pushbutton_addOpticalNoise.Text = '+ Optical Noise';
    opticalNoiseColor = goGreen;
else
    XDAS.h.DAS.pushbutton_addOpticalNoise.Text = 'No Optical Noise';    
end


if CM.fiber.ifCMN
    CMNColor = goGreen;
    XDAS.h.DAS.pushbutton_addCMN.Text = '+ CMN Noise';
else
    XDAS.h.DAS.pushbutton_addCMN.Text = 'No CMN Noise';
end

if CM.fiber.ifPolarity
    polarityColor = goGreen;
    XDAS.h.DAS.pushbutton_polarity.Text = 'Reversed Polarity';
else
    XDAS.h.DAS.pushbutton_polarity.Text = 'Normal Polarity';
end

if CM.fiber.ifNoiseOnly
    noiseOnlyColor = goGreen;
    XDAS.h.DAS.pushbutton_noiseOnly.Text = 'Noise Only';
else
    XDAS.h.DAS.pushbutton_noiseOnly.Text = 'Sig & Noise';
end

if CM.simulation.ifFirstBreaks
    firstBreaksColor = goGreen;
    XDAS.h.simulation.pushbutton_firstBreaks.Text = 'First Breaks';
else
    XDAS.h.simulation.pushbutton_firstBreaks.Text = 'No First Breaks';
end
    

if CM.fiber.ifremoveCMN
    XDAS.h.DAS.pushbutton_removeCMN.Text = 'Remove CMN';
    removeCMNColor = goGreen;
else
    XDAS.h.DAS.pushbutton_removeCMN.Text = 'Leave in CMN';
end

if CM.fiber.ifGauge
    XDAS.h.simulation.pushbutton_useGL.Text = 'Use Gauge';
    useGaugeColor = goGreen;
else
    XDAS.h.simulation.pushbutton_useGL.Text = 'No Gauge';
end

set(XDAS.h.DAS.pushbutton_addOpticalNoise,  'BackgroundColor',opticalNoiseColor)
set(XDAS.h.DAS.pushbutton_addCMN,           'BackgroundColor',CMNColor)
set(XDAS.h.DAS.pushbutton_displaySourceNum, 'BackgroundColor',displayNoiseColor)
%set(handles.pushbutton_addFading,                      'BackgroundColor',fadingColor)
set(XDAS.h.DAS.pushbutton_removeCMN,        'BackgroundColor',removeCMNColor)
set(XDAS.h.simulation.pushbutton_useGL,     'BackgroundColor',useGaugeColor)
set(XDAS.h.DAS.pushbutton_polarity,         'BackgroundColor',polarityColor)
set(XDAS.h.DAS.pushbutton_noiseOnly,        'BackgroundColor',noiseOnlyColor)
set(XDAS.h.simulation.pushbutton_firstBreaks,      'BackgroundColor',firstBreaksColor)

% set the edit fields to the to default current values
set(XDAS.h.DAS.edit_opticalSNR,    'Value',num2str(CM.fiber.opticalNoiseSNR))
set(XDAS.h.DAS.edit_CMNSNR,        'Value',num2str(CM.fiber.CMNSNR))
%set(handles.edit_fadingSNR,       'string',num2str(CM.fiber.fadingSNR))
set(XDAS.h.simulation.edit_GL,     'Value',num2str(CM.fiber.GL))

drawnow
