% Copyright (c) 2016, German Neuroinformatics Node (G-Node)
%
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted under the terms of the BSD License. See
% LICENSE file in the root of the Project.

classdef Property < nix.NamedEntity
    % PROPERTY Metadata Property class
    %   NIX metadata property

    properties (Hidden)
        % namespace reference for nix-mx functions
        alias = 'Property'
    end

    properties (Dependent)
        values
    end

    methods
        function obj = Property(h)
            obj@nix.NamedEntity(h);

            % assign dynamic properties
            nix.Dynamic.add_dyn_attr(obj, 'unit', 'rw');
            nix.Dynamic.add_dyn_attr(obj, 'mapping', 'rw');
            nix.Dynamic.add_dyn_attr(obj, 'datatype', 'r');
        end

        function r = get.values(obj)
            fname = strcat(obj.alias, '::values');
            r = nix_mx(fname, obj.nix_handle);
        end

        function [] = set.values(obj, val)
            values = val;
            if (~iscell(values))
                values = num2cell(val);
            end

            for i = 1:length(values)
                if (isstruct(values{i}))
                    curr = values{i}.value;
                else
                    curr = values{i};
                end

                if (~strcmpi(class(curr), obj.datatype))
                    error('Values do not match property data type!');
                end
            end

            fname = strcat(obj.alias, '::updateValues');
            nix_mx(fname, obj.nix_handle, values);
        end

        function r = value_count(obj)
            fname = strcat(obj.alias, '::valueCount');
            r = nix_mx(fname, obj.nix_handle);
        end

        function [] = values_delete(obj)
            fname = strcat(obj.alias, '::deleteValues');
            nix_mx(fname, obj.nix_handle);
        end

        % return value 0 means name and id of two properties are
        % identical, any other value means either name or id differ.
        function r = compare(obj, property)
            if (~isa(property, class(obj)))
               error('Function only supports comparison of Properties.');
            end

            fname = strcat(obj.alias, '::compare');
            r = nix_mx(fname, obj.nix_handle, property.nix_handle);
        end
    end

end
