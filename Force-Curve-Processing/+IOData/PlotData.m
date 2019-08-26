function handles = PlotData(LineData, handles, varargin)
% PLOTDATA plot prior extracted data via ExtractPlotData according to
% setting in FCProcessing

%% Input Parsing
p = inputParser;

addRequired(p, 'LineData');
addRequired(p, 'handles');
addParameter(p, 'RefreshAll', true);

parse(p, LineData, handles, varargin{:});

LineData = p.Results.LineData;
handles = p.Results.handles;
RefreshAll = p.Results.RefreshAll;

%% preparation
trace_x = [];
trace_y = [];
retrace_x = [];
retrace_y = [];

if ~isempty(handles.guiprops.MainAxes)
    ax = handles.guiprops.MainAxes;
    ForceCurves = findall(ax, 'Tag', 'ForceCurve');
    if RefreshAll
        delete(allchild(ax));
    else
        delete(ForceCurves);
    end
else
    note = 'No open Main Graph Window';
    HelperFcn.ShowNotification(note);
    return
end


%% setup plot

% prepare data for axis labeling
curvename = handles.guiprops.Features.edit_curve_table.UserData.CurrentCurveName;
xchannel_val = handles.guiprops.Features.curve_xchannel_popup.Value;
ychannel_val = handles.guiprops.Features.curve_ychannel_popup.Value;
if ~isempty(curvename)
    if ~isempty(handles.curveprops.(curvename).RawData.SpecialInformation)
        info = handles.curveprops.(curvename).RawData.SpecialInformation.Segment1;
        if ~isempty(info.columns) && ~isempty(info.units)
            channels = info.columns;
            units = info.units;
        else
            CurveData = handles.curveprops.(curvename).RawData.CurveData;
            segments = fieldnames(CurveData);
            channels = fieldnames(CurveData.(segments{1}));
            units = cell(length(channels), 1);
            for i = 1:length(channels)
                units{i} = 'unknown';
            end
        end
    else % EasyImport is true --> CurveData is just a matrix with numerical data
        CurveData = handles.curveprops.(curvename).RawData.CurveData;
        sz = size(CurveData);
        channels = cell(sz(2), 1);
        units = cell(sz(2), 1);
        for i = 1:sz(2)
            channels{i} = ['Channel ' num2str(i)];
            units{i} = 'unknown';
        end
    end
end

% prepare plot data
if ~isempty(LineData) && ~isempty(LineData.Trace)
    segment = fieldnames(LineData.Trace);
    for i = 1:length(segment)
        if ~isempty(LineData.Trace.(segment{i}).XData) && ...
                ~isempty(LineData.Trace.(segment{i}).YData)
            trace_x = [trace_x; LineData.Trace.(segment{i}).XData];
            trace_y = [trace_y; LineData.Trace.(segment{i}).YData];
        else
            trace_x = [];
            trace_y = [];
        end
    end
else
    trace_x = [];
    trace_y = [];
end

if ~isempty(LineData) && ~isempty(LineData.Retrace)
    segment = fieldnames(LineData.Retrace);
    for i = 1:length(segment)
        if ~isempty(LineData.Retrace.(segment{i}).XData) && ...
                ~isempty(LineData.Retrace.(segment{i}).YData)
            retrace_x = [retrace_x; LineData.Retrace.(segment{i}).XData];
            retrace_y = [retrace_y; LineData.Retrace.(segment{i}).YData];
        else
            continue
        end
    end
else
    retrace_x = [];
    retrace_y = [];
end

% convert trace from cell to mat if necessary
if isa(trace_x, 'cell') 
    trace_x = cell2mat(trace_x);
end
if isa(trace_y, 'cell')
    trace_y = cell2mat(trace_y);
end

% convert retrace from cell to mat if necessary
if isa(retrace_x, 'cell')
    retrace_x = cell2mat(retrace_x);
end
if isa(retrace_y, 'cell')
    retrace_y = cell2mat(retrace_y);
end

% plot trace and retrace
if ~isempty(trace_x) && ~isempty(trace_y)
%     % try to use scatter plots instead of line, because they can be
%     % processed faster in matlab
    hold(ax, 'on');
    trace = scatter(ax, trace_x, trace_y);
    hold(ax, 'off');
    trace.Marker = 'o';
    trace.MarkerEdgeColor = handles.curveprops.TraceColor;
    trace.MarkerFaceColor = handles.curveprops.TraceColor;
    trace.SizeData = 2;
    trace.DisplayName = 'Trace';
    trace.Tag = 'ForceCurve';
end

if ~isempty(retrace_x) && ~isempty(retrace_y)
%     % try to use scatter plots instead of line, because they can be
%     % processed faster in matlab
    hold(ax, 'on');
    retrace = scatter(ax, retrace_x, retrace_y);
    hold(ax, 'off');
    retrace.Marker = 'o';
    retrace.MarkerEdgeColor = handles.curveprops.RetraceColor;
    retrace.MarkerFaceColor = handles.curveprops.RetraceColor;
    retrace.SizeData = 2;
    retrace.DisplayName = 'Retrace';
    retrace.Tag = 'ForceCurve';
end

ax.XGrid = 'on';
ax.YGrid = 'on';
ax.XMinorGrid = 'on';
ax.YMinorGrid = 'on';
try
    ax.XLabel.String = [channels{xchannel_val} ' / ' units{xchannel_val}];
catch ME
    switch ME.identifier
        case 'MATLAB:badsubscript'
            % message: 'Index exceeds the number of array elements (<anyNumber>).'
            % reason: the channels of an specific curve-segment are not the
            %         same as in defined above.
            % solution: take channel names from fcp´s channel dropdowns
            xchannel_dropdown = handles.guiprops.Features.curve_xchannel_popup;
            x_idx = xchannel_dropdown.Value;
            ax.XLabel.String = xchannel_dropdown.String{x_idx};
        otherwise
            rethrow(ME)
    end
end
try
    ax.YLabel.String = [channels{ychannel_val} ' / ' units{ychannel_val}];
catch ME
    switch ME.identifier
        case 'MATLAB:badsubscript'
            % message: 'Index exceeds the number of array elements (<anyNumber>).'
            % reason: the channels of an specific curve-segment are not the
            %         same as in defined above.
            % solution: take channel names from fcp´s channel dropdowns
            ychannel_dropdown = handles.guiprops.Features.curve_ychannel_popup;
            y_idx = ychannel_dropdown.Value;
            ax.YLabel.String = ychannel_dropdown.String{y_idx};
        otherwise
            rethrow(ME)
    end
end

guidata(handles.figure1, handles);