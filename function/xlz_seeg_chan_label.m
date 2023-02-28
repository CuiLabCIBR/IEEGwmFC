function [chan_group, elec_labels] = xlz_seeg_chan_label(chan_label)

%% main function
            % step_1 identify the electrode
       for nn = 1:length(chan_label)
               chan_num_start_index(nn) = regexp(chan_label{nn}, '\d*');
               chan_title{nn} = chan_label{nn}(1:(chan_num_start_index(nn)-1));
       end
       [elec_labels, ~, ic] = unique(chan_title);
       % step_2 identify chan group start
       chan_list = 1:length(chan_label);
       chan_group_start = [];
       chan_group_start(1) = 1;
       chan_group_start = [chan_group_start, chan_list(diff(ic) ~= 0)+1];
       % step_3 group the channels
       chan_group_start = [chan_group_start, length(chan_label)+1];
       for CG = 1:length(chan_group_start)-1
               chan_group{CG} = chan_label(chan_group_start(CG):(chan_group_start(CG+1)-1));
       end

end