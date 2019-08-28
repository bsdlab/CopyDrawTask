function [ resultsST ] = wordTask( generic )
%LETTERTASK Request a trace, trace over a few times


    theWindow = generic.theWindow;
    startTrial = 1;
    
    if isfield(generic,'rerun');
        % Figure out how far we got
        temp = dir([generic.datDir 't-*']);
        startTrial = length(temp)+1;
    end
    
    trialsVector = generic.trialsVector;
    totTrials = length(trialsVector.names);
    resultsST = NaN(2,totTrials); % Score then time
    
    if (length(generic.trialsVector(1).names)) == 6 %For the training block, give loads of time
        letterTime = max(generic.blockLetterTimes);
    else
        letterTime = generic.blockLetterTimes(1);
    end
    lastBreak = tic;
    
    block_specific_info = fullfile(generic.datDir, generic.block_name);
    mkdir(block_specific_info)
    save(fullfile(generic.datDir,generic.block_name, ['tinfo_',generic.block_name]),'trialsVector');
    
    for nTrial = startTrial:totTrials
        % Loadup letter information
        load(char(trialsVector.places(nTrial)),'templateLet','theBox');
        generic.theBox = theBox;
        
        % Calculate trial time
        totTime = letterTime*length(char(trialsVector.names(nTrial)));
        
        % Trace the letter
        id = trialsVector.id(nTrial);
        [traceLet, trialTime, preTrialTime, trialStart, exited] = ...
            traceLetter(templateLet, generic, totTime,...
            generic.finishWhenRaised, id, 'trial_number', nTrial, 'total_trials', totTrials);
        if exited
            break;
        end
        
        % Calculate the score and save trial information
        score = 0; % do this post-hoc
        
        theWord = char(trialsVector.names(nTrial));
        save_name = fullfile(generic.datDir, generic.block_name, [ 'tscore_' int2str(nTrial),generic.block_name]);

        save(save_name,'templateLet','traceLet','score','trialStart', 'trialTime','preTrialTime', 'theBox','theWord','id');
        
        
        resultsST(:,nTrial) = [score trialTime];
        
        % Draw nothing for the break.
        clear score trialTime templateLet traceLet;
        interPause = tic;
  
    end
    
    
end
