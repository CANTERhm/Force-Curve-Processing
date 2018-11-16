function LeftBorderCallback(src, evt)
%LEFTBORDERCALLBACK update the left border edit on FCP-Apps results-panel
%   reacts to unser input in left borer edit; checks validity of input and
%   updates the result object

    % refresh results object
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    table = handles.guiprops.Features.edit_curve_table;
    curvename = table.UserData.CurrentCurveName;
    if isprop(handles.curveprops.(curvename).Results, 'Baseline')
        results = handles.curveprops.(curvename).Results.Baseline;
    end
%     results = getappdata(handles.figure1, 'Baseline');
    
    %% validate user input
    input = src.String;
    num = str2double(input);
    
    % is input a number?
    if isnan(num) % input was not allowed 
        num = results.selection_borders(1);
    end
    
    % relative units?
    if strcmp(results.units, 'relative')
        if num < 0 % too small
            num = 0;
        end
        if num > 1 % too big
            num = 1;
        end
    end
    
    % apply input 
    src.String = num2str(num);
    results.selection_borders(1) = num;
    
    %% update all important varaibles
    
    % update results object
%     setappdata(handles.figure1, 'Baseline', results);
    handles.curveprops.(curvename).Results.Baseline = results;
    guidata(handles.figure1, handles);

    % trigger update to handles.curveprops.curvename.Results.Baseline
    results.FireEvent('UpdateObject');

end % LeftBorderCallback

