function UpdateCalibrationStatusCallback(src, evt, handles)
% UPDATECALIBRATIONSTATUSCALLBACK Update Calibration Status LED, according
% to the calibration status

status = handles.curveprops.Calibrated;
led = handles.guiprops.Features.calibration_status;
if status == true
    led.BackgroundColor = 'green';
else
    led.BackgroundColor = 'red';
end