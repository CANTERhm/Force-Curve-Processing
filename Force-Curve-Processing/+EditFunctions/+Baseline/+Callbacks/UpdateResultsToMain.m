function UpdateResultsToMain(src, evt)
%UPDATERESULTSTOMAIN wirte Baseline results object to handles
%   write it to handles.curveprops.curvename.Results.Baseline, if this
%   field exits

    % handles and results-object
    main = findobj(allchild(groot), 'Type', 'Figure', 'Tag', 'figure1');
    handles = guidata(main);
    results = getappdata(handles.figure1, 'Baseline');
    table = handles.guiprops.Features.edit_curve_table;
    
    % abort function, if no curve was loaded
    if isempty(table.Data)
        return
    end
    
    % abort function if Basline is not registered in curvename.Results
    names = fieldnames(handles.curveprops.(table.UserData.CurrentCurveName).Results);
    if ~ismember(names, 'Baseline')
        return
    end
    
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
    handles.curveprops.(table.UserData.CurrentCurveName).Results.Baseline = data;
    
    
%     % remove fields, which should not be stored in
%     % curveprops.curvename.Results.Baseline
%     if isprop(results, 'input_elements')
%         results.delproperty('input_elements');
%     end
%     if isprop(results, 'output_elements')
%         results.delproperty('output_elements');
%     end
%     if isprop(results, 'property_event_listener')
%         results.delproperty('property_event_listener');
%     end
%     if isprop(results, 'external_event_listener')
%         results.delproperty('external_event_listener');
%     end
    
    
    % update handles-struct
    % Do not update results-object! is modified an not possible to use it
    % futher in activeEditfunction
    % possible issues:
    %   - due to the work on a handle (results is a handle to a
    %   Results-object), it is possible, that results is up to date
    %   anyways.
    guidata(handles.figure1, handles);

end % UpdateResultsToMain

