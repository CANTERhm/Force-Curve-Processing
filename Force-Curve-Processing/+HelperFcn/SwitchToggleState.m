function SwitchToggleState(src, varargin)
%SWITCHTOGLESSTATE applies the desired behavior of edit procedure
%toggelbuttons
%
% input:
%   - src: object, which toggle state should be switched
%   - obj_list: optional property, a cell-array, containing a list of
%   switchable gui elements, which shall be switched off if src is set true

    %% input parsing
    p = inputParser;

    ExpectedStyles = {'togglebutton', 'checkbox'};
    ValidStyles = @(x)assert(any(validatestring(x, ExpectedStyles)), 'SwitchToggleState:wrongStyle',...
        'input was not an expected style for toggle-element.');

    addRequired(p, 'src');
    addOptional(p, 'obj_list', []);
    addParameter(p, 'style', 'togglebutton', ValidStyles)

    parse(p, src, varargin{:});

    src = p.Results.src;
    obj_list = p.Results.obj_list;
    style = p.Results.style;

    %% function procedure
    
    % work off obj_list input parameter
    if isempty(obj_list)
        list = allchild(src.Parent);
    else
        list = obj_list;
    end
    
    for i = 1:length(list)
        % catch src.Value before it gets changed
        if isa(list(i).UserData, 'struct')
            names = fieldnames(list(i).UserData);
            if ~any(ismember(names, 'lh'))
                list(i).UserData.lh = [];
            end
            if ~any(ismember(names, 'last_value'))
                list(i).UserData.last_value = [];
            end
            if ~any(ismember(names, 'on_gui'))
                list(i).UserData.on_gui = Results();
                list(i).UserData.on_gui.Status = false;
            end
        else
            list(i).UserData.lh = [];
            list(i).UserData.last_value = [];
            list(i).UserData.on_gui = Results();
            list(i).UserData.on_gui.Status = false;
        end
        if isempty(list(i).UserData.lh)
            list(i).UserData.lh = PropListener();
            list(i).UserData.lh.addListener(list(i),...
                'Value',...
                'PostSet',...
                @SetOnGui);
        end
    end
    
    % work off style input parameter
    switch style
        case 'togglebutton' % make sure, only switching another togglebutton can deactivate src
            if src.Value == 0 
                % if src isn't pressed, press it
                src.Value = 1;
            end
        case 'checkbox' % every other checkbox gets unchecked
            if src.Value == 0
                src.Value = 1;
            else
                src.Value = 0;
            end
    end

    % if src.Value == 1, set every other toggleelemt.Value = 0
    mask = list ~= src;
    list = list(mask);
    for i = 1:length(list)
        if isa(list, 'cell')
            list{i}.Value = 0;
        else
            list(i).Value = 0;
        end
    end 
    
    %% Callbacks
    function SetOnGui(src, evt)
        persistent CUR_OBJ
        persistent CYCLE 
        obj = evt.AffectedObject;
        try
            if strcmp(CYCLE, 'second')
                current_object_string = CUR_OBJ.String;
                last_object_string = obj.String;
                
                % is true if:
                %   - last pressed togglebutton is not currently pressed
                %     toggle button
                if ~strcmp(current_object_string, last_object_string)
                    obj.UserData.on_gui.Status = false;
                    CUR_OBJ.UserData.on_gui.Status = true;
                end
                
                % is true if:
                %   - a toggle button is pressed the first time on a gui at
                %   all
                if strcmp(current_object_string, last_object_string) && ...
                        CUR_OBJ.UserData.on_gui.Status == false
                    obj.UserData.on_gui.Status = false;
                    CUR_OBJ.UserData.on_gui.Status = true;
                end
            end
        catch ME
            switch ME.identifier
                case 'MATLAB:UndefinedFunction'
                    % CUR_OBJ is empty
                    % reason: editbutton pressed for the first time after
                    %         loading.
                    % move on
                case 'MATLAB:class:InvalidHandle'
                    % invalid or deleted Object
                    % reason: e.g. procedure has been deleted an loaded
                    %         again. CUR_OBJ contains in this case an 
                    %         deleted object.
                    % move on
                otherwise
                    rethrow(ME);
            end
        end
        CUR_OBJ = obj;
        if isempty(CYCLE)
            CYCLE = 'second';
        else
            CYCLE = [];
        end
    end

end % SwitchToggleState

