function UpdateDeflectionAdjustmentStatusCallback(src, evt, handles)
% UPDATEDEFLECTIONADJUSTMENTSTATUSCALLBACK Update Deflection_Adjustment Status LED, according
% to the adjustment status

status = handles.curveprops.DeflectionAdjusted;
led = handles.guiprops.Features.deflection_adjustment_status;
if status == true
    led.BackgroundColor = 'green';
else
    led.BackgroundColor = 'red';
end

