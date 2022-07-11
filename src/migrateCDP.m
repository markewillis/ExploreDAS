function migrateCDP(waveType)

% ***********************************************************************************************************
%  migrateCDP - this function migrates a CDP
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


refTraceOptions.ifSingleTrace   = true;
refTraceOptions.whichTrace      = 1;
refTraceOptions.traceType       = 'Ref';
refTraceOptions.ifdirect        = CM.simulation.ifFirstBreaks;
refTraceOptions.ifOpticalNoise  = false;
refTraceOptions.opticalNoiseSNR = CM.fiber.opticalNoiseSNR;
refTraceOptions.ifCMN           = false;
refTraceOptions.CMNSNR          = CM.fiber.CMNSNR;
refTraceOptions.ifPolarity      = false;


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


  
% *******************************************************
% compute the 1-way distance table that can be resused for each migration velocity
% *******************************************************

cdpx  = CM.model.CDPx;
nshots = get(XDAS.obj.sources,'nsource');
nz = round((CM.model.migZmax - CM.model.migZmin)/CM.model.zinc + 0.5);
shotx = zeros(1,nshots);
for ishot=1:nshots
    shotx(ishot) = get(XDAS.obj.shotRecords(ishot),'sourceX');
end
z  = CM.model.migZmin + (0:nz-1)*CM.model.zinc;

% create instances of the migrated image for the reference and DAS cases
XDAS.obj.migratedCDPPair = migratedCDP(cdpx,nshots,shotx,nz,z);


% ******************************************************
% loop over all shots
% ******************************************************

for ishot = 1:get(XDAS.obj.sources,'nsource')
    
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
    
    % make a copy of this shot record so we can modify it and not mess up the original data
    thisShotRecord = XDAS.obj.shotRecords(ishot);
    
    % ************************************************************************************************
    % get traces from disk if they have been saved already on disk
    % ************************************************************************************************


    fail = thisShotRecord.restoreFromDisk();
   
    if fail
        % the file with the shot record cannot be opened - ask user to select the correct directory
        menuSetDataDirectory_Callback(0, 0);
        fail = thisShotRecord.restoreFromDisk();
    end
    
    nchannels = get(thisShotRecord,'nchannels');
    
    % inform user of current status
    title(XDAS.h.axes_model,['Migrating shot ' num2str(ishot) ' into CDP' ],'fontsize',16,'fontweight','bold')
    drawnow

    
    % *******************************************************
    % start migration for this shot
    % *******************************************************
    
    if ifConstant
        % use the constant velocity model
        shotTable = mkTTtable(  cdpx,z,thisShotRecord.sourceX,thisShotRecord.sourceZ,velocity);
    else
        % use the v(z) model
        shotTable = mkTTtableVz(cdpx,z,thisShotRecord.sourceX,thisShotRecord.sourceZ,velocity,kz);
    end    
    
    
    % loop over each channel in the record
    for ichannel = 1:nchannels
        
        % create the receiver travel time table       
        if ifConstant
            % use the constant velocity model
            recTable = mkTTtable(  cdpx,z,thisShotRecord.wellX(ichannel),thisShotRecord.wellZ(ichannel),velocity);
        else
            % use the v(z) model
            recTable = mkTTtableVz(cdpx,z,thisShotRecord.wellX(ichannel),thisShotRecord.wellZ(ichannel),velocity,kz);
        end
        
        % create a two way travel time table from the shot and receiver table
        twoWayTTT = shotTable + recTable;
        
        % extract two traces to migrate
        refTraceOptions.whichTrace = ichannel;
        traceR = thisShotRecord.prepareTraceForMigration(refTraceOptions);
        
        otherTraceOptions.whichTrace = ichannel;
        traceO = thisShotRecord.prepareTraceForMigration(otherTraceOptions);

        % migrate the two traces
        XDAS.obj.migratedCDPPair.migrateTrace(ishot,traceR, traceO, twoWayTTT);

    end
    
    % ************************************************************************************************
    % purge data from record if desired to save memory space (it is already saved on disk)
    % ************************************************************************************************

        thisShotRecord.purgeTraces();
    
end
    
% ********************************************************************
% plot the final migration result
% ********************************************************************

XDAS.obj.migratedCDPPair.plot(waveType);

% inform user of current status
title(XDAS.h.axes_model,['Migration finished '],'fontsize',16,'fontweight','bold')
drawnow

