function SetInputElements(varargin)
%SETINPUTELEMENTS Setup Graphical Elements for Inputparameter
%   Set Graphical Elements for the aquisition of Inputparameters of
%   the activated Editfunction

    %% handles and results-object
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    results = getappdata(handles.figure1, 'VerticalTipPosition');
    
    %% variables
    curve_xchannel_popup_string = handles.guiprops.Features.curve_xchannel_popup.String;
    curve_ychannel_popup_string = handles.guiprops.Features.curve_ychannel_popup.String;
    if handles.curveprops.Calibrated
        handles_springconstant_value = num2str(handles.curveprops.CalibrationValues.SpringConstant);
        handles_sensitivity_value = num2str(handles.curveprops.CalibrationValues.Sensitivity);
    else
        handles_springconstant_value = '...';
        handles_sensitivity_value = '...';
    end
    
    % channel values
    if isempty(results.settings_xchannel_popup_value)
        curve_xchannel_popup_value = handles.guiprops.Features.curve_xchannel_popup.Value;
    else
        curve_xchannel_popup_value = results.settings_xchannel_popup_value;
    end
    if isempty(results.settings_ychannel_popup_value)
        curve_ychannel_popup_value = handles.guiprops.Features.curve_ychannel_popup.Value;
    else
        curve_ychannel_popup_value = results.settings_ychannel_popup_value;
    end
    
    %% main panels
    container = varargin{1};
    panel = uix.Panel('Parent', container,...
        'Title', 'Settings',...
        'Tag', 'vtp_settings_panel',...
        'Padding', 10);
    vbox = uix.VBox('Parent', panel,...
        'Tag', 'vtp_settings_vbox');
    
    grid1 = uix.Grid('Parent', vbox,...
        'Spacing', 5,...
        'Tag', 'vtp_settings_grid_1');
    grid2 = uix.Grid('Parent', vbox,...
        'Spacing', 5,...
        'Tag', 'vtp_settings_grid_2');
    grid3 = uix.Grid('Parent', vbox,...
        'Spacing', 5,...
        'Tag', 'vtp_settings_grid_3');
    
    %% disclaimer
    format = '%s\n%s';
    disclaimer_text = sprintf(format,...
        ['- ychannel: A signal representating the vertical Deflection of the Cantilever',...
        ' either as Force in N (use SpringConstant to calculate the vertical tip position),',...
        ' or as Sensorsignal in V (use Sensitivity to calculate the vertical tip position)'],...
        '- xchannel: A signal representating the piezo height in m');
    disclaimer = uicontrol('Parent', grid1,...
        'Style', 'text',...
        'HorizontalAlignment', 'left',...
        'Tag', 'vtp_settings_disclaimer_label',...
        'String', disclaimer_text);
    grid1.Heights = -1;
    grid1.Widths = -1;
    
    %% channel settings
    
    xchannel_label = uicontrol('Parent', grid2,...
        'Style', 'text',...
        'HorizontalAlignment', 'left',...
        'Tag', 'vtp_settings_xchannel_label',...
        'String', 'xchannel:');
    ychannel_label = uicontrol('Parent', grid2,...
        'Style', 'text',...
        'HorizontalAlignment', 'left',...
        'Tag', 'vtp_settings_ychannel_label',...
        'String', 'ychannel:');
    
    xchannel_popup = uicontrol('Parent', grid2,...
        'Style', 'popupmenu',...
        'Tag', 'vtp_settings_xchannel_popup',...
        'String', curve_xchannel_popup_string,...
        'Value', curve_xchannel_popup_value,...
        'Callback', @EditFunctions.VerticalTipPosition.Callbacks.ElementCallbacks.SettingsXchannelCallback);
    ychannel_popup = uicontrol('Parent', grid2,...
        'Style', 'popupmenu',...
        'Tag', 'vtp_settings_ychannel_popup',...
        'String', curve_ychannel_popup_string,...
        'Value', curve_ychannel_popup_value,...
        'Callback', @EditFunctions.VerticalTipPosition.Callbacks.ElementCallbacks.SettingsYchannelCallback);
    
    grid2.Heights = [20 20];
    grid2.Widths = [-1 -1];
    
    %% calculation settings
    tooltip = 'VTM = xchannel - ychannel/SpringConstant';
    springconstant_label = uicontrol('Parent', grid3,...
        'Style', 'text',...
        'HorizontalAlignment', 'left',...
        'Tag', 'vtp_settings_sprinconstant_label',...
        'Tooltip', tooltip,...
        'String', 'SpringConstant:');
    tooltip = 'VTM = xchannel - ychannel*Sensitivity';
    sensitivity_label = uicontrol('Parent', grid3,...
        'Style', 'text',...
        'HorizontalAlignment', 'left',...
        'Tag', 'vtp_settings_sensitivity_label',...
        'Tooltip', tooltip,...
        'String', 'Sensitivity:');
    
    springconstant_value = uicontrol('Parent', grid3,...
        'Style', 'text',...
        'HorizontalAlignment', 'right',...
        'Tag', 'vtp_settings_springconstant_value',...
        'String', handles_springconstant_value);
    sensitivity_value = uicontrol('Parent', grid3,...
        'Style', 'text',...
        'HorizontalAlignment', 'right',...
        'Tag', 'vtp_settings_sensitivityt_value',...
        'String', handles_sensitivity_value);
    
    springconstant_unit = uicontrol('Parent', grid3,...
        'Style', 'text',...
        'Tag', 'vtp_settings_springconstant_unit',...
        'String', 'N/m');
    sensitivity_unit = uicontrol('Parent', grid3,...
        'Style', 'text',...
        'Tag', 'vtp_settings_sensitivity_unit',...
        'String', 'm/V');
    
    springconstant_checkbox = uicontrol('Parent', grid3,...
        'Style', 'checkbox',...
        'Tag', 'vtp_settings_springconstant_checkbox',...
        'Value', 1);
    sensitivity_checkbox = uicontrol('Parent', grid3,...
        'Style', 'checkbox',...
        'Tag', 'vtp_settings_sensitivity_checkbox',...
        'Value', 0);
    
    springconstant_checkbox.Callback = {@EditFunctions.VerticalTipPosition.Callbacks.ElementCallbacks.SettingsSpringconstantCallback,...
        [springconstant_checkbox; sensitivity_checkbox]};
    sensitivity_checkbox.Callback = {@EditFunctions.VerticalTipPosition.Callbacks.ElementCallbacks.SettingsSensitivityCallback,...
        [springconstant_checkbox; sensitivity_checkbox]};
    
    grid3.Heights = [20 20];
    grid3.Widths = [-1 -1 -0.5 -1];
    
    %% adjust panel positions
    vbox.Heights = [95 70 60];
  
    %% update handles and results-object
    
    results = results.addproperty('input_elements');
    
    input_elements.panel = panel;
    input_elements.vbox = vbox;
    input_elements.grid1 = grid1;
    input_elements.grid2 = grid2;
    input_elements.grid3 = grid3;
    
    % grid1
    input_elements.disclaimer = disclaimer;
    
    % grid2
    input_elements.xchannel_label = xchannel_label;
    input_elements.ychannel_label = ychannel_label;
    input_elements.xchannel_popup = xchannel_popup;
    input_elements.ychannel_popup = ychannel_popup;
    
    % grid3
    input_elements.springconstant_label = springconstant_label;
    input_elements.sensitivity_label = sensitivity_label;
    input_elements.springconstant_value = springconstant_value;
    input_elements.sensitivity_value = sensitivity_value;
    input_elements.springconstant_unit = springconstant_unit;
    input_elements.sensitivity_unit = sensitivity_unit;
    input_elements.springconstant_checkbox = springconstant_checkbox;
    input_elements.sensitivity_checkbox = sensitivity_checkbox;
    
    % defaults for results-object
    results.settings_xchannel_popup_value = curve_xchannel_popup_value;
    results.settings_ychannel_popup_value = curve_ychannel_popup_value;
    results.settings_springconstant_checkbox_value = 1;
    results.settings_sensitivity_checkbox_value = 0;
    
    results.input_elements = input_elements;
    
    setappdata(handles.figure1, 'VerticalTipPosition', results);
    guidata(handles.figure1, handles);

end % SetInputElements

