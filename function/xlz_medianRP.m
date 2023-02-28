function [medianR, medianP] = xlz_medianRP(R, P)
        medianR = median(R, 1);
        % find the P value
        if mod(size(R, 1),2)==0
                for N = 1:size(R, 2)
                        [~, tempIndex] = sort(R(:, N), 'ascend');
                        a = length(tempIndex)/2;
                        b = a + 1;
                        medianP(N) = max(P(tempIndex([a, b]), N));
                end
        else
                for N = 1:size(R, 2)
                        [~, tempIndex] = sort(R(:, N), 'ascend');
                        a = (1+length(tempIndex))/2;
                        medianP(N) = P(tempIndex(a), N);
                end
        end
end

