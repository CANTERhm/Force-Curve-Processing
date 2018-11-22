function WindowButtonDownCallback(src, evt)
% WBDCB window button down callback

    % get results-object
    main_wbdcb = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    h_wbdcb = guidata(main_wbdcb);
    r_wbdcb = getappdata(h_wbdcb.figure1, 'Baseline');

    cp_wbdcb = h_wbdcb.guiprops.MainAxes.CurrentPoint;
    r_wbdcb.userdata.new_borders = [cp_wbdcb(1, 1) cp_wbdcb(1, 1)];

    % refresh results object and handles
    setappdata(h_wbdcb.figure1, 'Baseline', r_wbdcb);
    guidata(h_wbdcb.figure1, h_wbdcb);

    src.WindowButtonMotionFcn = @WindowButtonMoveCallback;
    src.WindowButtonUpFcn = @WindowButtonUpCallback;

    function WindowButtonMoveCallback(src, evt)
    % WBMCB window button move callback

        % get results-object
        main_wbmcb = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
        h_wbmcb = guidata(main_wbmcb);
        r_wbmcb = getappdata(h_wbmcb.figure1, 'Baseline');

        cp_wbmcb = h_wbmcb.guiprops.MainAxes.CurrentPoint;
        new_borders = [r_wbmcb.userdata.new_borders(1) cp_wbmcb(1, 1)];
        r_wbmcb.userdata.new_borders = new_borders;

        % renew an initial markup while moving the mouse
        ax = findobj(h_wbmcb.guiprops.MainFigure, 'Type', 'Axes');
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

        % refresh results object and handles
        setappdata(h_wbmcb.figure1, 'Baseline', r_wbmcb);
        guidata(h_wbmcb.figure1, h_wbmcb);

        drawnow;
    end % WindowsButtonMoveCallback

    function WindowButtonUpCallback(src, evt)
    % WBUCB window button up callback

        % get results-object
        main_wbucb = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
        h_wbucb = guidata(main_wbucb);
        r_wbucb = getappdata(h_wbucb.figure1, 'Baseline');  
        
        % because r_wbucb.UserData.new_borders comes in absolute units
        % (due to CurrentPoint-proerty from Axes) one has to convert it 
        % into relative ones 
        table = h_wbucb.guiprops.Features.edit_curve_table;
        curvename = table.UserData.CurrentCurveName;
        RawData = h_wbucb.curveprops.(curvename).RawData;
        xchannel = h_wbucb.guiprops.Features.curve_xchannel_popup.Value;
        ychannel = h_wbucb.guiprops.Features.curve_ychannel_popup.Value;
        curvedata = UtilityFcn.ExtractPlotData(RawData, h_wbucb,...
            xchannel,...
            ychannel);
        linedata = UtilityFcn.ConvertToVector(curvedata);
        new_relative_borders = EditFunctions.Baseline.AuxillaryFcn.UserDefined.BorderTransformation(linedata,...
            'absolute-relative',...
            'user_defined_borders', r_wbucb.userdata.new_borders);
        r_wbucb.selection_borders = sort(new_relative_borders);

        src.WindowButtonMotionFcn = '';
        src.WindowButtonUpFcn = '';

        % refresh results object and handles
        setappdata(h_wbucb.figure1, 'Baseline', r_wbucb);
        guidata(h_wbucb.figure1, h_wbucb);
    end % WindowsButtonUpCallback

end % WindowsButtonDownCallback
