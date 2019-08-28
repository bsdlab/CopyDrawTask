function bbci = generate_bbcisettings(acquire_bv, stim_on, stim_off_post, stim_config) 

bbci= struct;
bbci.source(1).record_basename = 'dummy';
if acquire_bv
    bbci.source(1).acquire_fcn= @bbci_acquire_bv;
    bbci.source(1).acquire_param= {'clab',{'*'}};
    bbci.source(1).record_signals = true;
else
    bbci.source(1).acquire_fcn= @bbci_acquire_randomSignals;
    bbci.source(1).acquire_param= {'clab',{'*'}};    
    bbci.source(1).record_signals = false;
end

bbci.source(1).min_blocklength = 10;

% bbci.signal(1).source = 1;
% bbci.signal(1).clab =  {'*'};
bbci.feature(1).ival = [-10 0];

bbci.classifier(1).feature = 1;
bbci.classifier(1).fcn = @(C,y) 1;

if stim_on
    bbci.control(1).classifier = 1;
    bbci.control(1).fcn = @control_experiment_end;
    bbci.control(1).param = {'stim_off_post', stim_off_post,...
                            'StimChannel', stim_config.StimChannel,...
                            'ReturnChannel', stim_config.ReturnChannel};
    bbci.control(1).condition.marker = 251;
    bbci.quit_condition.marker= 255;
else
    bbci.quit_condition.marker= 251;
end 

bbci.log.output = 0;
bbci.quit_condition.running_time=inf;