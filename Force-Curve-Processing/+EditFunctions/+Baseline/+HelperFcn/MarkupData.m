function MarkupData()
%MARKUPDATA Marksup data between selection_borders property
%  	Tracks the selection_borders property via
%   propertylistener and marks up the range according to this property
%   on FCP GraphWindow.

    %% refresh handles and results
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    results = getappdata(main, 'Baseline');
    
    %% markup datarange
    
    % transform relative units to absolute
    if strcmp(results.units, 'relative')
        borders = TransformToAbsolute();
    else
        borders = results.selection_borders;
    end
    
    if isempty(borders)
        return
    end
    
    ax = findobj(handles.guiprops.MainFigure, 'Type', 'Axes');
    xpoints = [borders(1) borders(2) borders(2) borders(1)];
    ypoints = [ax.YLim(1) ax.YLim(1) ax.YLim(2) ax.YLim(2)];
    hold(ax, 'on');
    patch(ax, xpoints, ypoints, 'black',...
        'FaceColor', 'black',...
        'FaceAlpha', 0.1,...
        'LineStyle', 'none',...
        'Tag', 'markup',...
        'DisplayName', 'Markup');
    hold(ax, 'off');
    
    %% update handles, results and fire event UpdateObject
    % update results object
    setappdata(handles.figure1, 'Baseline', results);
    guidata(handles.figure1, handles);

    % trigger update to handles.curveprops.curvename.Results.Baseline
    results.FireEvent('UpdateObject');
    
    %% nested functions
    
    function new_borders = TransformToAbsolute()
        table = handles.guiprops.Features.edit_curve_table;
        if isempty(table.Data)
            new_borders = results.selection_borders;
            return
        end
        
        % preparation of needed variables
        xchannel = handles.guiprops.Features.curve_xchannel_popup.Value;
        ychannel = handles.guiprops.Features.curve_ychannel_popup.Value;
        curvename = table.UserData.CurrentCurveName;
        RawData = handles.curveprops.(curvename).RawData;
        editfunctions = allchild(handles.guiprops.Panels.processing_panel);
        baseline = findobj(editfunctions, 'Tag', 'Baseline');
        last_editfunction_index = find(editfunctions == baseline) + 1;
        last_editfunction = editfunctions(last_editfunction_index).Tag;
        
        % abort transformation because no curvedata is available
        if isempty(table.Data)
            new_borders = [];
            return
        else
            % test if there are already calculated data, if not take data
            % for last Editfunction
            if isempty(results.calculated_data)
                % get data from last editfunction
                curvedata = UtilityFcn.ExtractPlotData(RawData, handles, xchannel, ychannel,...
                    'edit_button', last_editfunction);
                linedata = EditFunctions.Baseline.HelperFcn.ConvertToVector(curvedata);
            else
                % get data from active editfunction
                curvedata = UtilityFcn.ExtractPlotData(RawData, handles, xchannel, ychannel);
                linedata = EditFunctions.Baseline.HelperFcn.ConvertToVector(curvedata);
            end
        end
        
        % transformation of borders
            if isempty(linedata)
                new_borders = [];
                return
            end
            
            x = linedata(:,1);

            % left border
            a_left_index = round(length(x)*results.selection_borders(1));
            if a_left_index == 0
                a_left_index = 1;
            end
            a_left = x(a_left_index);

            % right border
            a_right_index = round(length(x)*results.selection_borders(2));
            if a_right_index == 0
                a_right_index = 1;
            end
            a_right = x(a_right_index);

            new_borders = [a_left a_right];
        
    end % TransformToAbsolute
end % MarkupData

