#!/bin/bash

# pre_posts ディレクトリのファイルを posts に移動するスクリプト
# 移動時にファイル名の prefix に最終変更日付を付与します。

foo () {
    WORK_DIR=$(cd $(dirname $0); pwd)
    pushd $WORK_DIR &> /dev/null

    for filename in $(ls *.${1} 2> /dev/null)
    do
        dt=$(date -r ${filename} "+%Y-%m-%d")
        echo ">>${filename}_${dt}"
        mv "${filename}" "../posts/${dt}_${filename}";
    done;
}

foo 'ipynb'
foo 'md'
foo 'qmd'
