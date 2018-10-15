classdef Results < Properties
    
    properties(SetObservable, AbortSet)
        Status
    end % properties
    
    methods
        
        function obj = Results()
            obj.Status = 'unprocessed';
        end % Boa consturctor
        
    end % methods
    
end % classdef