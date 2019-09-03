function handles = InitiateGraphicalRepresentation(handles)
% INITIATEGRAPHICALREPRESENTATION Initiate graphical representation of the
% EditFunction: Contact Point

    %% create variables
    table = handles.guiprops.Features.edit_curve_table;
    
    % abort if tabel is empty (means no curves loaded)
    if isempty(table.Data) || isempty(table.UserData)
        return
    end
    
    curvename = table.UserData.CurrentCurveName;
    cp_results = handles.curveprops.(curvename).Results.ContactPoint;
    ax = handles.guiprops.MainAxes;
    
    %% plot graphical representation
    y = linspace(ax.YLim(1), ax.YLim(2), 2);
    x = zeros(1, length(y));
    
    hold(ax, 'on');
    plot(ax, x, y, 'k--',...
        'Tag', 'cp_offset_representation',...
        'DisplayName', 'Offset');
    hold(ax, 'off');
    
    %% update handles-struct
    handles.curveprops.(curvename).Results.ContactPoint = cp_results;
    guidata(handles.figure1, handles);
end

