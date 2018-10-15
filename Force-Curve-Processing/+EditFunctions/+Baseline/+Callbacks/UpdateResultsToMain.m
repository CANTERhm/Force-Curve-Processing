function UpdateResultsToMain(src, evt, handles, results)
%UPDATERESULTSTOMAIN wirte Baseline results object to handles
%   write it to handles.curveprops.curvename.Results.Baseline, if this
%   field exits

table = handles.guiprops.Features.edit_curve_table;
    
    % abort function, if no curve was loaded
    if isempty(table.Data)
        return
    end
    
    % abort function if Basline is not registered in curvename.Results
    names = fieldnames(handles.curveprops.(table.UserData.CurrentCurveName).Results);
    if ~ismember(names, 'Baseline')
        return
    end
    
    handles.curveprops.(table.UserData.CurrentCurveName).Results.Baseline = results;
    
    % update handles-struct
    guidata(handles.figure1, handles);

end % UpdateResultsToMain

