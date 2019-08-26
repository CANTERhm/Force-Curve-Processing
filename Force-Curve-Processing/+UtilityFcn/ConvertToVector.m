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
                continue
%                 trace_x = [];
%                 trace_y = [];
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
                continue
%                 retrace_x = [];
%                 retrace_y = [];
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

