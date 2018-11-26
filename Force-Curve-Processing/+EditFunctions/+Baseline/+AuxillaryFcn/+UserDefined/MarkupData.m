function MarkupData(varargin)
%MARKUPDATA Marksup data between selection_borders property
%  	Tracks the selection_borders property via
%   propertylistener and marks up the range according to this property
%   on FCP GraphWindow.

    %% input parser
    p = inputParser;
    
    ValidCharacter = @(x)assert(isa(x, 'char') || isa(x, 'string'),...
        'MarkupData:invalidInput',...
        'Input is not a character-vector or a string-scalar.');
    
    addOptional(p, 'src', []);
    addOptional(p, 'evt', []);
    addParameter(p, 'EditFunction', 'Baseline', ValidCharacter);
    
    parse(p, varargin{:});
    
    src = p.Results.src;
    evt = p.Results.evt;
    EditFunction = p.Results.EditFunction;

    %% refresh handles and results

    % get latest references to handles and result
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    if ~isempty(main)
        handles = guidata(main);
        results = getappdata(handles.figure1, EditFunction);
    else
        % abort, no open fcp-app
        return
    end
    
    if isempty(results)
        % no editfunctions are loaded
        return
    end
    
    %% markup datarange
    
    % transform relative units to absolute
    % since the units property is likely to vanish (only working with
    % relative units makes life easier) this comparison may be obsolete 
    if strcmp(results.units, 'relative')
        borders = TransformToAbsolute(handles, results, EditFunction);
    else
        borders = results.selection_borders;
    end
    
    if isempty(borders)
        return
    end
    
    ax = handles.guiprops.MainAxes;
    markup = findobj(ax, 'Type', 'Patch', 'Tag', 'markup');
    xpoints = [borders(1) borders(2) borders(2) borders(1)];
    ypoints = [ax.YLim(1) ax.YLim(1) ax.YLim(2) ax.YLim(2)];
    
    if isempty(markup)
        % setup an new markup
        hold(ax, 'on');
        patch(ax, xpoints, ypoints, 'black',...
            'FaceColor', 'black',...
            'FaceAlpha', 0.1,...
            'LineStyle', 'none',...
            'Tag', 'markup',...
            'DisplayName', 'Data Range');
        hold(ax, 'off');
    else
        % in case there are more markups on screen than there should be
        % delete every markup but the last one
        len = length(markup);
        if len > 1
            for i = 2:len
                delete(markup(i))
            end
        end
        
        % update markup if theres only one
        markup.XData = xpoints;
        markup.YData = ypoints;
        markup.FaceColor = 'black';
    end
    
    %% update handles, results and fire event UpdateObject
    % update results object
    setappdata(handles.figure1, EditFunction, results);
    guidata(handles.figure1, handles);

    % trigger update to handles.curveprops.curvename.Results.EditFunction
    results.FireEvent('UpdateObject');
    
    %% nested functions
    
    function new_borders = TransformToAbsolute(handles, results, EditFunction)
        
        table = handles.guiprops.Features.edit_curve_table;
        if isempty(table.Data)
            new_borders = results.selection_borders;
            return
        end
        
        % preparation of needed variables
        xchannel = handles.guiprops.Features.curve_xchannel_popup.Value;
        ychannel = handles.guiprops.Features.curve_ychannel_popup.Value;
        curvename = table.UserData.CurrentCurveName;
        RawData = handles.curveprops.(curvename).RawData;
        editfunctions = allchild(handles.guiprops.Panels.processing_panel);
        edit_function = findobj(editfunctions, 'Tag', EditFunction);
        last_editfunction_index = find(editfunctions == edit_function) + 1;
        last_editfunction = editfunctions(last_editfunction_index).Tag;
        
        % abort transformation because no curvedata is available
        if isempty(table.Data)
            new_borders = [];
            return
        else
            % test if there are already calculated data, if not take data
            % for last Editfunction
            if isempty(results.calculated_data)
                % get data from last editfunction
                curvedata = UtilityFcn.ExtractPlotData(RawData, handles, xchannel, ychannel,...
                    'edit_button', last_editfunction);
                linedata = ConvertToVector(curvedata);
            else
                % get data from active editfunction
                curvedata = UtilityFcn.ExtractPlotData(RawData, handles, xchannel, ychannel);
                linedata = ConvertToVector(curvedata);
            end
        end
        
        % transformation of borders
            if isempty(linedata)
                new_borders = [];
                return
            end
            
            x = linedata(:,1);

            % left border
            a_left_index = round(length(x)*results.selection_borders(1));
            if a_left_index == 0
                a_left_index = 1;
            end
            a_left = x(a_left_index);

            % right border
            a_right_index = round(length(x)*results.selection_borders(2));
            if a_right_index == 0
                a_right_index = 1;
            end
            a_right = x(a_right_index);

            new_borders = [a_left a_right];
        
    end % TransformToAbsolute
end % MarkupData

function vector_data = ConvertToVector(data)
    % flattens the data input to an nx2-double vector for calculation
    % purposes
    %
    % input:
    %   - data: extracted curvedata obtained via ExtractPlotData
    %
    % output:
    %   - vector_data: vectorized curvedata as nx2 double-vector;
    %                   :,1 --> x-data
    %                   :,2 --> y-data

    trace_x = [];
    trace_y = [];
    retrace_x = [];
    retrace_y = [];

    % prepare data
    if ~isempty(data.Trace)
        segment = fieldnames(data.Trace);
        for i = 1:length(segment)
            if ~isempty(data.Trace.(segment{i}).XData) && ...
                    ~isempty(data.Trace.(segment{i}).YData)
                trace_x = [trace_x; data.Trace.(segment{i}).XData];
                trace_y = [trace_y; data.Trace.(segment{i}).YData];
            else
                trace_x = [];
                trace_y = [];
            end
        end
    end

    if ~isempty(data.Retrace)
        segment = fieldnames(data.Retrace);
        for i = 1:length(segment)
            if ~isempty(data.Retrace.(segment{i}).XData) && ...
                    ~isempty(data.Retrace.(segment{i}).YData)
                retrace_x = [retrace_x; data.Retrace.(segment{i}).XData];
                retrace_y = [retrace_y; data.Retrace.(segment{i}).YData];
            else
                retrace_x = [];
                retrace_y = [];
            end
        end
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

    % output
    curve_x = [trace_x; retrace_x];
    curve_y = [trace_y; retrace_y];
    vector_data = [curve_x, curve_y];

end % ConvertToVector

