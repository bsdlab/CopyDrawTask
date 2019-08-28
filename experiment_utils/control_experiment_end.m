function [packet, state] = control_experiment_end(cl_out, state, event_info, varargin)
global BTB
global PPORT
% currently, ignore what comes from the classifier output,
% this function manages the post-block stim off and corresponding 
% baseline recording

options = propertylist2struct(varargin{:});
options = set_defaults(options, 'stim_off_post', 15,...
                                'StimChannel', 'none',...
                                'ReturnChannel', 'none');
fig_relaxEnd = gen_relaxFig() ;
stim_onStandard(0, 1, options.StimChannel, options.ReturnChannel);
[Results]=AO_StopStimulation(options.StimChannel);
disp('stop stimulation');
pause(options.stim_off_post)
bbci_trigger_parport(255, BTB.Acq.IoLib, hex2dec(PPORT));
pause(0.1)
close(fig_relaxEnd)
packet = [];

