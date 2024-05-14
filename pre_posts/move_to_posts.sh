#!/bin/bash

# pre_posts ディレクトリのファイルを posts に移動するスクリプト
# 移動時にファイル名の prefix に最終変更日付を付与します。

foo () {
    WORK_DIR=$(cd $(dirname $0); pwd)
    pushd $WORK_DIR &> /dev/null

    files=$(ls *.${1} 2> /dev/null)

    if [ -n "$files" ]; then
        for filename in "$files"
        do
            echo "move $filename"
            dt=$(date -r $filename +"%Y-%m-%d")
            mv "${filename}" "../posts/${dt}_${filename}";
        done;

    fi
}

foo 'ipynb'
foo 'md'
foo 'qmd'
