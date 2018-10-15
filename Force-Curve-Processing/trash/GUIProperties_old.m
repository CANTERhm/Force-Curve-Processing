classdef GUIProperties < handle & dynamicprops
% GUIPROPERTIES class for organizing Gui properties like panels, boxes or
% buttons
%
% Guiproperties default properties are:
%   - Panels: property for GuiToolbox Panels
%   - SubPanels: property for sublevel Panels
%   - Features: property for Gui features like buttons
%   - DynamicProps: struct; holds all dynamically added properties
%
% Methods:
%   - addproperty(prop, Name Value Pairs)
%   --> add a property dynamically to an instance fo this class
%       - prop: (type: char) Name of property
%       - NV Pairs:
%           - prophandle: handle to the property 'prop'
%           - exclude: (type: logical) if true, prop doesn't get an entry in
%                      DynamicProps-Structure
%
%   - delproperty(prop)
%   --> delete a property from an instance of this class
%       - prop: (type: char) Name of property to delete

    properties (SetObservable, AbortSet)
        Panels
        SubPanels
        Features
        DynamicProps
    end % properties
    
    methods
        
        function obj = GUIProperties()
            obj.Panels = [];
            obj.SubPanels = [];
            obj.Features = [];
            obj.DynamicProps = struct();
        end % Boa constructor
        
        function obj = addproperty(obj, prop, varargin)
            % input parsing
            p = inputParser;
            
            ValidCharacterInput = @(x)assert(isa(x, 'char'), 'GuiProperties:addproperty:invalidInput',...
                'Input was not a character-vector');
%             ValidHandleInput = @(x)assert(isa(x, 'function_handle'), 'GuiProperties:addproperty:invalidInput',...
%                 'Input was not a function handle');
            ValidLogicInput = @(x)assert(islogical(x), 'GUIProperties:addproperty:invalidInput',...
                'Input was not true or false');
            
            addRequired(p, 'obj');
            addRequired(p, 'prop', ValidCharacterInput);
            addParameter(p, 'prophandle', []);
            addParameter(p, 'exclude', false, ValidLogicInput);
            
            parse(p, obj, prop, varargin{:});
            
            % method procedure
            obj = p.Results.obj;
            prop = p.Results.prop;
            prophandle = p.Results.prophandle;
            exclude = p.Results.exclude;
            
            dprop = obj.addprop(prop);
            dprop.SetObservable = true;
            
            switch exclude
                case false
                    obj.DynamicProps.(prop) = dprop;
            end
            
            if ~isempty(prophandle)
                obj.(prop) = prophandle;
            end
        end % addproperty
        
        function obj = delproperty(obj, prop, varargin)
            % input parsing
            p = inputParser;
            
            ValidCharacterInput = @(x)assert(isa(x, 'char'), 'GuiProperties:delproperty:invalidInput',...
                'Input was not a character-vector');
            
            addRequired(p, 'obj');
            addRequired(p, 'prop', ValidCharacterInput);
            
            parse(p, obj, prop, varargin{:});
            
            obj = p.Results.obj;
            prop = p.Results.prop;
            
            % method procedure
            try
                delete(obj.DynamicProps.(prop));
            catch ME % if you can
                switch ME.identifier
                    case 'MATLAB:nonExistentField'
                        warning('GuiPorperties:delproperty:nonExistentField',...
                            '\n%s\n', ME.message);
                        return
                    otherwise
                        rethrow(ME);
                end
            end
        end % delproperty
        
        
    end % methods


end % classdef