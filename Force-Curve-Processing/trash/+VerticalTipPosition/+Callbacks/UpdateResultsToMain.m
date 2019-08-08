function UpdateResultsToMain(src, evt)
%UPDATERESULTSTOMAIN wirte Baseline results object to handles
%   write it to handles.curveprops.curvename.Results.Baseline, if this
%   field exits
%
% Don't forget to Replace the word EditFunction with the EidtFunction-name
% you are working on!
% lines:
%   - 16
%   - 26
%   - 44

    %% handles and results-object
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    results = getappdata(handles.figure1, 'VerticalTipPosition');
    table = handles.guiprops.Features.edit_curve_table;
    
    %% work off criteria for abortion
    % abort function, if no curve was loaded
    if isempty(table.Data)
        return
    end
    
    % abort function if Basline is not registered in curvename.Results
    names = fieldnames(handles.curveprops.(table.UserData.CurrentCurveName).Results);
    if ~ismember(names, 'VerticalTipPosition')
        return
    end
    
    %% broadcast specific properties for one specific curve
    % load results without input_elements, output_elements,
    % PropertyEventListener and ExternalEventListener to
    % handles.curveprops.curvename.Reuslts.Baseline
    props = properties(results);
    discard_props = {'input_elements',...
        'output_elements',...
        'property_event_listener',...
        'external_event_listener',...
        'DynamicProps'};
    mask = ~ismember(props, discard_props);
    load_to_data = props(mask);
    for i = 1:length(load_to_data)
        data.(load_to_data{i}) = results.(load_to_data{i});
    end
    handles.curveprops.(table.UserData.CurrentCurveName).Results.VerticalTipPosition = data;
    
    %% broadcast common properties for all curves
    % there are certain properties, if changed, all curves should be
    % noticed about the change
    % if this is not the case, comment the whole sections
    discard_props = {'calculated_data',...
        'Sensitivity',...
        'SpringConstant'};
    mask = ~ismember(props, discard_props);
    load_to_data = props(mask);
    for i = 1:length(load_to_data)
        data.(load_to_data{i}) = results.(load_to_data{i});
    end
    curves = table.Data(:, 1);
    for i = 1:length(curves)
        handles.curveprops.(curves{i}).Results.VerticalTipPosition = data;
    end
    
    %% update handles 
    % update handles-struct
    % Do not update results-object! is modified an not possible to use it
    % futher in activeEditfunction
    % possible issues:
    %   - due to the work on a handle (results is a handle to a
    %   Results-object), it is possible, that results is up to date
    %   anyways.
    guidata(handles.figure1, handles);

end % UpdateResultsToMain

