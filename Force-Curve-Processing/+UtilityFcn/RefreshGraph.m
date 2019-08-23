function RefreshGraph(varargin)
%REFRESHGRAPH brings a refreshed version of the afm-curve to the screen
%
%   Refreshes the objects on MainAxes. It also can be used as Callback.
%
% Syntax:
%     - RefreshGraph(xchannel_idx, ychannel_idx)
%     - RefreshGraph(___, 'EditFunction', 'editfunction-tag')
%     - RefreshGraph(___, 'RefreshAll', boolen-value)
%
% Input:
%     - if RefreshGraph is used as an Callback, the first two elements are
%     source-data and event-data
%     - xchannel_idx: Value of an xchannel_popup (default: fcp-app curve_xchannel_popup.Value)
%     - ychannel_idx: Value of an ychannel_popup (default: fcp-app curve_ychannel_popup.Value)
%     - curve_part_idx: Value of an curve_parts_popup (default: fcp-app curve_parts_popup.Value)
%     - curve_segment_idx: Value of an curve_segments_popup (default: fcp-app curve_segments_popup.Value)
%
% Optional Name-Value-Pairs:
%     - EditFunction: char-vector determining the tag of an editfunction to
%                     take the calculated_data-property for dataplotting if
%                     available
%     - RefreshAll: true/ false (default: true); 
%           *if true, all elements on graph gets resettet. If there are 
%            elements which should not be replottet they get discarded.
%           *if false, only the trace and retrace objects are going to be
%            resettet. Ohter Elements remaining untouched.
    
    %% input parsing
    p = inputParser;
    
    ValidChannelInputClasses = {'double', 'char', 'string'};
    ValidEditFuncInputClasses = {'char', 'struct'};
    
    ValidChannelInput = @(x) any(validatestring(class(x), ValidChannelInputClasses));
    ValidEditFuncInput = @(x) any(validatestring(class(x), ValidEditFuncInputClasses));

%   % this part might be obsolete, delete it in the future
%
%     ValidChar = @(x)assert(isa(x, 'char') || isa(x, 'struct'),...
%         'RefreshGraph:invalidInput',...
%         'input for EditFunction was not a character-vector or a string-scalar.');
    
%     ValidNumber = @(x)assert(isnumeric(x),...
%         'RefreshGraph:invalidInput',...
%         'input was not numeric of one of the following inputparameters:\n%s\n%s\n%s\n%s.\n',...
%         'xchannel_idx', 'ychannel_idx', 'curve_part_idx', 'curve_segment_idx');
    
    addOptional(p, 'src', []);
    addOptional(p, 'evt', []);
    addParameter(p, 'xchannel_idx', [], ValidChannelInput);
    addParameter(p, 'ychannel_idx', [], ValidChannelInput);
    addParameter(p, 'EditFunction', [], ValidEditFuncInput)
    addParameter(p, 'RefreshAll', true);
    
    parse(p, varargin{:});
    
    src = p.Results.src;
    evt = p.Results.evt;
    xchannel_idx = p.Results.xchannel_idx;
    ychannel_idx = p.Results.ychannel_idx;
    EditFunction = p.Results.EditFunction;
    refresh_all = p.Results.RefreshAll;
    
    %% function procedure
    
    % get results-object
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    table = handles.guiprops.Features.edit_curve_table;
    
    if isempty(table.Data)
        % no loaded curves, abort function
        return
    end
    
    if isempty(src) && isempty(evt)
        InCallback = false;
    else
        InCallback = true;
    end

    if ~isempty(EditFunction)
        curvename = table.UserData.CurrentCurveName;
        res = handles.curveprops.(curvename).Results;
        if isprop(res, EditFunction)
            if isfield(res.(EditFunction), 'calculated_data')
                results = res.(EditFunction).calculated_data;
            else
                results = [];
            end
        else
            results = [];
        end
    else
        results = [];
    end
    
    if isempty(xchannel_idx) && isempty(ychannel_idx)
        if ~InCallback
            xchannel = handles.guiprops.Features.curve_xchannel_popup.Value;
            ychannel = handles.guiprops.Features.curve_ychannel_popup.Value;
        else
            xchannel = results.input_elements.input_xchannel_popup.Value;
            ychannel = results.input_elements.input_ychannel_popup.Value;
        end
    else
        xchannel = xchannel_idx;
        ychannel = ychannel_idx;
    end

    curvename = table.UserData.CurrentCurveName;
    RawData = handles.curveprops.(curvename).RawData;
  
    if ~isempty(results)
        curvedata = UtilityFcn.ExtractPlotData(RawData, handles,...
            'xchannel_idx', xchannel,...
            'ychannel_idx', ychannel);
    else
        curvedata = UtilityFcn.ExtractPlotData(RawData, handles,...
            'xchannel_idx', xchannel,...
            'ychannel_idx', ychannel,...
            'edit_button', 'procedure_root_btn');
    end    
    handles = IOData.PlotData(curvedata, handles, 'RefreshAll', refresh_all);
    guidata(handles.figure1, handles);
    
end % RefreshGraph

