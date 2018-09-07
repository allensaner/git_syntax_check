
function gits() {
    git status|awk '{if($0 ~ /\.php/){
        split($0,r,".php");split(r[length(r)-1],r," ");
        cmd="php -l "r[length(r)]".php";
        while(cmd|getline res){
            if(res ~ /Parse error/){
                split(res,errinfo,"Parse error: ");
                errs[NR]=errinfo[2];
                break;
            }
        }
        if(errs[NR]=="")print $0"  [ok]";
        else print $0"  [error]";
    }else print $0;}
    END{print "Parse error:";for(i in errs)if(errs[i]!=""){hasErr=1;break;}
    if(hasErr==1){print "  (don'\''''t do anthing silly but fix your bug)";
    for(i in errs)if(errs[i]!="")print "        "errs[i];}
    else print "  (just do it as git)";print ""}'\                                                                           |awk 'BEGIN{cmd="git status -s";while(cmd|getline res){split(res,r," ");files[r[2]]=1}}
    {if($0~/Changes to be committed/)status="committed"; if($0~/Changes not staged for commit/)status="commit";
    if($0~/Untracked files/)status="untracked"; if($0~/Parse error/)status="parse";
    for(i in files)if(match($0,i)){
        if(status=="committed")$0="\033[0;032;040m"$0"\033[0m";
        else if(status=="commit")$0="\033[0;031;040m"$0"\033[0m";
        else if(status=="untracked")$0="\033[0;031;040m"$0"\033[0m";
        else if(status=="parse")$0="\033[1;031;040m"$0"\033[0m";
    break} print $0}'
}
alias gits=gits
