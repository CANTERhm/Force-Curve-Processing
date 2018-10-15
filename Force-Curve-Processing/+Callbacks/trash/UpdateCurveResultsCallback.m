function UpdateCurveResultsCallback(src, evt, handles)
% UPDATECURVERESULTSCALLBACK update the curveprops.curvename.Results-object
% if the edit_functions change

handles = HelperFcn.LoadEditFunctions(handles);
guidata(handles.figure1, handles);

