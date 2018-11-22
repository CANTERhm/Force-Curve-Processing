function SetInputElements(PanelObject)
%SETINPUTELEMENTS Setup Graphical Elements for Inputparameter
%   Set Graphical Elements for the aquisition of Inputparameters of
%   the activated Editfunction

    % handles and results-object
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    results = getappdata(handles.figure1, 'Baseline');
    
    %% setup panels
    settings_panel = uix.Panel('Parent', PanelObject,...
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
    
    % label for tilt
    tilt_label = uicontrol('Parent', grid1,...
        'Style', 'text',...
        'HorizontalAlignment', 'left',...
        'String', 'Tilt:');
    tilt_label.Tag = 'tilt_label';

    % checkbox for tilt
    tilt = uicontrol('Parent', grid1,...
        'Style', 'checkbox',...
        'Value', tilt_value,...
        'Tag', 'tilt'); 

    % label for tilt and offset
    tilt_offset_label = uicontrol('Parent', grid1,...
        'Style', 'text',...
        'HorizontalAlignment', 'left',...
        'String', 'Tilt + Offset:');
    tilt_offset_label.Tag = 'tilt_offset_label';

    % checkbox for tilt and offset
    tilt_offset = uicontrol('Parent', grid1,...
        'Style', 'checkbox',...
        'Value', tilt_offset_value,...
        'Tag', 'tilt_offset');

    grid1.Heights = -1;
    grid1.Widths = [-1 -1 -1 -1];
    
    %% grid2
    
    % label for left Border 
    left_border_label = uicontrol('Parent', grid2,...
        'Style', 'text',...
        'HorizontalAlignment', 'left',...
        'String', 'Left Border:');
    left_border_label.Tag = 'left_border_label';

    % edit for left border
    left_border = uicontrol('Parent', grid2,...
        'Style', 'edit',...
        'String', num2str(results.selection_borders(1)),...
        'Tag', 'left_border',...
        'Callback', '');

    % label for right border
    right_border_label = uicontrol('Parent', grid2,...
        'Style', 'text',...
        'HorizontalAlignment', 'left',...
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
    settings_vbox.Heights = [15 20];
    settings_vbox.Spacing = 20;
    
    %% update handles and results-object
    
    results = results.addproperty('input_elements');
    
    input_elements.tilt = tilt;
    input_elements.tilt_offset = tilt_offset;
    input_elements.tilt_label = tilt_label;
    input_elements.tilt_offset_label = tilt_offset_label;

    input_elements.left_border = left_border;
    input_elements.right_border = right_border;
    input_elements.left_border_label = left_border_label;
    input_elements.right_border_label = right_border_label;
    
    input_elements.settings_panel = settings_panel;
    input_elements.settings_vbox = settings_vbox;
    input_elements.settings_grid1 = grid1;
    input_elements.settings_grid2 = grid2;
    results.input_elements = input_elements;
    
    setappdata(handles.figure1, 'Baseline', results);
    guidata(handles.figure1, handles);

end % SetInputElements
