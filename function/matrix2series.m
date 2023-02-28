function [series] = matrix2series(matrix)
        temp = ones(size(matrix));
        index = find(triu(temp, 1));
        series = matrix(index);
end

