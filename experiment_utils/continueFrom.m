% Experiment. Large parts of this were simply copied from MouseTraceDemo2.
% Thanks guys! Other scripting done by George Prichard 02/02/2012.

try 
    %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    PsychJavaTrouble;
    %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    % Get subject info, create a storage directory
    clear all; clear all;
    if 1
        default   = {'test'};answer   = {'test'};
        while strcmp(answer{1},default{1})
            commandwindow
            prompt = {'Enter participant number'};
            dlg_title = 'Participant Data Storage';
            num_lines = 1;
            answer    = inputdlg(prompt,dlg_title,num_lines,default);
            file   = answer{1};
        end
    end
        
    day = inputdlg('Training Day','Participant Trial Generation',1,{' '});
    day = str2double(day); generic.day = day;
    generic.datDir = ['data/' file '/' int2str(day) '/'];
    mkdir(generic.datDir);
    if length(dir(generic.datDir))<3
        error('Directory empty. FAIL.');
    end
    
    load(['data/' file '/trialsVector'],'trialsVector');
        
    trialsVector = trialsVector(day);
    generic.trialsVector = trialsVector;
    
    % Preferences
    generic.boxColour = [160 160 180];
    generic.boxHeight = 200;
    generic.boxLineWidth = 6;
    
    generic.templateColor = [80 80 150];
    generic.templateThickness = 3;
    
    generic.traceColor = [255 50 50]; % Crimson
    generic.traceThickness = 1;
    
    generic.breaksEvery = 15; % enforced break every n trials
    generic.breakTime = 15; % Break time in seconds
    generic.scoreWait = 1;
    
    generic.letterTime = 2; % seconds allowed per letter
    
    
    % Open up a window on the screen and clear it.
    whichScreen = max(Screen('Screens'));
    [theWindow,theRect] = Screen(whichScreen,'OpenWindow');
    
    % Housekeeping
    KbName('UnifyKeyNames')
    generic.escKeys = [KbName('LeftControl') KbName('x') KbName('LeftShift')];
    generic.return = KbName('Return');

    generic.theWindow = theWindow; 
    generic.theRect = theRect;
    theX = theRect(RectRight)/2;
    theY = theRect(RectBottom)/2;
    generic.theX = theX; generic.theY = theY;
    startTime = clock; % because you just never know. 
    instructionText = ['Ready?'];
    printText(generic,instructionText);
    startExp = tic;
    
    generic.rerun = 1;   
    % This is how you run the word task
    scores = wordTask(generic);
    finExp = toc(startExp);
    save([generic.datDir 'scores'],'scores','finExp');
    fprintf('tt: %1.2f\n',finExp/60);
    
    % 
    closingText = 'Aaand you are done for today! Thanks a bunch for coming :-)'; 
    
    printText(generic,closingText);
    
    % Close up shop
    Screen(theWindow,'DrawText','Click mouse to finish',50,50,255);
    ShowCursor;
    Screen(theWindow,'Close');

catch
    Screen('CloseAll')
    ShowCursor;
    psychrethrow(psychlasterror);
end %try..catch..
