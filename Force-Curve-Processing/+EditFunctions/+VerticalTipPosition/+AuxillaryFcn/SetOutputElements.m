function SetOutputElements(varargin)
%SETOUTPUTELEMENTS Setup Graphical Elements for Outputparameter
%   Set Graphical Elements for the representation of Outputparameters of
%   the activated Editfunction

    %% handles and results-object
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    results = getappdata(handles.figure1, 'VerticalTipPosition');
    
    %% main panels
    container = varargin{1};
    panel = uix.Panel('Parent', container,...
        'Title', 'Results',...
        'Tag', 'vtp_results_panel',...
        'Padding', 10);
    vbox = uix.VBox('Parent', panel,...
        'Tag', 'vtp_results_vbox');
    
    grid = uix.Grid('Parent', vbox,...
        'Spacing', 5,...
        'Tag', 'vtp_results_grid');
    
    %% calculation status
    disclaimer_string = EditFunctions.VerticalTipPosition.AuxillaryFcn.UserDefined.CalculationStatus(results.calculation_status);
    
    %% graphical elements
    
    disclaimer = uicontrol('Parent', grid,...
        'Style', 'text',...
        'Tag', 'vtp_results_disclaimer',...
        'HorizontalAlignment', 'left',...
        'String', disclaimer_string);
    
    grid.Heights = -1;
    grid.Widths = -1;
    
    %% update handles and results-object
    setappdata(handles.figure1, 'VerticalTipPosition', results);
    guidata(handles.figure1, handles);

end % SetOutputElements

