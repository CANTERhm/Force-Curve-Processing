function handles = UISetSavepath(handles)
%UISETSAVEPATH set path to save for processed curves

if isempty(handles.guiprops.SavePathObject)
    savepath = FilePath();
else
    savepath = handles.guiprops.SavePathObject;
end

savepath = savepath.uigetdir();

handles.guiprops.SavePathObject = savepath;
guidata(handles.figure1, handles)
