function CellSelectionCallback(src, evt, handles)
%CELLEDITCALLBACK Summary of this function goes here

if ~isempty(evt.Indices)
    
    % activating all connected listeners to UpdateObject-Event
    handles.guiprops.FireEvent('UpdateObject');
    
    % determine curvename
    row = evt.Indices(1, 1);
    curvename = src.Data{row, 1};
    
    % Update handles.curveprops.curvename.Results-property with
    % edit_functions
    dynprops = handles.curveprops.(curvename).Results.DynamicProps;
    if ~isempty(handles.procedure.DynamicProps) && isempty(dynprops)
        handles = HelperFcn.AddFunctionsToCurve(handles);
    end
    
    %% update specific guiprops and curveprops properties
    src.UserData.CurrentRowIndex = row;
    src.UserData.CurrentRowSpan = [evt.Indices(1, 1); evt.Indices(end, 1)];
    src.UserData.CurrentCurveName = curvename;
    handles.curveprops.CurrentCurveName = curvename;
    %% recalculate all editfunctions
    % also replot the graph according to the active edit function if one
    % has been loaded
    UtilityFcn.ExecuteAllEditFcn
    
    %% replot graph if no edit functions have been loaded or procedure_root_btn is active
    xchannel_value = handles.guiprops.Features.curve_xchannel_popup.Value;
    ychannel_value = handles.guiprops.Features.curve_ychannel_popup.Value;
    edit_buttons = handles.guiprops.Features.edit_buttons;
    
    edit_functions = allchild(handles.guiprops.Panels.processing_panel);
    to_test = false(length(edit_functions), 1);
    for i = 1:length(to_test)
        if edit_functions(i).Value == 1
            to_test(i) = true;
        end
    end
    active_edit_function = edit_functions(to_test);
    
    if isempty(edit_buttons) || strcmp(active_edit_function.Tag, 'procedure_root_btn')
        UtilityFcn.RefreshGraph([], [],...
            xchannel_value,...
            ychannel_value,...
            'RefreshAll', true);
    end
    
    
end
guidata(handles.figure1, handles);


