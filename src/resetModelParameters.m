function resetModelParameters

% ***********************************************************************************************************
%  resetModelParameters - this function resets all of the model parameters to default
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

% reset model dimensions
CM.model.xmin      = 0;
CM.model.xmax      = 5000;
CM.model.zmin      = 0;
CM.model.zmax      = 5000;
CM.model.zinc      = 10;
CM.model.xinc      = 15;
CM.model.Pvelocity = 4000;
CM.model.Svelocity = round(CM.model.Pvelocity/(1.5));
CM.model.Vp0       = 1500;
CM.model.Vs0       = 1000;
CM.model.kz        = 0.7;
CM.model.nsamples = 5000;
CM.model.f0       = 50;
CM.model.fmin     = 9;
CM.model.fmax     = 96;
CM.model.dt       = 0.001;
CM.model.tmax     = CM.model.nsamples * CM.model.dt;

CM.model.migZmin = 0;
CM.model.migZmax = CM.model.zmax;
CM.model.migXmin = 0;
CM.model.migXmax = CM.model.xmax;

CM.model.CDPx    = mean([CM.model.xmin CM.model.xmax]);

CM.model.modelImage = [];
CM.model.ifShowBackgroundImage = false;



