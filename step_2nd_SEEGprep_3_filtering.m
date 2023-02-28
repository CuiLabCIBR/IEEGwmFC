%% filtering the ieeg signal
% set the environment
start_env;

% set the workpath
workpath = 'E:\IEEG_DSI_connectome';
cd(workpath);

sub_list = [1, 2, 8:17, 20:23];
for s_num = 1 : 1 : length(sub_list)
    
    sub = sub_list(s_num);
    subj_ID = ['sub-',num2str(sub,'%04d')];
    disp(subj_ID);
    subjieeg_folder = fullfile(workpath, 'IEEGprep', 'IEEGprep', subj_ID, 'ieeg');% read the state folder
    state_folder = dir(subjieeg_folder);
    
     % read the signals file
    for stfn = 1 : length(state_folder)

        if contains({'awake'}, state_folder(stfn).name)
            
            state_ID = ['state-', state_folder(stfn).name];
            
            data_dir = dir(fullfile(state_folder(stfn).folder, state_folder(stfn).name, 'IEEGprep_noartifact', '*.mat'));
            
            for ddn = 1 : length(data_dir)

                if data_dir(ddn).bytes > 1*1024*1024 && data_dir(ddn).isdir == 0
                    
                    data_path = fullfile(data_dir(ddn).folder, data_dir(ddn).name);
                    
                    cell_str = strsplit(data_dir(ddn).name,'_');
                    for csn = 1:length(cell_str)
                         if contains(cell_str{csn},'ses') == 1
                            ses_ID = cell_str{csn};
                         end
                         if contains(cell_str{csn},'run') == 1
                            run_ID = cell_str{csn};
                         end
                    end

                    task_ID = 'task-rest';
                    
                    data_no_artifacts = [];
                    data_f = [];
                    load(data_path);% load the data

                    % bandpass filtering
                    cfg = [];
                    cfg.demean = 'yes';
                    cfg.baselinewindow = 'all';
                    cfg.bpfilter = 'yes';
                    cfg.bpfiltord = 3;
                    cfg.bpfreq = [0.5, 300]; 
                    cfg.bsfiltord = 3;
                    cfg.bsfreq = [49 51; 99 101; 149 151; 199 201; 249 251; 299 300]; % line frequency
                    data_filter_bandpass_linenoise = ft_preprocessing(cfg, data_no_artifacts);
                    
                    savefilepath = fullfile('IEEGprep', 'IEEGprep', subj_ID, 'ieeg', state_folder(stfn).name, 'IEEGprep_filter_bp05-300');
                    mkdir(savefilepath);
                    savefilename = [subj_ID, '_', state_ID, '_', ses_ID, '_', task_ID, '_', run_ID, '_filter.mat'];
                    save(fullfile(savefilepath, savefilename), 'data_filter_bandpass_linenoise', '-v7.3');
                end
            end
        end
    end
end