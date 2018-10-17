function MarkupData()
%MARKUPDATA Marksup data between selection_borders property
%  	Tracks the selection_borders property via
%   propertylistener and marks up the range according to this property
%   on FCP GraphWindow.

    %% refresh handles and results
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    results = getappdata(main, 'Baseline');
    
    %% markup datarange
    
    % transform relative units to absolute
    if strcmp(results.units, 'relative')
    else
    end
    
    
    %% update handles, results and fire event UpdateObject
    % update results object
    setappdata(handles.figure1, 'Baseline', results);
    guidata(handles.figure1, handles);

    % trigger update to handles.curveprops.curvename.Results.Baseline
    results.FireEvent('UpdateObject');
    
    %% nested functions
    
    function absolute = TransformToAbsolute(results, handles)
        
        % preparation of needed variables
        table = handles.guiprops.Features.edit_curve_table;
        xchannel = handles.guiprops.Features.curve_xchannel_popup.Value;
        ychannel = handles.guiprops.Features.curve_ychannel_popup.Value;
        curvename = table.UserData.CurrentCurveName;
        RawData = handles.curveprops.(curvename).RawData;
        editfunctions = allchild(handles.guiprops.Panels.processing_panel);
        baseline = findobj(editfunctions, 'Tag', 'Baseline');
        last_editfunction_index = find(editfunctions == baseline) + 1;
        last_editfunction = editfunctions(last_editfunction_index).Tag;
        
        % transformation of borders
            x = linedata(:,1);

            % left border
            a_left_index = round(length(x)*old_borders(1));
            a_left = x(a_left_index);

            % right border
            a_right_index = round(length(x)*old_borders(2));
            a_right = x(a_right_index);

            new_borders = [a_left a_right];
        
    end % TransformToAbsolute
end % MarkupData

