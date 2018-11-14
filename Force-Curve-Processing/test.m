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
    ExplicitlyNoCallback();
    par = src.Parent;
    list = allchild(par);
    fmt = 'Object: %s;  Is on Gui: %d\n';
    clc
    for i = 1:length(list)
        try
            part1 = list(i).String;
        catch
            part1 = 999;
        end
        try
            part2 = list(i).UserData.on_gui.Status;
        catch
            part2 = 999;
        end
        fprintf(fmt, part1, part2);
    end
end

function ExplicitlyNoCallback()
    % gets called inside an callback
    button = findall(allchild(groot), 'Type', 'UIControl');
    btn1 = button(1);
    lh = PropListener();
    try
        lh.addListener(btn1.UserData.on_gui, 'Status', 'PostSet', @lcb);
    catch
        % move on
    end
    
    function lcb(src, evt)
        obj = evt.AffectedObject;
    end
end


