function UpdateBorderEditsCallback(src, evt, left_border, right_border)
% Callback to react on changes of selection_borders-property

% refresh results object
main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
handles = guidata(main);
results = getappdata(handles.figure1, 'Baseline');

left_border.String = num2str(results.selection_borders(1));
right_border.String = num2str(results.selection_borders(2));

