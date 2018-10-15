function main_filespecifier_label_callback(src, evt, mainHandles)
%MAIN_FILESPECIFIER_LABLE_CALLBACK update filespecifier-label on
%calibrate-curves-submenu

if isempty(mainHandles.handles)
    src.String = '';
    return
end
specifier = mainHandles.handles.curveprops.settings.FileSpecifier;
specifier(1) = [];
src.String = specifier;
