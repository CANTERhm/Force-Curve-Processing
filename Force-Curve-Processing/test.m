table = handles.guiprops.Features.edit_curve_table;
curvename = table.UserData.CurrentCurveName;
xchannel = handles.guiprops.Features.curve_xchannel_popup.Value;
ychannel = handles.guiprops.Features.curve_ychannel_popup.Value;
RawData = handles.curveprops.(curvename).RawData;

LineData = UtilityFcn.ExtractPlotData(RawData, handles, xchannel, ychannel);
line = UtilityFcn.ConvertToVector(LineData);

figure();
hold on
plot(line(:,1), line(:,2));