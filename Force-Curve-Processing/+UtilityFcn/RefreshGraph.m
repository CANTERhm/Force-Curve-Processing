function RefreshGraph(varargin)
%REFRESHGRAPH brings a refreshed version of the afm-curve to the screen
%   Refreshes the objects on MainAxes. It also can be used as Callback.
%   optional Name-Value-Pairs:
%       - RefreshAll: true/ false (default: true); 
%           *if true, all elements on graph gets resettet. If there are 
%            elements which should not be replottet they get discarded.
%           *if false, only the trace and retrace objects are going to be
%            resettet. Ohter Elements remaining untouched.
    
    %% input parsing
    p = inputParser;
    
    ValidChar = @(x)assert(isa(x, 'char') || isa(x, 'struct'),...
        'RefreshGraph:invalidInput',...
        'input for EditFunction was not a character-vector or a string-scalar.');
    
    addOptional(p, 'src', []);
    addOptional(p, 'evt', []);
    addParameter(p, 'EditFunction', [], ValidChar)
    addParameter(p, 'RefreshAll', true);
    
    parse(p, varargin{:});
    
    src = p.Results.src;
    evt = p.Results.evt;
    EditFunction = p.Results.EditFunction;
    refresh_all = p.Results.RefreshAll;
    
    %% function procedure
    
    % get results-object
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    table = handles.guiprops.Features.edit_curve_table;
%     results = getappdata(handles.figure1, 'Baseline');
%     update_appdata = true;

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
    
    
    if isempty(table.Data)
        % no loaded curves, abort function
        return
    end
    
    xchannel = handles.guiprops.Features.curve_xchannel_popup.Value;
    ychannel = handles.guiprops.Features.curve_ychannel_popup.Value;
    curvename = table.UserData.CurrentCurveName;
    RawData = handles.curveprops.(curvename).RawData;
     
%     % function call outside of an editfunction
%     if isempty(results)
%         update_appdata = false;
%     end
  
    if ~isempty(results)
        curvedata = UtilityFcn.ExtractPlotData(RawData, handles, xchannel, ychannel);
    else
        curvedata = UtilityFcn.ExtractPlotData(RawData, handles, xchannel, ychannel,...
            'edit_button', 'procedure_root_btn');
    end    

%     if isobject(results) && ~isempty(results.calculated_data)
%         curvedata = UtilityFcn.ExtractPlotData(RawData, handles, xchannel, ychannel);
%     else
%         curvedata = UtilityFcn.ExtractPlotData(RawData, handles, xchannel, ychannel,...
%             'edit_button', 'procedure_root_btn');
%     end
    handles = IOData.PlotData(curvedata, handles, 'RefreshAll', refresh_all);

%     % refresh results object and handles
%     if update_appdata
%         setappdata(handles.figure1, 'Baseline', results);
%         guidata(handles.figure1, handles);
%         
%         % trigger update to handles.curveprops.curvename.Results.Baseline
%         results.FireEvent('UpdateObject');
%     end

    guidata(handles.figure1, handles);
    
end % RefreshGraph

