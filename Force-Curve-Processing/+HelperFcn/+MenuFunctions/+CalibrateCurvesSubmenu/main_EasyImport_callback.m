function main_EasyImport_callback(src, evt, mainHandles)
%MAIN_EASYIMPORT_CALLBACK updates EasyImoport Label on Calibrate Curves
%Submenu according to EasyImport Settings

if isempty(mainHandles.handles)
    src.String = 'False';
    return
end

switch mainHandles.handles.curveprops.settings.EasyImport
    case true
        src.String = 'True';
    case false
        src.String = 'False';
end