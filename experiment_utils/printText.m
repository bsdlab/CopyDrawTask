function [] = printText( generic, myText, enforceTime )
%Draw the instructions on the screen
%   Mostly taken from DrawFormattedTextDemo.m

if nargin < 3
    enforceTime = 0;
end

theWindow = generic.theWindow;
theRect = generic.theRect;
Screen(theWindow,'FillRect',[5 5 5]);
textColour = [153 153 255];
HideCursor;
% Draw the text to the screen
DrawFormattedText(theWindow, myText, 'center', 'center', textColour, 60, 0, 0, 1.5);
if ~enforceTime
    DrawFormattedText(theWindow, 'Press any key to continue...', 'center', (theRect(4)-50),textColour);
end
Screen('Flip',theWindow);

if enforceTime
    pause(enforceTime);
    DrawFormattedText(theWindow, 'Press any key to continue...', 'center', 'center',textColour);
    Screen('Flip',theWindow);
    KbWait;
else
    pause(1);
    KbWait;
end
end

   