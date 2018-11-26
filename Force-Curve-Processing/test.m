close all
fig = figure();
panel = uix.Panel('Parent', fig);
box = uix.HButtonBox('Parent', panel);
btn1 = uicontrol('Parent', box,...
    'Style', 'togglebutton',...
    'String', 'test1',...
    'Callback', @cb);

btn2 = uicontrol('Parent', box,...
    'Style', 'togglebutton',...
    'String', 'test2',...
    'Callback', @cb);
btn3 = uicontrol('Parent', box,...
    'Style', 'togglebutton',...
    'String', 'test3',...
    'Callback', @cb);

function cb(src, evt)
    HelperFcn.SwitchToggleState(src);
    outsidefunction();
end

function outsidefunction()
    list = findall(allchild(groot), 'Type', 'UIControl');
    
    for i = 1:length(list)
        if isa(list(i).UserData, 'struct')
            names = fieldnames(list(i).UserData);
            if ~any(ismember(names, 'lh2'))
                list(i).UserData.lh2 = PropListener();
                list(i).UserData.lh2.addListener(list(i).UserData.on_gui,...
                    'Status',...
                    'PostSet',...
                    @StateChanged);
            end
        end
    end
    
    function StateChanged(src, evt)
        obj = evt.AffectedObject;
        disp('StateChanged');
        fmt = 'On Gui: %d\n';
        fprintf(fmt, obj.Status);
    end
end

