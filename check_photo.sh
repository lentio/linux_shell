#!/bin/bash

function lookupFile
{
    echo "执行命令：$0 $1";
    file="$1"

    if test -f ${file}
    then
        ext="${file##*.}"
        if [ "${file##*.}"x = "JPG"x ] || [ "${file##*.}"x = "jpg"x ] || [ "${file##*.}"x = "jpeg"x ] || [ "${file##*.}"x = "HEIC"x ] #文件名满足的条件-正则表达式 *需要更改为您想匹配的条件，
        then
            subStr=`exiftool ${file} | grep "Date/Time Original" |  awk -F: 'NR==1{print $2"-"$3"-"$4"."$5"."$6}'` 
            #获取文件名
            filename=`echo $subStr | sed -e 's/^[ \t]*//g'`

            # 文件名重定向
            echo "rename ${file} to ${filename}.$ext"  
            `mv "${file}" "${filename}.$ext"`
        elif  [ "${file##*.}"x = "mp4"x ] || [ "${file##*.}"x = "MP4"x ] || [ "${file##*.}"x = "MOV"x ] || [ "${file##*.}"x = "mov"x ]
        then
            subStr=`exiftool ${file} | grep "Media Create Date" |  awk -F: 'NR==1{print $2"-"$3"-"$4"."$5"."$6}'` 
            #获取文件名
            filename=`echo $subStr | sed -e 's/^[ \t]*//g'`
 
            # 文件名重定向
            echo "rename ${file} to ${filename}.$ext" 
            `mv "${file}" "${filename}.$ext"`
        fi
    elif test -d ${file} 
    then
        for subfile in $1/*
        do
            lookupFile ${subfile} #递归遍历
         done
    fi

    echo "完成命令：$0 $file";
}

for file in `find . -name "*.mov" -o -name "*.MOV" -o -name "*.JPG" -o -name "*.jpg" -o -name "*.jpeg" -o -name ".MP4" -o -name "*.mp4" -o -name "*.HEIC"`
do 
    echo "-----------------------------------------------"
    lookupFile ${file}
done