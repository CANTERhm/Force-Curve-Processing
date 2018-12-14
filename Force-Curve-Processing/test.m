
clearvars

springconstant = 0.0823;
fig = findall(allchild(groot), 'Type', 'Figure', 'Tag', 'MainFigure');
ax = findall(allchild(fig), 'Type', 'Axes');
lines = findall(allchild(ax), 'Type', 'Line');
line = lines(1);

xdata = line.XData';
ydata = line.YData';
xcorr = xdata + ydata./springconstant;

fig = figure();
fig.Position = [100 100 1200 800];
hold on
plot(xdata, ydata, 'Marker', '.', 'LineStyle', 'none');
plot(xcorr, ydata, 'Marker', '.', 'LineStyle', 'none');
hold off
legend('raw', 'corrected')