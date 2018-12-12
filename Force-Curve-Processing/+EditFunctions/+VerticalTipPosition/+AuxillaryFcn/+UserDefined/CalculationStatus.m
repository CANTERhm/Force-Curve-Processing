function disclaimer = CalculationStatus(status, varargin)
%CALCULATIONSTATUS Error and Warning System for VerticalTipPosition

    %% input parsing
    p = inputParser;
    
    ValidStatus = @(x)assert(isa(x, 'double') && x >= 1,...
        'CalculateStatus:invalidInput',...
        'Input for "status" is not a positive double-scalar.');
    
    addRequired(p, 'status', ValidStatus);
    
    parse(p, status, varargin{:});
    
    status = p.Results.status;
    
    %% function procedure
    switch status
        case 1
            disclaimer = 'Vertical Tip Position successfully calculated';
        case 2
            disclaimer = 'error 2: No loaded curves';
        case 3
            disclaimer = 'error 3: Curves are not calibrated';
    end

end % CalculationStatus

