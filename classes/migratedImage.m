classdef migratedImage < handle
    
% ***********************************************************************************************************
%  migratedImage - this class handles migrated images
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
            
    % migratedImage - migrated image
    %   this class provides a place to hold migrated images
    
    properties
        nx
        nz
        x
        z
        imageRef
        imageOther
        count
    end
    
    properties (Constant)
        interpFactor = 10;
    end
    
    methods
        function obj = migratedImage(nx,nz,x,z)
            % migratedImage Construct an instance of this class
            if nargin == 0
                % create a default-sized migrated image instance
                obj.nx = 1;
                obj.nz = 1;
                obj.x  = 0;
                obj.z  = 0;
                obj.imageRef   = zeros(nz,nx);
                obj.imageOther = zeros(nz,nx);
                obj.count = 0;
            else
                % create a specific sized instance
                obj.nx = nx;
                obj.nz = nz;
                obj.x  = x;
                obj.z  = z;
                obj.imageRef   = zeros(nz,nx);
                obj.imageOther = zeros(nz,nx);
                obj.count = 0;
            end
        end
        
        function migrateTrace(obj,traceRef,traceOther,twoWayTTT)
            % migrateTrace migrate the traces in this shot record into the image
            
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
                
                % use matrix math to implement the migration (fast)
                
                iget = min(nsamples,max(1,round(twoWayTTT/dt)));
                
                obj.imageRef   = obj.imageRef   + traceR(iget);
                obj.imageOther = obj.imageOther + traceO(iget);
                
            else
                
                % use explicit for loops to implement the migration (which is very slow)
                for iz = 1:obj.nz            
                    for ix = 1:obj.nx
                        % get 2-way time to this image cell
                        get = twoWayTTT(iz,ix);
                        % round to get the nearest time sample from the trace
                        iget = min(nsamples,max(1,round(get/dt)));
                        % create the migrated image for each data set
                        obj.imageRef(  iz,ix) = obj.imageRef(  iz,ix) + traceR(iget);
                        obj.imageOther(iz,ix) = obj.imageOther(iz,ix) + traceO(iget);
                    end
                end
            end
        end
        
        function plotRepeat(obj,hfig,titleFigure,polarity)
            
            %plotRepeat - reuse an existing figure and plot the migration result
            
            figure(hfig)
            
            subplot(1,2,1)
            imagesc(obj.x,obj.z,obj.imageRef)
            colormap(bone)
            ylabel('Depth','fontweight','bold','fontsize',12)
            xlabel('Distance','fontweight','bold','fontsize',12)
            title(['Reference Migration' ],'fontweight','bold','fontsize',12)
            set(gca,'fontweight','bold','fontsize',12)
            ca = caxis;
            maxval = max(ca(1), ca(2));
            ca = [-1 1]*maxval/4.;
            caxis(ca);
            
            scalar = 1;
            if polarity
                scalar = -1;
            end
           
            subplot(1,2,2)
            imagesc(obj.x,obj.z,obj.imageOther*scalar)
            colormap(bone)
            ylabel('Depth','fontweight','bold','fontsize',12)
            xlabel('Distance','fontweight','bold','fontsize',12)
            title([titleFigure ' Migration' ],'fontweight','bold','fontsize',12)
            set(gca,'fontweight','bold','fontsize',12)
            ca = caxis;
            maxval = max(ca(1), ca(2));
            ca = [-1 1]*maxval/4.;
            caxis(ca);
             
        end
        
         function [fail] = saveToSEGY(obj,filenameRef,filenameOther,polarity)
            % saveToSEGY - save migrated images to SEGY files
                    
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
                
                [TextualFileHeader] = mkHeader('ExploreDAS output', obj.z,obj.x,'Migrated Image - Reference');
                 
                WriteSegyEvenBetter(filenameRef,obj.imageRef, ...
                                    'dt',1, ...
                                    'SourceX', obj.x*100, ...
                                    'SourceY', obj.x*100, ...
                                    'GroupX',  obj.x*100, ...
                                    'GroupY',  obj.x*100, ...
                                    'SourceGroupScalar', SourceGroupScalar,  ...
                                    'TextualFileHeader',TextualFileHeader,   ...
                                    'MeasurementSystem', 1                   ...
                               );
                failRef   = false;
                          
                [TextualFileHeader] = mkHeader('ExploreDAS output', obj.z,obj.x,'Migrated Image - Other');
 
                WriteSegyEvenBetter(filenameOther,obj.imageOther*scalar, ...
                                    'dt',1, ...
                                    'SourceX', obj.x*100, ...
                                    'SourceY', obj.x*100, ...
                                    'GroupX',  obj.x*100, ...
                                    'GroupY',  obj.x*100, ...
                                    'SourceGroupScalar', SourceGroupScalar,  ...
                                    'TextualFileHeader',TextualFileHeader,   ...
                                    'MeasurementSystem', 1                   ...
                               );
                failOther = false;
            
%                                     'TexturalFileHeader',texturalFileHeader,            ...
            
            catch
                % problems writing to disk
                fail = true;
            end
            
            if failRef || failOther
                fail = true;
            end
        end            
      
        function plot(obj,titleFigure,polarity)
            
            %plot - open a new figure window and plot the migration results
            
            hfig = figure('Name','Migrated Image','Tag','migratedimage');
            
            plotRepeat(obj,hfig,titleFigure,polarity)
            
        end
        
        function package = packageMigrationUp(obj)
            
            % packageMigrationUp return all the data for this obj to the caller
            
            package.nx         = obj.nx;
            package.nz         = obj.nz;
            package.x          = obj.x;
            package.z          = obj.z;
            package.imageRef   = obj.imageRef;
            package.imageOther = obj.imageOther;
            package.count      = obj.count;
        end
    end
end

