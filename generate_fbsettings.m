function fbsettings = generate_fbsettings(VPcode,fbsettings_name, root_name, block_name)
%UNTITLED2 Summary of this function goes here

global PPORT 
fbsettings = struct;
fbsettings.VPcode = VPcode
fbsettings.n_trials = 12; % choose multiple of n_letters
fbsettings.letter_time = 2.2; % 2.2; % Adapt this for each patient
fbsettings.image_size = 2; % possible: [1, 1.5, 2, 2.5, 3, 3.5]
fbsettings.n_letters = 3; % 3 - 3 letters per shape (long form), 2 - 2 letters per shape (short form)
fbsettings.block_name = block_name;
fbsettings.root_dir = root_name;
fbsettings.finishWhenRaised = 0; % finish trial when pencil loses contact with sketch tablet

save(fbsettings_name, 'fbsettings')

end

