% Copyright (c) 2016, German Neuroinformatics Node (G-Node)
%
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted under the terms of the BSD License. See
% LICENSE file in the root of the Project.

classdef File < nix.Entity
    % File nix File object

    properties(Hidden)
        % namespace reference for nix-mx functions
        alias = 'File'
    end

    methods
        function obj = File(path, mode)
            if (~exist('mode', 'var'))
                mode = nix.FileMode.ReadWrite; %default to ReadWrite
            end
            h = nix_mx('File::open', path, mode); 
            obj@nix.Entity(h);

            % assign relations
            nix.Dynamic.addGetChildEntities(obj, 'blocks', @nix.Block);
            nix.Dynamic.addGetChildEntities(obj, 'sections', @nix.Section);
        end

        % braindead...
        function r = isOpen(obj)
            fname = strcat(obj.alias, '::isOpen');
            r = nix_mx(fname, obj.nixhandle);
        end

        function r = fileMode(obj)
            fname = strcat(obj.alias, '::fileMode');
            r = nix_mx(fname, obj.nixhandle);
        end

        function r = validate(obj)
            fname = strcat(obj.alias, '::validate');
            r = nix_mx(fname, obj.nixhandle);
        end

        % ----------------
        % Block methods
        % ----------------

        function r = createBlock(obj, name, type)
            fname = strcat(obj.alias, '::createBlock');
            h = nix_mx(fname, obj.nixhandle, name, type);
            r = nix.Utils.createEntity(h, @nix.Block);
        end

        function r = blockCount(obj)
            r = nix.Utils.fetchEntityCount(obj, 'blockCount');
        end

        function r = hasBlock(obj, idName)
            r = nix.Utils.fetchHasEntity(obj, 'hasBlock', idName);
        end

        function r = openBlock(obj, idName)
            r = nix.Utils.openEntity(obj, 'openBlock', idName, @nix.Block);
        end

        function r = openBlockIdx(obj, index)
            idx = nix.Utils.handleIndex(index);
            r = nix.Utils.openEntity(obj, 'openBlockIdx', idx, @nix.Block);
        end

        function r = deleteBlock(obj, del)
            r = nix.Utils.deleteEntity(obj, 'deleteBlock', del, 'nix.Block');
        end

        function r = filterBlocks(obj, filter, val)
            r = nix.Utils.filter(obj, 'blocksFiltered', filter, val, @nix.Block);
        end

        % ----------------
        % Section methods
        % ----------------

        function r = createSection(obj, name, type)
            fname = strcat(obj.alias, '::createSection');
            h = nix_mx(fname, obj.nixhandle, name, type);
            r = nix.Utils.createEntity(h, @nix.Section);
        end

        function r = sectionCount(obj)
            r = nix.Utils.fetchEntityCount(obj, 'sectionCount');
        end

        function r = hasSection(obj, idName)
            r = nix.Utils.fetchHasEntity(obj, 'hasSection', idName);
        end

        function r = openSection(obj, idName)
            r = nix.Utils.openEntity(obj, 'openSection', idName, @nix.Section);
        end

        function r = openSectionIdx(obj, index)
            idx = nix.Utils.handleIndex(index);
            r = nix.Utils.openEntity(obj, 'openSectionIdx', idx, @nix.Section);
        end

        function r = deleteSection(obj, del)
            r = nix.Utils.deleteEntity(obj, 'deleteSection', del, 'nix.Section');
        end

        function r = filterSections(obj, filter, val)
            r = nix.Utils.filter(obj, 'sectionsFiltered', filter, val, @nix.Section);
        end

        % maxdepth is an index
        function r = findSections(obj, maxDepth)
            r = obj.filterFindSections(maxDepth, nix.Filter.acceptall, '');
        end

        % maxdepth is an index
        function r = filterFindSections(obj, maxDepth, filter, val)
            r = nix.Utils.find(obj, 'findSections', maxDepth, filter, val, @nix.Section);
        end
    end

end
