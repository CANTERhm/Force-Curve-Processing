function WindowResizeCallback(src, evt)
%TABLERESIZECALLBACK Executes if FCP-App size changes

handles = guidata(src);

% Resize handles.guiprops.Features.edit_curve_table columns
try
    table = handles.guiprops.Features.edit_curve_table;
catch ME % if you can
    switch ME.identifier
        case 'MATLAB:UndefinedFunction'
            % move on
            table = [];
        case 'MATLAB:nonExistentField' % no edit_curve_table in handles.guiprops.Featues
            % move on
            table = [];
        otherwise
            rethrow(ME);
    end
    
end
if ~isempty(table)
    UtilityFcn.CalculateColumnWidth(table, [0.75 0.25]);
    handles.guiprops.Features.edit_curve_table = table;
end

% update handles structure
guidata(handles.figure1, handles)


