classdef cmnTrace < matlab.mixin.SetGetExactNames
    
% ***********************************************************************************************************
%  cmnTrace - this class handles common mode noise traces
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
    
    % cmnTrace Supply a common mode noise trace

    
    properties
        CMN
        fileName
        ntracesIn
        nsamplesIn
    end
    
    methods
        function obj = cmnTrace(fileName,ntraces,nsamples)
            % cmnTrace Construct an instance of this class
            if nargin == 1
                % read in common mode noise from disk file
                obj.fileName = fileName;
                copy = load(fileName,'CMN','ntracesOut','nsamplesOut');
                obj.CMN        = copy.CMN;
                obj.ntracesIn  = copy.ntracesOut;
                obj.nsamplesIn = copy.nsamplesOut;
            else
                % generate random noise for the common mode noise
                obj.fileName = 'no file used-random numbers';
                obj.CMN        = (rand(nsamples,ntraces)-0.5) * 2.;
                obj.ntracesIn  = ntraces;
                obj.nsamplesIn = nsamples;
            end
        end
        
        function selectedNoise = mkCMN(obj,nsamples,rmsSyn,desiredSNR,CMNseeds)
            % mkCMN - this function creates a CMN trace by randomly selecting a trace and a time window from the 
            %         existing CMN traces. Note the seeds are pre-saved so that the noise is repeatable for each simulation.
            %         The CMN trace is scaled to match the desired SNR value
            
            % randomly choose a noise trace from the set of traces
            randomNumber = CMNseeds(1);
            noiseTrace = obj.ntracesIn * randomNumber;
            noiseTrace = ceil(noiseTrace);
            noiseTrace = min(obj.ntracesIn,max(1,noiseTrace));
            
            % randomly select a time range in the input noise trace
            startingSampleRange = obj.nsamplesIn-nsamples;
            randomNumber   = CMNseeds(2);
            startingSample = startingSampleRange * randomNumber;
            startingSample = ceil(startingSample);
            startingSample = min(obj.nsamplesIn - nsamples,max(1,startingSample));
            
            % extract the trace range from the noise record
            selectedNoise = obj.CMN(startingSample:startingSample+nsamples-1,noiseTrace);
            
            rmsNoise = max(abs(selectedNoise(:)));

            % ****************************************************
            % derive the scalar to obtain the desired SNR
            % ****************************************************
            
            % desiredSNR = 20.*log10(rmsSyn/(rmsNoise*scalar));
            % desiredSNR/20 = log10(rmsSyn/(rmsNoise*scalar));
            % 10^(desiredSNR/20) = rmsSyn/(rmsNoise*scalar);
            % scalar = rmsSyn/(rmsNoise*10^(desiredSNR/20));
            
            scalar = rmsSyn /(rmsNoise * 10^(desiredSNR/20));
            selectedNoise = scalar*selectedNoise;       
            
            
        end
        
        function [selectedNoise,rmsNoise ] = mkCMNunscaled(obj,nsamples,CMNseeds)
            % mkCMN - this function creates a CMN trace by randomly selecting a trace and a time window from the 
            %         existing CMN traces. Note the seeds are pre-saved so that the noise is repeatable for each simulation.
            %         The CMN trace is NOT scaled 
            
            % randomly choose a noise trace
            randomNumber = CMNseeds(1);
            noiseTrace = obj.ntracesIn * randomNumber;
            noiseTrace = ceil(noiseTrace);
            noiseTrace = min(obj.ntracesIn,max(1,noiseTrace));
            
            % randomly select a time range in the input noise record
            startingSampleRange = obj.nsamplesIn-nsamples;
            randomNumber   = CMNseeds(2);
            startingSample = startingSampleRange * randomNumber;
            startingSample = ceil(startingSample);
            startingSample = min(obj.nsamplesIn - nsamples,max(1,startingSample));
            
            % extract the trace range from the noise record
            selectedNoise = obj.CMN(startingSample:startingSample+nsamples-1,noiseTrace);
            
            rmsNoise = max(abs(selectedNoise(:)));

            
        end        
    end
end

