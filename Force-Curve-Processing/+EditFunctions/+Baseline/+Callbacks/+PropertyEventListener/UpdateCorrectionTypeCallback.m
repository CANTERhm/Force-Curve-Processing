function UpdateCorrectionTypeCallback(src, evt)
%UPDATECORRECTIONTYPECALLBACK update the correction_type property 
    UtilityFcn.RefreshGraph('EditFunction', 'Baseline', 'RefreshAll', true);
    EditFunctions.Baseline.AuxillaryFcn.UserDefined.MarkupData();
end % UpdateCorrectionTypeCallback

