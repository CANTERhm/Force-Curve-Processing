function RelativeUnitsValueChangedCallback(src, evt)
% RELATIVEUNITSVALUECHANGEDCALLBACK updates the units-property of the
% results-object according to the relative units radio button value

    %% create variables
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    table = handles.guiprops.Features.edit_curve_table;
    
    % abort if tabel is empty (means no curves loaded)
    if isempty(table.Data)
        return
    end
    
    curvename = table.UserData.CurrentCurveName;
    absolute = handles.procedure.Baseline.function_properties.gui_elements.setting_absolute_units_radio_btn;
    
    %% toggle like behavior of radio buttons
    if src.Value == 0
        absolute.Value = 1;
        handles.curveprops.(curvename).Results.Baseline.units = 'absolute';
    else
        absolute.Value = 0;
        handles.curveprops.(curvename).Results.Baseline.units = 'relative';
    end
    
    %% update handles-struct
    guidata(handles.figure1, handles);
end

