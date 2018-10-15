function func = CreateFunctionFromList(filepath)
%CREATEFUNCTIONFROMLIST Create a func struct from txt.-file

fileID = fopen(filepath);
function_list = textscan(fileID, '%s');
function_list = function_list{1,1};
fclose(fileID);

for i = 1:length(function_list)
    str = split(function_list{i}, ',');
    
    if length(str) == 1
        f.name = str{1,1};
        f.callback = '';
        f.args = [];
    end
    
    if length(str) == 2
        f.name = str{1,1};
        f.callback = str2func(str{2,1});
        f.args = [];
    end
    
    if length(str) >= 3
        f.name = str{1,1};
        f.callback = str2func(str{2,1});
        f.args = str(3:end,1);
    end
    
    func.(str{1,1}) = f;
end

