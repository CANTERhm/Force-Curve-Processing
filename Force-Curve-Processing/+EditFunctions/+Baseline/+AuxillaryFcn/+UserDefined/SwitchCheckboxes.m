function SwitchCheckboxes(src, obj_list)
    mask = obj_list ~= src;
    list = obj_list(mask);
    for i = 1:length(list)
        if src.Value == 1
            list(i).Value = 0;
        else
            list(i).Value = 1;
        end
    end
end % SwitchCheckboxes
