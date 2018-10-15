function input_features = layout_input(main_vbox)
% INPUT_FEATURES cares about the layout of inputparameter on FCP-App
    
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    results = getappdata(handles.figure1, 'Baseline');

    settings_panel = uix.Panel('Parent', main_vbox,...
        'Padding', 10,...
        'Tag', 'settings_panel',...
        'Title', 'Settings');
    settings_vbox = uix.VBox('Parent', settings_panel,...
        'Tag', 'settings_vbox');

    grid1 = uix.Grid('Parent', settings_vbox,...
        'Tag', 'settings_grid1',...
        'Spacing', 5);
    grid2 = uix.Grid('Parent', settings_vbox,...
        'Tag', 'settings_grid2',...
        'Spacing', 5);

    %% grid1
    
    % tilt or tilt_offset checkbox
    switch results.correction_type
        case 1
            tilt_value = 1;
            tilt_offset_value = 0;
        case 2
            tilt_value = 0;
            tilt_offset_value = 1;
    end
    
    % absolute or relative checkbox
    switch results.units
        case 'absolute'
            absolute_units_value = 1;
            relative_units_value = 0;
        case 'relative'
            absolute_units_value = 0;
            relative_units_value = 1;
    end
    
    % label for tilt
    tilt_label = TextLabel('Parent', grid1,...
        'String', 'Tilt');
    tilt_label.Tag = 'tilt_label';

    % label for relative units
    relative_units_label = TextLabel('Parent', grid1,...
        'String', 'Relative Units');
    relative_units_label.Tag = 'relative_units_label';

    % checkbox for tilt
    tilt = uicontrol('Parent', grid1,...
        'Style', 'checkbox',...
        'Value', tilt_value,...
        'Tag', 'tilt'); 

    % checkbox and for relative units
    relative_units = uicontrol('Parent', grid1,...
        'Style', 'checkbox',...
        'Value', relative_units_value,...
        'Tag', 'relative_units');

    % label for tilt and offset
    tilt_offset_label = TextLabel('Parent', grid1,...
        'String', 'Tilt + Offset');
    tilt_offset_label.Tag = 'tilt_offset_label';

    % label for absolute units
    absolute_units_label = TextLabel('Parent', grid1,...
        'String', 'Absolute Units');
    absolute_units_label.Tag = 'absolute_units_label';

    % checkbox for tilt and offset
    tilt_offset = uicontrol('Parent', grid1,...
        'Style', 'checkbox',...
        'Value', tilt_offset_value,...
        'Tag', 'tilt_offset');

    % checkbox for absolut values
    absolute_units = uicontrol('Parent', grid1,...
        'Style', 'checkbox',...
        'Value', absolute_units_value,...
        'Tag', 'absolute_units');

    grid1.Heights = [-1 -1];
    grid1.Widths = [-1 -1 -1 -0.15];

    %% grid2
    
    % label for left Border 
    left_border_label = TextLabel('Parent', grid2,...
        'String', 'Left Border:');
    left_border_label.Tag = 'left_border_label';

    % edit for left border
    left_border = uicontrol('Parent', grid2,...
        'Style', 'edit',...
        'String', num2str(results.selection_borders(1)),...
        'Tag', 'left_border',...
        'Callback', '');

    % label for right border
    right_border_label = TextLabel('Parent', grid2,...
        'String', 'Right Border:');
    right_border_label.Tag = 'right_border_label';

    % edit for right border
    right_border = uicontrol('Parent', grid2,...
        'Style', 'edit',...
        'String', num2str(results.selection_borders(2)),...
        'Tag', 'right_border',...
        'Callback', '');

    grid2.Heights = -1;
    grid2.Widths = [-1 -1 -1 -1];


    %% settings_panel heights
    settings_vbox.Heights = [40 20];

    %% output
    input_features.tilt = tilt;
    input_features.tilt_offset = tilt_offset;
    input_features.relative_units = relative_units;
    input_features.absolute_units = absolute_units;
    input_features.tilt_label = tilt_label;
    input_features.tilt_offset_label = tilt_offset_label;
    input_features.relative_units_label = relative_units_label;
    input_features.absolute_units_label = absolute_units_label;

    input_features.left_border = left_border;
    input_features.right_border = right_border;
    input_features.left_border_label = left_border_label;
    input_features.right_border_label = right_border_label;
    
    input_features.settings_panel = settings_panel;
    input_features.settings_vbox = settings_vbox;
    input_features.settings_grid1 = grid1;
    input_features.settings_grid2 = grid2;
    
    setappdata(handles.figure1, 'Baseline', results);
    guidata(handles.figure1, handles);
    
end % layout_input
