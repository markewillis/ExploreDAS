function resetFiber

% ***********************************************************************************************************
%  resetFiber - this function sets the default parameters for the fiber
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

CM.fiber.ifGauge             = false;
CM.fiber.ifOpticalNoise      = false;
CM.fiber.ifCMN               = false;
CM.fiber.ifExtraOpticalNoise = false;
CM.fiber.ifExtraCMN          = false;
CM.fiber.ifFading            = false;
CM.fiber.ifremoveCMN         = false;
CM.fiber.ifPolarity          = false;
CM.fiber.ifNoiseOnly         = false;

CM.fiber.opticalNoiseSNR = 20;
CM.fiber.CMNSNR          = 20;
CM.fiber.fadingSNR       = 20;
CM.fiber.GL              = 10;

CM.fiber.nNoiseFiles     = 3;
CM.fiber.nCMNFiles       = 1;
CM.fiber.ifNoiseFromFile = false;

updateNoiseGUI;