clear; close all;
addpath(genpath('./'));

%
% Define here were to save the traces and results
% No need to modify the rest of the script just F5 and enjoy
%
% sebastian.castano@blbt.uni-freiburg.de
% 03.2019
%
results_dir = './tmp/';
root_name = fullfile(results_dir,['sample_run_',char(java.util.UUID.randomUUID.toString)]);


block_name_base = 'copyDraw_block';
info_runs_dir = fullfile(root_name,'info_runs');
mkdir(root_name);
mkdir(info_runs_dir);
while (1)
    next_block = get_next_block(root_name, block_name_base);
    qst = sprintf('Execute copy draw training block # %d? [y/n] ', next_block);
    answer = binary_question(qst);
    if ~answer
        break
    end
    block_name = [block_name_base, sprintf('%02d',next_block)];
    mkdir(fullfile(root_name,block_name));
    
    disp(sprintf('Press a key to start block number %d',next_block))
    pause
    fbsettings_name = fullfile(info_runs_dir,['block_',sprintf('%02d',next_block),'_fbsettings','.mat']);
    fbsettings = generate_fbsettings('testsubject',fbsettings_name, root_name,block_name);
    str = ['!matlab -nodesktop -nosplash -r "startup_copyDraw(); feedback_copyDraw(''',fbsettings_name,''')"'];
    eval(str)
end