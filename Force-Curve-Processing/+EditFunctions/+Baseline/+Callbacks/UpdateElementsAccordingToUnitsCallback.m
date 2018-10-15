function UpdateElementsAccordingToUnitsCallback(src, evt)
%UPDATEELEMENTSACCORDINGTOUNITSCALLBACK Porpertylistener callback to update
%left/right border edit according to results.units-property

% get results-object
main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
handles = guidata(main);
results = getappdata(handles.figure1, 'Baseline');

switch results.units
    case 'relative'
        new_borders = ExpressAsRelative(handles, results);
    case 'absolute'
        new_borders = ExpressAsAbsolute(handles, results);
end

end % UpdateElementsAccordingToUnitsCallback

