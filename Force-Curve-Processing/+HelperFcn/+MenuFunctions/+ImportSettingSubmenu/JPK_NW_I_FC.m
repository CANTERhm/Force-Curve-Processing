    function mainHandles = JPK_NW_I_FC(mainHandles)
% JPK_NW_I_FC update main-functions gui according to jpk-NW-I settings

%% delete previous layout
delete(allchild(mainHandles.custom_settings_vbox));

%% input from panel

% prevent flickering of panel elements while loading
mainHandles.custom_settings_vbox.Visible = 'off';

input_from_hbox = uix.HBox('Parent', mainHandles.custom_settings_vbox);
TextLabel('Parent', input_from_hbox,...
    'String', 'Input From:',...
    'VerticalAlignment', 'center');
popup_string = {'JPK NW-I standard', 'Custom Textfile'};
uicontrol('Parent', input_from_hbox,...
    'Style', 'popup',...
    'String', popup_string,...
    'Callback', @callback_popup);
general_purpos_vbox = uix.VBox('Parent', mainHandles.custom_settings_vbox);

% show custom_settings_vbox
mainHandles.custom_settings_vbox.Heights = [30, -1];
mainHandles.custom_settings_vbox.Visible = 'on';

%% update mainHandles-struct
guidata(mainHandles.mainDialog, mainHandles);

%% default layout
jpk_nw_I_standard_txt();

%% nested functions
    
    function jpk_nw_I_standard_txt()
        delete(allchild(general_purpos_vbox));
        mainHandles = guidata(mainHandles.mainDialog);
        mainHandles.settings = struct();
        
        mainHandles.settings.general_header_edit = {'jpk_general_header'};
        mainHandles.settings.segment_header_edit = {'jpk_fc_full_settings'};
        mainHandles.settings.delimiter_edit = {' '};
        mainHandles.settings.comment_style_edit = {'#'};
        mainHandles.settings.column_specifier_edit = {'columns:'};
        mainHandles.settings.search_query_edit = 'jpk-nw-I-standard-text';
        mainHandles.settings.InformationStyle = 'jpk-nanowizard-I';
        mainHandles.settings.CurvePartIdx.trace = [1; 2];
        mainHandles.settings.CurvePartIdx.retrace = [3; 6];
        
        %% update mainHandles-struct
        guidata(mainHandles.mainDialog, mainHandles);
    end

    function CustomTextfile()
        delete(allchild(general_purpos_vbox));
        mainHandles = guidata(mainHandles.mainDialog);
        mainHandles.settings = struct();
        
        % use fixed information style supposing, that we only import from
        % jpk nw afms and SearchQuery requires only minor adjustments.
        mainHandles.settings.InformationStyle = 'jpk-nanowizard-I';
        mainHandles.settings.CurvePartIdx.trace = [1; 2];
        mainHandles.settings.CurvePartIdx.retrace = [3; 6];
        
        % create and hide panel to prevent "flickering" during creation
        custompanel = uix.Panel('Parent', general_purpos_vbox,...
            'Padding', 5,...
            'Visible', 'off');
        custom_general_purpos_vbox = uix.VBox('Parent', custompanel);
        
        customgrid1 = uix.Grid('Parent', custom_general_purpos_vbox);
        customgrid2 = uix.Grid('Parent', custom_general_purpos_vbox);
        customgrid3 = uix.Grid('Parent', custom_general_purpos_vbox);
        customgrid4 = uix.Grid('Parent', custom_general_purpos_vbox);
        
        % customgrid1
        TextLabel('Parent', customgrid1,...
            'String', 'General Header Length:');
        TextLabel('Parent', customgrid1,...
            'String', 'Segment Header Length:');
        TextLabel('Parent', customgrid1,...
            'String', 'Delimiter:');
        TextLabel('Parent', customgrid1,...
            'String', 'Comment Style:');
        TextLabel('Parent', customgrid1,...
            'String', 'Column Specifier:');
        general_header_edit = uicontrol('Parent', customgrid1,...
            'Style', 'edit',...
            'Callback', @HelperFcn.MenuFunctions.ImportSettingSubmenu.JPK_NW_I_FC_callbacks.general_header_edit_callback);
        segment_header_edit = uicontrol('Parent', customgrid1,...
            'Style', 'edit',...
            'Callback', @HelperFcn.MenuFunctions.ImportSettingSubmenu.JPK_NW_I_FC_callbacks.segment_header_edit_callback);
        delimiter_edit = uicontrol('Parent', customgrid1,...
            'Style', 'edit',...
            'Callback', @HelperFcn.MenuFunctions.ImportSettingSubmenu.JPK_NW_I_FC_callbacks.delimiter_edit_callback);
        comment_style_edit = uicontrol('Parent', customgrid1,...
            'Style', 'edit',...
            'Callback', @HelperFcn.MenuFunctions.ImportSettingSubmenu.JPK_NW_I_FC_callbacks.comment_style_edit_callback);
        column_specifier_edit = uicontrol('Parent', customgrid1,...
            'Style', 'edit',...
            'Callback', @HelperFcn.MenuFunctions.ImportSettingSubmenu.JPK_NW_I_FC_callbacks.column_specifier_edit_callback);
        customgrid1.Heights =20*ones(1, 5);
        customgrid1.Widths = [-3 -1];
        
        %customgrid2
        fixed_column_checkbox = uicontrol('Parent', customgrid2,...
            'Style', 'checkbox');
        TextLabel('Parent', customgrid2,...
            'String', 'Fixed Column Num:');
        fixed_column_edit = uicontrol('Parent', customgrid2,...
            'Style', 'edit',...
            'Enable', 'off',...
            'Callback', @HelperFcn.MenuFunctions.ImportSettingSubmenu.JPK_NW_I_FC_callbacks.fixed_column_edit_callback);
        customgrid2.Heights = 20;
        customgrid2.Widths = [-0.5 -2.5 -1];
        
        % customgrid3
        TextLabel('Parent', customgrid3,...
            'String', 'Custom Search Query:')
        customgrid3.Heights = 20;
        customgrid3.Widths = -1;

        
        % customgrid4
        search_query_edit = uicontrol('Parent', customgrid4,...
            'Style', 'edit',...
            'HorizontalAlignment', 'left',...
            'Max', 2,...
            'Callback', @HelperFcn.MenuFunctions.ImportSettingSubmenu.JPK_NW_I_FC_callbacks.search_query_edit_callback);
        customgrid4.Heights = -1;
        customgrid4.Widths = -1;

        % adjust heights of custom_general_purpos_vbox
        custom_general_purpos_vbox.Heights = [100 20 20 -1];
        
        % finally show custompanel
        custompanel.Visible = 'on';

        %% property event listener
        lh = PropListener();

        % add listeners
        lh.addListener(fixed_column_checkbox, 'Value', 'PostSet',...
            {@HelperFcn.MenuFunctions.ImportSettingSubmenu.JPK_NW_I_FC_callbacks.fixed_column_checkbox_callback,...
            column_specifier_edit,...
            fixed_column_edit});
        
        %% update mainHandles-struct
        guidata(mainHandles.mainDialog, mainHandles);
        
    end % CustomTextfile

%% Callbacks

    function callback_popup(src, evt)
        switch src.Value
            case 1
                jpk_nw_I_standard_txt();
            case 2
                CustomTextfile();
        end
    end

end % JPK_NW_I_FC