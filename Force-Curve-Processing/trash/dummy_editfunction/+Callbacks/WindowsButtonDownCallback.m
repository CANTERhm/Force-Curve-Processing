function WindowsButtonDownCallback(src, evt)
% WBDCB window button down callback

    % get results-object
    main_wbdcb = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles_wbdcb = guidata(main_wbdcb);

    % Stuff to do for WindowsButtonDownCallback

    % update handles
    guidata(handles_wbdcb.figure1, handles_wbdcb);

    src.WindowButtonMotionFcn = @WindowsButtonMoveCallback;
    src.WindowButtonUpFcn = @WindowsButtonUpCallback;

    function WindowsButtonMoveCallback(src, evt)
    % WBMCB window button move callback

        % get results-object
        main_wbmcb = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
        handles_wbmcb = guidata(main_wbmcb);

        % stuff to do for WindowsButtonMoveCallback

        % update handles
        guidata(handles_wbmcb.figure1, handles_wbmcb);

        drawnow;
    end % WindowsButtonMoveCallback

    function WindowsButtonUpCallback(src, evt)
    % WBUCB window button up callback

        % get results-object
        main_wbucb = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
        handles_wbucb = guidata(main_wbucb);

        % Stuff do to for WindowsButtonUpCallback

        src.WindowButtonMotionFcn = '';
        src.WindowButtonUpFcn = '';

        % update handles
        guidata(handles_wbucb.figure1, handles_wbucb);
        
    end % WindowsButtonUpCallback

end % WindowsButtonDownCallback
