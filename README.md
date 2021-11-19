# Tar-command-replica
Made a tar command replica in shell script that implements the basic tar commands
## Instructions for running:
Some assumptions and points which should be kept in mind for smooth execution:
1. I am assuming that all the commands given to tar among c,r,x,t,f,f-,v are followed by f in all the commands as instructed by the professor.
2. Before extraction of the files in the archive, remember to remove the files with the same name as that of the files stored in the archive, otherwise those will be appended with the same data which is currently in them.
3. The extracted files will have the same data as that of the initial file but, with a newline from the beginning of the file.
4. The archive file is a text file, as instructed by the professor.
5. Don’t a tar command to just create a tar archive without any file arguments, as that is
not possible in real terminal as well.
6. Don’t give c and r commands together.
## Steps for proper execution: 
1. After the execution of the shell script, type the tar command, start with creating the archive file using the command : $ tar cvf <name of the archive file> <flie1> <file2> ...
2. Then execute any further tar commands you want to, also, you can give tar commands in any order I.e. cvf, vfc, fcv, etc. will all do the same task as in orignal tar command.
