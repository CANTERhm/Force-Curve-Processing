function ShowNotification(str, varargin)
%SHOWNOTIFICATION display str for duration on notifiaction panel

% input parser scheme
p = inputParser;

ValidStr = @(s)assert(isa(s, 'char'), 'ShowNotification:ValidStr:invalidInput',...
    'Input is not a character vector');
ValidDuration = @(t)assert(isa(t, 'int') && t <= 0, 'ShowNotification:ValidDuration:invalidInput',...
    'Input is not a valid duration');

addRequired(p, 'str', ValidStr);
addOptional(p, 'duration', 5, ValidDuration);

parse(p, str, varargin{:})

str = p.Results.str;
duration = p.Results.duration;

% processing notifications
parfig = findobj(allchild(groot), 'Tag', 'figure1');
handles = guidata(parfig);

note_panel = handles.guiprops.Panels.notification_panel;
notifications = allchild(note_panel);

% if a notification is requestet while another one is on screen, stop all
% running timer and start the new one
if ~isempty(notifications)
    running_timer = timerfind;
    for i = 1:length(running_timer)
        stop(running_timer(i));
    end
end

% create timer and notification label
t = timer('ExecutionMode', 'singleShot',...
    'StartDelay', duration,...
    'TimerFcn', @Timer_Fcn,...
    'StopFcn', {@Stop_Fcn, handles});

uicontrol('Parent', handles.guiprops.Panels.notification_panel,...
    'Style', 'text',...
    'HorizontalAlignment', 'left',...
    'String', str);

start(t);

% callback functions for timer objects
    function Timer_Fcn(src, evt)
    end

    function Stop_Fcn(src, evt, handles)
        panel = handles.guiprops.Panels.notification_panel;
        notes = allchild(panel);
        delete(notes);
        delete(src);
    end

end
