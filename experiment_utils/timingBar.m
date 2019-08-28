function [ ] = timingBar( totTime, timeLeft, generic)
%TIMINGBAR Show a timer bar on the screen with how long they have left
%   This is actually a grey bar, then a black bar that grows over it. This
%   allows for how drawing works in PTB.
try
% Draw the timer, 1/2 screen width, centered, at the bottom
theRect = generic.theRect;
timeSize = theRect(3)/4;
timeColour = [180 180 160];

timeXS = theRect(3)/2 - timeSize;
timeXF = theRect(3)/2 + timeSize;    
timeYS = theRect(4) - 100;
timeYF = theRect(4) - 100;

if totTime == timeLeft
    Screen(generic.theWindow,'DrawLine',timeColour,timeXS,timeYS,timeXF,timeYF,6);
else
    % Calculate how much time has passed, and draw a screen-coloured line
    % over the original line to represent that.
    consumedTime = timeXF-timeXS;
    consumedTime = consumedTime * (1-(timeLeft/totTime));
    timeXS = timeXS+consumedTime;
%     if timeLeft < totTime
%         save('timing');
%         gfdsfgs
%     end
    Screen(generic.theWindow,'DrawLine',timeColour,timeXS,timeYS,timeXF,timeYF,6);
end
catch
    err = lasterror;
    save('tB-error');    
    error('tracingBar error');
end
end

