#!/usr/bin/env bash

force=false
month=6

echo -e "\e[34m"

delete_remote_branch() {
    if [ "$force" = true ]; then
        response=""
    else
        echo -e "\e[97mAre you sure to delete remote branch \e[92m$1\e[97m? [press any symbol for cancel or just enter for delete] "
        read response
    fi

    if [ -z "$response" ]; then
        git push origin --delete $1
        echo -e "Branch \e[92m$1\e[97m deleted"
        return 1
    elif [ "$response" = "exit" ]; then
        echo -e "\e[31mExited"
        exit 0
    fi

    echo -e "\e[31mCanceled\e[97m"
    return 0
}

delete_local_branch() {
    echo -e "\e[97mLocal branch \e[92m$1\e[97m deleted"
    git branch -d $1
}

while true; do
    case "$1" in
        -f | --force ) force=true; shift 2;;
        -m | --month ) month=$2; shift;;
        * ) break ;;
    esac
done

echo -e "\e[97mFetching branches for a period of more than $month months.."

today=`date +%s`
branches=`git branch -r --merged | grep -v HEAD`
countBranches=`git branch -r --merged | grep -v HEAD | wc -l`
needDate=$(date -d "-$month month" +%s)

echo "Count branches: $countBranches"

git fetch
git remote prune origin

if [ $force = true ]; then
    echo -e "\e[31mAttention, please!!!"
    echo -e "I'am not recomended use this command. Use it in exceptional cases!"
    echo -e "Script deleted all old remote branches without confirm dialog"
    echo ""
    echo -e "\e[97mAre you sure to \e[31mforce delete all \e[97mold branches? [yes/no]"
    read response
    case "$response" in
        yes) 
            force=true
            ;;
        *)
            echo -e "\e[97mYou are \e[31mcanceled\e[97m force delete old branches"
            exit
            ;;
    esac
fi



for branch in $branches
do 
    gitShow=`git show --no-patch --raw --pretty=format:"%h;%an;%ad%" $branch`
    
    author=`echo "$gitShow" | awk -F ";" '{print $2}'`
    date=`echo "$gitShow" | awk -F ";" '{print $3}' | cut -f 1 -d ' ' --complement | cut -d ' ' -f-4`
    branchDate=`date -d "$date" +%s`
    branchDateStr=`date -d "$date" +%F`

    localBranch=`echo "$branch" | cut -f 1 -d '/' --complement`
    existsLocalBranch=`git branch --list "$localBranch"`
    
    if [ $localBranch = "master" ]; then 
        continue
    fi

    if [ $branchDate -lt $needDate ]; then
        echo -e "\e[97mBranch: \e[33m$branch\e[97m, Created At: \e[36m$branchDateStr \e[97mAuthor: \e[36m$author"

        delete_remote_branch $localBranch

        if [ -n "$existsLocalBranch" ]; then
            if [ "$?" = "1" ]; then
                delete_local_branch $localBranch
            fi
        fi

        echo "---"
        echo ""
    fi
done

echo "Finish"
exit 1