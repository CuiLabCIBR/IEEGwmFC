function [p_corrected] = BHfdr(pvalues)
    pvalues_series = reshape(pvalues, [length(pvalues(:)),1]);    
    p_corrected_series = mafdr(pvalues_series, 'BHFDR', true);
    p_corrected = reshape(p_corrected_series, size(pvalues));
end

