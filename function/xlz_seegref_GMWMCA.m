function [data_CAR, grayM_reref, whiteM_reref, gray_chan, white_chan, none_chan] = xlz_seegref_GMWMCA(data, electrode_tsv, chan_group)

%% main function
      white_chan_num = 0;
       none_chan_num = 0;
       gray_chan_num = 0;
       none_chan = {};
       white_chan = {};
       gray_chan = {};
       for cg = 1:length(chan_group)
           for II = 1:length(chan_group{cg})
               for JJ = 1:length(electrode_tsv.Channel)
                   if strcmpi(chan_group{cg}{II}, electrode_tsv.Channel{JJ})
                       chan_group{cg}{II,2} = electrode_tsv.ASEG{JJ};
                       if contains(electrode_tsv.ASEG{JJ}, 'White')
                           white_chan_num= white_chan_num+1;
                           white_chan{white_chan_num,1} = chan_group{cg}{II,1};
                           white_chan{white_chan_num,2} = chan_group{cg}{II,2};
                       elseif contains(electrode_tsv.ASEG{JJ}, 'N/A')
                           none_chan_num = none_chan_num + 1;
                           none_chan{none_chan_num, 1} = chan_group{cg}{II, 1};
                           none_chan{none_chan_num, 2} = chan_group{cg}{II, 2};
                       else 
                           gray_chan_num = gray_chan_num + 1;
                           gray_chan{gray_chan_num, 1} = chan_group{cg}{II, 1};
                            gray_chan{gray_chan_num, 2} = chan_group{cg}{II, 2};
                       end
                   end
               end
           end
       end
        % step_5 gray channels bipolar reference
       cfg = [];
       cfg.channel = gray_chan(:,1);
       cfg.reref = 'yes';
       cfg.refchannel = gray_chan(:,1);
       cfg.refmethod = 'avg';
       grayM_reref = ft_preprocessing(cfg, data);
        cfg = [];
       cfg.channel = white_chan(:,1);
       cfg.reref = 'yes';
       cfg.refchannel = white_chan(:,1);
       cfg.refmethod = 'avg';
       whiteM_reref = ft_preprocessing(cfg, data);
        cfg = [];
        cfg.appendsens = 'yes';
        ref_data = {grayM_reref, whiteM_reref};
        data_CAR = ft_appenddata(cfg, ref_data{:});% combine the data into one data structure
end