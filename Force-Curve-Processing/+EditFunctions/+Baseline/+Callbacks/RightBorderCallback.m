function RightBorderCallback(src, evt)
%LEFTBORDERCALLBACK update the right border edit on FCP-Apps results-panel
%   reacts to unser input in right borer edit; checks validity of input and
%   updates the result object

    % refresh results object
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    results = getappdata(handles.figure1, 'Baseline');
    
    %% validate user input
    input = src.String;
    num = str2double(input);
    
    % is input a number?
    if isnan(num) % input was not allowed 
        num = results.selection_borders(2);
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
    results.selection_borders(2) = num;
    
    %% update all important variables
    
    % update results object
    setappdata(handles.figure1, 'Baseline', results);
    guidata(handles.figure1, handles);

    % trigger update to handles.curveprops.curvename.Results.Baseline
    results.FireEvent('UpdateObject');

end % RightBorderCallback