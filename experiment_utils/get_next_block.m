function next_block = get_next_block(dir_base, block_name )
% The next consecutive block number
%
contents = dir(dir_base);
contents = {contents.name};
substrmatch = @(targ,cellArray) find(~cellfun(@isempty,strfind(cellArray,targ)));

matching_files = substrmatch(block_name,contents);
matching_files = contents(matching_files);

for idx = 1:numel(matching_files)
    fname = matching_files{idx};
    idx_ext = strfind(fname,'.');
    if ~isempty(idx_ext)
        matching_files{idx} = fname(1:idx_ext-1);
    else
        matching_files{idx} = fname;
    end
end

matching_files = unique(matching_files);

recorded_blocks = [];
for idx = 1:numel(matching_files)
    if ~isempty(strfind(block_name, 'eyes')) || ~isempty(strfind(block_name, 'postRestingState'))
        block_str = matching_files{idx}(end-1:end);
    else
        block_str = matching_files{idx}(length(block_name)+1:end);
    end
    block_num = str2num(block_str);
    
    if isempty(block_num)
        wrng_str = sprintf('failed to identify block number for %s', matching_files{idx});
        warning(wrng_str);
    else        
        recorded_blocks = [recorded_blocks, block_num];
    end
end

if isempty(recorded_blocks)
    next_block = 1;
else
    next_block = max(recorded_blocks) +1;
end
