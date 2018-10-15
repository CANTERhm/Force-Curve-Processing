function handles = AddFunctionsToCurve(handles)
% ADDFUNCTIONSTOCURVE Add procedure functions to the loaded afm-curves in
% handles.curveprops-property

Data = handles.guiprops.Features.edit_curve_table.Data;
if ~isempty(Data)
    curvelist = fieldnames(handles.curveprops.DynamicProps);
else
    curvelist = [];
end
if ~isempty(handles.procedure.DynamicProps)
    procedurelist = fieldnames(handles.procedure.DynamicProps);
else
    procedurelist = [];
end

for i = 1:length(curvelist)
    results = handles.curveprops.(curvelist{i}).Results;
    for n = 1:length(procedurelist)
        if ~any(ismember(properties(results), procedurelist{n}))
            results.addproperty(procedurelist{n});
        end
    end
end

% update handles-structure
if ~isempty(curvelist)
    handles.curveprops.(curvelist{i}).Results = results;
end
guidata(handles.figure1, handles);