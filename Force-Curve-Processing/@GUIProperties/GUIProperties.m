classdef GUIProperties < Properties 
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
        Features
    end % properties

    methods
        
        function obj = GUIProperties()
            obj.Panels = [];
            obj.Features = [];
        end % Boa constructor
        
    end % methods

end % classdef