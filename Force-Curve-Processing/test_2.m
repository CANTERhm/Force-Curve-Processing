t = allchild(handles.guiprops.Panels.processing_panel);
m = arrayfun(@fun, t);

clearvars -except main handles m

function y = fun(btn)
    if btn.Value == 0
        y = false;
    else
        y = true;
    end
end