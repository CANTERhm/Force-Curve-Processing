function handles = UpdateGuiElements(handles)
% UPDATEGUIELEMENTS update the inidcation (calucaltion_status) from
% EidtFunction: Tip Sample Seperation

    %% create variables
    table = handles.guiprops.Features.edit_curve_table;
    
    % abort if tabel is empty (means no curves loaded)
    if isempty(table.Data) || isempty(table.UserData)
        return
    end
    
    curvename = table.UserData.CurrentCurveName;
    calculation_status = handles.procedure.TipSampleSeperation.function_properties.gui_elements.calculation_status;
    status = handles.curveprops.(curvename).Results.TipSampleSeperation.calculation_status;
    
    if status
        calculation_status.BackgroundColor = 'green';
    else
        calculation_status.BackgroundColor = 'red';
    end

end

