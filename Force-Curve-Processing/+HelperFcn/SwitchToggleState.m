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
    
    % catch src.Value before it gets changed
    if isa(src.UserData, 'struct')
        names = fieldnames(src.UserData);
        if ~any(ismember(names, 'lh'))
            src.UserData.lh = [];
        end
        if ~any(ismember(names, 'last_value'))
            src.UserData.last_value = [];
        end
        if ~any(ismember(names, 'on_gui'))
            src.UserData.on_gui = Results();
            src.UserData.on_gui.Status = false;
        end
    else
        src.UserData.lh = [];
        src.UserData.last_value = [];
        src.UserData.on_gui = Results();
        src.UserData.on_gui.Status = false;
    end
    
    if isempty(src.UserData.lh)
        src.UserData.lh = PropListener();
        src.UserData.lh.addListener(src, 'Value', 'PreSet', @SetLastValue);
        src.UserData.lh.addListener(src, 'Value', 'PreSet', @SetOnGui);
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
    
    function SetLastValue(src, evt)
        obj = evt.AffectedObject;
        obj.UserData.last_value = obj.Value;
    end

    function SetOnGui(src, evt)
        obj = evt.AffectedObject;
        try
            last_value = obj.UserData.last_value;
        catch
            last_value = [];
        end
        if ~isempty(last_value)
            if obj.Value == 0 && obj.UserData.last_value == 1
                obj.UserData.on_gui.Status = true;
            else
                obj.UserData.on_gui.Status = false;
            end
        else
            obj.UserData.on_gui.Status = false;
        end
    end

end % SwitchToggleState

