classdef migratedCDP < matlab.mixin.SetGetExactNames
    
% ***********************************************************************************************************
%  migratedCDP - this class handles migrated CDPs
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
        
    % migratedCDP - class stores migrated CDP gathers
    
    properties
        nshots
        nz
        shotx
        cdpx
        z
        imageRef
        imageOther
        count
    end
    
    properties (Constant)
        interpFactor = 10;
    end
    
    methods
        function obj = migratedCDP(cdpx,nshots,shotx,nz,z)
            % migratedCDP Construct an instance of this class
            if nargin == 0
                % create default migrated CDP with one trace
                obj.cdpx       = 0;
                obj.nshots     = 1;
                obj.nz         = 1;
                obj.shotx      = 0;
                obj.z          = 0;
                obj.imageRef   = zeros(nz,nshots);
                obj.imageOther = zeros(nz,nshots);
                obj.count      = 0;
            else
                % create migrated CDP gather place holder with the input values
                obj.cdpx       = cdpx;
                obj.nshots     = nshots;
                obj.nz         = nz;
                obj.shotx      = shotx;
                obj.z          = z;
                obj.imageRef   = zeros(nz,nshots);
                obj.imageOther = zeros(nz,nshots);
                obj.count = 0;
            end
        end
        
        function package = packageCDPUp(obj)
            % packageCDPUp return all the data for this obj to the caller
                package.cdpx       = obj.cdpx;
                package.nshots     = obj.nshots;
                package.nz         = obj.nz;
                package.shotx      = obj.shotx;
                package.z          = obj.z;
                package.imageRef   = obj.imageRef;
                package.imageOther = obj.imageOther;
                package.count      = obj.count;
        end  
        
        function migrateTrace(obj,ishot,traceRef,traceOther,twoWayTTT)
            % migrateTrace - migrate all the traces from this shot into the corresponding CDP trace
            
            obj.count = obj.count + 1;
            
            % unpack the traces and their meta data
            traceR   = traceRef.trace;
            dt       = traceRef.dt;
            nsamples = length(traceR);
            
            traceO   = traceOther.trace;
            dt       = traceOther.dt;
            nsamples = length(traceO);
           
            fast = true;
            
            if fast
                % use matrix math to implement the migration quicker
                
                % round to get the nearest time sample from the trace
                iget = min(nsamples,max(1,round(twoWayTTT/dt)));
                % create the migrated image for each data set
                obj.imageRef(  :,ishot) = obj.imageRef(  :,ishot) + traceR(iget)';
                obj.imageOther(:,ishot) = obj.imageOther(:,ishot) + traceO(iget)';
                
            else
                % use explicit for loop which runs slower
                
                for iz = 1:obj.nz
                    % get 2-way time to this image cell
                    get = twoWayTTT(iz);
                    % round to get the nearest time sample from the trace
                    iget = min(nsamples,max(1,round(get/dt)));
                    % create the migrated image for each data set
                    obj.imageRef(  iz,ishot) = obj.imageRef(  iz,ishot) + traceR(iget);
                    obj.imageOther(iz,ishot) = obj.imageOther(iz,ishot) + traceO(iget);
                    
                end
            end
            
        end
        
        function plot(obj,titleFigure)
            % plot - create a plots of the reference and Other migrated CDPs
            
            [ndepth,nshots] = size(obj.imageRef);
            
            hfig = figure('Name','Migrated CDP','Tag','migratedCDP');
            subplot(1,2,1)
            imagesc(1:nshots,obj.z,obj.imageRef)
            colormap(bone)
            ylabel('Depth','fontweight','bold','fontsize',12)
            xlabel('Shot Number','fontweight','bold','fontsize',12)
            title(['Reference CDP' ],'fontweight','bold','fontsize',12)
            set(gca,'fontweight','bold','fontsize',12)
            ca = caxis;
            maxval = max(ca(1), ca(2));
            ca = [-1 1]*maxval/4.;
            caxis(ca);
            
            subplot(1,2,2)
            imagesc(1:nshots,obj.z,obj.imageOther)
            colormap(bone)
            ylabel('Depth','fontweight','bold','fontsize',12)
            xlabel('Shot Number','fontweight','bold','fontsize',12)
            title([titleFigure ' Migration' ],'fontweight','bold','fontsize',12)
            set(gca,'fontweight','bold','fontsize',12)
            caxis(ca)
            ca = caxis;
            maxval = max(ca(1), ca(2));
            ca = [-1 1]*maxval/4.;
            caxis(ca);
            
        end
        
        function [fail] = saveToSEGY(obj,filenameRef,filenameOther,polarity)
            
            % saveToSEGY - save migrated CDP to SEGY files 
            
            scalar = 1;
            if polarity
                scalar = -1;
            end
                     
            fail      = false;
            failRef   = true;
            failOther = true;
                   
            % set the group scaling function
            SourceGroupScalar = -100;
            
           
            try
                % save the data to disk in SEGY format
                
                [TextualFileHeader] = mkHeader('ExploreDAS output', obj.z,obj.shotx,'Migrated CDP - Reference');
                 
                WriteSegyEvenBetter(filenameRef,obj.imageRef, ...
                                    'dt',1, ...
                                    'SourceX', obj.shotx*100, ...
                                    'SourceY', obj.cdpx *100 * ones(1,obj.nshots), ...
                                    'GroupX',  obj.shotx*100, ...
                                    'GroupY',  obj.cdpx *100 * ones(1,obj.nshots), ...
                                    'SourceGroupScalar', SourceGroupScalar,  ...
                                    'TextualFileHeader',TextualFileHeader,            ...
                                    'MeasurementSystem', 1                   ...
                               );
                failRef   = false;
                          
                [TextualFileHeader] = mkHeader('ExploreDAS output', obj.z,obj.shotx,'Migrated CDP - Other'); 
                
                WriteSegyEvenBetter(filenameOther,obj.imageOther*scalar, ...
                                    'dt',1, ...
                                    'SourceX', obj.shotx*100, ...
                                    'SourceY', obj.cdpx *100 * ones(1,obj.nshots), ...
                                    'GroupX',  obj.shotx*100, ...
                                    'GroupY',  obj.cdpx *100 * ones(1,obj.nshots), ...
                                    'SourceGroupScalar', SourceGroupScalar,  ...
                                    'TextualFileHeader',TextualFileHeader,            ...
                                    'MeasurementSystem', 1                   ...
                              );
                failOther = false;
            
            
            catch
                % problems writing to disk
                fail = true;
            end
            
            if failRef || failOther
                fail = true;
            end
        end      
        
    end
end

