function stats = rm_anova(x, s, f)
%
%  RM_ANOVA
%
%  Usage:
%    >> stats = rm_anova(x, s, f);
%
%  Author:
%    Valentin WYART (valentin.wyart@chups.jussieu.fr)
%

n = length(f);

command = 'is=unique(s);';
eval(command);
for i = 1:n
    command = ['i' int2str(i) '=unique(f{' int2str(i) '});'];
    eval(command);
end

command = 'ns=length(is);';
eval(command);
for i = 1:n
    command = ['n' int2str(i) '=length(i' int2str(i) ');'];
    eval(command);
end

dim = '';
for i = 1:n
    dim = [dim 'n' int2str(i) ','];
end
dim = [dim 'ns'];
command = ['indx=cell(' dim ');'];
eval(command);
command = ['data=cell(' dim ');'];
eval(command);
command = ['aver=zeros(' dim ');'];
eval(command);
command = '';
for i = 1:n
    command = [command 'for j' int2str(i) '=1:n' int2str(i) ','];
end
command = [command 'for js=1:ns,'];
idx = '';
for i = 1:n
    idx = [idx 'j' int2str(i) ','];
end
idx = [idx 'js'];
command = [command 'indx{' idx '}=find('];
for i = 1:n
    command = [command 'f{' int2str(i) '}==i' int2str(i) '(j' int2str(i) ')&'];
end
command = [command 's==is(js));'];
command = [command 'data{' idx '}=x(indx{' idx '});'];
command = [command 'aver(' idx ')=mean(data{' idx '});'];
for i = 1:n
    command = [command 'end,'];
end
command = [command 'end'];
eval(command);

command = 'st=';
for i = 1:n+1
    command = [command 'sum('];
end
command = [command 'aver,'];
for i = 1:n+1
    command = [command int2str(n+2-i) '),'];
end
command = [command(1:end-1) ';'];
eval(command);
command = 'ss=reshape(';
for i = 1:n
    command = [command 'sum('];
end
command = [command 'aver,'];
for i = 1:n
    command = [command int2str(n+1-i) '),'];
end
command = [command '[ns,1]);'];
eval(command);
for i = 1:n
    comb = mycombnk(1:n, i);
    for i1 = 1:size(comb, 1)
        id = '';
        for i2 = 1:size(comb, 2)
            id = [id int2str(comb(i1,i2))];
        end
        sid = ['s' id];
        excl = setdiff(1:n, comb(i1,:));
        excl = sort(excl, 'descend');
        sumdim = [int2str(n+1) '),'];
        for i2 = 1:length(excl)
            sumdim = [sumdim int2str(excl(i2)) '),'];
        end
        resdim = '[';
        for i2 = 1:size(comb, 2)
            resdim = [resdim 'n' int2str(comb(i1,i2)) ','];
        end
        if size(comb, 2) == 1
            resdim = [resdim '1]'];
        else
            resdim = [resdim(1:end-1) ']'];
        end
        command = [sid '=reshape('];
        for i2 = 1:length(excl)+1
            command = [command 'sum('];
        end
        command = [command 'aver,' sumdim resdim ');'];
        eval(command);
        if i < n
            sid = ['s' id 's'];
            excl = setdiff(1:n, comb(i1,:));
            excl = sort(excl, 'descend');
            sumdim = '';
            for i2 = 1:length(excl)
                sumdim = [sumdim int2str(excl(i2)) '),'];
            end
            resdim = '[';
            for i2 = 1:size(comb, 2)
                resdim = [resdim 'n' int2str(comb(i1,i2)) ','];
            end
            resdim = [resdim 'ns]'];
            command = [sid '=reshape('];
            for i2 = 1:length(excl)
                command = [command 'sum('];
            end
            command = [command 'aver,' sumdim resdim ');'];
            eval(command);
        end
    end
end

command = 'dfs=ns-1;';
eval(command);
for i = 1:n
    comb = mycombnk(1:n, i);
    for i1 = 1:size(comb, 1)
        name = 'df';
        for i2 = 1:size(comb, 2)
            name = [name int2str(comb(i1,i2))];
        end
        operation = '=';
        for i2 = 1:size(comb, 2)
            operation = [operation '(n' int2str(comb(i1,i2)) '-1)*'];
        end
        operation(end) = [];
        command = [name operation ';'];
        eval(command);
        
        name = [name 's'];
        operation = [operation '*(ns-1)'];
        command = [name operation ';'];
        eval(command);
    end
end

command = 'expx=sum(x(:).^2);';
eval(command);
id = '';
for i = 1:n
    id = [id int2str(i)];
end
command = ['exp' id 's=expx;'];
eval(command);
command = 'expt=st^2/(';
for i = 1:n
    command = [command 'n' int2str(i) '*'];
end
command = [command 'ns);'];
eval(command);
command = 'exps=sum(ss(:).^2)./(';
for i = 1:n
    command = [command 'n' int2str(i) '*'];
end
command = [command(1:end-1) ');'];
eval(command);
for i = 1:n
    comb = mycombnk(1:n, i);
    for i1 = 1:size(comb, 1)
        id = '';
        for i2 = 1:size(comb, 2)
            id = [id int2str(comb(i1,i2))];
        end
        expid = ['exp' id];
        sid = ['s' id];
        excl = setdiff(1:n, comb(i1,:));
        denom = '(1*';
        for i2 = 1:length(excl)
            denom = [denom 'n' int2str(excl(i2)) '*'];
        end
        denom = [denom 'ns)'];
        command = [expid '=sum(' sid '(:).^2)./' denom ';'];
        eval(command);
        if i < n
            expid = ['exp' id 's'];
            sid = ['s' id 's'];
            excl = setdiff(1:n, comb(i1,:));
            denom = '(1*';
            for i2 = 1:length(excl)
                denom = [denom 'n' int2str(excl(i2)) '*'];
            end
            denom = [denom(1:end-1) ')'];
            command = [expid '=sum(' sid '(:).^2)./' denom ';'];
            eval(command);
        end
    end
end

command = 'sss=exps-expt;';
eval(command);
for i = 1:n
    comb = mycombnk(1:n, i);
    for i1 = 1:size(comb, 1)
        id = '';
        for i2 = 1:size(comb, 2)
            id = [id int2str(comb(i1,i2))];
        end
        command = ['ss' id '='];
        op = '+';
        for j = i:-1:1
            combbis = mycombnk(comb(i1,:), j);
            for j1 = 1:size(combbis, 1)
                idbis = '';
                for j2 = 1:size(combbis, 2)
                    idbis = [idbis int2str(combbis(j1,j2))];
                end
                command = [command op 'exp' idbis];
            end
            if strcmp(op, '+')
                op = '-';
            else
                op = '+';
            end
        end
        command = [command op 'expt;'];
        eval(command);
        command = ['ss' id 's='];
        op = '+';
        for j = i:-1:1
            combbis = mycombnk(comb(i1,:), j);
            for j1 = 1:size(combbis, 1)
                idbis = '';
                for j2 = 1:size(combbis, 2)
                    idbis = [idbis int2str(combbis(j1,j2))];
                end
                command = [command op 'exp' idbis 's'];
            end
            if strcmp(op, '+')
                op = '-';
            else
                op = '+';
            end
            for j1 = 1:size(combbis, 1)
                idbis = '';
                for j2 = 1:size(combbis, 2)
                    idbis = [idbis int2str(combbis(j1,j2))];
                end
                command = [command op 'exp' idbis];
            end
        end
        command = [command op 'exps'];
        if strcmp(op, '+')
            op = '-';
        else
            op = '+';
        end
        command = [command op 'expt;'];
        eval(command);
    end
end
            
command = 'mss=sss/dfs;';
eval(command);
for i = 1:n
    comb = mycombnk(1:n, i);
    for i1 = 1:size(comb, 1)
        id = '';
        for i2 = 1:size(comb, 2)
            id = [id int2str(comb(i1,i2))];
        end
        command = ['ms' id '=ss' id '/df' id ';'];
        eval(command);
        command = ['ms' id 's=ss' id 's/df' id 's;'];
        eval(command);
    end
end

for i = 1:n
    comb = mycombnk(1:n, i);
    for i1 = 1:size(comb, 1)
        id = '';
        for i2 = 1:size(comb, 2)
            id = [id int2str(comb(i1,i2))];
        end
        command = ['if ms' id 's==0,f' id '=0;else,f' id '=ms' id '/ms' id 's;end'];
        eval(command);
    end
end

for i = 1:n
    comb = mycombnk(1:n, i);
    for i1 = 1:size(comb, 1)
        id = '';
        for i2 = 1:size(comb, 2)
            id = [id int2str(comb(i1,i2))];
        end
        command = ['p' id '=1-myfcdf(f' id ',df' id ',df' id 's);'];
        eval(command);
    end
end

command = 'stats=struct;';
for i = 1:n
    comb = mycombnk(1:n, i);
    for i1 = 1:size(comb, 1)
        id = '';
        fd = '';
        for i2 = 1:size(comb, 2)
            id = [id int2str(comb(i1,i2))];
            fd = [fd 'f' int2str(comb(i1,i2)) 'x'];
        end
        fd = fd(1:end-1);
        command = ['stats.' fd '.fstats=f' id ';'];
        eval(command);
        command = ['stats.' fd '.pvalue=p' id ';'];
        eval(command);
    end
end
