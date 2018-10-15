function UpdateForceCurveStatusCallback(src, evt, handles)
%UPDATEFORCECURVESTATUSCALLBACK Updates the Froce-Curve Type status on
%FCP-App Processing Information panel according to
%handles.settings.InformationStyle Property

infostyle = handles.curveprops.settings.InformationStyle;
label = handles.guiprops.Features.curve_type_status;
label.String = infostyle;

end % UpdateForceCurveStatusCallback

