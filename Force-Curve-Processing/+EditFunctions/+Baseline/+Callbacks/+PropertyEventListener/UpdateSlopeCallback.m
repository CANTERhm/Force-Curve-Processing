function UpdateSlopeCallback(varargin)
%UPDATESLOPECALLBACK update slope labels on Baseline-Resultspanel-Inputparameters
%   
%   Update slope_value_label and slope_unit_label
%   according to results-object. It can also be used as a normal function


    %% inputparser
    p = inputParser;
    
    ValidNumber = @(x)assert(isnumeric(x),...
        'UpdateSlopeCallback:invalidInput',...
        'Input was not numeric for one of the following inputparameters:\n%s\n%s\n%s\n%s\n',...
        'xchannel_idx', 'ychannel_idx', 'curve_part_idx', 'curve_segment_idx');
    
    addOptional(p, 'src', []);
    addOptional(p, 'evt', []);
    addOptional(p, 'xchannel_idx', [], ValidNumber);
    addOptional(p, 'ychannel_idx', [], ValidNumber);
    
    parse(p, varargin{:});
    
    src = p.Results.src;
    evt = p.Results.evt;
    xchannel_idx = p.Results.xchannel_idx;
    ychannel_idx = p.Results.ychannel_idx;
    
    %% function procedure
    
    % get results-object
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    results = getappdata(handles.figure1, 'Baseline');
    
    % get label references
    sl_value = results.output_elements.slope_value_label;
    sl_unit = results.output_elements.slope_unit_label;
    
    % update value labels
    sl_value.String = num2str(results.slope);
    
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
        if isempty(xchannel_idx) && isempty(ychannel_idx)
            xch = results.input_elements.input_xchannel_popup.Value;
            ych = results.input_elements.input_ychannel_popup.Value;
        else
            xch = xchannel_idx;
            ych = ychannel_idx;
        end
        sl_unit.String = [units{ych} '/' units{xch}];
    end

    % refresh results object and handles
    setappdata(handles.figure1, 'Baseline', results);
    guidata(handles.figure1, handles);

    % trigger update to handles.curveprops.curvename.Results.Baseline
    results.FireEvent('UpdateObject');

end % UpdateSlopeCallback

