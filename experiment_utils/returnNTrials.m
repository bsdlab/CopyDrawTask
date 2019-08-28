function [ useWords useShapes outWords outShapes ] = returnNTrials(possibleWords, possibleShapes, N)
%RETURNNTRIALS Called by generateTV - returns the requested number of
%trials of each condition

% if mod(N,3) 
%     error('Not divisible by 3, try again');
% end

% possibleWLen = cellfun(@length,possibleWords);
possibleSLen = cellfun(@length,possibleShapes);

% inWords = NaN(N,1);

% for i = 3:5
%     in = Shuffle(find(possibleWLen == i));
%     inPlace = (i-3)*N/3+1;
%     inWords(inPlace:inPlace+N/3-1) = in(1:N/3);
% end
inShapes = NaN(N,1);

% for i = 3:5
% for i= 3:4 % only "short" shapes
%     in = Shuffle(find(possibleSLen == i));
%     inPlace = (i-3)*N/2+1;
%     inShapes(inPlace:inPlace+N/2-1) = in(1:N/2);
% end

% useWords = possibleWords(inWords);
useWords = {};
% useShapes = possibleShapes(inShapes);
useShapes = repmat(possibleShapes,1,ceil(N/numel(possibleShapes)));
useShapes = useShapes(1:N);

% outWords = setdiff(possibleWords,useWords);
outWords = {};
outShapes = setdiff(possibleShapes,useShapes);



end

