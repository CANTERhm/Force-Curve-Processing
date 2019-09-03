table = handles.guiprops.Features.edit_curve_table;

% abort if tabel is empty (means no curves loaded)
if isempty(table.Data) || isempty(table.UserData)
    return
end

curvename = table.UserData.CurrentCurveName;
RawData = handles.curveprops.(curvename).RawData;
results = handles.curveprops.(curvename).Results.Baseline.calculated_data;

% results = [];

fig = figure();
ax = axes(fig);
ax.NextPlot = 'add';
grid on;
grid minor;

if ~isempty(results)
    cd = UtilityFcn.ExtractPlotData(RawData, handles,...
        'xchannel_idx', 'measuredHeight',...
        'ychannel_idx', 'vDeflection',...
        'edit_button', 'Baseline');
else
    cd = UtilityFcn.ExtractPlotData(RawData, handles,...
        'xchannel_idx', 'measuredHeight',...
        'ychannel_idx', 'vDeflection',...
        'edit_button', 'procedure_root_btn');
end 
parts = fieldnames(cd);

for i = 1:length(parts)
    part = parts{i};
    segments = fieldnames(cd.(parts{i}));
    for n = 1:length(segments)
        seg = segments{n};
        plot(ax, cd.(part).(seg).XData, cd.(part).(seg).YData);
    end
end

% clearvars -except main handles