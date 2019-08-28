function [ all ] = generateTrainingVect( N_trials ,imageSize)
%GENERATETRAININGVECT Pass back the training vector

% tWD = fullfile('templates','trainingWords');
tSD = fullfile('templates','trainingShapes', ['/Size_' num2str(imageSize) '/']);
% trainWords = dir(fullfile(tWD, '*.mat')); trainWords = {trainWords.name}; trainWords = strrep(trainWords,'.mat','');
trainShapes = dir(fullfile(tSD, '*.mat')); trainShapes = {trainShapes.name}; trainShapes = strrep(trainShapes,'.mat','');

% tWPlaces = strcat(tWD,trainWords);
tSPlaces = fullfile(tSD,trainShapes);

% all.names = [trainWords trainShapes];
% all.places = [tWPlaces tSPlaces];


all.names = repmat(trainShapes,1,ceil(N_trials/numel(trainShapes)));
all.names = all.names(1:N_trials);
all.places = repmat(tSPlaces,1,ceil(N_trials/numel(tSPlaces)));
all.places = all.places(1:N_trials);

all.id = zeros(1,numel(all.names));

%% TODO GENERATE CODE TO IDENTIFY EACH SHAPE WITH A MARKER
unique_names = unique(all.names);

for idx_name_unique = 1:numel(unique_names)
    idx_code = ismember(all.names,unique_names{idx_name_unique});
    all.id(idx_code) = idx_name_unique;
end
end

