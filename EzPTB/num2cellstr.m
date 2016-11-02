function str = num2cellstr(x, f)
str = cell(1, length(x));
for i = 1:length(x)
    str{i} = num2str(x(i), f);
end
