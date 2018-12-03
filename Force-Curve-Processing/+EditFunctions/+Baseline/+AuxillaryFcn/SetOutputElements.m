function SetOutputElements(PanelObject)
%SETOUTPUTELEMENTS Setup Graphical Elements for Outputparameter
%   Set Graphical Elements for the representation of Outputparameters of
%   the activated Editfunction

    % handles and results-object
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    results = getappdata(handles.figure1, 'Baseline');

    %% praperation of layout
    
    panel = uix.Panel('Parent', PanelObject,...
        'Title', 'Results',...
        'padding', 10);
    
    results_vbox = uix.VBox('Parent', panel);
    
    grid = uix.Grid('Parent', results_vbox,...
        'spacing', 5);
    
    %% creating Labels
    
    % values
    if ~isempty(results.slope)
        slope = num2str(results.slope);
    else
        slope = '...';
    end
    if ~isempty(results.offset)
        offset = num2str(results.offset);
    else
        offset = '...';
    end

    % units
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
    
    % slope
    if ~isempty(units)
        xch = handles.guiprops.Features.curve_xchannel_popup.Value;
        ych = handles.guiprops.Features.curve_ychannel_popup.Value;
        slope_unit = [units{ych} '/' units{xch}];
    else
        slope_unit = '...';
    end
    
    % offset
    if ~isempty(units)
        ych = handles.guiprops.Features.curve_ychannel_popup.Value;
        offset_unit = units{ych};
    else
        offset_unit = '...';
    end
    
    slope_label = uicontrol('Parent', grid,...
        'Style', 'text',...
        'HorizontalAlignment', 'left',...
        'String', 'Slope:');
    
    offset_label = uicontrol('Parent', grid,...
        'Style', 'text',...
        'HorizontalAlignment', 'left',...
        'String', 'Offset:');
    
    slope_value_label = uicontrol('Parent', grid,...
        'Style', 'text',...
        'String', slope,...
        'HorizontalAlignment', 'center');
    
    offset_value_label = uicontrol('Parent', grid,...
        'Style', 'text',...
        'String', offset,...
        'HorizontalAlignment', 'center');
    
    slope_unit_label = uicontrol('Parent', grid,...
        'Style', 'text',...
        'HorizontalAlignment', 'left',...
        'String', slope_unit);
    
    offset_unit_label = uicontrol('Parent', grid,...
        'Style', 'text',...
        'HorizontalAlignment', 'left',...
        'String', offset_unit);
    
    grid.Heights = [-1 -1];
    grid.Widths = [-1 -1 -1];
    
    %% results_vbox heights
    results_vbox.Heights = 50;
    
    %% output
    results.addproperty('output_elements');
    
    output_elements.slope_label = slope_label;
    output_elements.slope_value_label = slope_value_label;
    output_elements.slope_unit_label = slope_unit_label;
    output_elements.offset_label = offset_label;
    output_elements.offset_value_label = offset_value_label;
    output_elements.offset_unit_label = offset_unit_label;
    
    output_elements.results_vbox = results_vbox;
    output_elements.results_grid = grid;
    results.output_elements = output_elements;
    
    setappdata(handles.figure1, 'Baseline', results);
    guidata(handles.figure1, handles);

end % SetOutputElements

