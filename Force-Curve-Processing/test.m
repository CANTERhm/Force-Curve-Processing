
nested(1,2,3,4);

function nested(x, y, varargin)
    disp("Total number of input arguments: " + nargin)
    
    formatSpec = "Size of varargin cell array: %dx%d";
    str = compose(formatSpec,size(varargin));
    disp(str)
end