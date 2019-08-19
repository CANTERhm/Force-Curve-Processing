function handles = UpdateGuiElements(handles)
% UPDATEGUIELEMENTS Updates all gui-elements, if they have been created and
% the next curve has been chosen

    %% create variables
    table = handles.guiprops.Features.edit_curve_table;
    
    % abort if tabel is empty (means no curves loaded)
    if isempty(table.Data) || isempty(table.UserData)
        return
    end
    
    curvename = table.UserData.CurrentCurveName;
    baseline = handles.curveprops.(curvename).Results.Baseline;
    
    %% update the gui

end

