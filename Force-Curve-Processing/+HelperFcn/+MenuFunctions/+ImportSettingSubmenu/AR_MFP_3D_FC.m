function mainHandles = AR_MFP_3D_FC(mainHandles)
%AR_MFP_3D_FC update main-functions gui according to mfp-3d-settings

%% delete previous layout
delete(allchild(mainHandles.custom_settings_vbox));

%% input from panel

% prevent flickering of panel elements while loading
mainHandles.custom_settings_vbox.Visible = 'off';

input_from_hbox = uix.HBox('Parent', mainHandles.custom_settings_vbox);
TextLabel('Parent', input_from_hbox,...
    'String', 'Search Query:');
popup_string = {'AR MFP-3D standard', 'Custom Search Query'};
uicontrol('Parent', input_from_hbox,...
    'Style', 'popup',...
    'String', popup_string,...
    'Callback', @callback_popup);
general_purpos_vbox = uix.VBox('Parent', mainHandles.custom_settings_vbox);

% show custom_settings_vbox
mainHandles.custom_settings_vbox.Heights = [30, -1];
mainHandles.custom_settings_vbox.Visible = 'on';

%% default layout
ar_mfp_3d_standard();

%% update mainHandles-struct to mainDialog
guidata(mainHandles.mainDialog, mainHandles);

%% nested functions
    function ar_mfp_3d_standard()
        delete(allchild(general_purpos_vbox));
        mainHandles = guidata(mainHandles.mainDialog);
        mainHandles.settings = struct();
        
        mainHandles.settings.search_query_edit = 'mfp-3d-bio-standard';
        mainHandles.settings.InformationStyle = 'mfp-3d-bio';
        mainHandles.settings.CurvePartIdx.trace = [1; 1];
        mainHandles.settings.CurvePartIdx.retrace = [2; 2];
        
        %% update mainHandles-struct
        guidata(mainHandles.mainDialog, mainHandles);
        
    end % ar_mfp_3d_standard

    function CustomSearchQuery()
        delete(allchild(general_purpos_vbox));
        mainHandles = guidata(mainHandles.mainDialog);
        mainHandles.settings = struct();
        
        % use fixed information style supposing, that we only import from
        % ar mfp-3d afms and SearchQuery requires only minor adjustments.
        mainHandles.settings.InformationStyle = 'mfp-3d-bio';
        mainHandles.settings.CurvePartIdx.trace = [1; 1];
        mainHandles.settings.CurvePartIdx.retrace = [2; 2];
        
        % Visible off, prevent flickering of elements while loading
        custompanel = uix.Panel('Parent', general_purpos_vbox,...
            'Padding', 5,...
            'Visible', 'off');
        custom_general_purpos_vbox = uix.VBox('Parent', custompanel);
        
        customgrid1 = uix.Grid('Parent', custom_general_purpos_vbox);
        customgrid2 = uix.Grid('Parent', custom_general_purpos_vbox);
        
        % customgrid1
        TextLabel('Parent', customgrid1,...
            'String', 'Custom Search Query:');
        customgrid1.Heights = 20;
        customgrid1.Widths = -1;
        
        % customgrid2
        search_query_eidt = uicontrol('Parent', customgrid2,...
            'Style', 'edit',...
            'HorizontalAlignment', 'left',...
            'Max', 2,...
            'Callback', @HelperFcn.MenuFunctions.ImportSettingSubmenu.AR_MFP_3D_FC_callbacks.search_query_edit_callback);
        customgrid2.Heights = -1;
        customgrid2.Widths = -1;
        
        % adjust heights of custom_general_purpos_vbox
        custom_general_purpos_vbox.Heights = [20 -1];
        
        % show custompanel
        custompanel.Visible = 'on';
        
        %% update mainHandles-struct
        guidata(mainHandles.mainDialog, mainHandles);
        
    end % CustomSearchQuery

%% callbacks
    function callback_popup(src, evt)
        switch src.Value
            case 1
                ar_mfp_3d_standard();
            case 2
                CustomSearchQuery();
        end
    end % callback_popup

end % AR_MFP_3D_FC
