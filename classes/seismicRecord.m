classdef seismicRecord <  matlab.mixin.SetGetExactNames
    
% ***********************************************************************************************************
%  seismicRecord - this class handles the properties of a seismic record
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

    % seismicRecords - this class holds the seismic data and methods

    
    properties
        
        shotNumber          % the shot number of this seismic record
 
        directionCosines    % the direction cosines for each channel of the well (seismic record)
        dt                  % the sample internval in seconds
        dataDir             % the data directory to put the saved copies of the record
        
        fromDisk            % logical - true get data from copy on disk, false - it is held in memory
        firstBreaks         % the arrival times (in seconds) of the direct wave
        
        gaugeLength         % the gauge length used for the DAS data
              
        nchannels           % the number of channels (levels) in the seismic record
        nsamples            % the number of time samples in the seismic record

        opticalNoiseSeeds   % the saved 3 random number seeds to create the optical noise 
        CMNSeeds            % the saved 2 random number seeds to create the CMN
        
        rmsSignal           % the rms (or max) value of the signal in tracesOther
        rmsOpticalNoise     % the rms value of the optical noise   in tracesOther Noise
        rmsCMN              % the rms value of the CMN             in traceCMS
        
        scalarOpticalNoise
        scalarCMN

        sourceWavelet       % literal to describe the source: 'Ricker' or 'Klauder'
        sourceX             % the source X location in meters
        sourceZ             % the source Z (depth) location in meters
        sourcef0            % the source center frequency if Ricker
        sourcefmin          % the source low frequency value if Klauder
        sourcefmax          % the source high frequency value if Klauder
        source2ReceiverDistance  % the source to receiver direct arrival distance
        
        timeAxis            % the time axis of each trace (1:nsamples)*dt
        
        traceCMN            % the common mode noise trace
        tracesRef           % the Reference traces (acoustic)
        tracesRefDirect     % the Reference traces (acoustic) direct arrival only
        
        tracesOther         % the Other traces (either DAS or Vz geophone)
        tracesOtherDirect   % the Other traces with direct arrival only
        tracesOtherNoise    % the copy of the Other traces if noise is added to the Other traces
        
        velocityType        % constant or gradient
        v0                  % velocity v0 constant
        kz                  % velocity gradient kz
        
        waveType            % literal describing the option for the Other traces: 'VPZ, VPDAS, VSH, VSDAS'
        wellX               % the well x locations for each channel
        wellZ               % the well z locations for each channel
        wellMD              % the measured depth of each channel
        wellXup             % the x location of the half gauge length 'up'   location
        wellZup             % the z location of the half gauge length 'up'   location
        wellXdn             % the x location of the half gauge length 'down' location
        wellZdn             % the z location of the half gauge length 'down' location
        
        valid               % logical stating if the object is valid (true) or corrupted (false)

    end
    
    properties (Constant)
        interpFactor   = 10;
        depthTolerance = 10;
        
        nramp          = 10; % the number of samples to ramp up the taper function
        
    end
    
    
    methods
        
        function obj = seismicRecord(shotNumber,waveType,nsamples,nchannels,dt,sourceWavelet,f0,fmin,fmax,sourceX,sourceZ,...
                                     wellX,wellZ,wellMD,velocityType,gaugeLength,dataDir)
                                 
            % seismicRecords - Construct an instance of this class
            
            if nargin == 2
                
                % ******************************************************************
                % restore a shot record from disk
                % ******************************************************************
                
                obj.shotNumber = shotNumber;
                filename = waveType;      % get the file name from the second arg - waveType
                
                try
                    a = load(filename,'header','tracesRef',  'tracesRefDirect',...
                                               'tracesOther','tracesOtherDirect', 'tracesOtherNoise', ...
                                               'traceCMN');
                catch
                    % cannot read this file - error out
                    obj.valid = false;
                    return
                end
                
                % verify and copy all of the object values to the object
                fail = postToObject(a);
                
                if fail
                    obj.valid = false;
                else
                    obj.valid = true;
                end
                
                
            else
                
                % ******************************************************************
                % create a new object instance from data passed through the calling sequence
                % ******************************************************************
                
                if nargin == 17
                    % the data directory was specified in the call function - save it
                    obj.dataDir = dataDir;
                else
                    % the data directory wasn't specified - so use the default "data" dir
                    obj.dataDir    = 'data';
                    
                end
                
                
                 
                obj.valid          = true;
                
                obj.shotNumber     = shotNumber;                 
                obj.dt             = dt;                
                obj.fromDisk       = false;                
                obj.gaugeLength    = gaugeLength; 
                obj.nchannels      = nchannels;
                obj.nsamples       = nsamples;
                
                obj.opticalNoiseSeeds = rand(1,3);     % seeds to generate the optical noise so they can be recreated
                obj.CMNSeeds          = rand(1,2);     % seeds for the common mode noise so they can be recreated
                
                obj.sourceWavelet  = sourceWavelet;
                obj.sourceX        = sourceX;
                obj.sourceZ        = sourceZ;
                obj.sourcef0       = f0;
                obj.sourcefmin     = fmin;
                obj.sourcefmax     = fmax;
                % obj.source2ReceiverDistance       % see below
                
                obj.timeAxis       = (1:obj.nsamples)*obj.dt;
                
                obj.velocityType   = velocityType;
                obj.v0             = 4000;           % default velocity
                obj.kz             = 0.;             % default velocity gradient
                
                obj.waveType       = waveType;
                obj.wellX          = wellX;
                obj.wellZ          = wellZ;
                obj.wellMD         = wellMD;
                
                
                % allocate space for future computation
                
                obj.wellXup = [];
                obj.wellZup = [];
                obj.wellXdn = [];
                obj.wellZdn = [];
                
                obj.traceCMN                 = zeros(nsamples,1);
                
                obj.tracesRef                = zeros(nsamples,nchannels);
                obj.tracesRefDirect          = zeros(nsamples,nchannels);
                
                obj.tracesOther              = zeros(nsamples,nchannels);
                obj.tracesOtherDirect        = zeros(nsamples,nchannels);
                obj.tracesOtherNoise         = zeros(nsamples,nchannels);
                
                obj.firstBreaks              = zeros(1,obj.nchannels);
                obj.source2ReceiverDistance  = zeros(1,obj.nchannels);
                obj.directionCosines         = zeros(2,obj.nchannels);
            end
        end
        
        function [recordOut,fail] = getMergedData(obj,traceOptions) 

            % getMergedData - merge all of the desired data types together

            fail = false;
            if obj.fromDisk
                fail = restoreFromDisk(obj);
                if fail
                    % cannot read record
                    recordOut = 0;
                    return
                end
            end
            
            % options for the data types:
            
            % traceOptions.ifSingleTrace   = { true, false }
            % traceOptions.whichTrace      = value
            % traceOptions.traceType       = {'Ref','Other','None'}
            % traceOptions.ifdirect        = {true, false}
            
            % traceOptions.ifOpticalNoise  = { true, false};
            % traceOptions.opticalNoiseSNR = value
            % traceOptions.ifCMN           = { true, false}
            % traceOptions.CMNSNR          = value
            % traceOptions.ifPolarity      = { true, false};
            
            if traceOptions.ifSingleTrace
                channelRange = traceOptions.whichTrace;
            else
                channelRange = 1:obj.nchannels;
            end
            
            % select the trace to prepare
            switch traceOptions.traceType
                case 'Ref'
                    % output the reference trace type
                    recordOut = obj.tracesRef(:,channelRange);
                    % add the direct wave
                    if traceOptions.ifdirect
                        recordOut = recordOut + obj.tracesRefDirect(:,channelRange);
                    end
                    % do not add noise to Ref traces
                    return
                case 'Other'
                    % output the Other trace type
                    recordOut = obj.tracesOther(:,channelRange);
                    % add the direct wave
                    if traceOptions.ifdirect
                        recordOut = recordOut + obj.tracesOtherDirect(:,channelRange);
                    end
                    if traceOptions.ifPolarity
                        recordOut = recordOut * (-1.0);
                    end
                    
                case 'None'
                    % No reflection data to be included
                    recordOut = zeros(size(obj.tracesOther(:,channelRange)));
                    % add the direct wave - trouble here - which one to add? selecting Other
                    if traceOptions.ifdirect
                        recordOut = recordOut + obj.tracesOtherDirect(:,channelRange);
                        if traceOptions.ifPolarity
                            recordOut = recordOut * (-1.0);
                        end
                    end
            end
            
            % reset noise scalars
            obj.scalarOpticalNoise = 0.;
            obj.scalarCMN          = 0.;
            
            % add noise
            if traceOptions.ifOpticalNoise
                % compute the scalar to create the desired optical noise level
                obj.scalarOpticalNoise = computeSNRscalar(obj,obj.rmsOpticalNoise,traceOptions.opticalNoiseSNR);
                % add the optical noise
                recordOut = recordOut + obj.tracesOtherNoise(:,channelRange) * obj.scalarOpticalNoise;
            end
            if traceOptions.ifCMN
                % compute the scalar for the desired CMN level
                obj.scalarCMN = computeSNRscalar(obj,obj.rmsCMN,traceOptions.CMNSNR);
                % add CMN
                noiseTrace =  obj.traceCMN * obj.scalarCMN;
                iput = 0;
                for ichannel = channelRange
                    iput = iput + 1;
                    recordOut(:,iput) = recordOut(:,iput) + noiseTrace;
                end
            end          
                        
        end
        
        function [traceOut,fail] = prepareTraceForMigration(obj,traceOptions)
            
            % prepareTraceForMigration - prepare the selected trace for migration

            % create the merged trace of all trace options
            [trace,fail] = getMergedData(obj,traceOptions);
            
            if fail
                % trouble reading in data from disk
                return
            end
            

            % take derivative of input trace(s) so we don't have to do it after migration
            trace(1:end-1) = diff(trace);
            trace(end)     = 0;
                       
            % interpolate the input trace - so that we don't have to interpolate the trace on the fly
            newspacing = getScatterSpacing;
            traceFine   = interp1(1:obj.nsamples,trace,   1:1/newspacing:obj.nsamples);
            dtNew = obj.dt/newspacing;

            % normal trick if the time sample is outside of the range of the actual trace
            %  peg the picked sample to the beginning or end of the trace.
            %  if that sample is chosen, then trace sample value is zero so causes no harm
            traceFine(  1)   = 0;
            % taper the end of the trace
            traceFine((end-9:end)) = traceFine((end-9:end)).*(10:-1:1)/10;
            
            % create structure holding the prepared trace
            traceOut.trace = traceFine;
            traceOut.dt    = dtNew;
            
        end
        
        function [fail] = createWellDirectionCosines(obj)
            
            % createWellDirectionCosines - create the unit vectors (direction cosines for the well trajectory)
            %  with increasing depth

            fail = false;
            if obj.fromDisk
                fail = restoreFromDisk(obj);
                if fail
                    % cannot read data file
                    return
                end
            end
            
            % compute the direction cosines
            for ichannel = 2:obj.nchannels-1
                dx = (obj.wellX(ichannel+1) - obj.wellX(ichannel-1));
                dz = (obj.wellZ(ichannel+1) - obj.wellZ(ichannel-1));
                
                obj.directionCosines(:,ichannel) = [dx,dz]/sqrt(dx^2 + dz^2);
            end
            
            % fix the endpoints which can't be computed directly by a 3 point operator
            obj.directionCosines(:,  1) = obj.directionCosines(:,2);
            obj.directionCosines(:,end) = obj.directionCosines(:,end-1);
        end
        
        function  [fail] = interpPointsGLdepths(obj)
            
            % interpPointsGLdepths - create the "well" locations half gauge length up and down
            %                         so that the DAS data can be created from the geophones at those locations
            
            fail = false;
            if obj.fromDisk
                fail = restoreFromDisk(obj);
                if fail
                    % cannot read file from disk
                    return
                end
            end
            
            % interpolate the plus and minus half GL points for each channel
            
            % compute the coordinates (x&z) for the MD a half gauge length shallower
            newpoints = obj.wellMD - obj.gaugeLength/2;
            
            % fix the ends to not try to extrapolate
            mask = newpoints < obj.wellMD(1);
            newpoints(mask)  = obj.wellMD(1);
            mask = newpoints > obj.wellMD(end);
            newpoints(mask)  = obj.wellMD(end);
            
            obj.wellXup = interp1(obj.wellMD,obj.wellX,newpoints);
            obj.wellZup = interp1(obj.wellMD,obj.wellZ,newpoints);
            
            % compute the coordinates (x&z) for the MD a half gauge length deeper
            newpoints = obj.wellMD + obj.gaugeLength/2;
            
            % fix the ends to not try to extrapolate
            mask = newpoints < obj.wellMD(1);
            newpoints(mask)  = obj.wellMD(1);
            mask = newpoints > obj.wellMD(end);
            newpoints(mask)  = obj.wellMD(end);
            obj.wellXdn = interp1(obj.wellMD,obj.wellX,newpoints);
            obj.wellZdn = interp1(obj.wellMD,obj.wellZ,newpoints);
        end
        
        function [fail] = createShotsConstantVel(obj,thisOnlySegment)
            
            % createShotsConstantVel - create shot records using constant velocity for all or a selected reflector

            global CM
            global createShotsInfo
            global XDAS
            
            fail = false;
            
            if nargin == 1
                % simulate using all of the reflector segments
                if XDAS.obj.reflectors.nsegments < 1
                    fail = true;
                    return
                end
                listOfSegmentsToUse = 1:XDAS.obj.reflectors.nsegments;
            else
                % only simulate using one reflector segment
                if XDAS.obj.reflectors.nsegments < thisOnlySegment
                    fail = true;
                    return
                end
                listOfSegmentsToUse = thisOnlySegment;
            end
            
            if obj.fromDisk
                fail = restoreFromDisk(obj);
                if fail
                    % cannot read data from disk
                    return
                end
            end
            
            switch obj.sourceWavelet
                case 'Klauder'
                    % save the Klauder wavelet for reuse for each trace
                     savedKlauderWavelet = mkKlauderWavelet(obj.sourcefmin,obj.sourcefmax,obj.dt);
            end


    
            % ************************************************************************
            % Create synthetic traces from list of scatterers for the current shot
            % ************************************************************************

            obj.source2ReceiverDistance = sqrt( (obj.sourceX - obj.wellX).^2 + ...
                                                (obj.sourceZ - obj.wellZ).^2);
                        
            % use the constant velocity model
            obj.firstBreaks = obj.source2ReceiverDistance / createShotsInfo.velocity;
            
            % save the forward modeling parameters for this shot
            obj.v0 = createShotsInfo.velocity;   
            obj.kz = 0;
            
            % create a trace for each channel
            for ichannel = 1:obj.nchannels
                
                
                distShotToReceiver = obj.source2ReceiverDistance(ichannel);
                
                % need to create two events: 1) the reference event, and 2) the desired event
                %  If the desired event in a DAS record, then we have to compute two geophone events
                %      - one a half gauge shallower and another one a half gauge deeper
                
                % loop over all reflector segments
                for ireflector = listOfSegmentsToUse
                    
                    % create the times for each scatterer for this channel location
                    if ~isempty(XDAS.obj.reflectors.segments(ireflector).interpx) 
                        % Source to reflector distances
                        dxSource   = (obj.sourceX         - XDAS.obj.reflectors.segments(ireflector).interpx);
                        dzSource   = (obj.sourceZ         - XDAS.obj.reflectors.segments(ireflector).interpz);
                        distShot   = sqrt( dxSource.^2 + dzSource.^2);
                        
                        % Reference receiver to reflector distances
                        dxRec      = (obj.wellX(ichannel) - XDAS.obj.reflectors.segments(ireflector).interpx);
                        dzRec      = (obj.wellZ(ichannel) - XDAS.obj.reflectors.segments(ireflector).interpz);
                        distRec    = sqrt( dxRec   .^2 + dzRec   .^2);
                        distShot2Refl2Rec = distShot + distRec;
                                               
                        % use this reflector if it is below the receiver (channel) depth
                        %  the trick is that the min path length is longer than the direct path from source to receiver
                        if abs(min(distShot2Refl2Rec) - distShotToReceiver) > createShotsInfo.depthTolerance
                                                      
                            % compute the travel time for each point on the reflector
                            eventTimes = (distShot2Refl2Rec) / createShotsInfo.velocity;
                            % compute the direction cosines for each point on the fiber to the reflection point
                            reflectionDirectionCosine = ([dxRec', dzRec' ]./ distRec')';
                            
                            
                            % ******************************************
                            % create the reference event
                            % ******************************************
                            
                            % create spreading
                            amps      = ones(size(eventTimes)) ./ distShot2Refl2Rec;
                            % create the traces for this set of times
                            switch obj.sourceWavelet
                                case 'Ricker'
                                    newTraceRef   = mkTraceRicker(eventTimes,obj.nsamples,obj.dt,obj.sourcef0,amps)';
                                otherwise
                                    newTraceRef   = mkTraceKlauder(eventTimes,obj.nsamples,obj.dt,amps,savedKlauderWavelet)';
                            end
                            % save this reference trace in the accumulating shot record
                            obj.tracesRef(:,ichannel)= obj.tracesRef(:,ichannel) + newTraceRef * XDAS.obj.reflectors.segments(ireflector).reflectionCoeficientScalar;
                            
                            % ******************************************
                            % create the Other event
                            % ******************************************
                            
                            % compute the dot product of the well trajectory direction cosines at this channel
                            %  with the direction cosines for the incoming reflection from each point along the reflector
                            cosineAngle = reflectionDirectionCosine'*obj.directionCosines(:,ichannel);
                            
                            if ~CM.fiber.ifGauge 
                                
                                % ******************************************
                                % create a gephone event
                                % ******************************************
                                
                                % handle the non-DAS case - its simple - don't use a gauge!
                                switch createShotsInfo.waveType
                                    case {'VPZ', 'VPDAS'}
                                        % vertical component "P" geophone use cos theta angle of incidence
                                        amps = cosineAngle;
                                    case {'VSH', 'VSDAS'}
                                        % horizontal "shear" geophone use sin theta of the angle of incidence
                                        amps = sin(acos(cosineAngle));
                                end
                                % apply spreading
                                amps = amps./ distShot2Refl2Rec;
                                % create contribution from this reflector
                                if createShotsInfo.ifRicker
                                    newTraceOther = mkTraceRicker(eventTimes,obj.nsamples,obj.dt,obj.sourcef0,amps)';
                                else
                                    newTraceOther = mkTraceKlauder(eventTimes,obj.nsamples,obj.dt,amps,savedKlauderWavelet)';
                                end
                                % save this reference trace in the accumulating shot record
                                obj.tracesOther(:,ichannel)= obj.tracesOther(:,ichannel) + newTraceOther * XDAS.obj.reflectors.segments(ireflector).reflectionCoeficientScalar;
                                
                            else
                                
                                % ******************************************
                                % create a DAS event - requires a gauge distance! more work
                                % ******************************************
                                switch createShotsInfo.waveType
                                    case 'VPDAS'
                                        % cos squared theta
                                        amps = cosineAngle.^2;
                                    case 'VSDAS'
                                        % sin 2*theta
                                        amps = sin(2.*acos(cosineAngle));
                                end
                                % ***************************************************************
                                % need to create an event half a gauge above and below current MD
                                % ***************************************************************
                                
                                % Reference receiver half gauge up to reflector distances
                                dxRecUp      = (obj.wellXup(ichannel) - XDAS.obj.reflectors.segments(ireflector).interpx);
                                dzRecUp      = (obj.wellZup(ichannel) - XDAS.obj.reflectors.segments(ireflector).interpz);
                                distRecUp    = sqrt( dxRecUp   .^2 + dzRecUp   .^2);
                                distShot2Refl2RecUp = distShot + distRecUp;
                                
                                % Reference receiver half gauge down to reflector distances
                                dxRecDn      = (obj.wellXdn(ichannel) - XDAS.obj.reflectors.segments(ireflector).interpx);
                                dzRecDn      = (obj.wellZdn(ichannel) - XDAS.obj.reflectors.segments(ireflector).interpz);
                                distRecDn    = sqrt( dxRecDn   .^2 + dzRecDn   .^2);
                                distShot2Refl2RecDn = distShot + distRecDn;
                                
                                % add in spreading for the center reference point
                                amps = amps ./ distShot2Refl2Rec;
                                
                                % ********************************************************************************
                                % compute the travel time for each point on the reflector for the half gauge down
                                % ********************************************************************************
                                eventTimes = (distShot2Refl2RecDn) / createShotsInfo.velocity;
                                % create the new contribution from the reflector to this DAS sensor
                                switch obj.sourceWavelet
                                     case 'Ricker'
                                    newTraceOtherDn = mkTraceRicker(eventTimes,obj.nsamples,obj.dt,obj.sourcef0,amps)';
                                otherwise
                                    newTraceOtherDn = mkTraceKlauder(eventTimes,obj.nsamples,obj.dt,amps,savedKlauderWavelet)';
                                end
                                % ********************************************************************************
                                % compute the travel time for each point on the reflector for the half gauge up
                                % ********************************************************************************
                                eventTimes = (distShot2Refl2RecUp) / createShotsInfo.velocity;
                                % create the new contribution from the reflector to this DAS sensor
                                switch obj.sourceWavelet
                                     case 'Ricker'
                                    newTraceOtherUp = mkTraceRicker(eventTimes,obj.nsamples,obj.dt,obj.sourcef0,amps)';
                                otherwise
                                    newTraceOtherUp = mkTraceKlauder(eventTimes,obj.nsamples,obj.dt,amps,savedKlauderWavelet)';
                                end
                                % save this contribution to the accumulating traces
                                obj.tracesOther(:,ichannel)= obj.tracesOther(:,ichannel) ...
                                                           + ( - newTraceOtherDn + newTraceOtherUp) / obj.gaugeLength  ...
                                                           * XDAS.obj.reflectors.segments(ireflector).reflectionCoeficientScalar;
                            end
                            
                        end
                    end
                end                
            end
            % mute off the first break because the DAS creation (difference of two geophone depths) creates a fake first arrival
            obj.muteFB('Ref');
            obj.muteFB('Other');
        end
        
        function [fail] = createShotsVofZ(obj,thisOnlySegment)
            
            % createShotsVofZ - - create shot records using velocity gradient for all or a selected reflector
            
            global CM
            global XDAS
            global createShotsInfo
            
            
            if nargin == 1
                % simulate using all of the reflector segments
                if XDAS.obj.reflectors.nsegments < 1
                    fail = true;
                    return
                end
                listOfSegmentsToUse = 1:XDAS.obj.reflectors.nsegments;
            else
                % only simulate using one reflector segment
                if XDAS.obj.reflectors.nsegments < thisOnlySegment
                    fail = true;
                    return
                end
                listOfSegmentsToUse = thisOnlySegment;
            end
            
            fail = false;
            if obj.fromDisk
                fail = restoreFromDisk(obj);
                if fail
                    % cannot read data from disk
                    return
                end
            end
            
            switch obj.sourceWavelet
                case 'Klauder'
                    % save the Klauder wavelet for reuse for each trace
                     savedKlauderWavelet = mkKlauderWavelet(obj.sourcefmin,obj.sourcefmax,obj.dt);
            end
            
            % ************************************************************************
            % Create synthetic traces from list of scatterers
            % ************************************************************************

            obj.source2ReceiverDistance = sqrt( (obj.sourceX - obj.wellX).^2 + ...
                                                (obj.sourceZ - obj.wellZ).^2);

            % compute the direct arrival time at each channel & save it
            rec.x  = obj.wellX;
            rec.z  = obj.wellZ;
            shot.x = obj.sourceX * ones(size(rec.x));
            shot.z = obj.sourceZ * ones(size(rec.x));

            obj.firstBreaks = timeInVgradient(shot,rec,createShotsInfo.v0,createShotsInfo.kz);

            % save the forward modeling parameters for this shot
            obj.v0 = createShotsInfo.velocity;   
            obj.kz = createShotsInfo.kz;
            
            % create a trace for each channel
            for ichannel = 1:obj.nchannels
                
                % need to create two events: 1) the reference event, and 2) the desired event
                %  If the desired event in a DAS record, then we have to compute two geophone events
                %      - one a half gauge shallower and another one a half gauge deeper
                
                % loop over all reflector segments
                for ireflector = listOfSegmentsToUse
        
                    % create the times for each scatterer for this channel location
                    if ~isempty(XDAS.obj.reflectors.segments(ireflector).interpx)
                        % Source to reflector distances
                        dxSource   = (obj.sourceX         - XDAS.obj.reflectors.segments(ireflector).interpx);
                        dzSource   = (obj.sourceZ         - XDAS.obj.reflectors.segments(ireflector).interpz);
                        distShot   = sqrt( dxSource.^2 + dzSource.^2);
                        
                        % Reference receiver to reflector distances
                        dxRec      = (obj.wellX(ichannel) - XDAS.obj.reflectors.segments(ireflector).interpx);
                        dzRec      = (obj.wellZ(ichannel) - XDAS.obj.reflectors.segments(ireflector).interpz);
                        distRec    = sqrt( dxRec   .^2 + dzRec   .^2);
                        distShot2Refl2Rec = distShot + distRec;

                        % source to reflector times
                        refl.x = XDAS.obj.reflectors.segments(ireflector).interpx;
                        refl.z = XDAS.obj.reflectors.segments(ireflector).interpz;
                        shot.x = obj.sourceX * ones(size(refl.x));
                        shot.z = obj.sourceZ * ones(size(refl.x));
                        
                        shot2refTimes = timeInVgradient(shot,refl,createShotsInfo.v0,createShotsInfo.kz);
                        
                        % channel to reflector times
                        well.x = obj.wellX(ichannel)*ones(size(refl.x));
                        well.z = obj.wellZ(ichannel)*ones(size(refl.z));
                        
                        well2refTimes = timeInVgradient(well,refl,createShotsInfo.v0,createShotsInfo.kz);
                        
                        % use this reflector if it is below the receiver (channel) depth
                        %  the trick is that the min path length is longer than the direct path from source to receiver
                        if abs(min(distShot2Refl2Rec) - obj.source2ReceiverDistance(ichannel)) > createShotsInfo.depthTolerance
                
                            % compute the travel time for each point on the reflector
                            eventTimes = shot2refTimes + well2refTimes;
                            % compute the direction cosines for each point on the fiber to the reflection point
                            reflectionDirectionCosine = ([dxRec', dzRec' ]./ distRec')';
                
                
                            % ******************************************
                            % create the reference event
                            % ******************************************
                            
                            % create spreading
                            amps      = ones(size(eventTimes)) ./ distShot2Refl2Rec;
                            % create the traces for this set of times
                            switch obj.sourceWavelet
                                case 'Ricker'
                                    newTraceRef   = mkTraceRicker(eventTimes,obj.nsamples,obj.dt,obj.sourcef0,amps)';
                                otherwise
                                    newTraceRef   = mkTraceKlauder(eventTimes,obj.nsamples,obj.dt,amps,savedKlauderWavelet)';
                            end
                            % save this reference trace in the accumulating shot record
                            obj.tracesRef(:,ichannel)= obj.tracesRef(:,ichannel) + newTraceRef * XDAS.obj.reflectors.segments(ireflector).reflectionCoeficientScalar;
                
                            % ******************************************
                            % create the Other event
                            % ******************************************
                            
                            % compute the dot product of the well trajectory direction cosines at this channel
                            %  with the direction cosines for the incoming reflection from each point along the reflector
                            cosineAngle = reflectionDirectionCosine'*obj.directionCosines(:,ichannel);
                
                            if ~CM.fiber.ifGauge || strcmp(createShotsInfo.waveType,'VPZ') || strcmp(createShotsInfo.waveType,'VSH')
                                
                                % ******************************************
                                % create a gephone event
                                % ******************************************
                                
                                % handle the non-DAS case - its simple - don't use a gauge!
                                switch createShotsInfo.waveType
                                    case {'VPZ', 'VPDAS'}
                                        % vertical component "P" geophone use cos theta angle of incidence
                                        amps = cosineAngle;
                                    case {'VSH', 'VSDAS'}
                                        % horizontal "shear" geophone use sin theta of the angle of incidence
                                        amps = sin(acos(cosineAngle));
                                end
                                % apply spreading
                                amps = amps./ distShot2Refl2Rec;
                                % create contribution from this reflector
                                if createShotsInfo.ifRicker
                                    newTraceOther = mkTraceRicker(eventTimes,obj.nsamples,obj.dt,obj.sourcef0,amps)';
                                else
                                    newTraceOther = mkTraceKlauder(eventTimes,obj.nsamples,obj.dt,amps,savedKlauderWavelet)';
                                end
                                % save this reference trace in the accumulating shot record
                                obj.tracesOther(:,ichannel)= obj.tracesOther(:,ichannel) + newTraceOther * XDAS.obj.reflectors.segments(ireflector).reflectionCoeficientScalar;
                    
                            else
                                
                                % ******************************************
                                % create a DAS event - requires a gauge distance! more work
                                % ******************************************
                                switch createShotsInfo.waveType
                                    case 'VPDAS'
                                        % cos squared theta
                                        amps = cosineAngle.^2;
                                    case 'VSDAS'
                                        % sin 2*theta
                                        amps = sin(2.*acos(cosineAngle));
                                end
                                % ***************************************************************
                                % need to create an event half a gauge above and below current MD
                                % ***************************************************************
                                
                                % Reference receiver half gauge up to reflector distances
                                dxRecUp      = (obj.wellXup(ichannel) - XDAS.obj.reflectors.segments(ireflector).interpx);
                                dzRecUp      = (obj.wellZup(ichannel) - XDAS.obj.reflectors.segments(ireflector).interpz);
                                distRecUp    = sqrt( dxRecUp   .^2 + dzRecUp   .^2);
                                distShot2Refl2RecUp = distShot + distRecUp;
                                
                                % Reference receiver half gauge down to reflector distances
                                dxRecDn      = (obj.wellXdn(ichannel) - XDAS.obj.reflectors.segments(ireflector).interpx);
                                dzRecDn      = (obj.wellZdn(ichannel) - XDAS.obj.reflectors.segments(ireflector).interpz);
                                distRecDn    = sqrt( dxRecDn   .^2 + dzRecDn   .^2);
                                distShot2Refl2RecDn = distShot + distRecDn;                    
                    
                                well.x = ones(size(refl.x))*obj.wellXdn(ichannel);
                                well.z = ones(size(refl.z))*obj.wellZdn(ichannel);
                                
                                wellDn2refTimes = timeInVgradient(well,refl,createShotsInfo.v0,createShotsInfo.kz);
                                
                                well.x = ones(size(refl.x))*obj.wellXup(ichannel);
                                well.z = ones(size(refl.z))*obj.wellZup(ichannel);
                                
                                wellUp2refTimes = timeInVgradient(well,refl,createShotsInfo.v0,createShotsInfo.kz);
                                
                                % add in spreading for the center reference point
                                amps = amps ./ distShot2Refl2Rec;
                                
                                % ********************************************************************************
                                % compute the travel time for each point on the reflector for the half gauge down
                                % ********************************************************************************
                                eventTimes = shot2refTimes + wellDn2refTimes;
                                % create the new contribution from the reflector to this DAS sensor
                                switch obj.sourceWavelet
                                     case 'Ricker'
                                    newTraceOtherDn = mkTraceRicker(eventTimes,obj.nsamples,obj.dt,obj.sourcef0,amps)';
                                otherwise
                                    newTraceOtherDn = mkTraceKlauder(eventTimes,obj.nsamples,obj.dt,amps,savedKlauderWavelet)';
                                end

                                % ********************************************************************************
                                % compute the travel time for each point on the reflector for the half gauge up
                                % ********************************************************************************
                                eventTimes = shot2refTimes + wellUp2refTimes;
                                % create the new contribution from the reflector to this DAS sensor
                                switch obj.sourceWavelet
                                     case 'Ricker'
                                    newTraceOtherUp = mkTraceRicker(eventTimes,obj.nsamples,obj.dt,obj.sourcef0,amps)';
                                otherwise
                                    newTraceOtherUp = mkTraceKlauder(eventTimes,obj.nsamples,obj.dt,amps,savedKlauderWavelet)';
                                end
                                % save this contribution to the accumulating traces
                                obj.tracesOther(:,ichannel)= obj.tracesOther(:,ichannel) ...
                                                           +( - newTraceOtherDn + newTraceOtherUp)  / obj.gaugeLength  ...
                                                           * XDAS.obj.reflectors.segments(ireflector).reflectionCoeficientScalar;
                                                        
                            end
                            
                        end
                    end
                end
                
            end
            % mute off the first break because the DAS creation (difference of two geophone depths) creates a fake first arrival
            obj.muteFB('Ref');
            obj.muteFB('Other');
        end
        
        function [fail] = createFirstBreaks(obj)
            
            % createFirstBreaks - create record with first breaks from precomputed times
            
 
            global CM
            global createShotsInfo


            fail = false;
            if obj.fromDisk
                fail = restoreFromDisk(obj);
                if fail
                    % cannot read data from disk
                    return
                end
            end
            
            switch obj.sourceWavelet
                case 'Klauder'
                    % save the Klauder wavelet for reuse for each trace
                     savedKlauderWavelet = mkKlauderWavelet(obj.sourcefmin,obj.sourcefmax,obj.dt);
            end
            
            % allocate space for the first break traces
            obj.tracesRefDirect   = zeros(size(obj.tracesRef));
            obj.tracesOtherDirect = zeros(size(obj.tracesOther));
            
            % ************************************************************************
            % Create synthetic traces first break only from the precomputed arrival times
            % ************************************************************************

            % compute the direct arrival time at each channel & save it
            
            shot.x = obj.sourceX;
            shot.z = obj.sourceZ;
            
            % set the velocity info for this recrod
            switch obj.velocityType
                case 'Constant'
                    
                    obj.v0 = createShotsInfo.velocity;
                    obj.kz = 0;
                    
                case 'Gradient'
                    
                    % save the forward modeling parameters for this shot
                    obj.v0 = createShotsInfo.v0;
                    obj.kz = createShotsInfo.kz;
            end

            % create a trace for each channel
            for ichannel = 1:obj.nchannels
                
                % extract the travel time for the first break arrival time of this channel
                eventTimes = obj.firstBreaks(ichannel);
                
                % ******************************************
                % create the reference event
                % ******************************************
                
                % create spreading
                amps      = 100*ones(size(eventTimes)) ./ max([1. obj.source2ReceiverDistance(ichannel)]);
                
                % create the traces for this set of times
                switch obj.sourceWavelet
                    case 'Ricker'
                        newTraceRef   = mkTraceRicker(eventTimes,obj.nsamples,obj.dt,obj.sourcef0,amps)';
                    otherwise
                        newTraceRef   = mkTraceKlauder(eventTimes,obj.nsamples,obj.dt,amps,savedKlauderWavelet)';
                end
                % save this reference trace in the accumulating shot record
                obj.tracesRefDirect(:,ichannel) = newTraceRef;
                %deriveRef = diff(newTraceRef);
                %fbTraces.tracesRef(1:obj.nsamples-1,ichannel) = deriveRef;
                
                % ******************************************
                % create the Other event
                % ******************************************
                
                % compute the dot product of the well trajectory direction cosines at this channel
                %  with the direction cosines for the incoming reflection from each point along the reflector
                % Reference receiver to shot distances
                dxRec      = (obj.wellX(ichannel) - obj.sourceX);
                dzRec      = (obj.wellZ(ichannel) - obj.sourceZ);
                distRec    = sqrt( dxRec   .^2 + dzRec   .^2);
                reflectionDirectionCosine = ([dxRec', dzRec' ]./ distRec')';
                cosineAngle = reflectionDirectionCosine'*obj.directionCosines(:,ichannel);
                
                if ~CM.fiber.ifGauge || strcmp(createShotsInfo.waveType,'VPZ') || strcmp(createShotsInfo.waveType,'VSH')
                    
                    % ******************************************
                    % create a gephone event
                    % ******************************************
                    
                    % handle the non-DAS case - its simple - don't use a gauge!
                    switch  obj.waveType
                        case {'VPZ', 'VPDAS'}
                            % vertical component "P" geophone use cos theta angle of incidence
                            amps = cosineAngle;
                        case {'VSH', 'VSDAS'}
                            % horizontal "shear" geophone use sin theta of the angle of incidence
                            amps = sin(acos(cosineAngle));
                    end
                    
                    % apply spreading
                    amps = 100.*amps./max([1. obj.source2ReceiverDistance(ichannel)]);
                    % create contribution from this reflector
                    switch obj.sourceWavelet
                        case 'Ricker'
                            obj.tracesOtherDirect(:,ichannel) = mkTraceRicker( eventTimes,obj.nsamples,obj.dt,obj.sourcef0,amps)';
                        otherwise
                            obj.tracesOtherDirect(:,ichannel) = mkTraceKlauder(eventTimes,obj.nsamples,obj.dt,amps,savedKlauderWavelet)';
                    end
                    
                else
                    
                    % ******************************************
                    % create a DAS event - requires a gauge distance! more work
                    % ******************************************
                    switch obj.waveType
                        case 'VPDAS'
                            % cos squared theta
                            amps = cosineAngle.^2;
                        case 'VSDAS'
                            % sin 2*theta
                            amps = sin(2.*acos(cosineAngle));
                    end
                    % ***************************************************************
                    % need to create an event half a gauge above and below current MD
                    % ***************************************************************
                    
                    
                    switch obj.velocityType
                        case 'Constant'
                            
                            % DOWN Reference receiver half gauge down to source distance
                            dxRecDn      = (obj.wellXdn(ichannel) - obj.sourceX);
                            dzRecDn      = (obj.wellZdn(ichannel) - obj.sourceZ);
                            wellDn2ShotTime    = sqrt( dxRecDn   .^2 + dzRecDn   .^2) / obj.v0;
                            
                            % UP Reference receiver half gauge up to source distance
                            dxRecUp      = (obj.wellXup(ichannel) - obj.sourceX);
                            dzRecUp      = (obj.wellZup(ichannel) - obj.sourceZ);
                            wellUp2ShotTime    = sqrt( dxRecUp   .^2 + dzRecUp   .^2) / obj.v0;
                            
                        case 'Gradient'
                            
                            % DOWN compute travel times from the shot to half gauge below channel using gradient model
                            well.x = obj.wellXdn(ichannel);
                            well.z = obj.wellZdn(ichannel);
                            
                            wellDn2ShotTime = timeInVgradient(shot,well,obj.v0,obj.kz);
                            
                            % UP compute travel times from the shot to half gauge above channel using gradient model
                            well.x = obj.wellXup(ichannel);
                            well.z = obj.wellZup(ichannel);
                            
                            wellUp2ShotTime = timeInVgradient(shot,well,obj.v0,obj.kz);
                    end
                    
                    % add in spreading for the center reference point
                    amps = 100 * amps ./max([1. obj.source2ReceiverDistance(ichannel)]);
                    
                    % ********************************************************************************
                    % compute the travel time for each point on the reflector for the half gauge down
                    % ********************************************************************************
                    eventTimes = wellDn2ShotTime;
                    % create the new contribution from the reflector to this DAS sensor
                    switch obj.sourceWavelet
                        case 'Ricker'
                            newTraceOtherDn = mkTraceRicker(eventTimes,obj.nsamples,obj.dt,obj.sourcef0,amps)';
                        otherwise
                            newTraceOtherDn = mkTraceKlauder(eventTimes,obj.nsamples,obj.dt,amps,savedKlauderWavelet)';
                    end
                    
                    % ********************************************************************************
                    % compute the travel time for each point on the reflector for the half gauge up
                    % ********************************************************************************
                    eventTimes = wellUp2ShotTime;
                    % create the new contribution from the reflector to this DAS sensor
                    switch obj.sourceWavelet
                        case 'Ricker'
                            newTraceOtherUp = mkTraceRicker(eventTimes,obj.nsamples,obj.dt,obj.sourcef0,amps)';
                        otherwise
                            newTraceOtherUp = mkTraceKlauder(eventTimes,obj.nsamples,obj.dt,amps,savedKlauderWavelet)';
                    end
                    % save this contribution to the accumulating traces
                    obj.tracesOtherDirect(:,ichannel)=  - newTraceOtherDn + newTraceOtherUp;
                    
                end
                
            end
        end
    
        
        function [fail] = muteFB(obj,whichRecord)
            
            % muteFB - mute off the first breaks from record
            
            %fbTime     = obj.firstBreaks;     % the first break arrival time in seconds
            %dtIn       = obj.dt;              % dt the sampling interval of the input trace
            %nsamplesIn = obj.nsamples ;       % the number of samples of the input trace
            %nramp       = 10;                 % ramp to apply to top mute
            
            fail = false;
            if obj.fromDisk
                fail = restoreFromDisk(obj);
                if fail
                    % cannot read data from disk
                    return
                end
            end
            
            % width (in samples) of one cycle of the source
            switch obj.sourceWavelet
                case 'Ricker'
                    % Ricker source
                    nperiod  = round(1./obj.sourcef0 / obj.dt);
                otherwise
                    % Klauder source
                    nperiod = round(1./mean([obj.sourcefmin obj.sourcefmax]) / obj.dt);
            end
            
            for ichannel = 1:obj.nchannels
                fbSamples = min(obj.nsamples,max(1,round(obj.firstBreaks(ichannel)/obj.dt)));     % the sample number of the first break in the input trace
                
                isampleFullMute = min(obj.nsamples,max(1,fbSamples + nperiod));           % full top mute sample
                isampleEndMute  = min(obj.nsamples,max(1,isampleFullMute + obj.nramp-1)); % end top mute ramp sample
                
                taper = (1:obj.nramp)/obj.nramp;
                
                % create the mute function
                mute = ones(obj.nsamples,1);
                % full mute at the beginning
                mute(1:isampleFullMute) = 0;
                % tapered mute over ramp
                mute(isampleFullMute:isampleEndMute) = taper;
                
                switch whichRecord
                    case 'Ref'
                        % apply the mute function
                        obj.tracesRef(  :,ichannel) = obj.tracesRef(  :,ichannel) .* mute;
                    otherwise
                        % apply the mute function
                        obj.tracesOther(:,ichannel) = obj.tracesOther(:,ichannel) .* mute;
                end
            end
        end
        
        
        function [recordWithNoise,fail] = addCMN(obj,inputRecord)
            
            % addCMN - This method adds the CMN stored in object to an input record and returns a new record
            
            fail = false;
            if obj.fromDisk
                fail = restoreFromDisk(obj);
                if fail
                    % cannot read file from disk
                    return
                end
            end

            recordWithNoise = zeros(size(inputRecord));
            
            for ichannel = 1:obj.nchannels
                recordWithNoise(:,ichannel)   = inputRecord(:,ichannel)   + obj.traceCMN(1:obj.nsamples);
            end

        end
        
        function [fail] = rmCMN(obj,whichRecord)
            
            % rmCMN - this method removes common mode noise from a record using signal processing

            fail = false;
            if obj.fromDisk
                fail = restoreFromDisk(obj);
                if fail
                    % cannot read file from disk
                    return
                end
            end
            
            switch whichRecord
                case 'Ref'
                    % extract the CMN for this record
                    CMNthisRecord = mean(obj.tracesRef,2);
                    
                    % remove the CMN noise from this record
                    for ichannel = 1:obj.nchannels
                        obj.tracesRef(:,ichannel) = obj.tracesRef(:,ichannel) - CMNthisRecord;
                    end                    
                case 'Other'
                    % extract the CMN for this record
                    CMNthisRecord = mean(obj.tracesOther,2);
                    
                    % remove the CMN noise from this record
                    for ichannel = 1:obj.nchannels
                        obj.tracesOther(:,ichannel) = obj.tracesOther(:,ichannel) - CMNthisRecord;
                    end
                otherwise
                    disp('Error: rmCMN can''t get here')
            end           
        end
        
        function rmsValue = rms(obj,whichRecord)
            
            % rms - this method estimates the rms value of an entire record
            
            switch whichRecord
                case 'Other'
                    rmsValue = rms(obj.tracesOther(:));
                case 'Ref'
                    rmsValue = rms(obj.tracesRef(:));
                otherwise
                    rmsValue = 0;
            end
        end
            
        function maxValue = max(obj,whichRecord)
            
            % max - this method estimates the maximum value of an entire record
            
            switch whichRecord
                case 'Other'
                    maxValue = max(abs(obj.tracesOther(:)));
                case 'Ref'
                    maxValue = max(abs(obj.tracesRef(:)));
                otherwise
                    maxValue = 0;
            end            
        end
        
        function [scalar] = computeSNRscalar(obj,rmsNoise,desiredSNR)
            
            % ****************************************************
            % computeSNRscalar - derive the scalar to obtain the desired SNR
            % ****************************************************
            
            % desiredSNR = 20.*log10(rmsSyn/(rmsNoise*scalar));
            % desiredSNR/20 = log10(rmsSyn/(rmsNoise*scalar));
            % 10^(desiredSNR/20) = rmsSyn/(rmsNoise*scalar);
            % scalar = rmsSyn/(rmsNoise*10^(desiredSNR/20));
            
            scalar = obj.rmsSignal /(rmsNoise * 10^(desiredSNR/20));

        end
        
        function [fail] = plot(obj,figTitleRef,figTitleOther,polarity,firstBreaks,ifNoise)
            
            % plot- create a new figure and plot out both records
            
            hfig = figure('Name','Seismic Record','Tag','seismicrecord');
            
            [fail] = plotRepeat(obj,hfig,figTitleRef,figTitleOther,polarity,firstBreaks,ifNoise);
 
        end
        
        function [fail] = plotRepeat(obj,hfig,figTitleRef,figTitleOther,traceOptions)
            
            % plotRepeat - use an existing figure handle and plot out both records
            
            % traceOptions.ifSingleTrace   = { true, false }
            % traceOptions.traceType       = {'Ref','Other','None'}
            % traceOptions.ifdirect        = {true, false}
            
            % traceOptions.ifOpticalNoise  = { true, false};
            % traceOptions.opticalNoiseSNR = value
            % traceOptions.ifCMN           = { true, false}
            % traceOptions.CMNSNR          = value
            
            % traceOptions.ifPolarity      = { true, false}
            
            
            figure(hfig)
            subplot(1,2,1);
            
            % get the reference data
            refOptions = traceOptions;
            refOptions.traceType = 'Ref';
            
            [recordOut, fail] = getMergedData(obj,refOptions);
            
            if fail
                % cannot read data file
                return
            end
            
            imagesc(obj.wellMD,obj.timeAxis,recordOut)
            colormap(bone)
            hold on
            plot(obj.wellMD,obj.firstBreaks,'r')
            xlabel('Measured Depth (m)','fontweight','bold','fontsize',12)
            ylabel('Time (s)','fontweight','bold','fontsize',12)
            title([ figTitleRef ' Shot Record ' num2str(obj.shotNumber)],'fontweight','bold','fontsize',12)
            set(gca,'fontweight','bold','fontsize',12)
            ca = caxis;
            maxval = max(ca(1), ca(2));
            ca = [-1 1]*maxval/8.;
            caxis(ca);
            hold off
            
            
            % get the Other data            
            [recordOut, fail] = getMergedData(obj,traceOptions);
            
            if fail
                % cannot read data file
                return
            end
            
            subplot(1,2,2)
            imagesc(obj.wellMD,obj.timeAxis,recordOut)
            colormap(bone)
            hold on
            plot(obj.wellMD,obj.firstBreaks,'r')
            xlabel('Measured Depth (m)','fontweight','bold','fontsize',12)
            ylabel('Time (s)','fontweight','bold','fontsize',12)
            title([ figTitleOther ' Shot Record ' num2str(obj.shotNumber)],'fontweight','bold','fontsize',12)
            set(gca,'fontweight','bold','fontsize',12)
            ca = caxis;
            maxval = max(ca(1), ca(2));
            ca = [-1 1]*maxval/8.;
            caxis(ca);
            hold off
            
            drawnow
        end
        
        function [fail] = plotFKRepeat(obj,figTitleRef,figTitleOther,traceOptions)
            
            % plotRepeat - use an existing figure handle and plot out fk of both records
            
            % traceOptions.ifSingleTrace   = { true, false }
            % traceOptions.traceType       = {'Ref','Other','None'}
            % traceOptions.ifdirect        = {true, false}
            
            % traceOptions.ifOpticalNoise  = { true, false};
            % traceOptions.opticalNoiseSNR = value
            % traceOptions.ifCMN           = { true, false}
            % traceOptions.CMNSNR          = value
            
            % traceOptions.ifPolarity      = { true, false}
            
            % sourceWavelet       % literal to describe the source: 'Ricker' or 'Klauder'
            % sourcef0            % the source center frequency if Ricker
            % sourcefmax          % the source high frequency value if Klauder
            
            switch obj.sourceWavelet
                case 'Ricker'
                    fmax = 2.25 * obj.sourcef0;
                case 'Klauder'
                    fmax = 1.25 * obj.sourcefmax;
                otherwise
                    fmax = 10000;
            end
                        
            % get the reference data
            refOptions = traceOptions;
            refOptions.traceType = 'Ref';
            
            [recordOut, fail] = getMergedData(obj,refOptions);
            
            if fail
                % cannot read data file
                return
            end
            
            ddz = abs(obj.wellMD(2) - obj.wellMD(1));
            plotFK(recordOut,obj.dt,ddz,false,fmax,figTitleRef)
            
  
            % get the Other data            
            [recordOut, fail] = getMergedData(obj,traceOptions);
            
            if fail
                % cannot read data file
                return
            end
            
            plotFK(recordOut,obj.dt,ddz,false,fmax,figTitleOther)
                      
            drawnow
        end
        
        function [fail] = plotRepeatTrace(obj,hfig,figTitleRef,figTitleOther,traceOptions)
            
            % plotRepeatTrace - plot selected traces on an existing figure
            
            % get the reference data
            refOptions = traceOptions;
            refOptions.traceType = 'Ref';
            
            [traceoutRef,  fail1] = getMergedData(obj,refOptions);
            [traceoutOther,fail2] = getMergedData(obj,traceOptions);
            
            fail = fail1 || fail2;
            if fail
                % cannot read in files
                return
            end
                     
            figure(hfig)
            plot(obj.timeAxis,traceoutRef./max(abs(traceoutRef)),'r')
            hold on
            plot(obj.timeAxis,traceoutOther./max(abs(traceoutOther)),'k')
            xlabel('Time (s)','fontweight','bold','fontsize',12)
            title(['Comparison Reference (red) and Other (black) channel ' num2str(traceOptions.whichTrace)],'fontweight','bold','fontsize',12)
            set(gca,'fontweight','bold','fontsize',12)
            hold off
            
        end
        
        function [fail] = saveToDisk(obj,filename)
            
            % saveToDisk - this method saves the structure to a matlab formatted file
            
            header.shotNumber              = obj.shotNumber;
            
            header.directionCosines        = obj.directionCosines;      % the direction cosines for each channel of the well (seismic record)
            header.dt                      = obj.dt;                    % the sample internval in seconds
            header.dataDir                 = obj.dataDir;               % the data directory to put the saved copies of the record

            header.fromDisk                = obj.fromDisk;              % logical - true get data from copy on disk, false - it is held in memory
            header.firstBreaks             = obj.firstBreaks;           % the arrival times (in seconds) of the direct wave

            header.gaugeLength             = obj.gaugeLength;           % the gauge length used for the DAS data
            
            header.nchannels               = obj.nchannels;             % the number of channels (levels) in the seismic record
            header.nsamples                = obj.nsamples;              % the number of time samples in the seismic record

            header.opticalNoiseSeeds       = obj.opticalNoiseSeeds;
            header.CMNSeeds                = obj.CMNSeeds;
            
            header.sourceWavelet           = obj.sourceWavelet;
            header.sourceX                 = obj.sourceX;
            header.sourceZ                 = obj.sourceZ;
            header.sourcef0                = obj.sourcef0;
            header.sourcefmin              = obj.sourcefmin;
            header.sourcefmax              = obj.sourcefmax;
            header.source2ReceiverDistance = obj.source2ReceiverDistance;
            
            header.timeAxis                = obj.timeAxis;
            
            header.valid                   = obj.valid;
            header.velocityType            = obj.velocityType;
            
            header.waveType                = obj.waveType;          
            header.wellX                   = obj.wellX;
            header.wellZ                   = obj.wellZ;
            header.wellMD                  = obj.wellMD;
            header.wellXup                 = obj.wellXup;      % the x location of the half gauge length 'up'   location
            header.wellZup                 = obj.wellZup;      % the z location of the half gauge length 'up'   location
            header.wellXdn                 = obj.wellXdn;      % the x location of the half gauge length 'down' location
            header.wellZdn                 = obj. wellZdn;     % the z location of the half gauge length 'down' location
            
            
            tracesRef                      = obj.tracesRef;
            tracesRefDirect                = obj.tracesRefDirect;
            tracesOther                    = obj.tracesOther;
            tracesOtherDirect              = obj.tracesOtherDirect;
            tracesOtherNoise               = obj.tracesOtherNoise; 
            traceCMN                       = obj.traceCMN;            
     
            fail = false;
            
            try
                % save the data to disk
                save(filename,'header','tracesRef',  'tracesRefDirect',...
                                       'tracesOther','tracesOtherDirect', 'tracesOtherNoise', ...
                                       'traceCMN');
            
            catch
                % problems writing to disk
                fail = true;
            end
            
        end
 
        function [fail] = saveToSEGY(obj,filenameRef,filenameOther,traceOptions)
            
            % saveToSEGY - this method saves the structure to a SEGY formatted file
                
            fail      = false;
            failRef   = false;
            failOther = false;
            
            % get the reference data
            refOptions = traceOptions;
            refOptions.traceType = 'Ref';
            
            % set the group scaling function
            SourceGroupScalar = -100;
                        
            
            try
                
                % *******************************************************
                % save the data to disk in SEGY format
                % *******************************************************
                
                 
                % get the reference traces putting together the parts per user settings
                
                [recordOut, failRef] = getMergedData(obj,refOptions);

                % create the ascii header
            
                [TextualFileHeader] = mkHeader('ExploreDAS output', obj.timeAxis,obj.wellX,'Shot Record - Reference');

                WriteSegyEvenBetter(filenameRef,recordOut, ...
                                    'dt',obj.dt, ...
                                    'SourceX', obj.sourceX*100 * ones(1,obj.nchannels), ...
                                    'SourceY', obj.sourceZ*100 * ones(1,obj.nchannels), ...
                                    'GroupX',  obj.wellX  *100,                         ...
                                    'GroupY',  obj.wellZ  *100,                         ...
                                    'SourceGroupScalar', SourceGroupScalar,             ...
                                    'TextualFileHeader',TextualFileHeader,   ...
                                    'MeasurementSystem', 1                              ...
                               );
                           
                % get the other traces putting together the parts per user settings
                
               [recordOut, failOther] = getMergedData(obj,traceOptions);

                % create the ascii header
                
                [TextualFileHeader] = mkHeader('ExploreDAS output', obj.timeAxis,obj.wellX,'Shot Record - Other');
                
                WriteSegyEvenBetter(filenameOther,recordOut, ...
                                    'dt',obj.dt, ...
                                    'SourceX', obj.sourceX*100 * ones(1,obj.nchannels), ...
                                    'SourceY', obj.sourceZ*100 * ones(1,obj.nchannels), ...
                                    'GroupX',  obj.wellX  *100,                         ...
                                    'GroupY',  obj.wellZ  *100,                         ...
                                    'SourceGroupScalar', SourceGroupScalar,             ...
                                    'TextualFileHeader',TextualFileHeader,   ...
                                    'MeasurementSystem', 1                              ...
                               );
                
            
            catch
                % problems writing to disk
                fail = true;
            end
            
            if failRef || failOther
                fail = true;
            end
        end
        
        
        function [fail] = archiveToDisk(obj)
            
            % archiveToDisk - this method puts the trace data on disk & delete trace data
            
            filename = createFileName(obj);
            
            fail = saveToDisk(obj,filename);
            
            if fail
                % something bad happened - can't write to disk
                return
            end
            
            % clear the trace data to save memory
            purgeTraces(obj)
            
        end
        
        function purgeTraces(obj)
            
            % purgeTraces - this method deletes the trace data from memory
            
            % clear the trace data to save memory
            obj.tracesRef         = [];
            obj.tracesRefDirect   = [];
            obj.tracesOther       = [];
            obj.tracesOtherDirect = []; 
            obj.tracesOtherNoise  = []; 
            obj.traceCMN          = [];            
            
            obj.fromDisk     = true;
            
        end
        
        function [fail] = restoreFromDisk(obj)
            
            % restoreFromDisk - this routine brings the trace data back from disk

            filename = createFileName(obj);

            fail = false;
            try
                a = load(filename,'header','tracesRef',  'tracesRefDirect',...
                                  'tracesOther','tracesOtherDirect', 'tracesOtherNoise', ...
                                  'traceCMN');
            catch
                fail = true;
                % warn the user of the failure to find this file
                hfig = uifigure;
                msg = ['Cannot open file: ' filename '. Try setting the data directory properly'];
                ttitle = 'Shot Record File Not Found';
                
                selection = uiconfirm(hfig,msg,ttitle,'Options',{'Ok'}, 'DefaultOption',1);
                
                delete(hfig)
                
                return
            end
            
            % re-inflate parameters from disk values
            
            obj.tracesRef         = a.tracesRef;
            obj.tracesRefDirect   = a.tracesRefDirect;
            obj.tracesOther       = a.tracesOther;
            obj.tracesOtherDirect = a.tracesOtherDirect; 
            obj.tracesOtherNoise  = a.tracesOtherNoise; 
            obj.traceCMN          = a.traceCMN;            
             
            obj.fromDisk       = false;
            
        end
        
        function [filename] = createFileName(obj)
            
            % createFileName - create the file name for the current shot number
            
            filename = [ 'shot_' num2str(obj.shotNumber) '.mat'];
            filename = fullfile(obj.dataDir,filename);
        end
        
        function backupTracesOther(obj)
            
            % backupTracesOther - create a back up copy of the current tracesOther structure
            
           obj.tracesOtherBackup = obj.tracesOther; 
        end
        
        function restoreTracesOther(obj)
            
            % restoreTracesOther - copy the backup copy of the data back to the tracesOther structure
            
            obj.tracesOther = obj.tracesOtherBackup;
            obj.tracesOtherBackup = [];
        end
        
        function [fail] = postToObject(obj,copy)
            
            % ******************************************************************
            % postToObject - create a new object from data passed through the calling sequence
            % ******************************************************************
            
            % default that it fails, if it gets to the bottom of the list we win!
            fail = true;
                
            if checkHeader(copy.header,'shotNumber');        return; end
            if checkHeader(copy.header,'dt');                return; end
            
            if checkHeader(copy.header,'fromDisk')          
                obj.fromDisk = false;
            end
            
            if checkHeader(copy.header,'gaugeLength');       return; end
            if checkHeader(copy.header,'nchannels');         return; end
            if checkHeader(copy.header,'nsamples');          return; end
            
            if checkHeader(copy.header,'opticalNoiseSeeds')
                obj.opticalNoiseSeeds = rand(1,3); 
            end
            if checkHeader(copy.header,'CMNSeeds')
                obj.CMNSeeds = rand(1,2); 
            end
            
            if checkHeader(copy.header,'sourceWavelet');     return; end
            if checkHeader(copy.header,'sourceX');           return; end
            if checkHeader(copy.header,'sourceZ');           return; end
            if checkHeader(copy.header,'sourcef0');          return; end
            if checkHeader(copy.header,'sourcefmin');        return; end
            if checkHeader(copy.header,'sourcefmax');        return; end
            
            if checkHeader(copy.header,'timeAxis')
                obj.timeAxis = (1:obj.nsamples)*obj.dt;
            end
                 
            if checkHeader(copy.header,'velocityType');      return; end
            if checkHeader(copy.header,'waveType');          return; end
            if checkHeader(copy.header,'wellX');             return; end
            if checkHeader(copy.header,'wellZ');             return; end
            if checkHeader(copy.header,'wellMD');            return; end
            
            if checkHeader(copy.header,'wellXup')
                 obj.wellXup = [];
            end
            if checkHeader(copy.header,'wellZup')
                 obj.wellZup = [];
            end
            if checkHeader(copy.header,'wellXdn')
                obj.wellXdn = [];
            end
            if checkHeader(copy.header,'wellZdn')
                 obj.wellZdn = [];
            end
            
            if checkHeader(copy.header,'firstBreaks')
                obj.firstBreaks = zeros(1,obj.nchannels);
            end
            if checkHeader(copy.header,'source2ReceiverDistance')
                obj.source2ReceiverDistance  = zeros(1,obj.nchannels);
            end
            if checkHeader(copy.header,'directionCosines')
                obj.directionCosines = zeros(2,obj.nchannels);
            end
            
            if checkHeader(copy.header,'tracesRef')
                obj.tracesRef = zeros(obj.nsamples,obj.nchannels);
            end
            if checkHeader(copy.header,'tracesRefDirect')
                obj.tracesRefDirect = zeros(obj.nsamples,obj.nchannels);
            end
            if checkHeader(copy.header,'tracesOther')
                obj.tracesOther = zeros(obj.nsamples,obj.nchannels);
            end
            if checkHeader(copy.header,'tracesOtherDirect')
                obj.tracesOtherDirect = zeros(obj.nsamples,obj.nchannels);
            end
            if checkHeader(copy.header,'tracesOtherNoise')
                obj.tracesOtherNoise = zeros(obj.nsamples,obj.nchannels);
            end
            if checkHeader(copy.header,'traceCMN')
                obj.traceCMN = zeros(obj.nsamples,obj.nchannels);
            end
           
            if checkHeader(copy.header,'dataDir')
                obj.dataDir = 'data';
            end
            
            fail = false;
        end
        
        function [fail] = checkHeader(obj,header,var)
            
            % checkHeader - check to make sure the header is present in the structure or fail
            %               if success - then copy header value to the current object
            
            if ~isfield(header,'var')
                disp(['Missing ' var ' in saved file'])
                fail = true;
                return
            end
            fail = false;
            command = ['obj.' var ' = header.' var ';'];
            eval(command);

        end
    end

end

