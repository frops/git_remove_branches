[**DEPRECATED**] Use git commands for delete merged branches instead of this code

## Git commands:
Original issues: https://stackoverflow.com/questions/6127328/how-do-i-delete-all-git-branches-which-have-been-merged

Code:
```
git branch --merged | egrep -v "(^\*|master|main|dev)" | xargs git branch -d
```
It delete all merged branches in the master|main|dev branches.

---

### Remove old branches

The script deletes old remote and local branches of your git-repository in interactive mode

#### Usage

##### Linux
Just run script.sh
~~~~
./script.sh
~~~~

Each time a confirmation is requested to delete a branch.
Press enter for delete branch or any symbol for cancel.

You may specify `exit` for stop script.

~~~~
Branch: origin/some_branch, Created At: 2017-05-26 Author: frops
Are you sure to delete remote branch some_branch? [press any symbol for cancel or just enter for delete] 
exit
Exited
~~~~

##### Mac OS / Windows
Use **Docker** and run as in Linux

~~~~
docker run -v $(pwd):/app frops/git_remove_branches ./script.sh -m 12
~~~~

##### Params
`-m|--month` – age of making branches in the months you want to delete

`-f|--force` – the force mode, in which branches are deleted without confirmation. Please, be careful. I'am not recomended use this command. Use it in exceptional cases!

##### For example
Delete branches older then 6 month:
~~~~
./script.sh
~~~~

Delete branches older then 24 month (2 years):
~~~~
./script.sh -m 24
~~~~

Delete branches older then 6 month in **force mode**. 

**Please, be careful with this command.**
~~~~
./script.sh -f
~~~~

