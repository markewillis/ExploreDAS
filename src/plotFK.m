function [up, dn] = plotFK(Data,dt,dz,ifscalebytrace,fmax,typeData)

% ***********************************************************************************************************
%  plotFK - this function plots the fk transform of the input Data
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


debug = false;

% get the size of the input data
[nsamp,ntraceOrig] = size(Data);
  
% **************************************************
% create a mirrored version of the input data
% **************************************************

DataN = zeros(nsamp,2*ntraceOrig);
DataN(:,1:ntraceOrig)        = Data;
DataN(:,end:-1:ntraceOrig+1) = Data;

% **************************************************
% get the size of the mirrored data
% **************************************************

[nsamp,ntrace] = size(DataN);

 nheel = ntrace;
 
% **************************************************
% apply a trace scaling if desired
% **************************************************

 scalar = ones(1,ntrace);

 if ifscalebytrace
     for itrace = 1:ntrace
         scalar(itrace) =  max(abs(DataN(:,itrace)));         % find the maximum of this trace
         DataN(:,itrace) = DataN(:,itrace) ./scalar(itrace);  % normalize the trace by the maximum of the trace
     end
 end
 
% **************************************************
% plot the mirrored data
% **************************************************
 
if debug
    figure
     time     = (1:nsamp)*dt;
     distance = (1:ntrace)*dz;

    imagesc(distance,time,DataN)
    cm = [bone' (1-bone)']';
    colormap(cm)
    if ifscalebytrace
        title('Mirrored Data: scaled by trace max')
    else
        title('Mirrored Data')
    end
end

% **************************************************
% transform the mirror input data to fk space
% **************************************************

vspec =fftshift(fft2(DataN));
 
 
% fnyq = floor(nsamp /2) +1;
% knyq = floor(nheel /2) +1;
 

% create the axis values
df    = 1./(nsamp * dt);
dk    = 1./(ntrace * dz);

kaxis = [-ntrace/2 :1: ntrace/2] * dk;
faxis = [-nsamp /2 :1: nsamp /2] * df;

figure('Name','FK plot','Tag','fkplot');
imagesc(kaxis,faxis,abs(vspec))
ylim([-1 1]*fmax)
set(gca,'fontsize',14,'fontweight','bold')
title([typeData ': fk Amplitude Spectrum'])
axis xy
colormap(jet)
xlabel('Wavenumber (1/m)')
ylabel('Frequency (Hz)')

return

