function generic = set_psychFeedback(fbsettings)
global BTB

VPcode = fbsettings.VPcode;
root_dir = fbsettings.root_dir;
generic.datDir = root_dir;
mkdir(generic.datDir);

generic.image_size = fbsettings.image_size;
n_trials = fbsettings.n_trials;
LetterTime = fbsettings.letter_time;
generic.block_name =  fbsettings.block_name;
generic.finishWhenRaised = fbsettings.finishWhenRaised;
trialsVector = generateTrialsVect(n_trials, {'shapes'}, generic.image_size, fbsettings.n_letters);
generic.trialsVector = trialsVector;

% trial tep
generic.breaksEvery = n_trials; % Enforced break every n trials
generic.blockLetterTimes = [LetterTime]; % seconds allowed per letter

% Task preferences.
generic.boxColour = [160 160 180];

generic.boxHeight = 200;
generic.boxLineWidth = 6;

generic.templateColor = [80 80 150];
generic.templateThickness = 2;

generic.traceColor = [255 50 50]; % Crimson
generic.traceThickness = 3;

generic.startTrialBoxColor = [50 255 255];
generic.startTrialBoxWidth = 20;
generic.distance2Trace = 200;

generic.startDrawBoxWidth = 10;

generic.readingTime = 10;
generic.breakTime = 7; % Enforced break time in seconds (minimum only, no maximum)
generic.scoreWait = 1;

Screen('Preference', 'SkipSyncTests', 1)
screen_info = get(0, 'MonitorPositions');
% Open up a window on the screen and clear it.
whichScreen = max(Screen('Screens'));
if length(Screen('Screens')) == 1
    [theWindow,theRect] = Screen(whichScreen,'OpenWindow', [], [0 0 screen_info(end,end-1:end)]);
else
    hostname = char( getHostName( java.net.InetAddress.getLocalHost ) );
    if strcmp(hostname,'precision')
        [theWindow,theRect] = Screen(whichScreen,'OpenWindow', [], [screen_info(1,1:2),0,1080]);
    else
        [theWindow,theRect] = Screen(whichScreen,'OpenWindow', [0 0 0.7*screen_info(end,end-1:end)]);
    end
end


% Housekeeping
KbName('UnifyKeyNames')
generic.escKeys = [KbName('LeftControl') KbName('x') KbName('LeftShift')]; % Hold down these keys to escape
generic.return = KbName('Return');
generic.theWindow = theWindow;
generic.theRect = theRect;
theX = theRect(RectRight)/2;
theY = theRect(RectBottom)/2;
generic.theX = theX; generic.theY = theY;