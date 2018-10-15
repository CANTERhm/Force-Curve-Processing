function SwitchToggleState(src)
%SWITCHTOGLESSTATE applies the desired behavior of edit procedure
%toggelbuttons

% make sure, only switching another togglebutton can deactivate src
if src.Value == 0
    src.Value = 1;
end

% if src.Value == 1, set every other togglebutton.Value == 0
list = allchild(src.Parent);
mask = list ~= src;
list = list(mask);
for i = 1:length(list)
    list(i).Value = 0;
end