
clearvars

res = Results();
lh = PropListener();
lh.addListener(res, 'Status', 'PostSet', @listener);

function listener(src, evt)
    disp('listener executed');
end