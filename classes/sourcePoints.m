classdef sourcePoints < matlab.mixin.SetGetExactNames
    
% ***********************************************************************************************************
%  sourcePoints - this class handles the properties of a seismic source points
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

    % sourcePoints - class instances hold the list of source points
    
    properties
        nsource
        x
        z
        color
    end
    
    methods
        function obj = sourcePoints()
            
            %sourcePoints Construct a default instance of this class
            %  
            obj.nsource = 0;
            obj.x = [];
            obj.z = [];
            obj.color = 'r';
        end
        
        function addPoint(obj,x,z)
            
            % addPoint - Add a point to the Source array object
            %   
            obj.nsource = obj.nsource + 1;
            obj.x(obj.nsource) = x;
            obj.z(obj.nsource) = z;
            obj.color = 'r';
        end
        
        function deletePoint(obj,x,z)
            
            % deletePoint - delete a source point in the array of points
            
            if obj.nsource > 1
                % find the closest well point to the digitized point
                [~,index] = min(abs((obj.x - x).^2 + (obj.z - z).^2));
                % omit the closest well point point
                list = 1:obj.nsource;
                mask = list ~= index(1);
                obj.x = obj.x(mask);
                obj.z = obj.z(mask);
                obj.nsource = obj.nsource - 1;
            else
                % all of the points have been deleted - reset the object
                obj.nsource = 0;
                obj.x = [];
                obj.z = [];
                obj.color = 'k';
            end
        end
        
        function plot(obj,hObject)
            
            % plot - this method plots out the source points as red stars
            
            if obj.nsource > 0
                plot(hObject,obj.x,obj.z,'*r','Tag','sourcePoints')
            end
        end
        
         
         function ok = replace(obj,x,z,color)
             
             % replace - this method inflates the object with new data
             
             ok = true;
             nx = length(x);
             nz = length(z);
             if nx == nz
                 obj.x = x;
                 obj.z = z;
                 obj.nsource = nx;
                 obj.color = color;
             else
                % the data is inconsistent!
                 ok = false;
             end
         end
    end
    
end

