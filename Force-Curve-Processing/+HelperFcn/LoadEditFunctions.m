function handles = LoadEditFunctions(handles)
% LOADEDITFUCNTIONS Load Edit functions to gui and, if available to
% curveporps

% if no procedure file has been chosen (cancel button in UIGetFilepath)
filenames = handles.guiprops.ProcedureFilePathObject.files;
if ~isa(filenames, 'cell') & filenames == 0
    return
end

if ~isempty(filenames)
    if ~isa(handles.procedure.DynamicProps, 'struct')
        handles = UtilityFcn.CreateProcedureFunctions(handles);
    end
end

if ~isempty(handles.curveprops.DynamicProps) 
    handles = HelperFcn.AddFunctionsToCurve(handles);
end

if isempty(handles.guiprops.Features.edit_buttons)
    handles = HelperFcn.AddFunctionsToGui(handles);
end

% update handles-structure
guidata(handles.figure1, handles);

