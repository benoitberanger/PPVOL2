function [nOccurences] = HasConsecutiveValues(x, nConsecutiveValues, excludedValues)
    %
    % HasConsecutiveValues
    %
    %  Purpose:
    %    Counts the number of consecutive chains in a vector.
    %
    %  Usage:
    %    [nOccurences] = HasConsecutiveValues(x, nConsecutiveValues, excludedValues);
    %
    %  Arguments:
    %    [i]                  x - vector
    %    (i) nConsecutiveValues - number of consecutive values (default: 2)
    %    (i)     excludedValues - excluded values (default: none)
    %    [o]        nOccurences - number of consecutive chains in the vector
    
    %  [2008/01/30] Valentin Wyart (valentin.wyart@chups.jussieu.fr)
    
    
    if nargin < 3 || isempty(excludedValues)
        excludedValues = [];
    end
    if nargin < 2 || isempty(nConsecutiveValues)
        nConsecutiveValues = 2;
    end
    if nargin < 1
        error('Not enough input arguments');
    end
    
    if isempty(x)
        nOccurences = 0;
        return
    end
    
    x = x(:);

    d = [1; diff(x)] ~= 0;
    n = diff([find(d); length(x)+1]);
    y = x(d);
    
    n = n(~ismember(y, excludedValues));
    y = y(~ismember(y, excludedValues));
    
    nOccurences = nnz(n >= nConsecutiveValues);    
    return

end
