classdef CurveProperties < Properties
% CURVEPROPERTIES hold properties concerning fc-data
%
% Zur Verfügung stehen die Voreingestellten SegmentHeader Längen:
% 'jpk_fc_full_settings' >> volle Header Länge eines F-C-Experiments: 108
% 'jpk_fc_channel_info_only' >> nur Kanalinfos eines F-C-Experiments: 7

    properties
        settings
    end % properties
    
    properties(Constant)
%         JPK_NW_I_ClampSegmentNames = { % (:,1) --> own names; (:,2) --> jpk names
%             'Segment1', 'extend-spm';...
%             'Segment2', 'paus-at-end-spm';...
%             'Segment3', 'Initial retract';...
%             'Segment4', 'Clamp retract';...
%             'Segment5', 'plane-spm';...
%             'Segment6', 'retract-spm'};
        JPK_NW_I_ClampSegmentNames = struct('Segment1', 'extend-spm',...
            'Segment2', 'paus-at-end-spm',...
            'Segment3', 'Initial retract',...
            'Segment4', 'Clamp retract',...
            'Segment5', 'plane-spm',...
            'Segment6', 'retract-spm');
%         JPK_NW_I_ClampSegmentNames = struct('extend-spm', 'Segment1',...
%             'paus-at-end-spm', 'Segment2',...
%             'Initial retract', 'Segment3',...
%             'Clamp retract', 'Segment4',...
%             'plane-spm', 'Segment5',...
%             'retract-spm', 'Segment6');
    end % constant properties
    
    methods
        
        function obj = CurveProperties()
            obj.settings.UserData = [];
            obj.settings.CurvePartIdx = [];
            obj.settings.FileSpecifier = [];
            obj.settings.SegmentHeaderLength = 'jpk_fc_full_settings';
            obj.settings.GeneralHeaderLength = 8;
            obj.settings.Delimiter = ' ';
            obj.settings.Comments = '#';
            obj.settings.ColumnSpecifier = 'columns';
            obj.settings.SearchQuery = 'jpk-nanowizard-I-standard';
            obj.settings.InformationStyle = 'jpk-nanowizard-I';
            obj.settings.EasyImport = false;
        end % Boa Constructor
        
    end % methods
    
end % classdef