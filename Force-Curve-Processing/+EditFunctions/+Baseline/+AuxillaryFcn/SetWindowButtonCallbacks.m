function handles = SetWindowButtonCallbacks(handles)
% SETWINDOWBUTTONCALLBACKS set the window button callbacks properly in order
% to ensure correct behavior for the EditFunction: Baseline
    handles.guiprops.MainFigure.WindowButtonDownFcn = @WindowButtonDownCallback;
end

%% used Callbacks
function WindowButtonDownCallback(src, evt)
% WBDCB window button down callback

    % check wich mousebutton was pressed
    selection_type = src.SelectionType;
    
    if strcmp(selection_type, 'normal')
        go_on = true;
    elseif strcmp(selection_type, 'alt')
        go_on = false;
    elseif strcmp(selection_type, 'open')
        go_on = false;
    else
        return
    end
    
    if ~go_on
        return
    end 

    % get results-object
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    table = handles.guiprops.Features.edit_curve_table;
    
    % abort if tabel is empty (means no curves loaded)
    if isempty(table.Data)
        return
    end
    
    curvename = table.UserData.CurrentCurveName;
    results = handles.curveprops.(curvename).Results.Baseline;

    cp = handles.guiprops.MainAxes.CurrentPoint;
    results.selection_borders = [cp(1, 1) cp(1, 1)];

    % refresh results object and handles
    guidata(handles.figure1, handles);

    src.WindowButtonMotionFcn = @WindowButtonMoveCallback;
    src.WindowButtonUpFcn = @WindowButtonUpCallback;
end % WindowsButtonDownCallback

function WindowButtonMoveCallback(src, evt)
% WBMCB window button move callback

    % get results-object
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    table = handles.guiprops.Features.edit_curve_table;
    
    % abort if tabel is empty (means no curves loaded)
    if isempty(table.Data)
        return
    end
    
    curvename = table.UserData.CurrentCurveName;
    results = handles.curveprops.(curvename).Results.Baseline;

    cp = handles.guiprops.MainAxes.CurrentPoint;
    new_borders = [results.selection_borders(1) cp(1, 1)];
    results.selection_borders = new_borders;

    % renew an initial markup while moving the mouse
    ax = findobj(handles.guiprops.MainFigure, 'Type', 'Axes');
    markup = findobj(allchild(groot), 'Type', 'Patch', 'Tag', 'markup');

    xpoints = [new_borders(1) new_borders(2) new_borders(2) new_borders(1)];
    ypoints = [ax.YLim(1) ax.YLim(1) ax.YLim(2) ax.YLim(2)];

    if isempty(markup)
        % setup an new markup
        hold(ax, 'on');
        patch(ax, xpoints, ypoints, 'black',...
            'FaceColor', 'red',...
            'FaceAlpha', 0.1,...
            'LineStyle', 'none',...
            'Tag', 'markup',...
            'DisplayName', 'Data Range');
        hold(ax, 'off');
    else
        % in case there are more markups on screen than there should be
        % delete every markup but the last one
        len = length(markup);
        if len > 1
            for i = 2:len
                delete(markup(i))
            end
        end

        % update markup if theres only one
        markup.XData = xpoints;
        markup.YData = ypoints;
        markup.FaceColor = 'red';
    end

    % update handles
    guidata(handles.figure1, handles);

    drawnow;
end % WindowsButtonMoveCallback

function WindowButtonUpCallback(src, evt)
% WBUCB window button up callback

    % get results-object
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main); 
    table = handles.guiprops.Features.edit_curve_table;
    
    % abort if tabel is empty (means no curves loaded)
    if isempty(table.Data)
        return
    end
    
    curvename = table.UserData.CurrentCurveName;
    results = handles.curveprops.(curvename).Results.Baseline;
    baseline_properties = handles.procedure.Baseline.function_properties;
    
    % because selection_borders come in absolute units
    % (due to CurrentPoint-proerty from Axes) one has to convert it 
    % into relative ones 
    if strcmp(results.units, 'relative')
        RawData = handles.curveprops.(curvename).RawData;
        xchannel = baseline_properties.gui_elements.setting_xchannel_dropdown.Value;
        ychannel = baseline_properties.gui_elements.setting_ychannel_dropdown.Value;
        part = baseline_properties.gui_elements.setting_parts_dropdown.Value;
        segment = baseline_properties.gui_elements.setting_segments_dropdown.Value;
        curvedata = UtilityFcn.ExtractPlotData(RawData, handles,...
            xchannel,...
            ychannel,...
            part,...
            segment);
        linedata = UtilityFcn.ConvertToVector(curvedata);
        new_relative_borders = EditFunctions.Baseline.AuxillaryFcn.BorderTransformation(linedata,...
            'absolute-relative',...
            'user_defined_borders', results.selection_borders);
        results.selection_borders = sort(new_relative_borders);
    end
    
    src.WindowButtonMotionFcn = '';
    src.WindowButtonUpFcn = '';

    % update handles
    guidata(handles.figure1, handles);
end % WindowsButtonUpCallback
