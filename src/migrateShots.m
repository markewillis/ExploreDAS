function migrateShots(waveType)

% ***********************************************************************************************************
%  migrateShots - this function migrates all of the modeled shots
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

% ******************************************************
% check to see if the data are ready to be migrated
% ******************************************************

if(~isfield(XDAS.obj,'shotRecords') )
    title(XDAS.h.axes_model,'There are no shot records created - aborting migration','fontsize',16,'fontweight','bold')
    return
end


if ~CM.simulation.ifMigrateGeophone
    % process only the noise in the reference trace
            refTraceOptions.ifSingleTrace   = true;
            refTraceOptions.whichTrace      = 1;
            refTraceOptions.traceType       = 'None';
            refTraceOptions.ifdirect        = CM.simulation.ifFirstBreaks;
            refTraceOptions.ifOpticalNoise  = true;
            refTraceOptions.opticalNoiseSNR = CM.fiber.opticalNoiseSNR;
            refTraceOptions.ifCMN           = false;
            refTraceOptions.CMNSNR          = CM.fiber.CMNSNR;
            refTraceOptions.ifPolarity      = false;
    
else
    % process the reference trace as usual
            refTraceOptions.ifSingleTrace   = true;
            refTraceOptions.whichTrace      = 1;
            refTraceOptions.traceType       = 'Ref';
            refTraceOptions.ifdirect        = CM.simulation.ifFirstBreaks;
            refTraceOptions.ifOpticalNoise  = false;
            refTraceOptions.opticalNoiseSNR = CM.fiber.opticalNoiseSNR;
            refTraceOptions.ifCMN           = false;
            refTraceOptions.CMNSNR          = CM.fiber.CMNSNR;
            refTraceOptions.ifPolarity      = false;
end
            
            
            otherTraceOptions.ifSingleTrace   = true;
            otherTraceOptions.whichTrace      = 1;
            otherTraceOptions.traceType       = 'Other';
            otherTraceOptions.ifdirect        = CM.simulation.ifFirstBreaks;
            otherTraceOptions.ifOpticalNoise  = CM.fiber.ifOpticalNoise;
            otherTraceOptions.opticalNoiseSNR = CM.fiber.opticalNoiseSNR;
            otherTraceOptions.ifCMN           = CM.fiber.ifCMN;
            otherTraceOptions.CMNSNR          = CM.fiber.CMNSNR;
            otherTraceOptions.ifPolarity      = CM.fiber.ifPolarity;
            
            if CM.fiber.ifNoiseOnly
                %refTraceOptions.traceType     = 'None';
                otherTraceOptions.traceType   = 'None';                
            end

            plotTraceOptions                  = otherTraceOptions;
            plotTraceOptions.ifSingleTrace    = false;
%     
% *******************************************************
% compute the 1-way distance table that can be resused for each migration velocity
% *******************************************************

nx = round((CM.model.migXmax - CM.model.migXmin)/CM.model.xinc + 0.5);
nz = round((CM.model.migZmax - CM.model.migZmin)/CM.model.zinc + 0.5);
x  = CM.model.migXmin + (0:nx-1)*CM.model.xinc;
z  = CM.model.migZmin + (0:nz-1)*CM.model.zinc;

% create instances of the migrated image for the reference and DAS cases
XDAS.obj.migratedImagePair = migratedImage(nx,nz,x,z);
 
% create a running plot of the input data
hinputPlot = figure('Name','Input Record','Tag','inputrecord');
hmigPlot   = figure('Name','Migrated Record','Tag','migratedrecord');

% set up flags to choose which data set to use
ifDirect   = CM.simulation.ifFirstBreaks;
ifNoise    = CM.fiber.ifOpticalNoise | CM.fiber.ifCMN;
ifPolarity = CM.fiber.ifPolarity;

% ******************************************************
% loop over all shots
% ******************************************************

tic;
nshots = get(XDAS.obj.sources,'nsource');

for ishot = 1:nshots
    
    % set up the type of migration to perform (P versus S, constant versus gradient)
    switch get(XDAS.obj.shotRecords(ishot),'velocityType')
        case 'Constant'
            ifConstant = true;
            switch waveType
                case {'VPZ', 'VPDAS'}
                    velocity = CM.model.Pvelocity;
                case {'VSH', 'VSDAS'}
                    velocity = CM.model.Svelocity;
            end
        case 'Gradient'
            ifConstant = false;
            kz         = CM.model.kz;
            switch waveType
                case {'VPZ', 'VPDAS'}
                    velocity = CM.model.Vp0;
                case {'VSH', 'VSDAS'}
                    velocity = CM.model.Vs0;
            end
            
        otherwise
            % can never get here
            return
    end
    
    % make a copy of the handle to this shot record - easier to write
    thisShotRecord = XDAS.obj.shotRecords(ishot);
    
    
    % inform user of current status
    if ishot == 1
        title(XDAS.h.axes_model,['Migrating shot ' num2str(ishot) ' of ' num2str(nshots)],...
            'fontsize',16,'fontweight','bold')
    else
        timeElapse = toc;
        timeRemainingSec = timeElapse/(ishot-1) * (nshots - ishot+1);
        timeRemainingMin = timeRemainingSec / 60;
        
        timeRemainingSecRound = round(timeRemainingSec*10)/10; % round to one place
        timeRemainingMinround = round(timeRemainingMin*10)/10; % round to one place
        
        if timeRemainingMin > 1
            title(XDAS.h.axes_model,['Migrating shot ' num2str(ishot) ' of ' num2str(nshots) ', Mins remaining = ' num2str(timeRemainingMinround)],...
                'fontsize',16,'fontweight','bold')
        else
            title(XDAS.h.axes_model,['Migrating shot ' num2str(ishot) ' of ' num2str(nshots) ', Secs remaining = ' num2str(timeRemainingSecRound)],...
                'fontsize',16,'fontweight','bold')
        end
    end
    
    drawnow

    % replot the trace - but first load it from disk if needed
    fail = thisShotRecord.plotRepeat(hinputPlot,['Shot ' num2str(ishot) ' Ref Data'],'Other Data',plotTraceOptions);
    
    if fail
        % trouble reading in record - abort
         title(XDAS.h.axes_model,['Fatal Error - cannot plot the record'],'fontsize',16,'fontweight','bold')
         return
    end
    
    
    % *******************************************************
    % start migration for this shot
    % *******************************************************
    
    if ifConstant
        % use the constant velocity model
        shotTable = mkTTtable(  x,z,get(thisShotRecord,'sourceX'),get(thisShotRecord,'sourceZ'),velocity);
    else
        % use the v(z) model
        shotTable = mkTTtableVz(x,z,get(thisShotRecord,'sourceX'),get(thisShotRecord,'sourceZ'),velocity,kz);
    end    
    
    tic;
    
    % loop over each channel in the record
    for ichannel = 1:get(thisShotRecord,'nchannels')
        
        % create the receiver travel time table       
        if ifConstant
            % use the constant velocity model
            recTable = mkTTtable(  x,z,thisShotRecord.wellX(ichannel),thisShotRecord.wellZ(ichannel),velocity);
        else
            % use the v(z) model
            recTable = mkTTtableVz(x,z,thisShotRecord.wellX(ichannel),thisShotRecord.wellZ(ichannel),velocity,kz);
        end
        
        % create a two way travel time table from the shot and receiver table
        twoWayTTT = shotTable + recTable;
        
        % extract two traces to migrate
        refTraceOptions.whichTrace = ichannel;
        traceR = thisShotRecord.prepareTraceForMigration(refTraceOptions);
        
        otherTraceOptions.whichTrace = ichannel;
        traceO = thisShotRecord.prepareTraceForMigration(otherTraceOptions);
        
        % migrate the two traces
        XDAS.obj.migratedImagePair.migrateTrace(traceR, traceO, twoWayTTT);

        %if floor(ichannel/40)*40 == ichannel
        %    disp(['Finished migrating channel ' num2str(ichannel)])
        %end
        
    end
    
    toc
    
    % ************************************************************************************************
    % purge data from record if desired to save memory space (it is already saved on disk)
    % ************************************************************************************************

    thisShotRecord.purgeTraces();
    
    % ********************************************************************
    % plot the intermediate migration result
    % ********************************************************************
    
    XDAS.obj.migratedImagePair.plotRepeat(hmigPlot,['After shot ' num2str(ishot)],CM.fiber.ifPolarity);
    
end
    
% ********************************************************************
% plot the final migration result
% ********************************************************************

XDAS.obj.migratedImagePair.plot(waveType,CM.fiber.ifPolarity);

% inform user of current status
title(XDAS.h.axes_model,['Migration finished '],'fontsize',16,'fontweight','bold')
drawnow

