function obj = ReadProcedureFile(obj, file)
%READPROCEDUREFILE Readout fc-procedure-files

status = exist(file, 'file');

if status ~= 2
    warning('FCProcedure:ReadProcedureFile:invalidInput',...
        'input was not a valid file')
    return
end

fileID = fopen(file);
while ~feof(fileID)
    funSpec = textscan(fileID, '# %s', 'Delimiter', '\n');
    funSpec = funSpec{1};
    if ~isempty(funSpec) % textscan couldn't apply formatSpec
        splitStr = split(funSpec{1}, ': ');
        newProp = splitStr{2};
        obj.addproperty(newProp);
        for i = 1:length(funSpec)
            splitStr = split(funSpec{i}, ': ');
            try
                splitStr{2} = eval(splitStr{2});
            catch ME % if you can
                switch ME.identifier
                    case 'MATLAB:UndefinedFunction'
                        % do nothing
                    otherwise
                        rethrow(ME);
                end % switch
            end % try
            obj.(newProp).(splitStr{1}) = splitStr{2};
        end
    else % move to the next line
        fgets(fileID);
    end
end
fclose(fileID);
