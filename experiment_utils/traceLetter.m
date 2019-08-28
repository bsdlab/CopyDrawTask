function [ thePoints, trialTime, preTrialTime, trialStart, exit] = traceLetter( templateLet, generic, totTime, oneTouch, id, varargin )
%GETLETTER Ask the participant to draw a letter and retain it
%   Derived from MouseTraceDemo2. Remember: thePoints will be intuitively
%   upside down, but should be kept this way for simplicity of later
%   calculations.

%%% Seems like a good place to start a function....
global BTB % bbci tolbox global config variable

opts = propertylist2struct(varargin{:});
opts = set_defaults(opts,...
                'trial_number',[],...
                'total_trials', []);
   

% Return parameters
trialTime = 0;
preTrialTime = 0;
trialStart = 0;
exit = 0;

% General parameters
theWindow = generic.theWindow;
theRect = generic.theRect;
theBox = generic.theBox;
boxLineWidth = generic.boxLineWidth;
boxColour = generic.boxColour;
boxPos = theBox.boxPos;
startTrialWidth = generic.startTrialBoxWidth;
startDrawWidth = generic.startDrawBoxWidth;
% Ensure we can see the cursor, then fill the screen and show the beginning
% message.
ShowCursor(1);
Screen(theWindow,'FillRect',0);

% Draw trial number
if ~isempty(opts.trial_number)
    Screen(theWindow,'TextSize',20);
    str_trials = sprintf('%d/%d', opts.trial_number, opts.total_trials);
    Screen(theWindow, 'DrawText', str_trials, theRect(3)*0.9, theRect(4)*0.1,255);
end
% Draw indication
Screen(theWindow,'TextSize',40);
Screen(theWindow,'DrawLines',boxPos,boxLineWidth,boxColour);
disp(pwd)
theImageLocation = fullfile(pwd,'templates','instructions.png');
theImage = imread(theImageLocation);
imageTexture = Screen('MakeTexture', theWindow, theImage);
Screen('DrawTexture', theWindow, imageTexture, [0,0,1200,100], [400,108,1700, 208]);


% Draw the previous letter, remove any NaNs (there shouldn't be any with
% this version of the code...
let = templateLet';
let(:,isnan(let(1,:))) = [];

% Draw the template
templateThickness = generic.templateThickness;
Screen(theWindow,'DrawDots',let,templateThickness,generic.templateColor);
timingBar(totTime,totTime,generic);

% Generate area around starting point of the template letter
[~, ind] = min(let(1,:));
startPt = let(:,ind);
startAreaDraw = [(startPt(1) - startDrawWidth):1:(startPt(1) + startDrawWidth); (startPt(2) - startDrawWidth):1:(startPt(2) + startDrawWidth)];
Screen('FillOval', theWindow, generic.traceColor, [(startPt(1) - startDrawWidth) (startPt(1) + startDrawWidth); (startPt(2) - startDrawWidth) (startPt(2) + startDrawWidth)])

% Generate area which has to be touched to start trial
startTrialX = startPt(1) - generic.distance2Trace; 
startTrialY = startPt(1) - generic.distance2Trace; 
startAreaTrial = [(startTrialX - startTrialWidth):1:(startTrialX + startTrialWidth); (startTrialY - startTrialWidth):1:(startTrialY + startTrialWidth)];
Screen('FrameRect', theWindow, generic.startTrialBoxColor, [(startTrialX - startTrialWidth) (startTrialX + 20); (startTrialY - 20) (startTrialY + startTrialWidth)], 2);
Screen('Flip', theWindow);

% Make sure you aren't already touching at the very start
[x,y,buttons] = GetMouse(theWindow); 
while buttons(1)
    [x,y,buttons] = GetMouse(theWindow); 
end

% Wait for the first mouse 'click' (touching the tablet).
while (1)
    [x,y,buttons] = GetMouse(theWindow);
    % GO GO GO!
    % If 
    %     if buttons(1) && all([any(x==theBox.inX) any(y==theBox.inY)])
    % Reduce area
    % Wait for test person touching the trial start point
    if buttons(1) && all([any(x==startAreaTrial(1,:)) any(y==startAreaTrial(2,:))])
        startTrialTime = tic;
        break;
    end
    
    [k t keys] = KbCheck; % Allow escapes 
    if all(keys(generic.escKeys));
%         sca; 
        thePoints = [];
        exit = 1;
        return;
    end
end

Screen(theWindow,'FillRect',0);
Screen(theWindow,'DrawLines',boxPos,boxLineWidth,boxColour);
Screen(theWindow,'DrawDots',let,templateThickness,generic.templateColor);
timingBar(totTime,totTime,generic);
Screen('FillOval', theWindow, generic.traceColor, [(let(1,ind) - startDrawWidth) (let(1,ind) + startDrawWidth); (let(2,ind) - startDrawWidth) (let(2,ind) + startDrawWidth)]);
Screen('FillRect', theWindow, generic.startTrialBoxColor, [(startTrialX - startTrialWidth) (startTrialX + startTrialWidth); (startTrialY - startTrialWidth) (startTrialY + startTrialWidth)], 2);
Screen('Flip', theWindow);

while (1)
    [x,y,buttons] = GetMouse(theWindow); 
    % Wait for test person touching the drawing start point
    if buttons(1) && all([any(x==startAreaDraw(1,:)) any(y==startAreaDraw(2,:))])
        preTrialTime = toc(startTrialTime);
        trialStart = tic;
        break;
    end
end

%%%%% Below is *mostly* repeated within the while loop.
% Redraw the box, template, and timing bar - neccesary to use slow 'flip' as we change the text.
Screen(theWindow,'DrawLines',boxPos,boxLineWidth,boxColour);
Screen(theWindow,'DrawDots',let,templateThickness,generic.templateColor);
timingBar(totTime,totTime,generic);
%Screen(theWindow,'DrawText','Lift up pen to finish',50,RectBottom-200,255);

% Draw the first line!
[theX,theY] = GetMouse(theWindow);
thePoints = [theX theY];
traceColor = generic.traceColor;
traceThickness = generic.traceThickness;
Screen(theWindow,'DrawLine',traceColor,theX,theY,theX,theY,traceThickness);

% Set the 'dontclear' flag of Flip to 1 to prevent erasing the
% frame-buffer:
% Screen('Flip', theWindow, 0, 1);
Screen('Flip', theWindow);
% goTime = 1;
theTimer = tic;

while (1)
    [x,y,buttons] = GetMouse(theWindow);	
    % oneTouch means lifting the pen off the trackpad stops the trial.
    if ~buttons(1) 
        if oneTouch 
            % interrupt marker
            break;
        elseif ~isnan(thePoints(end,1))
            thePoints = [thePoints ; NaN NaN]; %#ok<AGROW>
            endTrialTime = tic;
        end
    end
    
    % Otherwise, we need to run out of time to end a trial.
    if totTime-toc(theTimer) <= 0;
        if ~isnan(thePoints(end,1)) % This only runs if they're still drawing at the end of a trial
            thePoints = [thePoints ; NaN NaN]; %#ok<AGROW>
            clear endTrialTime;
        end
        break; 
    end
        
    % Redraw the box, template 
    Screen(theWindow,'DrawLines',boxPos,boxLineWidth,boxColour);
    Screen(theWindow,'DrawDots',let,templateThickness,generic.templateColor);
    
    if buttons(1)
        % Draw trace
        thePoints = [thePoints ;x, y]; %#ok<AGROW>   
        Screen('FillOval', theWindow, traceColor, [(x - startDrawWidth), (x + startDrawWidth); (y - startDrawWidth), (y + startDrawWidth)])
        theX = x; theY = y;
    end
    
    for i = 1:size(thePoints)-1            
        Screen(theWindow,'DrawLine',traceColor,thePoints(i,1),thePoints(i,2),thePoints(i+1,1),thePoints(i+1,2),traceThickness);
    end
    % Redraw timing bar
    timingBar(totTime,totTime-toc(theTimer),generic);
    Screen('Flip', theWindow);
end

trialTime = toc(theTimer);
if exist('endTrialTime','var')
    trialTime = trialTime - toc(endTrialTime);
end
end

