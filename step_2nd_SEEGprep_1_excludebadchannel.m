%% read the data and visualize
% set the environment
start_env;
% set the workpath
workpath = 'E:\IEEG_DSI_connectome';
cd(workpath);
sub_list = 38;
for s_num = 1:1:length(sub_list)
     subj = sub_list(s_num);
     subj_ID = ['sub-', num2str(subj, '%04d')];
     disp(subj_ID);
     subj_ieeg_folder = fullfile(workpath, 'IEEGprep',  'IEEG',  subj_ID, 'ieeg');
     state_folder = dir(subj_ieeg_folder);% read the state folder
     for stfn = 1:length(state_folder)
            if contains({'awake'}, state_folder(stfn).name)
                state_ID = ['state-', state_folder(stfn).name];
                task_ID = 'task-rest';
                data_dir = dir(fullfile(state_folder(stfn).folder, state_folder(stfn).name, '*')); % read the file name of IEEG signals
                for ddn = 1:length(data_dir)
                    if data_dir(ddn).bytes > 10*1024*1024 && data_dir(ddn).isdir == 0
                        data_path = fullfile(data_dir(ddn).folder, data_dir(ddn).name);
                        cell_str = strsplit(data_dir(ddn).name, '_'); % read the session number and run number
                        for csn = 1:length(cell_str)
                            if contains(cell_str{csn}, 'ses') == 1
                                ses_ID = cell_str{csn};
                            end
                            if contains(cell_str{csn}, 'run') == 1
                                run_ID = cell_str{csn};
                            end
                        end
                        cfg = [];% read the signals file
                        cfg.dataset = data_path;
                        cfg.demean = 'yes';
                        cfg.detrend = 'yes';
                        data_raw = [];
                        data_raw = ft_preprocessing(cfg); 
                        for CHAN = 1:length(data_raw.hdr.chantype)
                                data_raw.hdr.chantype{CHAN,1} = 'SEEG';
                        end
                        cfg = [];  
                        cfg.ylim = [-40, 40];
                        cfg.viewmode = 'vertical';
                        cfg.preproc.demean  = 'yes';
                        cfg.preproc.detrend  = 'yes';
                        cfg.blocksize = 10;%duration in seconds for cutting continuous data in segments
                        cfg = ft_databrowser(cfg, data_raw); % view the signals
                        % exclude bad channels
                        badchannels_label.channel = {'all', '-C1*', '-C2*', '-C3*', '-C4*', '-C7*', '-C8*', '-C9*', '-C10*', ...
                            '-C11*', '-C12*', '-DC*', '-Trigger Event', '-TRIG', '-OSAT', '-PR', '-Pleth'};
                        cfg = [];
                        cfg.channel = badchannels_label.channel;
                        data_dbadchanel = ft_preprocessing(cfg, data_raw); 
                        % save bad channel info
                        badchannel_filefolder = fullfile(workpath, 'report', 'badchannel', subj_ID);
                        mkdir(badchannel_filefolder);
                        save(fullfile(badchannel_filefolder,[subj_ID,'_badchannel.mat']), "badchannels_label");
                        cfg = [];  
                        cfg.ylim = [-40,40];
                        cfg.viewmode = 'vertical';
                        cfg.preproc.demean  = 'yes';
                        cfg.preproc.detrend  = 'yes';
                        cfg.blocksize = 10;%duration in seconds for cutting continuous data in segments
                        cfg = ft_databrowser(cfg, data_dbadchanel); % view the clean signals
                    end
                end
            end
      end
end



