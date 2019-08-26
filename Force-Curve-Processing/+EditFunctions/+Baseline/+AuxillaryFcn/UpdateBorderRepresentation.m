function handles = UpdateBorderRepresentation(handles, part_index_name, segment_index_name, xchannel_name, ychannel_name, selection_borders_name)
% UPDATEBORDERREPRESENTATION updates the border representation on the
% main-axes (red/gray patch object) according to the
% selection_borders-property of the results-object in 
% handles.curveprops.(curvename).Results.Baseline

    %% create variables
    table = handles.guiprops.Features.edit_curve_table;
    
    % abort if tabel is empty (means no curves loaded)
    if isempty(table.Data)
        return
    end
    
    curvename = table.UserData.CurrentCurveName;
    curve = handles.curveprops.(curvename).RawData;
    border = handles.curveprops.(curvename).Results.Baseline.(selection_borders_name);
    parts_index = handles.curveprops.(curvename).Results.Baseline.(part_index_name);
    segments_index = handles.curveprops.(curvename).Results.Baseline.(segment_index_name);
    ax = handles.guiprops.MainAxes;
    
    %% calculate coordinates
    [LineData, handles] = UtilityFcn.ExtractPlotData(curve, handles,...
        'xchannel_idx', xchannel_name,...
        'ychannel_idx', ychannel_name,...
        'curve_part_idx', parts_index,...
        'curve_segment_idx', segments_index);
    LineVector = UtilityFcn.ConvertToVector(LineData);
    
    if isempty(LineVector)
        return
    end
    
    line_index_1 = round(length(LineVector(:,1))*border(1));
    line_index_2 = round(length(LineVector(:,1))*border(2));
    if line_index_1 == 0
        line_index_1 = 1;
    end
    if line_index_2 == 0
        line_index_2 = 1;
    end
    x_border = [LineVector(line_index_1,1) LineVector(line_index_2),1];
    xpoints = [x_border(1) x_border(2) x_border(2) x_border(1)];
    ypoints = [ax.YLim(1) ax.YLim(1) ax.YLim(2) ax.YLim(2)];

    %% update procedure
    markup = findobj(allchild(groot), 'Type', 'Patch', 'Tag', 'markup');
    if isempty(markup)
        % if no representation has been set up, create one
        hold(ax, 'on');
        markup = patch(ax, xpoints, ypoints, 'black',...
            'FaceColor', 'red',...
            'FaceAlpha', 0.1,...
            'LineStyle', 'none',...
            'Tag', 'markup',...
            'DisplayName', 'Data Range');
        hold(ax, 'off');
    else
        % if there are more than one representations on the screen, delete
        % all but the last
        len = length(markup);
        if len > 1
            for i = 2:len
                delete(markup(i))
            end
        end
    end
    
    % finally update the found representation
    markup.XData = xpoints;
    markup.YData = ypoints;
    markup.FaceColor = 'black';
    
    %% update handles-struct
    guidata(handles.figure1, handles);
end

