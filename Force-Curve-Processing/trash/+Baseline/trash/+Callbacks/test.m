function test(src, evt)

main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
handles = guidata(main);

data = getappdata(handles.figure1, 'Baseline');

EditFunctions.Baseline.HelperFcn.MarkupData();

disp(data);
