%% read the filtering data and detect the artifact
% set the environment
start_env;
% set the workpath
workpath = 'E:\IEEG_DSI_connectome';
cd(workpath);
sub_list = 1:36;
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
            data_dir = dir(fullfile(state_folder(stfn).folder, state_folder(stfn).name, 'IEEGprep_filter_bp05-300', '*.mat'));
            for ddn = 1 : length(data_dir)
                if data_dir(ddn).bytes > 1*1024*1024 && data_dir(ddn).isdir == 0
                    data_path = fullfile(data_dir(ddn).folder, data_dir(ddn).name);
                    load(data_path);
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
                 %% identify the artifact segment       
                 % reject the jump 
                        cfg = [];
                        cfg.continuous = 'yes';
                        % channel selection, cutoff and padding
                        cfg.artfctdef.zvalue.channel = 'all';
                        cfg.artfctdef.zvalue.cutoff = 60;
                        cfg.artfctdef.zvalue.trlpadding = 0;
                        cfg.artfctdef.zvalue.artpadding = 0;
                        cfg.artfctdef.zvalue.fltpadding = 0;
                        % algorithmic parameters
                        cfg.artfctdef.zvalue.cumulative = 'yes';
                        cfg.artfctdef.zvalue.medianfilter = 'yes';
                        cfg.artfctdef.zvalue.medianfiltord = 9;
                        cfg.artfctdef.zvalue.absdiff = 'yes';
                        % make the process interactive
                        cfg.artfctdef.zvalue.interactive = 'yes';
                        [cfg_jump, artifact_jump] = ft_artifact_zvalue(cfg, data_filter_bandpass_linenoise);
                        % save the artifact information
                        badchannel_filefolder = fullfile(workpath, 'report', 'artifact', subj_ID);
                        mkdir(badchannel_filefolder);
                        save(fullfile(badchannel_filefolder, [subj_ID, '_', run_ID, '_jump.mat']), 'cfg', 'artifact_jump', 'cfg_jump');
                % reject the muscle
                        cfg = [];
                        cfg.continuous = 'yes';
                        % channel selection, cutoff and padding
                        cfg.artfctdef.zvalue.channel = 'all';
                        cfg.artfctdef.zvalue.cutoff = 20;
                        cfg.artfctdef.zvalue.trlpadding = 0;
                        cfg.artfctdef.zvalue.fltpadding = 0;
                        cfg.artfctdef.zvalue.artpadding = 0.1;
                        % algorithmic parameters
                        cfg.artfctdef.zvalue.bpfilter = 'yes';
                        cfg.artfctdef.zvalue.bpfreq = [110 140];
                        cfg.artfctdef.zvalue.bpfiltord = 3;
                        cfg.artfctdef.zvalue.bpfilttype = 'but';
                        cfg.artfctdef.zvalue.hilbert = 'yes';
                        cfg.artfctdef.zvalue.boxcar = 0.2;
                        % make the process interactive
                        cfg.artfctdef.zvalue.interactive = 'yes';
                        [cfg_muscle, artifact_muscle] = ft_artifact_zvalue(cfg, data_filter_bandpass_linenoise);
                        % save the artifact information
                        badchannel_filefolder = fullfile(workpath, 'report', 'artifact', subj_ID);
                        mkdir(badchannel_filefolder);
                        save(fullfile(badchannel_filefolder, [subj_ID, '_', run_ID, '_muscle.mat']), 'cfg', 'artifact_muscle', 'cfg_muscle');
                 % reject the EOG
                        cfg = [];
                        cfg.continuous = 'yes';
                        % channel selection, cutoff and padding
                        cfg.artfctdef.zvalue.channel  = 'all';
                        cfg.artfctdef.zvalue.cutoff = 30;
                        cfg.artfctdef.zvalue.trlpadding = 0;
                        cfg.artfctdef.zvalue.artpadding = 0.1;
                        cfg.artfctdef.zvalue.fltpadding = 0;
                        % algorithmic parameters
                        cfg.artfctdef.zvalue.bpfilter = 'yes';
                        cfg.artfctdef.zvalue.bpfilttype = 'but';
                        cfg.artfctdef.zvalue.bpfreq  = [2 15];
                        cfg.artfctdef.zvalue.bpfiltord  = 3;
                        cfg.artfctdef.zvalue.hilbert  = 'yes';
                        % feedback
%                         cfg.artfctdef.zvalue.interactive = 'yes';
                        [cfg_EOG,  artifact_EOG] = ft_artifact_zvalue(cfg, data_filter_bandpass_linenoise);
                        % save the artifact information
                        badchannel_filefolder = fullfile(workpath, 'report', 'artifact', subj_ID);
                        mkdir(badchannel_filefolder);
                        save(fullfile(badchannel_filefolder, [subj_ID, '_', run_ID, '_EOG.mat']), 'cfg', 'artifact_EOG', 'cfg_EOG');
                    %% clean the artifact data
                        cfg = [];
                        cfg.artfctdef.reject = 'partial'; % this rejects complete trials, use 'partial' if you want to do partial artifact rejection
                        cfg.artfctdef.eog.artifact = artifact_EOG; %
                        cfg.artfctdef.jump.artifact = artifact_jump;
                        cfg.artfctdef.muscle.artifact = artifact_muscle;
                        data_deartifacts_afterfilter = ft_rejectartifact(cfg, data_filter_bandpass_linenoise);
%                         % view the clean data
%                         cfg = [];  
%                         cfg.ylim = [-40, 40];
%                         cfg.viewmode = 'vertical';
%                         cfg.preproc.demean  = 'yes';
%                         cfg.preproc.detrend  = 'yes';
%                         cfg.blocksize = 10;%duration in seconds for cutting continuous data in segments
%                         cfg = ft_databrowser(cfg, data_deartifacts_afterfilter); % view the clean signals
                        % save the file
                        savefilepath = fullfile('IEEGprep', 'IEEGprep', subj_ID, 'ieeg', state_folder(stfn).name, 'IEEGprep_deartifact_afterfilter');
                        mkdir(savefilepath);
                        savefilename = [subj_ID, '_', state_ID, '_', ses_ID, '_', task_ID, '_', run_ID, '_filterdata_removeartifact.mat'];
                        save([savefilepath, filesep, savefilename], 'data_deartifacts_afterfilter', '-v7.3');
                    end
                end
            end
      end
end