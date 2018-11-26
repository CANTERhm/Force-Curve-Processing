function results_features = layout_results(main_vbox)
%LAYOUT_RESULTS cares about the layout of resultparameter on FCP-App

    %% praperation of layout
    results_vbox = uix.VBox('Parent', main_vbox,...
        'Padding', 5);
    
    grid = uix.Grid('Parent', results_vbox);
    
    %% creating Labels
    
    slope_label = TextLabel('Parent', grid,...
        'String', 'Slope:');
    
    offset_label = TextLabel('Parent', grid,...
        'String', 'Offset:');
    
    slope_value_label = TextLabel('Parent', grid,...
        'String', '...',...
        'HorizontalAlignment', 'center');
    
    offset_value_label = TextLabel('Parent', grid,...
        'String', '...',...
        'HorizontalAlignment', 'center');
    
    slope_unit_label = TextLabel('Parent', grid,...
        'String', '...');
    
    offset_unit_label = TextLabel('Parent', grid,...
        'String', '...');
    
    grid.Heights = [-1 -1];
    grid.Widths = [-1 -1 -1];
    
    %% results_vbox heights
    results_vbox.Heights = 40;
    
    %% output
    results_features.slope_label = slope_label;
    results_features.slope_value_label = slope_value_label;
    results_features.slope_unit_label = slope_unit_label;
    results_features.offset_label = offset_label;
    results_features.offset_value_label = offset_value_label;
    results_features.offset_unit_label = offset_unit_label;
    
    results_features.results_vbox = results_vbox;
    results_features.results_grid = grid;
    
end % layout_results

