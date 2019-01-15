function SetInputElements(varargin)
%SETINPUTELEMENTS Setup Graphical Elements for Inputparameter
%   Set Graphical Elements for the aquisition of Inputparameters of
%   the activated Editfunction

    % handles and results-object
    [~, handles, results] = GetCommonVariables('EditFunction');
    
    % do Stuff
    
    % update handles and results-object
    PublishResults('EditFunction', handles, results);

end % SetInputElements

