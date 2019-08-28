function [ all ] = generateTrialsVect(Ntrials, type, imageSize, n_letters)
%GENERATETV Generate the trials vector for each day.

if nargin <2
    type = {'words','shapes'};
end
if n_letters == 2
    letter_type = 'short_';
elseif n_letters == 3
    letter_type = '';
end

wordsDir = ['templates/words/Size_' letter_type num2str(imageSize) '/'];
shapesDir = ['templates/shapes/Size_' letter_type num2str(imageSize) '/'];

% Get ALL the words/shapes, directories of the templates
allWords = dir([wordsDir '*.mat']); allWords = {allWords.name};
allShapes = dir([shapesDir, '*.mat']); allShapes = {allShapes.name};
allWords = strrep(allWords,'.mat','');
allShapes = strrep(allShapes,'.mat','');

% Just a useful function to return places in an array where a target is
% found.
substrmatch = @(targ,cellArray) find(~cellfun(@isempty,strfind(cellArray,targ)));

[words shapes restwords restshapes] = returnNTrials(allWords,allShapes,Ntrials);

% Get the trial order
% ListOrder = randomise(words,shapes);
ListOrder = Shuffle(1:(numel(words)+numel(shapes)));

% Organise the names, places, type, and lengths for storage and loading
Names = [words, shapes]; 
Names = Names(ListOrder);

Places = [strcat(wordsDir, words) strcat(shapesDir,shapes)];
Places = Places(ListOrder);

Types = zeros(1,length(Places));
Types(substrmatch('/shapes/',Places)) = 1;

class_keep = ismember({'words','shapes'}, type);

idx_keep = find(((Types == 0) & class_keep(1)) | ...
    ((Types == 1) & class_keep(2)));
    
Lengths = cellfun(@length,Names);

%% Chuck everything into a nice, big struct

all = struct;
all.names = Names(idx_keep);
all.places = Places(idx_keep);
all.types = Types(idx_keep);
all.lengths = Lengths(idx_keep);
all.id = zeros(1,numel(all.names));

%% TODO GENERATE CODE TO IDENTIFY EACH SHAPE WITH A MARKER
unique_names = sort(unique(all.names));

for idx_name_unique = 1:numel(unique_names)
    idx_code = ismember(all.names,unique_names{idx_name_unique});
    all.id(idx_code) = idx_name_unique;
end
    


end

