function [ trialOrder ] = randomise( useWords, useShapes )
%RANDOMISE Randomise the trials vector
    % Avoid repeating shapes/words AND repeating trial lengths

numLengthReps = 4;
numTypeReps = 5;

wordLs = cellfun(@length,useWords);
shapeLs= cellfun(@length,useShapes);

trialTypes = [wordLs-2 shapeLs+1];
nameTypes =1:(length(useWords) + length(useShapes));

trialOrder = randperm(length(trialTypes));
randInput = trialTypes(trialOrder);

%% Calculate word/shape repetitions
word0shape1 = (randInput/3)>1;
word_shape_reps = any([findstr(word0shape1,zeros(1,numTypeReps)), findstr(word0shape1,ones(1,numTypeReps))]);

%% Calculate length repetitions
wsLens =  randInput;
wsLens(wsLens>3) = wsLens(wsLens>3)-3;
length_reps = any(findstr(diff(wsLens),zeros(1,numLengthReps)));

%% Ensure no 2 in a row of anything
repNames = any(diff(nameTypes(trialOrder))==0);

z = 0;
tic;
while length_reps || word_shape_reps || repNames
    trialOrder = randperm(length(trialTypes));
    randInput = trialTypes(trialOrder);

    %% Calculate word/shape repetitions
    word0shape1 = (randInput/3)>1;
    word_shape_reps = any([findstr(word0shape1,zeros(1,numTypeReps)), findstr(word0shape1,ones(1,numTypeReps))]);

    %% Calculate length repetitions
    wsLens =  randInput;
    wsLens(wsLens>3) = wsLens(wsLens>3)-3;
    length_reps = any(findstr(diff(wsLens),zeros(1,numLengthReps)));
    z = z+1;
    
    %% Calculate name repetitions
    repNames = any(diff(nameTypes(trialOrder))==0);

end
fprintf('Randomisation took %1.2fs and %i iterations\n',toc,z);
    
    
    
end

