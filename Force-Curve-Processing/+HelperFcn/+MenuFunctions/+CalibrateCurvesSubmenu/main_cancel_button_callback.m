function main_cancel_button_callback(src, evt)
% MAIN_CANCEL_BUTTON_CALLBACK processes the cancel-pushbutton event on
% FCP-App main-function

main = findobj(allchild(groot), 'Type', 'Figure', 'Name', 'Calibrate Curves');

% if necessary, do something important

delete(main);

end

