function new_borders = BorderTransformation(linedata, direction, varargin)
    % calculation of new borders according to transformation direction
    %
    % input: 
    %   - linedata: vecotrized curvedata (means nx2-vector of force-curve)
    %   - direction: transformation direction
    %       *absolute-relative: transformation from absolute values to
    %       relative vaules
    %       * relative-absolute: transformation from relative-values to
    %       absolute-values
    % Name-Value-Pairs:
    %   - user_defined_borders: 1x2 vector representing left and right
    %   border for Markup of dataselection; if this parameter is set, it
    %   will be used instead of results.selection_borders as
    %   old_borders-varaible. (Window Callback defined in Baseline use this Parameter)
    %
    % output:
    %   - new_borders: transformed selection_borders-values
    
    %% input parsing
    p = inputParser;
    
    ValidBorders = @(x)assert(isa(x, 'double') && isvector(x),...
        'Baseline:HelperFcn:BorderTransformation:invalidInput',...
        'Only an 1x2 double vector is an valid input for "unser_defined_borders".');
    
    addRequired(p, 'linedata');
    addRequired(p, 'direction');
    addParameter(p, 'user_defined_borders', [], ValidBorders);
    
    parse(p, linedata, direction, varargin{:});
    
    linedata = p.Results.linedata;
    direction = p.Results.direction;
    user_defined_borders = p.Results.user_defined_borders;
    
    %% function procedure
    
    % get results-object
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    table = handles.guiprops.Features.edit_curve_table;
    curvename = table.UserData.CurrentCurveName;
    if isprop(handles.curveprops.(curvename).Results, 'Baseline')
        results = handles.curveprops.(curvename).Results.Baseline;
    end
%     results = getappdata(handles.figure1, 'Baseline');
    
    if isempty(user_defined_borders)
        old_borders = results.selection_borders;
    else
        old_borders = user_defined_borders;
    end
    
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
%     setappdata(handles.figure1, 'Baseline', results);
    handles.curveprops.(curvename).Results.Baseline = results;
    guidata(handles.figure1, handles);

    % trigger update to handles.curveprops.curvename.Results.Baseline
    results.FireEvent('UpdateObject');
    
end % BorderTransformation

