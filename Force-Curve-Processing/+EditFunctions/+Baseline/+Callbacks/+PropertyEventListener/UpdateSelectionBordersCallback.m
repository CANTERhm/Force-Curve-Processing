function UpdateSelectionBordersCallback(src, evt)
%UPDATESELECTIONBORDERSCALLBACK Updates selection_borders in results
    UtilityFcn.RefreshGraph('EditFunction', 'Baseline', 'RefreshAll', true);
    EditFunctions.Baseline.AuxillaryFcn.UserDefined.MarkupData();
end % UpdateSelectionBordersCallback

