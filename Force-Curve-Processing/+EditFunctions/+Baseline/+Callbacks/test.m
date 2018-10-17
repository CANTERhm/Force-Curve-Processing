function test(src, evt, left_border, right_border)

main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
handles = guidata(main);

data = getappdata(handles.figure1, 'Baseline');

left_border.String = num2str(data.selection_borders(1));
right_border.String = num2str(data.selection_borders(2));

disp(data);
