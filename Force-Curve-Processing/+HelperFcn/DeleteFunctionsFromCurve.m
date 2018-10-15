function handles = DeleteFunctionsFromCurve(handles)
% DELETEFUNCTIONSFROMCURVE Delete Edit-Functions from
% handles.curveprops.curvename.Results-properta

% % refresh handles-struct
% main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
% handles = guidata(main);

Data = handles.guiprops.Features.edit_curve_table.Data;
edit_buttons = handles.guiprops.Features.edit_buttons;

if ~isempty(edit_buttons)
    functionnames = fieldnames(edit_buttons);
else
    return
end

if ~isempty(Data)
    curvenames = fieldnames(handles.curveprops.DynamicProps);
    for i = 1:length(curvenames) % go through curves
        for n = 1:length(functionnames)
            results = fieldnames(handles.curveprops.(curvenames{i}).Results);
            if any(ismember(results, functionnames{n}))
                handles.curveprops.(curvenames{i}).Results.delproperty(functionnames{n});
            end
        end
        handles.curveprops.(curvenames{i}).Results.DynamicProps = [];
    end
end

guidata(handles.figure1, handles);