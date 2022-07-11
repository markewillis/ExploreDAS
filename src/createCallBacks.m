function createCallBacks
        
% ***********************************************************************************************************
%  createCallBacks - this function creates the call backs for each gui item
%
% ***********************************************************************************************************
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

% ****************************************************************
% callbacks for panel_simulation
% ****************************************************************

XDAS.h.simulation.edit_fmax.ValueChangedFcn                 = @edit_fmax_Callback;
XDAS.h.simulation.edit_fmin.ValueChangedFcn                 = @edit_fmin_Callback;
XDAS.h.simulation.edit_dt.ValueChangedFcn                   = @edit_dt_Callback;
XDAS.h.simulation.edit_tmax.ValueChangedFcn                 = @edit_tmax_Callback;
XDAS.h.simulation.pushbutton_model.ButtonPushedFcn          = @pushbutton_runModel_Callback;
XDAS.h.simulation.listbox_sourceType.ValueChangedFcn        = @listbox_sourceType_Callback;  
XDAS.h.simulation.edit_GL.ValueChangedFcn                   = @edit_GL_Callback;
XDAS.h.simulation.pushbutton_useGL.ButtonPushedFcn          = @pushbutton_useGL_Callback;
XDAS.h.simulation.pushbutton_firstBreaks.ButtonPushedFcn    = @pushbutton_firstBreaks_Callback;
XDAS.h.simulation.pushbutton_spectralRatios.ButtonPushedFcn = @pushbutton_spectralRatios_Callback;

XDAS.h.simulation.listbox_waveType.ValueChangedFcn          = @listbox_waveType_Callback;  


% ****************************************************************
% callbacks for panel_source
% ****************************************************************

XDAS.h.source.pushbutton_delete.ButtonPushedFcn      = @pushbutton_deleteSource_Callback;
XDAS.h.source.pushbutton_add.ButtonPushedFcn         = @pushbutton_addSource_Callback;

% ****************************************************************
% callbacks for panel_reflector
% ****************************************************************

XDAS.h.reflector.listbox_reflectors.ValueChangedFcn   = @listbox_selectReflector_Callback;
XDAS.h.reflector.pushbutton_reorder.ButtonPushedFcn   = @pushbutton_reorderReflectorPoints_Callback;
XDAS.h.reflector.pushbutton_delete.ButtonPushedFcn    = @pushbutton_deleteReflectorPoint_Callback;
XDAS.h.reflector.pushbutton_add.ButtonPushedFcn       = @pushbutton_addReflectorPoint_Callback;
XDAS.h.reflector.pushbutton_startNew.ButtonPushedFcn  = @pushbutton_addNewReflector_Callback;

% ****************************************************************
% callbacks for panel_well
% ****************************************************************

XDAS.h.well.pushbutton_reorder.ButtonPushedFcn        = @pushbutton_reorderWell_Callback;
XDAS.h.well.pushbutton_delete.ButtonPushedFcn         = @pushbutton_deleteWellPoint_Callback;
XDAS.h.well.pushbutton_add.ButtonPushedFcn            = @pushbutton_addWellPoint_Callback;

% ****************************************************************
% callbacks for panel_model
% ****************************************************************
 
 XDAS.h.model.edit_xmax.ValueChangedFcn            = @edit_Xmax_Callback;
 XDAS.h.model.edit_xmin.ValueChangedFcn            = @edit_Xmin_Callback;
 XDAS.h.model.edit_zmax.ValueChangedFcn            = @edit_Zmax_Callback;
 XDAS.h.model.edit_zmin.ValueChangedFcn            = @edit_Zmin_Callback;
 XDAS.h.model.edit_svel.ValueChangedFcn            = @edit_Svelocity_Callback;
 XDAS.h.model.edit_pvel.ValueChangedFcn            = @edit_Pvelocity_Callback;
 XDAS.h.model.edit_kz.ValueChangedFcn              = @edit_kz_Callback;
 XDAS.h.model.listbox_velocityType.ValueChangedFcn = @listbox_velocityType_Callback;
 XDAS.h.well.pushbutton_showImage.ButtonPushedFcn  = @pushbutton_showBackgroundImage;

% ****************************************************************
% callbacks for panel_migration
% ****************************************************************
 
XDAS.h.migration.pushbutton_migrate.ButtonPushedFcn  = @pushbutton_migrate_Callback;
XDAS.h.migration.pushbutton_CDP.ButtonPushedFcn      = @pushbutton_CDP_Callback;
XDAS.h.migration.edit_dx.ValueChangedFcn             = @edit_dx_Callback;
XDAS.h.migration.edit_dz.ValueChangedFcn             = @edit_dz_Callback;
XDAS.h.migration.edit_migZmin.ValueChangedFcn        = @edit_migZmin_Callback;
XDAS.h.migration.edit_migZmax.ValueChangedFcn        = @edit_migZmax_Callback;
XDAS.h.migration.edit_migXmin.ValueChangedFcn        = @edit_migXmin_Callback;
XDAS.h.migration.edit_migXmax.ValueChangedFcn        = @edit_migXmax_Callback;
XDAS.h.migration.edit_CDPx.ValueChangedFcn           = @edit_CDPx_Callback;

% ****************************************************************
% callbacks for panel_DAS
% ****************************************************************

XDAS.h.DAS.pushbutton_removeCMN.ButtonPushedFcn         = @pushbutton_removeCMN_Callback;

XDAS.h.DAS.edit_opticalSNR.ValueChangedFcn              = @edit_opticalNoiseSNR_Callback;
XDAS.h.DAS.pushbutton_addOpticalNoise.ButtonPushedFcn   = @pushbutton_addOpticalNoise_Callback;

XDAS.h.DAS.pushbutton_addCMN.ButtonPushedFcn            = @pushbutton_addCMN_Callback;
XDAS.h.DAS.edit_CMNSNR.ValueChangedFcn                  = @edit_cmnSNR_Callback;

XDAS.h.DAS.pushbutton_displayfk.ButtonPushedFcn         = @pushbutton_displayFK_Callback;
XDAS.h.DAS.pushbutton_displaySourceNum.ButtonPushedFcn  = @pushbutton_displaySourceNum_Callback;
XDAS.h.DAS.pushbutton_polarity.ButtonPushedFcn          = @pushbutton_polarity_Callback;
XDAS.h.DAS.pushbutton_noiseOnly.ButtonPushedFcn         = @pushbutton_noiseOnly_Callback;

XDAS.h.DAS.pushbutton_gainUp.ButtonPushedFcn            = @pushbutton_gainUp_Callback;
XDAS.h.DAS.pushbutton_gainDown.ButtonPushedFcn          = @pushbutton_gainDown_Callback;

