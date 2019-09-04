function UpdateGraphicalRepresentation(src, evt)
% UPDATEGRAPHICALREPRESENTATION update graphical representation of the EditFunction: ContactPoint

    %% create variables
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    ax = handles.guiprops.MainAxes;
    cp_offset = findobj(ax, 'tag', 'cp_offset_representation');
    
    if isempty(cp_offset)
        y = linspace(ax.YLim(1), ax.YLim(2), 2);
        x = zeros(1, length(y));

        hold(ax, 'on');
        plot(ax, x, y, 'k--',...
            'Tag', 'cp_offset_representation',...
            'DisplayName', 'Offset');
        hold(ax, 'off');
    else
        cp_offset.YData = [ax.YLim(1) ax.YLim(2)];
    end

end

