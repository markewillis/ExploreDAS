function [problems] = showNoiseyShots(plotType)

% ***********************************************************************************************************
%  [problems] = showNoiseyShots(plotType) - this function displays the data with noise
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
plotTraceOptions.whichTrace      = XDAS.h.simulation.listbox_channelNumber.Value;
plotTraceOptions.traceType       = 'Other';
plotTraceOptions.ifdirect        = CM.simulation.ifFirstBreaks;
plotTraceOptions.ifOpticalNoise  = CM.fiber.ifOpticalNoise;
plotTraceOptions.opticalNoiseSNR = CM.fiber.opticalNoiseSNR;
plotTraceOptions.ifCMN           = CM.fiber.ifCMN;
plotTraceOptions.CMNSNR          = CM.fiber.CMNSNR;
plotTraceOptions.ifPolarity      = CM.fiber.ifPolarity;

if CM.fiber.ifNoiseOnly
    plotRecordOptions.traceType  = 'None';
    plotTraceOptions.traceType   = 'None';
end


problems = false;

% ******************************************************
% check to see if the data are ready to be displayed
% ******************************************************

if(~isfield(XDAS.obj,'shotRecords') )
    title(XDAS.h.axes_model,'There are no shot records created - aborting shot display','fontsize',16,'fontweight','bold')
    problems = true;
    return
end

% ******************************************************
% get the shot (source) number to display
% ******************************************************

labelIndex = XDAS.h.simulation.listbox_sourceNumber.Value;
sourceNumberToDisplay = XDAS.h.simulation.listbox_sourceNumber.ItemsData(labelIndex);


% *****************************************************************************
% create each shot record
% *****************************************************************************



for ishot = sourceNumberToDisplay:sourceNumberToDisplay
    
    % inform user of current status
    title(XDAS.h.axes_model,['Adding noise to shot ' num2str(ishot)],'fontsize',16,'fontweight','bold')
    drawnow
    
    % ************************************************************************************************
    % get traces from disk 
    % ************************************************************************************************

    fail = XDAS.obj.shotRecords(ishot).restoreFromDisk();
    
    if fail
        % cannot open the file desired - ask user to select the proper directory
        menuSetDataDirectory_Callback(0, 0);
        fail = XDAS.obj.shotRecords(ishot).restoreFromDisk();
    end
   
    % ************************************************************************************************
    % replot final shot records into the same figure to save memory
    % ************************************************************************************************
    
    switch plotType
        case 'Record'
            hfigShots  = findOrCreateFigure('DisplayShotRecord','Selected Shot Record');
            fail = XDAS.obj.shotRecords(ishot).plotRepeat(hfigShots,createShotsInfo.plottitle,createShotsInfo.waveType,plotRecordOptions);
            
        case 'fk'
            fail = XDAS.obj.shotRecords(ishot).plotFKRepeat(createShotsInfo.plottitle,createShotsInfo.waveType,plotRecordOptions);
    end
    
    if fail
        % trouble reading in record - abort
         title(XDAS.h.axes_model,['Fatal Error - cannot plot the record'],'fontsize',16,'fontweight','bold')
         return
    end
    
    % ************************************************************************************************
    % replot example traces for both simulations
    % ************************************************************************************************
    
    switch plotType
        case 'Record'
            
            hfigTraces = findOrCreateFigure('DisplayTraces','Selected Wiggle Traces');
            
            fail = XDAS.obj.shotRecords(ishot).plotRepeatTrace(hfigTraces,createShotsInfo.plottitle,createShotsInfo.waveType,plotTraceOptions);
            
            if fail
                % trouble reading in record - abort
                title(XDAS.h.axes_model,['Fatal Error - cannot plot the trace'],'fontsize',16,'fontweight','bold')
                return
            end
    end

    % ************************************************************************************************
    % purge data from record if desired to save memory space (it is already saved on disk)
    % ************************************************************************************************

        XDAS.obj.shotRecords(ishot).purgeTraces();
    
end

% inform user of current status
title(XDAS.h.axes_model,['Finished showing shots with noise'],'fontsize',16,'fontweight','bold')
drawnow
