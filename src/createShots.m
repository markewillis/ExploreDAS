function [problems] = createShots(waveType)

% ***********************************************************************************************************
%  createShots - this function starts the creation of shot records
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

% *****************************************************************************
% check to make sure user has created all the required components
% *****************************************************************************

problems = checkForShotProblems;
if problems
    % there is not enough info to create the simulation
    return
end

% *****************************************************************************
% extract all parameters for the shot creation
% *****************************************************************************

setupShotInfo(waveType)
    
if createShotsInfo.ifRicker
    sourceWavelet = 'Ricker';
else
    sourceWavelet = 'Klauder';
end
if createShotsInfo.ifConstant
    velocityType = 'Constant';
else
    velocityType = 'Gradient';
end

% documentation for the options:

% traceOptions.ifSingleTrace   = { true, false }
% traceOptions.whichTrace      = value
% traceOptions.traceType       = {'Ref','Other','None'}
% traceOptions.ifdirect        = {true, false}

% traceOptions.ifOpticalNoise  = { true, false};
% traceOptions.opticalNoiseSNR = value
% traceOptions.ifCMN           = { true, false}
% traceOptions.CMNSNR          = value

% traceOptions.ifPolarity      = { true, false}

plotRecordOptions.ifSingleTrace   = false;
plotRecordOptions.whichTrace      = 1;
plotRecordOptions.traceType       = 'Other';
plotRecordOptions.ifdirect        = CM.simulation.ifFirstBreaks;
plotRecordOptions.ifOpticalNoise  = CM.fiber.ifOpticalNoise;
plotRecordOptions.opticalNoiseSNR = CM.fiber.opticalNoiseSNR;
plotRecordOptions.ifCMN           = CM.fiber.ifCMN;
plotRecordOptions.CMNSNR          = CM.fiber.CMNSNR;
plotRecordOptions.ifPolarity      = CM.fiber.ifPolarity;


plotTraceOptions.ifSingleTrace   = true;
plotTraceOptions.whichTrace      = 1;
plotTraceOptions.traceType       = 'Other';
plotTraceOptions.ifdirect        = CM.simulation.ifFirstBreaks;
plotTraceOptions.ifOpticalNoise  = CM.fiber.ifOpticalNoise;
plotTraceOptions.opticalNoiseSNR = CM.fiber.opticalNoiseSNR;
plotTraceOptions.ifCMN           = CM.fiber.ifCMN;
plotTraceOptions.CMNSNR          = CM.fiber.CMNSNR;
plotTraceOptions.ifPolarity      = CM.fiber.ifPolarity;

% ******************************************************
% preload the common mode noise
% ******************************************************

[cmnNoise] = preloadCMN(CM.fiber.ifNoiseFromFile);
    

% create figures to plot the created shot records and an example trace
hfigShots  = findOrCreateFigure('ShotRecord','Shot Record');
hfigTraces = findOrCreateFigure('Traces','Wiggle Traces');

% *****************************************************************************
% create each shot record
% *****************************************************************************

nshots = get(XDAS.obj.sources,'nsource');
tic;

for ishot = 1:nshots
    
    % inform user of current status
    if ishot == 1
        title(XDAS.h.axes_model,['Creating shot ' num2str(ishot) ' of ' num2str(nshots)],...
              'fontsize',16,'fontweight','bold')
    else
        timeElapse = toc;
        timeRemainingSec = timeElapse/(ishot-1) * (nshots - ishot+1);
        timeRemainingMin = timeRemainingSec / 60;
        
        timeRemainingSecRound = round(timeRemainingSec*10)/10; % round to one place
        timeRemainingMinround = round(timeRemainingMin*10)/10; % round to one place

        if timeRemainingMin > 1
            title(XDAS.h.axes_model,['Creating shot ' num2str(ishot) ' of ' num2str(nshots) ', Mins remaining = ' num2str(timeRemainingMinround)],...
                'fontsize',16,'fontweight','bold')
        else
            title(XDAS.h.axes_model,['Creating shot ' num2str(ishot) ' of ' num2str(nshots) ', Secs remaining = ' num2str(timeRemainingSecRound)],...
                'fontsize',16,'fontweight','bold')
        end
    end
    drawnow
    
    % ********************************************
    % create the shotRecord object to hold this seismic record
    XDAS.obj.shotRecords(ishot) = seismicRecord(ishot, ...
                                                          createShotsInfo.waveType, ...
                                                          createShotsInfo.nsamples, ...
                                                          createShotsInfo.nchannels, ...
                                                          createShotsInfo.dt, ...
                                                          sourceWavelet,...
                                                          createShotsInfo.f0,...
                                                          createShotsInfo.fmin,...
                                                          createShotsInfo.fmax,...
                                                          XDAS.obj.sources.x(ishot),...
                                                          XDAS.obj.sources.z(ishot),...
                                                          get(XDAS.obj.well,'interpx'),...
                                                          get(XDAS.obj.well,'interpz'),...
                                                          get(XDAS.obj.well,'MD'),...
                                                          velocityType,...
                                                          CM.fiber.GL,...
                                                          CM.paths.data);
                                 
    % check to see if the object was create ok
    if ~XDAS.obj.shotRecords(ishot).valid
        % trouble creating the shot - abort
         title(XDAS.h.axes_model,['Fatal Error - cannot create shot record'],'fontsize',16,'fontweight','bold')
         return
    end
        
    % compute the normal angle to the well bore
    fail = XDAS.obj.shotRecords(ishot).createWellDirectionCosines;

    % check to see if the object was create ok
    if fail
        % trouble creating the direction cosines - abort
         title(XDAS.h.axes_model,['Fatal Error - cannot create direction cosines'],'fontsize',16,'fontweight','bold')
         return
    end
   
    if createShotsInfo.useGauge
        % user wants to create DAS records - this requires using a gauge
        % using a gauge requires two depths around the point to be modeled
        % one depth is a half a gauge above, the other is half a gauge below
        fail = XDAS.obj.shotRecords(ishot).interpPointsGLdepths;
        % check to see if the object was create ok
        if fail
            % trouble creating the distances between GL points - abort
            title(XDAS.h.axes_model,['Fatal Error - cannot interpolate GL depths'],'fontsize',16,'fontweight','bold')
            return
        end
    end
    
    % ************************************************************************
    % Create upgoing reflected traces from list of scatterers for this shot
    % ************************************************************************
    
    if createShotsInfo.ifConstant
        % use the constant velocity model
        fail = XDAS.obj.shotRecords(ishot).createShotsConstantVel;
        if fail
            % trouble creating the shot - abort
            title(XDAS.h.axes_model,['Fatal Error - cannot create constant velocity shot'],'fontsize',16,'fontweight','bold')
            return
        end
    else
        % use the v(z) model
        fail = XDAS.obj.shotRecords(ishot).createShotsVofZ;
        if fail
            % trouble creating the shot - abort
            title(XDAS.h.axes_model,['Fatal Error - cannot create v(z) velocity shot'],'fontsize',16,'fontweight','bold')
            return
        end
    end
    
    % ************************************************************************
    % Create direct arrival traces for this shot
    % ************************************************************************
    
    fail = XDAS.obj.shotRecords(ishot).createFirstBreaks;
    if fail
        % trouble creating the first breaks - abort
        title(XDAS.h.axes_model,['Fatal Error - cannot first breaks'],'fontsize',16,'fontweight','bold')
        return
    end
    
    % ************************************************************************************************
    % add the noise to the record
    % ************************************************************************************************
    
    addAllNoise(XDAS.obj.shotRecords(ishot),cmnNoise)
   
    % ************************************************************************************************
    % replot final shot records into the same figure to save memory
    % ************************************************************************************************
    
    fail = XDAS.obj.shotRecords(ishot).plotRepeat(hfigShots,createShotsInfo.plottitle,createShotsInfo.waveType,plotRecordOptions);
    if fail
        % trouble plotting the shot - abort
        title(XDAS.h.axes_model,['Fatal Error - cannot replot shot'],'fontsize',16,'fontweight','bold')
        return
    end
    
    % ************************************************************************************************
    % replot example traces for both simulations
    % ************************************************************************************************
    
    fail = XDAS.obj.shotRecords(ishot).plotRepeatTrace(hfigTraces,createShotsInfo.plottitle,createShotsInfo.waveType,plotTraceOptions);
    if fail
        % trouble plotting the shot - abort
        title(XDAS.h.axes_model,['Fatal Error - cannot replot trace'],'fontsize',16,'fontweight','bold')
        return
    end
    
    % ************************************************************************************************
    % archive record to disk to save memory space
    % ************************************************************************************************

    fail = XDAS.obj.shotRecords(ishot).archiveToDisk();
    
    if fail
        title(XDAS.h.axes_model,['Fatal Error - cannot write shot record to disk'],'fontsize',16,'fontweight','bold')
        return
    end
 
end

% update the display list box for the all the sources
updateSourceNumberListBox();

% update the display list box for the all the channels
updateChannelNumberListBox();

% inform user of current status
title(XDAS.h.axes_model,['Finished creating all shots'],'fontsize',16,'fontweight','bold')
drawnow
