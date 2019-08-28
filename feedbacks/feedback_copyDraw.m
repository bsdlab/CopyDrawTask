function familiarization_copyDraw( file_fbsettings )

    PsychJavaTrouble;
    
    load(file_fbsettings);
    addpath(genpath('./'));
    generic = set_psychFeedback(fbsettings);
    startTime = clock; 
    startExp = tic;
    tempgen = generic;  
    tempgen.training = 1;
    tempgen.trialsVector = generateTrialsVect(fbsettings.n_trials, {'shapes'}, fbsettings.image_size, fbsettings.n_letters);

    scores = wordTask(tempgen);
    finExp = toc(startExp);
    
    save(fullfile(generic.datDir,['scores_',generic.block_name]),'scores','finExp')
    
    ShowCursor;
    Screen(tempgen.theWindow,'Close');
    
    disp('familiarization ...Done!')
    
exit()
end

