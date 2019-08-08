function SetOutputElements(varargin)
%SETOUTPUTELEMENTS Setup Graphical Elements for Outputparameter
%   Set Graphical Elements for the representation of Outputparameters of
%   the activated Editfunction

    % handles and results-object
    [~, handles, results] = UtilityFcn.GetCommonVariables('EditFunction');
    
    % do Stuff
    
    % update handles and results-object
    UtilityFcn.PublishResults('EditFunction', handles, results);

end % SetOutputElements

