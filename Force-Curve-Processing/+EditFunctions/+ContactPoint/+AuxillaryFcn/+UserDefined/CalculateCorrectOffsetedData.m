function corrected_data = CalculateCorrectOffsetedData(varargin)
% CALCULATECORRECTOFFSETEDDATA  calculation procedure for ContactPoint

    %% input parsing
    p = inputParser;
    
    addParameter(p, 'src', []);
    addParameter(p, 'evt', [])
    addParameter(p, 'data', []);
    addParameter(p, 'offset', []);
    addParameter(p, 'part_index', []);
    addParameter(p, 'segment_index', []);
    addParameter(p, 'xchannel_index', []);
    addParameter(p, 'ychannel_index', []);
    
    parse(p, varargin{:});
    
    src = p.Results.src;
    evt = p.Results.evt;
    data = p.Results.data;
    offset = p.Results.offset;
    part_index = p.Results.part_index;
    segment_index = p.Results.segment_index;
    xchannel_index = p.Results.xchannel_index;
    ychannel_index = p.Results.ychannel_index;
    
    %% function procedure
    
    %% output 
    corrected_data = [];
end % CalcluateCorrectOffsetedData