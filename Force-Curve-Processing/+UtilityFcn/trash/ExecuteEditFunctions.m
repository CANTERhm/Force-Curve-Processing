function handles = ExecuteEditFunctions(handles)
% EXECUTEEDITFUNCTIONS applies every function specified in Edit_procedure 
% (handles.guiprops.SubPanels.procedure_panel-property)

curvelist = fieldnames(handles.curveprops.DynamicProps);
funclist = handles.guiprops.procedure_functions;


% update handles-struct
guidata(handles.figure1, handles)
