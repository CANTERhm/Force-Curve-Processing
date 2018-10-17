function varargout = ExtractPlotData(RawData, handles, varargin)
%EXTRACTPLOTDATA extract data to plot from an afm-object
%   useful to get the data to display or make some calucation with
%   displayed data
% 
% input: 
%   - RawData: afm-object
%   - handles: handles-struct obtained via guide-apps
% optional input:
%   - xchannel_idx: index from xchannel popup form fcp-app (default: 1)
%   - ychannel_idx: index from ychannel popup from fcp-app (default: 2)
%
% output:
%   - LineData: struct, containing all data ready for displaying or
%   calculation
%   - handles: updated handles-struct
%
% Examples:
%   - LineData = ExtractPlotData(RawData, handles)
%   - [LineData, handles] = ExtractPlotData(RawData, handles)
%   - ___ = ExtractPlotData(___, xchannel_idx)
%   - ___ = ExtractPlotData(___, xchannel_idx, ychannel_idx)
%% input parsing
p = inputParser;

DefaultValues.xchannel = '1';
DefaultValues.ychannel = '2';
DefaultValues.active_edit_button = 'procedure_root_btn';

ValidChannelInput = @(x)assert(isa(x, 'double'),...
    'FCProcessing:ExtractPlotData:invalidInput',...
    'input was not type "double", representing a valid channel');

addRequired(p, 'RawData');
addRequired(p, 'handles');
addOptional(p, 'xchannel_idx', DefaultValues.xchannel, ValidChannelInput);
addOptional(p, 'ychannel_idx', DefaultValues.ychannel, ValidChannelInput);

parse(p, RawData, handles, varargin{:});

RawData = p.Results.RawData;
handles = p.Results.handles;
xchannel_idx = p.Results.xchannel_idx;
ychannel_idx = p.Results.ychannel_idx;

%% function procedure
curvename = handles.guiprops.Features.edit_curve_table.UserData.CurrentCurveName;
if isa(handles.guiprops.Features.curve_xchannel_popup.String, 'cell')
    xchannel = handles.guiprops.Features.curve_xchannel_popup.String{xchannel_idx};
    ychannel = handles.guiprops.Features.curve_ychannel_popup.String{ychannel_idx};
else % only one choice for popup, if there are no named channels
    xchannel = handles.guiprops.Features.curve_xchannel_popup.String;
    ychannel = handles.guiprops.Features.curve_ychannel_popup.String;
end

% determin segment_idx 
segment_idx = handles.guiprops.Features.curve_segments_popup.Value;

% determine wich edit_button is active
editBtns = allchild(handles.guiprops.Panels.processing_panel);
mask = false(length(editBtns),1);
for i = 1:length(mask)
    if editBtns(i).Value == 1
        mask(i) = 1;
    end
end

active_edit_button = editBtns(mask).Tag;

% is procedure_root_button is active, or another one?
if strcmp(active_edit_button, DefaultValues.active_edit_button)
    Data = RawData.CurveData;
else
    try
        Data = handles.curveprops.(curvename).Results.(active_edit_button);
    catch ME % if you can
        switch ME.identifier
            case 'MATLAB:noSuchMethodOrField'
                Data = [];
            otherwise
                rethrow(ME)
        end
    end % try
end % if 

trace_idx = handles.curveprops.CurvePartIndex.trace;
retrace_idx = handles.curveprops.CurvePartIndex.retrace;

switch segment_idx
    case 1 % all segments
        
        if isa(Data, 'struct')
            segments = fieldnames(RawData.CurveData);
            % trace
            for i = trace_idx(1):trace_idx(2)
                segname = segments{i};
                if ~isempty(Data)
                    Trace.(segname).XData = Data.(segname).(xchannel);
                    Trace.(segname).YData = Data.(segname).(ychannel);
                else
                    Trace.(segname).XData = RawData.CurveData.(segname).(xchannel);
                    Trace.(segname).YData = RawData.CurveData.(segname).(ychannel);
                end
            end

            % retrace
            for i = retrace_idx(1):retrace_idx(2)
                segname = segments{i};
                if ~isempty(Data)
                    Retrace.(segname).XData = Data.(segname).(xchannel);
                    Retrace.(segname).YData = Data.(segname).(ychannel);
                else
                    Retrace.(segname).XData = RawData.CurveData.(segname).(xchannel);
                    Retrace.(segname).YData = RawData.CurveData.(segname).(ychannel);
                end
            end

        elseif ~isempty(Data)
            data = Data(:, xchannel_idx);
            Trace.Segment1.XData = data;
            
            data = Data(:, ychannel_idx);
            Trace.Segment1.YData = data;
            Retrace.Segment1.XData = [];
            Retrace.Segment1.YData = [];
        else
            Trace.Segment1.XData = [];
            Trace.Segment1.YData = [];
            Retrace.Segment1.XData = [];
            Retrace.Segment1.YData = [];

        end % if 
        
    otherwise % only special segments
        
        segment_idx = segment_idx - 1;
        segments = fieldnames(RawData.CurveData);
        segname = segments{segment_idx};
        
        % trace
        if segment_idx <= trace_idx(2) & segment_idx >= trace_idx(1)
            if ~isempty(Data)
                Trace.(segname).XData = Data.(segname).(xchannel);
                Trace.(segname).YData = Data.(segname).(ychannel);
            else
                Trace.(segname).XData = RawData.CurveData.(segname).(xchannel);
                Trace.(segname).YData = RawData.CurveData.(segname).(ychannel);
            end
        else
                Trace.Segment1.XData = [];
                Trace.Segment1.YData = [];
        end

        % retrace
        if segment_idx <= retrace_idx(2) & segment_idx >= retrace_idx(1)
            if ~isempty(Data)
                Retrace.(segname).XData = Data.(segname).(xchannel);
                Retrace.(segname).YData = Data.(segname).(ychannel);
            else
                Retrace.(segname).XData = RawData.CurveData.(segname).(xchannel);
                Retrace.(segname).YData = RawData.CurveData.(segname).(ychannel);
            end
        else
                Retrace.Segment1.XData = [];
                Retrace.Segment1.YData = [];
        end
        
end % switch

% Decide which part to show
switch handles.guiprops.Features.curve_parts_popup.Value
    case 1
        LineData.Trace = Trace;
        LineData.Retrace = Retrace;
    case 2
        LineData.Trace = Trace;
        LineData.Retrace = [];
    case 3
        LineData.Trace = [];
        LineData.Retrace = Retrace;
end

guidata(handles.figure1, handles);

varargout{1} = LineData;
varargout{2} = handles;
