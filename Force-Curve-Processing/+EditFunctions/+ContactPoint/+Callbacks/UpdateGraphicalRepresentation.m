function UpdateGraphicalRepresentation(src, evt)
% UPDATEGRAPHICALREPRESENTATION update graphical representation of the EditFunction: ContactPoint

    %% create variables
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    ax = handles.guiprops.MainAxes;
    cp_offset = findobj(ax, 'tag', 'cp_offset_representation');
    
    if isempty(cp_offset)
        return
    end
    
    cp_offset.YData = [ax.YLim(1) ax.YLim(2)];

end

