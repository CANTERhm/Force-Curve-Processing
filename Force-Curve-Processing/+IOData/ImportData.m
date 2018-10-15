function handles = ImportData(handles)
%IMPORTDATA import curve data to fcp-app

% props from guiprops
filenames = handles.guiprops.FilePathObject.files;
path = handles.guiprops.FilePathObject.path;

% cancel button in UIGetFilepath was pressed 
if ~isa(filenames, 'cell') && filenames == 0
    return
end



% props form curveprops
Delimiter = handles.curveprops.settings.Delimiter;
Comments = handles.curveprops.settings.Comments;
ColumnSpecifier = handles.curveprops.settings.ColumnSpecifier;
SegmentHeaderLength = handles.curveprops.settings.SegmentHeaderLength;
GeneralHeaderLength = handles.curveprops.settings.GeneralHeaderLength;
SearchQuery = handles.curveprops.settings.SearchQuery;
InformationStyle = handles.curveprops.settings.InformationStyle;
EasyImport = handles.curveprops.settings.EasyImport;

disp('Perparing Data:');
bar = waitbar(0,'Query File Specifiers...');
steps = length(filenames);

% if importing was cancled
if ~isa(filenames, 'cell')
    close(bar);
    note = sprintf('\nFile Import Cancled.\n');
    HelperFcn.ShowNotification(note)
    clc
    return
end

% test if all files are the same type; we only allow the processing of one
% type of force-curves per processing session. This makes it easier to
% control the data handling.
specifiers = cell(steps, 1);
for i = 1:steps
    filepath = [path filenames{i}];
    test = afm(filepath, 'EasyImport', true);
    specifiers{i} = test.FileSpecifier;
    waitbar(i/steps, bar);
end
close(bar);
specifiers = categorical(specifiers);
specifier_types = categories(specifiers);
if length(specifier_types) > 1
    note = sprintf('\nAt least one force-curve has not the same File Type as others.\n');
    HelperFcn.ShowNotification(note);
    clc
    return
end

% start importing force-curves
bar = waitbar(0,'Preparing Data...');
for i = 1:steps
    disp(filenames{i});
    filepath = [path filenames{i}];
    curve = afm(filepath, 'EasyImport', EasyImport);
    curve.SegmentHeaderLength = SegmentHeaderLength;
    curve.GeneralHeaderLength = GeneralHeaderLength;
    curve.Delimiter = Delimiter;
    curve.Comments = Comments;
    curve.ColumnSpecifier = ColumnSpecifier;
    curve.SearchQuery = SearchQuery;
    
    % if FileSpecifier doesn't fit to InformationStyle 
    % (e.g. loading ibw-curves with jpk information style)
    FileSpecifier = ['*' curve.FileSpecifier];
    Allowed = afm.AllowedFileSpecifiers;
    ValidInformationStyles = afm.ValidInformationStyles;
    loaded = find(ismember(Allowed, FileSpecifier));
    supposed = find(ismember(ValidInformationStyles, InformationStyle));
    if loaded ~= supposed
        note = sprintf('SPECIFIED Force-Curve Type does not fit to LOADED Force-Curve Type');
        HelperFcn.ShowNotification(note);
        msgID = 'FCP:ImportData:FiletypeDiscrepancy';
        msg = 'SPECIFIED Force-Curve Type does not fit to LOADED Force-Curve Type\n>> skipping Curve';
        warning(msgID, msg);
        continue
    end
    
    try
        curve = curve.ImportData();
    catch ME % if you can
        switch ME.identifier
            case 'afm:ImportData:invalidFileSpecifier' % wrong filetype
                warning(ME.identifier,...
                    '\n%s\n%s',...
                    ME.message,...
                    '>> skipping Curve');
                HelperFcn.ShowNotification('Invalid FileSpecifier >> skipping Curve');
                continue
            otherwise
                rethrow(ME);
        end
    end
    
    if ~EasyImport
        curve = curve.StartSearch(InformationStyle);
    end
    
    try
        handles.curveprops.settings.FileSpecifier = curve.FileSpecifier;
        handles.curveprops.addproperty(curve.FileName);
        handles.curveprops.(curve.FileName).RawData = curve;
        handles.curveprops.(curve.FileName).Results = Results();
        handles.listeners.addListener(handles.curveprops.(curve.FileName).Results,...
            'Status', 'PostSet',...
            {@Callbacks.UpdateProcessingCurveStatusCallback, handles});
    catch ME
        switch ME.identifier
            case 'MATLAB:AddField:InvalidFieldName'
                warning(ME.identifier,...
                        '%s\n%s >> skipping Curve',...
                        ME.identifier,...
                        ME.message);
                HelperFcn.ShowNotification('Invalid Curve-Name >> skipping Curve');
                continue
            case 'MATLAB:class:PropertyInUse'
                warning(ME.identifier,...
                    '%s\n%s >> skipping curve',...
                    ME.identifier,...
                    ME.message);
            otherwise
                rethrow(ME);
        end
    end
    waitbar(i/steps, bar);
end

% refreshing the handles.guiprops.Features.curve_parts_popup property
handles.guiprops.FireEvent('UpdateObject');

% update processing information labels
% handles = guidata(handles.figure1);
handles = HelperFcn.UpdateProcInformationLabels(handles);

% update calibration-statuslabels if curves are calibrated 
handles = HelperFcn.UpdateCalibrationStatus(handles);

% update CalibrationValues-property of curveprops if available
[sensitivity, springconstant, handles] = UtilityFcn.CalibrationValues(handles);
handles.curveprops.CalibrationValues.Sensitivity = sensitivity;
handles.curveprops.CalibrationValues.SpringConstant = springconstant;

disp('Done');
close(bar);
guidata(handles.figure1, handles);

