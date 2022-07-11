classdef opticalNoiseRecord < matlab.mixin.SetGetExactNames
    
% ***********************************************************************************************************
%  opticalNoiseRecord - this class handles optical noise records
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

    % opticalNoiseRecord - the class contains the data and methods for optical noise records

    
    properties
        nNoiseFiles
        nsamplesWanted
        nchannelsWanted
        scalar
        rmsSyn
        rmsNoise
        desiredSNR
        
        rsrcsDir    % the data directory with the actual measured optical noise signals - if used
    end
    
    methods
        function obj = opticalNoiseRecord(nNoiseFiles,nchannelsWanted,nsamplesWanted,rsrcsDir)
            % opticalNoiseRecord - Construct an instance of this class
            
            obj.nNoiseFiles      = nNoiseFiles;
            obj.nchannelsWanted  = nchannelsWanted;
            obj.nsamplesWanted   = nsamplesWanted;
            
            if nargin ==4
                obj.rsrcsDir = rsrcsDir;
            else
                obj.rsrcsDir = 'rsrcs';
            end
        end
        
        function [noiseRecord] = makeNoise(obj,rmsSyn,desiredSNR,opticalNoiseSeeds)
            % makeNoise - Create a noise record by reading in actual optical noise records from disk

            
            obj.rmsSyn     = rmsSyn;
            obj.desiredSNR = desiredSNR;
            
            % randomly choose a noise file
            randomNumber = opticalNoiseSeeds(1);
            fileNumber = obj.nNoiseFiles * randomNumber;
            fileNumber = ceil(fileNumber);
            fileNumber = min(obj.nNoiseFiles,max(1,fileNumber));
            fnIn = ['noiseBlock_' num2str(fileNumber) '.mat'];
            fnIn = fullfile(obj.rsrcsDir,fnIn);
            
            % read in optical noise from file - it is in strain (not strain rate)
            noise = load(fnIn,'Data','ntracesOut','nsamplesOut');

            % randomly select a trace range in the input noise record
            startingChannelRange = noise.ntracesOut - obj.nchannelsWanted;
            randomNumber = opticalNoiseSeeds(2);
            startingChannel = startingChannelRange * randomNumber;
            startingChannel = ceil(startingChannel);
            startingChannel = min(noise.ntracesOut - obj.nchannelsWanted, max(1,startingChannel));
            
            % randomly select a time range in the input noise record
            startingSampleRange = noise.nsamplesOut - obj.nsamplesWanted;
            randomNumber = opticalNoiseSeeds(3);
            startingSample = startingSampleRange * randomNumber;
            startingSample = ceil(startingSample);
            startingSample = min(noise.nsamplesOut - obj.nsamplesWanted, max(1,startingSample));
            
            % extract the trace range from the noise record
            selectedNoise = noise.Data(startingSample :startingSample +obj.nsamplesWanted -1,...
                                       startingChannel:startingChannel+obj.nchannelsWanted-1      );
            
            % delete the noise record to save storage space
            clear noise;
            
            % extract signal levels of the noise
            obj.rmsNoise = rms(selectedNoise(:));
            
            % ****************************************************
            % derive the scalar to obtain the desired SNR
            % ****************************************************
            
            % desiredSNR = 20.*log10(rmsSyn/(rmsNoise*scalar));
            % desiredSNR/20 = log10(rmsSyn/(rmsNoise*scalar));
            % 10^(desiredSNR/20) = rmsSyn/(rmsNoise*scalar);
            % scalar = rmsSyn/(rmsNoise*10^(desiredSNR/20));
            
            obj.scalar = obj.rmsSyn /(obj.rmsNoise * 10^(obj.desiredSNR/20));
            
            % scale the noise
            noiseRecord = obj.scalar*selectedNoise;
            
        end

        function [noiseRecord,rmsNoise] = createNoise(obj,opticalNoiseSeeds,ifNoiseFromFile)
            % createNoise-  Create a noise record and do not scale it all
            %               The noise is either read in from a set of files, or created from random numbers
                                    
            if ifNoiseFromFile
                
                % read in actual optical noise from a set of files
                
                % randomly choose a noise file
                randomNumber = opticalNoiseSeeds(1);
                fileNumber = obj.nNoiseFiles * randomNumber;
                fileNumber = ceil(fileNumber);
                fileNumber = min(obj.nNoiseFiles,max(1,fileNumber));
                fnIn = ['noiseBlock_' num2str(fileNumber) '.mat'];
                fnIn = fullfile(obj.rsrcsDir,fnIn);
                
                % read in optical noise from file - it is in strain (not strain rate)
                noise = load(fnIn,'Data','ntracesOut','nsamplesOut');
                
                % randomly select a trace range in the input noise record
                startingChannelRange = noise.ntracesOut - obj.nchannelsWanted;
                randomNumber = opticalNoiseSeeds(2);
                startingChannel = startingChannelRange * randomNumber;
                startingChannel = ceil(startingChannel);
                startingChannel = min(noise.ntracesOut - obj.nchannelsWanted, max(1,startingChannel));
                
                % randomly select a time range in the input noise record
                startingSampleRange = noise.nsamplesOut - obj.nsamplesWanted;
                randomNumber = opticalNoiseSeeds(3);
                startingSample = startingSampleRange * randomNumber;
                startingSample = ceil(startingSample);
                startingSample = min(noise.nsamplesOut - obj.nsamplesWanted, max(1,startingSample));
                
                % extract the trace range from the noise record
                noiseRecord = noise.Data(startingSample :startingSample +obj.nsamplesWanted -1,...
                    startingChannel:startingChannel+obj.nchannelsWanted-1      );
                
                % delete the noise record to save storage space
                clear noise;
                
            else
                
                % create random noise to use as optical noise
                
                % set the random number generator so that the random number is the repeatable for this record
                seed = round(opticalNoiseSeeds(1) * 10000);
                rng(seed);
                        
                % create the random noise record
                noiseRecord = (rand(obj.nsamplesWanted,obj.nchannelsWanted) - 0.5) * 2.;
                            
            end
            
            % extract signal levels of the noise
            obj.rmsNoise = rms(noiseRecord(:));
            
            rmsNoise = obj.rmsNoise;
            
        end
        
    end
    
end

