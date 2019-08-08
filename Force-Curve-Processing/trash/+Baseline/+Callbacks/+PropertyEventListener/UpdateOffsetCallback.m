function UpdateOffsetCallback(varargin)
%UPDATEOFFSETCALLBACK Update offset_value_label and offset_unit_label according to results-object

    %% inputparsing
    p = inputParser;
    
    ValidNumber = @(x)assert(isnumeric(x),...
        'UpdateOffsetCallback:invalidInput',...
        'Input was not numeric for one of the following inputparameters:\n%s\n',...
        'ychannel_idx');
    
    addOptional(p, 'src', []);
    addOptional(p, 'evt', []);
    addOptional(p, 'ychannel_idx', [], ValidNumber);
    
    parse(p, varargin{:});
    
    src = p.Results.src;
    evt = p.Results.evt;
    ychannel_idx = p.Results.ychannel_idx;
    
    %% function procedure

    % get results-object
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    results = getappdata(handles.figure1, 'Baseline');
    
    % get label references
    off_value = results.output_elements.offset_value_label;
    off_unit = results.output_elements.offset_unit_label;
    
    % update value labels
    off_value.String = num2str(results.offset);
    
    % update unit labels
    table = handles.guiprops.Features.edit_curve_table;
    curvename = table.UserData.CurrentCurveName;
    SpecialInformation = handles.curveprops.(curvename).RawData.SpecialInformation;
    if ~isempty(SpecialInformation)
        units = SpecialInformation.Segment1.units;
    else
        units = [];
    end
    if ~isempty(units)
        if isempty(ychannel_idx)
            ych = results.input_elements.input_ychannel_popup.Value;
        else
            ych = ychannel_idx;
        end
        off_unit.String = units{ych};
    end

    % refresh results object and handles
    setappdata(handles.figure1, 'Baseline', results);
    guidata(handles.figure1, handles);

    % trigger update to handles.curveprops.curvename.Results.Baseline
    results.FireEvent('UpdateObject');

end % UpdateOffsetCallback

