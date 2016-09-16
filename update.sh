#!/bin/bash

THIS_DIR=$(cd $(dirname $0); pwd)

git fetch

cat .gitmodules |while read i
do
if [[ $i == \[submodule* ]]; then
    echo "Processing $i ..."

    # extract the module's prefix
    mpath=$(echo $i | cut -d\" -f2)

    # skip two lines
    read i; read i;

    # extract the url of the submodule
    murl=$(echo $i|cut -d\  -f3)

    # extract the module name
    mname=$(basename $mpath)

    read i;
    mbranch=$(echo $i|cut -d\  -f3)

    # fetch the files

    cd "${THIS_DIR}/${mpath}" && echo "git checkout $mbranch" &&  git checkout $mbranch && echo "git pull" && git pull
    if [[ $mbranch != "master" ]]; then
        cd "${THIS_DIR}/${mpath}" && echo "git fetch upstream" && git fetch upstream && echo "git rebase -p upstream/master" && git rebase -p upstream/master
    fi
fi
done

cd "${THIS_DIR}"
./commit.sh "Updating submodules"
