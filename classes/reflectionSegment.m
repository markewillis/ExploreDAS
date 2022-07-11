classdef reflectionSegment < matlab.mixin.SetGetExactNames
    
% ***********************************************************************************************************
%  reflectionSegment - this class handles the properties of a reflector segment
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

    % reflectionSegment - holder for a reflection structure
    
    properties
        % define reflectors
        reflectorNumber
        x
        z
        np
        color
        interpx
        interpz
        reflectionCoeficientScalar
    end
    
    properties (Constant)
        interpDistance = 10;
    end
    
    methods
        function obj = reflectionSegment(reflectorNumber,x,z,color,interpx,interpz,reflectionCoeficientScalar)
            % reflectionSegment Construct an instance of this class

            if nargin == 1
                % create default empty reflection segment
                obj.reflectorNumber = reflectorNumber;
                obj.x = [];
                obj.z = [];
                obj.np = 0;
                obj.color = 'r';
                obj.interpx = [];
                obj.interpz = [];
                obj.reflectionCoeficientScalar = 1;
            elseif nargin == 3
                % create reflection segment with just x & z values, and make it red
                obj.reflectorNumber = reflectorNumber;
                nx = min([length(x),length(z)]);
                obj.x = x;
                obj.z = z;
                obj.np = nx;
                obj.color = 'r';
                obj.interpx = [];
                obj.interpz = [];   
                obj.reflectionCoeficientScalar = 1;
            elseif nargin == 7
                % create reflection segment with all input properties
                obj.reflectorNumber = reflectorNumber;
                nx = min([length(x),length(z)]);
                obj.x = x;
                obj.z = z;
                obj.np = nx;
                obj.color = color;
                obj.interpx = interpx;
                obj.interpz = interpz;
                obj.reflectionCoeficientScalar = reflectionCoeficientScalar;
            end
        end
        
        
        function addPoint(obj,x,z)
            % addPoint add a point to the reflection Segment
            % add another reflection point
            obj.np        = obj.np + 1;
            obj.x(obj.np) = x;
            obj.z(obj.np) = z;
            obj.interpx   = [];
            obj.interpz   = [];

            % update the display
            plotAllPoints
            listbox_selectReflector_Callback([], [])
        end
        
        function [deleteSegment, reaction] = deletePoint(obj,x,z)
            
            % delete a point in the reflector segment
                       
            deleteSegment = false;
                     
            if obj.np > 1
                % find the closest source to the digitized point
                [~,index] = min(abs((obj.x - x).^2 + (obj.z - z).^2));
                % omit the closest source point
                list = 1:obj.np;
                mask = list ~= index(1);
                obj.x       = obj.x(mask);
                obj.z       = obj.z(mask);
                obj.np      = obj.np - 1;
                obj.interpx = [];
                obj.interpz = [];
                
                reaction = 'deleted point';
                
            else
                % delete this selected "entire" reflector from the list
                deleteSegment = true;
                
                reaction = 'remove this reflector from list';
                
            end
        end
        
        function [newx,newz] = interpPoints(obj,newInterpDistance)
            
            % interpPoints - interpolate the digitized points to a regular interval
            
            if nargin == 1
                % use the default interpolation distance since a new one was not entered
                newInterpDistance = obj.interpDistance;
                % the interpolated values are not returned but put into the obj
                newx = [];
                newz = [];
            end
            
 
            % compute the distance between each digitized point
            interPointDistances = sqrt((obj.x(1:end-1) - obj.x(2:end)).^2 + (obj.z(1:end-1) - obj.z(2:end)).^2);
 
            % remove any duplicate points
            iput = 1;
            xunique(1) = obj.x(1);
            zunique(1) = obj.z(1);
            for testPoint = 1:(length(obj.x)-1)
                if interPointDistances(testPoint) > .001
                    % this point is unique - save it
                    iput = iput + 1;
                    xunique(iput) = obj.x(testPoint+1);
                    zunique(iput) = obj.z(testPoint+1);
                end
            end
                               
            % compute the distance between each unique digitized point
            interPointDistances = sqrt((xunique(1:end-1) - xunique(2:end)).^2 + (zunique(1:end-1) - zunique(2:end)).^2);
            
            % compute the integrated distance "arclength' from the first point
            arclength = cumsum(interPointDistances);
            % add the distance from the first point to itself (which is zero)
            arclength = [ 0 arclength(:)']';
            
            % specify the new interpolated points
            MD = [0:newInterpDistance:arclength(end)];
            
            if nargin == 1
                % store new values in the object
                % interpolate the x values
                %
                   
                try
                    % interpolate the x values
                    obj.interpx = interp1(arclength,xunique,MD );
                    % interpolate the z values
                    obj.interpz = interp1(arclength,zunique,MD );
                catch
                    disp(['Failed in interpPoints '])
                end
            else
                % do not keep the new values, return them to the calling function
                % interpolate the x values
                newx = interp1(arclength,xunique,MD );
                % interpolate the z values
                newz = interp1(arclength,zunique,MD );
            end
            
        end
        
        function plot(obj,hObject)
            
            % plot - plot out the interpolated values
            
            if obj.np > 1
                % create the interpolated values for this reflector
                interpPoints(obj);
                % plot out the interpolated values for this reflector
                plot(hObject,obj.interpx, obj.interpz,'b')
            elseif obj.np == 1
                % there is only one point for this reflector - plot it as an asteric
                plot(hObject,obj.interpx, obj.interpz,'*b')
            else
                % do nothing because there are no points for the reflector
            end
            
        end
        function plotColor(obj,hObject)
            
            % plotColor - plot with thick lines
            
            if obj.np > 1
                % create the interpolated values for this reflector
                interpPoints(obj);
                % plot out the interpolated values for this reflector
                plot(hObject,obj.interpx, obj.interpz,'linewidth',3)
            elseif obj.np == 1
                % there is only one point for this reflector - plot it as an asteric
                plot(hObject,obj.interpx, obj.interpz,'*')
            else
                % do nothing because there are no points for the reflector
            end
            
        end        
        function plotPoints(obj,hObject)
            if obj.np == 1
                % there is only one point for this reflector - plot it as an asteric
                plot(hObject,obj.x, obj.z,'*r''Tag','Rselected')
            end
        end
        
        function reorderPoints(obj)
            
            % reorderPoints - reorder the points in the reflector so they are connected logically
            
            % assume the first point in the old is the first point in the new
            newOrder.x = obj.x;
            newOrder.z = obj.z;
            
            % create a list of available "next points"
            xlist = obj.x(2:end);
            zlist = obj.z(2:end);
            
            for ipoint = 2:obj.np-1
                % compute the distance between the last point and all of the other digitized points
                distanceFromCurrentPoint = sqrt((xlist - newOrder.x(ipoint-1)).^2 + (zlist - newOrder.z(ipoint-1)).^2);
                % find the closest point
                [~,index] = min(abs(distanceFromCurrentPoint));
                % found next point - save it to new list
                ifoundPoint = index(1);
                newOrder.x(ipoint) = xlist(ifoundPoint);
                newOrder.z(ipoint) = zlist(ifoundPoint);
                % remove the found point from the list of available points
                list = 1:length(xlist);
                mask = list ~= ifoundPoint;
                xlist = xlist(mask);
                zlist = zlist(mask);
            end
            
            % there is only one point left - add it to the new ordered list
            newOrder.x(obj.np) = xlist(1);
            newOrder.z(obj.np) = zlist(1);
            
            obj.x = newOrder.x;
            obj.z = newOrder.z;
            
        end
        
        % create getter functions 
        
        function reflectorNumber = get.reflectorNumber(obj)
            reflectorNumber = obj.reflectorNumber;
        end
        function x = get.x(obj)
            x = obj.x;
        end        
        function z = get.z(obj)
            z = obj.z;
        end         
        function np = get.np(obj)
            np = obj.np;
        end            
        function color = get.color(obj)
            color = obj.color;
        end                    
        function interpx = get.interpx(obj)
            interpx = obj.interpx;
        end        
        function interpz = get.interpz(obj)
            interpz = obj.interpz;
        end                
        
 
        function ok = replace(obj,reflectorNumber,x,z,color,interpx,interpz,reflectionCoeficientScalar)
            
            %replace - this function reinflates a reflection segment with new data 
            
            ok = true;
            nx = length(x);
            nz = length(z);
            
            if nx == nz
                obj.x       = x;
                obj.z       = z;
                obj.np      = nx;
                obj.color   = color;  
                obj.interpx = interpx;         
                obj.interpz = interpz;
                
                if nargin == 7 
                    obj.reflectionCoeficientScalar = 1;
                else
                    obj.reflectionCoeficientScalar = reflectionCoeficientScalar;
                end
                
                obj.reflectorNumber = reflectorNumber;
            else
                ok = false;
            end
        end             
        
        
    end
end

