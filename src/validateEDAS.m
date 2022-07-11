function [EDAS] = validateEDAS(EDAS)

% ***********************************************************************************************************
%  validateEDAS - this function checks the imported saved session to make sure it is valid
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

% this function validates the imported EAS structure to make sure that all fields are valid

global CM

% EDAS structure is created by
%
% EDAS.CM         = CM;
% EDAS.well       = exploreDAS.objects.well;
% EDAS.sources    = exploreDAS.objects.sources;
% EDAS.reflectors = exploreDAS.objects.reflectors;
% 

% ***************************************
% fix the missing path parameters
% ***************************************

if ~isfield(EDAS.CM,'paths')
    EDAS.CM.paths.data  = 'data';
    EDAS.CM.paths.rsrcs = 'rsrcs';
    EDAS.CM.paths.modelFile = [];
else
    if ~isfield(EDAS.CM.paths,'data')
        EDAS.CM.paths.data = 'data';
    end
    if ~isfield(EDAS.CM.paths,'rsrcs')
        EDAS.CM.paths.rsrcs = 'rsrcs';
    end
    if ~isfield(EDAS.CM.paths,'modelFile')
        EDAS.CM.paths.modelFile = [];
    end
end

% ***************************************
% fix the missing simulation parameters
% ***************************************

if ~isfield(EDAS.CM.simulation,'ifArchiveToDisk')
    EDAS.CM.simulation.ifArchiveToDisk = false;
end
if ~isfield(EDAS.CM.simulation,'ifFirstBreaks')
    EDAS.CM.simulation.ifFirstBreaks = false;
end

if ~isfield(EDAS.CM.simulation,'depthTolerance')
    EDAS.CM.simulation.depthTolerance = 10.;
end
if ~isfield(EDAS.CM.simulation,'channelSpacing')
    EDAS.CM.simulation.channelSpacing = 10;
end
if ~isfield(EDAS.CM.simulation,'ifMigrateGeophone')
    EDAS.CM.simulation.ifMigrateGeophone = true;
end

% ***************************************
% fix the missing fiber parameters
% ***************************************

if ~isfield(EDAS.CM.fiber,'ifGauge')
    EDAS.CM.fiber.ifGauge = false;
end
if ~isfield(EDAS.CM.fiber,'ifOpticalNoise')
    EDAS.CM.fiber.ifOpticalNoise = false;
end
if ~isfield(EDAS.CM.fiber,'ifCMN')
    EDAS.CM.fiber.ifCMN = false;
end
if ~isfield(EDAS.CM.fiber,'ifExtraOpticalNoise')
    EDAS.CM.fiber.ifExtraOpticalNoise = false;
end
if ~isfield(EDAS.CM.fiber,'ifExtraCMN')
    EDAS.CM.fiber.ifExtraCMN = false;
end
if ~isfield(EDAS.CM.fiber,'ifFading')
    EDAS.CM.fiber.ifFading = false;
end
if ~isfield(EDAS.CM.fiber,'ifremoveCMN')
    EDAS.CM.fiber.ifremoveCMN = false;
end
if ~isfield(EDAS.CM.fiber,'ifPolarity')
    EDAS.CM.fiber.ifPolarity = false;
end

if ~isfield(EDAS.CM.fiber,'ifNoiseOnly')
    EDAS.CM.fiber.ifNoiseOnly = false;
end
if ~isfield(EDAS.CM.fiber,'opticalNoiseSNR')
    EDAS.CM.fiber.opticalNoiseSNR = 20;
end
if ~isfield(EDAS.CM.fiber,'CMNSNR')
    EDAS.CM.fiber.CMNSNR = 20;
end
if ~isfield(EDAS.CM.fiber,'fadingSNR')
    EDAS.CM.fiber.fadingSNR = 20;
end
if ~isfield(EDAS.CM.fiber,'GL')
    EDAS.CM.fiber.GL = 10;
end
if ~isfield(EDAS.CM.fiber,'nNoiseFiles')
    EDAS.CM.fiber.nNoiseFiles = 3;
end
if ~isfield(EDAS.CM.fiber,'nCMNFiles')
    EDAS.CM.fiber.nCMNFiles = 1;
end
if ~isfield(EDAS.CM.fiber,'ifNoiseFromFile')
    EDAS.CM.fiber.ifNoiseFromFile = false;
end
% ***************************************
% fix the missing model parameters
% ***************************************

% depth values (Z)
if ~isfield(EDAS.CM.model,'migZmin')
    EDAS.CM.model.migZmin = 0.;
end
if ~isfield(EDAS.CM.model,'migZmax')
    EDAS.CM.model.migZmax = EDAS.CM.model.zmax;
end

% distance values (x)
if ~isfield(EDAS.CM.model,'migXmin')
    EDAS.CM.model.migXmin = 0.;
end
if ~isfield(EDAS.CM.model,'migXmax')
    EDAS.CM.model.migXmax = EDAS.CM.model.xmax;
end

% CDP location in X
if ~isfield(EDAS.CM.model,'CDPx')
    EDAS.CM.model.CDPx =  mean([ EDAS.CM.model.xmin  EDAS.CM.model.xmax]);
end

% the model display option
if ~isfield(EDAS.CM.model,'ifShowBackgroundImage')
    EDAS.CM.model.ifShowBackgroundImage =  false;
end

% the model display option
if ~isfield(EDAS.CM.model,'fnModel')
    EDAS.CM.model.fnModel    = [];
    EDAS.CM.model.modelImage = [];
else
    % import the background model
    try
        testImage = imread(EDAS.CM.model.fnModel);
    catch
        % can't read this model
        testImage                        = [];
        EDAS.CM.CM.model.fnModel         = [];
        EDAS.CM.CM.model.imageCropXStart = [];
        EDAS.CM.CM.model.imageCropZStart = [];
        EDAS.CM.CM.model.imageCropXend   = [];
        EDAS.CM.CM.model.imageCropZend   = [];
        
    end
    if ~isempty(testImage)
        [nz,nx,ncolor] = size(testImage);
        if ~isfield(EDAS.CM.model,'imageCropXStart')
            EDAS.CM.model.imageCropXStart =  1;
        end
        if ~isfield(EDAS.CM.model,'imageCropZStart')
            EDAS.CM.model.imageCropZStart =  1;
        end
        if ~isfield(EDAS.CM.model,'imageCropXend')
            EDAS.CM.model.imageCropXend =  nx;
        end
        if ~isfield(EDAS.CM.model,'imageCropZend')
            EDAS.CM.model.imageCropZend =  nz;
        end
        % crop the read in image to the previous size
        CM.model.modelImage = testImage(EDAS.CM.model.imageCropZStart:EDAS.CM.model.imageCropZend,...
                                        EDAS.CM.model.imageCropXStart:EDAS.CM.model.imageCropXend,:);
    end
end



