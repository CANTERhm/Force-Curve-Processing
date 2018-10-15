function UpdateProcedureFunctionsCallback(src, evt, handles)
% UPDATEPROCEDUREFUNCTIONS load processing-functions from procedure-file to
% the handles.curveprops.curvename.Results-property

if isempty(handles.curveprops.DynamicProps)
    return
end

curvelist = fieldnames(handles.curveprops.DynamicProps);
procedurelist = handles.guiprops.procedure_functions;

for i = 1:length(curvelist)
    results = handles.curveprops.(curvelist{i}).Results;
    for n = 1:length(procedurelist)
        if ~any(ismember(properties(results), procedurelist{n}))
            results.addproperty(procedurelist{n});
        end
    end
    handles.curveprops.(curvelist{i}).Results = results;
end

guidata(handles.figure1, handles);



