function handles = SetupMainFigure(handles)
%SETUPMAINFIGURE Setup mainfigure window for curve plotting

    name = handles.guiprops.MainFigureName;
    mainfig = handles.guiprops.MainFigure;

    if isempty(mainfig)
        handles.guiprops.MainFigure = figure('NumberTitle', 'off',...
            'Name', name,...
            'Tag', 'MainFigure',...
            'CloseRequestFcn', {@CloseMainFigureCallback, handles});
        ax = axes(handles.guiprops.MainFigure);
        ax.XGrid = 'on';
        ax.YGrid = 'on';
        ax.XMinorGrid = 'on';
        ax.YMinorGrid = 'on';
        ax.Tag = 'MainAxes';
        handles.guiprops.MainAxes = ax;
        ax.FontSize = 20;
        plottools();
        plotedit(handles.guiprops.MainFigure, 'off');
    end
    guidata(handles.figure1, handles);

    function CloseMainFigureCallback(src, evt, handles)
        delete(handles.guiprops.MainFigure);
        handles.guiprops.MainFigure = [];
        handles.guiprops.MainAxes = [];
    end

end