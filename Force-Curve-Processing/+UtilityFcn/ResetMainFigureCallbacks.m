function ResetMainFigureCallbacks(varargin)
%RESETMAINFIGURECALLBACKS Sets all Callbacks for MainFigure to default

    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    
    % Common Callbacks
    f = handles.guiprops.MainFigure;
    f.ButtonDownFcn = '';
    f.CreateFcn = '';
    f.DeleteFcn = '';
    
    % Keyboard Callbacks
    f.KeyPressFcn = '';
    f.KeyReleaseFcn = '';
    
    % Window Callback
    f.CloseRequestFcn = 'closereq';
    f.SizeChangedFcn = '';
    f.WindowButtonDownFcn = '';
    f.WindowButtonMotionFcn = '';
    f.WindowButtonUpFcn = '';
    f.WindowKeyPressFcn = '';
    f.WindowKeyReleaseFcn = '';
    f.WindowScrollWheelFcn = '';
    f.ResizeFcn = '';

end % ResetMainFigureCallbacks

