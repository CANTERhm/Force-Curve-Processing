function new_borders = BorderTransformation(linedata, direction)
    % calculation of new borders according to transformation direction
    %
    % input: 
    %   - linedata: vecotrized curvedata (means nx2-vector of force-curve)
    %   - direction: transformation direction
    %       *absolute-relative: transformation from absolute values to
    %       relative vaules
    %       * relative-absolute: transformation from relative-values to
    %       absolute-values
    %
    % output:
    %   - new_borders: transformed selection_borders-values

    
    % get results-object
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    results = getappdata(handles.figure1, 'Baseline');
    
    old_borders = results.selection_borders;
    switch direction
        case 'absolute-relative'
            xdata = linedata(:,1);
            x = length(xdata);
            a_left = old_borders(1);
            a_right = old_borders(2);
            aind_left = knnsearch(xdata, a_left);
            aind_right = knnsearch(xdata, a_right);

            % left border
            r_left = aind_left/x;

            % right border
            r_right = aind_right/x;

            new_borders = [r_left r_right];
        case 'relative-absolute'
            x = linedata(:,1);

            % left border
            a_left_index = round(length(x)*old_borders(1));
            if a_left_index == 0
                a_left_index = 1;
            end
            a_left = x(a_left_index);

            % right border
            a_right_index = round(length(x)*old_borders(2));
            if a_right_index == 0
                a_right_index = 1;
            end
            a_right = x(a_right_index);

            new_borders = [a_left a_right];
    end

    % refresh results object and handles
    setappdata(handles.figure1, 'Baseline', results);
    guidata(handles.figure1, handles);

    % trigger update to handles.curveprops.curvename.Results.Baseline
    results.FireEvent('UpdateObject');
    
end % BorderTransformation

