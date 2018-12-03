function UpdateElementsAccordingToUnitsCallback(varargin)
%UPDATEELEMENTSACCORDINGTOUNITSCALLBACK Porpertylistener callback 
%
%   This Callback updates the left/right border edits according to 
%   results.units-property. It is going to be invoked, if the
%   WindowButton-Callbacks executes as response to an user dragging a new
%   selection area for Dataselection.
%   UpdateElementsAccordingToUnitsCallback is also allowed to be used as
%   normal function
%
% Syntax:
%   - UpdateElementsAccordingToUnitsCallback()
%   - UpdateElementsAccordingToUnitsCallback(xchannel_idx, ychannel_idx)
%   - UpdateElementsAccordingToUnitsCallback(xchannel_idx, ychannel_idx, curve_part_idx)
%   - UpdateElementsAccordingToUnitsCallback(xchannel_idx, ychannel_idx, curve_part_idx, curve_segment_idx)
% 
% Input:
%   - if used as Callback, the first two inputparameters are source-data
%   and event-data
%   - xchannel_idx: Value of an xchannel_popup (default: fcp-app curve_xchannel_popup.Value)
%   - ychannel_idx: Value of an ychannel_popup (default: fcp-app curve_ychannel_popup.Value)
%   - curve_part_idx: Value of an curve_part_popup (default: fcp-app curve_parts_popup.Value)
%   - curve_segment_idx: Value of an curve_segment_popup (default: fcp-app curve_segments_popup.Value)


    %% inputparser
    p = inputParser;
    
    ValidNumber = @(x)assert(isnumeric(x),...
        'UpdatesAccordingToUnitsCallback:invalidInput',...
        'Input was not numeric for one of the following inputparameters:\n%s\n%s\n%s\n%s\n',...
        'xchannel_idx', 'ychannel_idx', 'curve_part_idx', 'curve_segment_idx');
    
    addOptional(p, 'src', []);
    addOptional(p, 'evt', []);
    addOptional(p, 'xchannel_idx', [], ValidNumber);
    addOptional(p, 'ychannel_idx', [], ValidNumber);
    addOptional(p, 'curve_part_idx', [], ValidNumber);
    addOptional(p, 'curve_segment_idx', [], ValidNumber);
    
    parse(p, varargin{:})
    
    src = p.Results.src;
    evt = p.Results.evt;
    xchannel_idx = p.Results.xchannel_idx;
    ychannel_idx = p.Results.ychannel_idx;
    curve_part_idx = p.Results.curve_part_idx;
    curve_segment_idx = p.Results.curve_segment_idx;
    
    %% function procedure
    % get results-object
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    results = getappdata(handles.figure1, 'Baseline');

    % preparation of frequently used variables
    table = handles.guiprops.Features.edit_curve_table;
    
    % abort if no curve has been loaded
    if isempty(table.UserData) || isempty(table.Data)
        return
    end
    
    if isempty(xchannel_idx) && isempty(ychannel_idx)
        xchannel = results.input_elements.input_xchannel_popup.Value;
        ychannel = results.input_elements.input_ychannel_popup.Value;
    else
        xchannel = xchannel_idx;
        ychannel = ychannel_idx;
    end
    if isempty(curve_part_idx)
        part = results.input_elements.input_parts_popup.Value;
    else
        part = curve_part_idx;
    end
    if isempty(curve_segment_idx)
        segment = results.input_elements.input_segments_popup.Value;
    else
        segment = curve_segment_idx;
    end
    curvename = table.UserData.CurrentCurveName;
    RawData = handles.curveprops.(curvename).RawData;
    editfunctions = allchild(handles.guiprops.Panels.processing_panel);
    baseline = findobj(editfunctions, 'Tag', 'Baseline');
    last_editfunction_index = find(editfunctions == baseline) + 1;
    last_editfunction = editfunctions(last_editfunction_index).Tag;

    switch results.units
        case 'relative'
            new_borders = ExpressAsRelative(handles, results, table,...
                RawData,...
                xchannel,...
                ychannel,...
                part,...
                segment,...
                last_editfunction);
        case 'absolute'
            new_borders = ExpressAsAbsolute(handles, results, table,...
                RawData,...
                xchannel,...
                ychannel,...
                part,...
                segment,...
                last_editfunction);
    end
    
    results.selection_borders = new_borders;
    
    % refresh results object and handles
    setappdata(handles.figure1, 'Baseline', results);
    guidata(handles.figure1, handles);

    % trigger update to handles.curveprops.curvename.Results.Baseline
    results.FireEvent('UpdateObject');

%% nested functions

    function new_borders = ExpressAsRelative(handles, results, table, RawData,...
            xchannel, ychannel, part, segment, last_editfunction)
        % transforms absolute selection_borders to relative ones
        
        % abort transformation because no curvedata is available
        if isempty(table.Data)
            new_borders = [];
            return
        else
            % test if there are already calculated data, if not take data
            % for last Editfunction
            if isempty(results.calculated_data)
                % get data from last editfunction
                curvedata = UtilityFcn.ExtractPlotData(RawData, handles,...
                    xchannel,...
                    ychannel,...
                    part,...
                    segment,...
                    'edit_button', last_editfunction);
                linedata = EditFunctions.Baseline.HelperFcn.ConvertToVector(curvedata);
            else
                % get data from active editfunction
                curvedata = UtilityFcn.ExtractPlotData(RawData, handles,...
                    xchannel,...
                    ychannel,...
                    part,...
                    segment);
                linedata = UtilityFcn.ConvertToVector(curvedata);
            end
        end
        new_borders = sort(EditFunctions.Baseline.AuxillaryFcn.UserDefined.BorderTransformation(linedata, 'absolute-relative'));
    end % ExpressAsRelative

    function new_borders = ExpressAsAbsolute(handles, results, table, RawData,...
            xchannel, ychannel, part, segment, last_editfunction)
        % transforms relative selection_borders to aboslute ones
        
        % abort transformation because no curvedata is available
        if isempty(table.Data)
            new_borders = [];
            return
        else
            % test if there are already calculated data, if not take data
            % for last Editfunction   
            if isempty(results.calculated_data)
                % get data from last editfunction
                curvedata = UtilityFcn.ExtractPlotData(RawData, handles,...
                    xchannel,...
                    ychannel,...
                    part,...
                    segment,...
                    'edit_button', last_editfunction);
                linedata = EditFunctions.Baseline.HelperFcn.ConvertToVector(curvedata);
            else
                % get data from active editfunction
                curvedata = UtilityFcn.ExtractPlotData(RawData, handles,...
                    xchannel,...
                    ychannel,...
                    part,...
                    segment);
                linedata = UtilityFcn.ConvertToVector(curvedata);
            end
        end
        new_borders = sort(EditFunctions.Baseline.AuxillaryFcn.UserDefined.BorderTransformation(linedata, 'relative-absolute'));
    end % ExpressAsAbsolute

end % UpdateElementsAccordingToUnitsCallback