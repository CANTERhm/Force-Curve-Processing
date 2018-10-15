function handles = SeveralMonitors(handles, fObject1, fObject2)
% SEVERALMONITORS puts FCProcessing-window and Graph-Main-Window on
% different screens, if there are several monitors connected to the system

% input: 
%       - fObject1: handle to FCProcessing-window
%       - fObject2: handle to Graph-Main-Window

set(groot, 'Units', 'normalized')
set(fObject1, 'Units', 'normalized')
set(fObject2, 'Units', 'normalized')
monitors = get(groot, 'MonitorPositions');
sz = size(monitors);  

if sz(1) > 1 % more than one monitor is connected
    if strcmp(fObject1.WindowStyle, 'normal')
        pos = fObject1.OuterPosition;
        pos(3:4) = pos(3:4)./2;
        position = [monitors(1,1:2) pos(3:4)];
        fObject1.OuterPosition = position;
    end
    if strcmp(fObject2.WindowStyle, 'normal')
        pos = fObject1.OuterPosition;
        pos(3:4) = pos(3:4)./2;
        position = [monitors(1,1:2) pos(3:4)];
        fObject2.OuterPosition = position;
    end
    maxfig(fObject1, 1);
    maxfig(fObject2, 0);
end
guidata(handles.figure1, handles)
