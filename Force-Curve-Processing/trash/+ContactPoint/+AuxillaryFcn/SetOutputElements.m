function SetOutputElements(varargin)
%SETOUTPUTELEMENTS Setup Graphical Elements for Outputparameter
%   Set Graphical Elements for the representation of Outputparameters of
%   the activated Editfunction

    %% handles and results-object
    [~, handles, results] = UtilityFcn.GetCommonVariables('ContactPoint');
    
    %% variables
    value = results.offset;
    unit_idx = handles.guiprops.Features.curve_xchannel_popup.Value;
    table = handles.guiprops.Features.edit_curve_table;
    if ~isempty(table.Data)
        curvename = table.UserData.CurrentCurveName;
        SpecialInformation = handles.curveprops.(curvename).RawData.SpecialInformation;
        if ~isempty(SpecialInformation)
            units = SpecialInformation.Segment1.units;
        else
            units = [];
        end
    else
        units = [];
    end
    if ~isempty(units)
        unit = units{unit_idx};
    else
        unit = '';
    end
    
    %% main panels
    container = varargin{1};
    panel = uix.Panel('Parent', container,...
        'Title', 'Results',...
        'Tag', 'cp_results_panel',...
        'Padding', 10);
    vbox = uix.VBox('Parent', panel,...
        'Tag', 'cp_results_vbox');
    
    grid = uix.Grid('Parent', vbox,...
        'Spacing', 5,...
        'Tag', 'cp_results_grid');
    
    %% results
    offset_label = uicontrol('Parent', grid,...
        'Style', 'text',...
        'HorizontalAlignment', 'left',...
        'Tag', 'cp_results_offset_label',...
        'String', 'Offset:');
    offset_value = uicontrol('Parent', grid,...
        'Style', 'text',...
        'HorizontalAlignment', 'left',...
        'Tag', 'cp_results_offset_value',...
        'String', value);
    offset_unit = uicontrol('Parent', grid,...
        'Style', 'text',...
        'HorizontalAlignment', 'left',...
        'Tag', 'cp_results_offset_unit',...
        'String', unit);

    grid.Heights = -1;
    grid.Widths = [-1 -1 -1];

    %% update handles and results-object
    results = results.addproperty('output_elements');
    
    % main panels
    output_elements.panel = panel;
    output_elements.vbox = vbox;
    output_elements.grid = grid;
    
    % grid
    output_elements.offset_label = offset_label;
    output_elements.offset_value = offset_value;
    output_elements.offset_unit = offset_unit;
    
    results.output_elements = output_elements;
    
    UtilityFcn.PublishResults('ContactPoint', handles, results);

end % SetOutputElements

