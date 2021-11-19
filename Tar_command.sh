#!/bin/sh
#Mansi, 200101064
#tar [options] [archive-file] [file or directory to be archived]
#reading the input command
read line
#parsing the space in the command and storing individual elements in an array
read -a arr <<< $line
#getting the length of the array
length=${#arr[@]}


#parsing the string containing commands(c,r,x,t,f,f-,v) into different commands and storing these commands in the array y
for (( i=0 ; i < ${#arr[1]} ; i++ ));
do
    y[i]=${arr[1]:i:1};
done

#checking if the given command is tar or not , if not then giving appropriate error
if [ "${arr[0]}" = "tar" ]
then
    
#checking for c command in the array y
for (( i=0 ; i < ${#arr[1]} ; i++ ));
do
    if [ "${y[i]}" = "c" ]
    then
    #if present, creating a text file which will store the data of the archive files along with their metadata
    #here i am storing the metadata for each file after ******^^^^^^****** mark, so that while extraction, i can use them as a guide to find the meta data for the respective file
        echo "******^^^^^^******" >> ${arr[2]}
        for (( i=3 ; i < ${#arr[@]} ; i++ ));
        do
        #finding the metadata for the file that needs to be archived using grep for ls -l
            ls -l>>grep -w ${arr[i]}
        #transferring this data from the grep doc to the arcive file
            cat grep>>${arr[2]}
        #writing a mark to differentiate between metadata and actual data of the file
            echo "######^^^^^^######" >> ${arr[2]}
        #writing data from the file to archive file
            cat ${arr[i]}>>${arr[2]}
            echo >>${arr[2]}
        #writing a mark in the archive file to denote the end of the actual data/file
            echo "######^^^^^^######" >> ${arr[2]}
            echo "******^^^^^^******" >> ${arr[2]}
        #deleting the grep doc once the metadata is taken from it so that it can store the metadata for upcoming file
            rm grep
        done
    fi
done


#checking for r command in array y and doing the same thing as c as we just need to append the new files at the end of the archive file
for (( i=0 ; i < ${#arr[1]} ; i++ ));
do
    if [ "${y[i]}" = "r" ]
    then
        for (( i=3 ; i < ${#arr[@]} ; i++ ));
        do
            ls -l>>grep -w ${arr[i]}
            cat grep>>${arr[2]}
            echo "######^^^^^^######" >> ${arr[2]}
            cat ${arr[i]}>>${arr[2]}
            echo >>${arr[2]}
            echo "######^^^^^^######" >> ${arr[2]}
            echo "******^^^^^^******" >> ${arr[2]}
            rm grep
        done
    fi
done


#checking for t command in the array y
for (( i=0 ; i < ${#arr[1]} ; i++ ));
do
    if [ "${y[i]}" = "t" ]
    then
        #if peresent, we need to print the names of the files in the archive file
        flag=0
        #reading the archive file line by line
        while IFS= read -r line;
        do
        #if flag is 1 that means that this line contains metadata
            if(test $flag -eq 1)
            then
            #parsing the white spaces in the metadata line and storing the components in array arrl
                read -a arrl <<< $line
            #as we know that the file name is the 9th entry in the metadata line, we will print that name from the parsed array arrl
                echo ${arrl[8]}
            #as we are done with the metadata line, we must return flag to 0 to represent that the next line is not metadata
                flag=0
            fi
        #turning flag to 1 from 0 when we identify ******^^^^^^****** mark, which represents the presence of metadata in the next line
            if [ "$line" = "******^^^^^^******" ]
            then
                flag=1
            fi
        done < ${arr[2]}
    fi
done


#checking for x command in the array y
for (( i=0 ; i < ${#arr[1]} ; i++ ));
do
    if [ "${y[i]}" = "x" ]
    then
    #if present, puting flag and count to 0, flag for extracting the name of the file and count for actual data extraction
        flag=0
        count=0
    #reading the arhive file line by line
        while IFS= read -r line;
        do
        #if flag=1, extracting the filename in the same way as in t command
            if(test $flag -eq 1)
            then
                read -a arrl <<< $line
            #creating the file with the extracted filename
                echo >>${arrl[8]}
            #returning flag to 0 to represent the end of metadata reading
                flag=0
            fi
            #identifying the start of actual data in the file
            if [ "$line" = "######^^^^^^######" ]
            then
                if(test $count -eq 0)
                then
                #if found, initializing count to 1 to represent the start of actual data
                    count=1
                    continue
                else
                #if found, initializing count to 0 to represent the end of actual data
                    count=0
                fi
            fi
            #printing actual data in the file whose name we extracted
            if(test $count -eq 1)
            then
                echo $line>>${arrl[8]}
            fi
            #puting flag 1 when the coming line is metadata line
            if [ "$line" = "******^^^^^^******" ]
            then
                flag=1
            fi
        done < ${arr[2]}
    fi
done

#checking for v command in the array y
for (( i=0 ; i < ${#arr[1]} ; i++ ));
do
    if [ "${y[i]}" = "v" ]
    then
    #if found, we will find the meta data and print the metadata for that file
        flag=0
    #reading the archive file
        while IFS= read -r line;
        do
            if(test $flag -eq 1)
            then
            #printing the metadata line
                echo $line
                flag=0
            fi
            
            if [ "$line" = "******^^^^^^******" ]
            then
                flag=1
            fi
        done < ${arr[2]}
    fi
done


#checking for f- command
#for (( i=0 ; i < ${#arr[1]} ; i++ ));
#do
    #if [ "${y[i]}" = "f-" ]
#done

else
#printing error message if the given command is not a tar operation
    echo PLEASE GIVE A TAR COMMAND
fi
