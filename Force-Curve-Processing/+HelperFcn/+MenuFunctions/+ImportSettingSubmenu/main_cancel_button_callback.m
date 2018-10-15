function main_cancel_button_callback(src, evt)
% MAIN_CANCEL_BUTTON_CALLBACK processes the cancel-pushbutton event on main

main = findobj(groot, 'Type', 'Figure', 'Name', 'Import Settings');

% if necessary, do something important

delete(main);

