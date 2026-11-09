https://www.naukri.com/code360/library/unix-interview-questions

https://www.youtube.com/watch?v=p6yAvnS3KHQ


🧩--LS
ls -lt	→	Newest file (Date wise, time wise created) appears on top
ls -lr  →   Reverse alphabetical, long format
ls -ltr →   Oldest file first, reverse time order
ls -lSr →   Smallest file first

ls -lt
👉 Newest file appears on top
-rw-r--r-- 1 oracle dba  2048 Jan 30 22:10 alert.log
-rw-r--r-- 1 oracle dba  1024 Jan 29 18:30 app.log
-rw-r--r-- 1 oracle dba   512 Jan 25 09:15 old.log

a.txt  b.txt  c.txt
ls -lr
👉 file arranged in alphabetically order
Output:

c.txt
b.txt
a.txt

ls -ltr
👉 OLdest file appears on top
-rw-r--r-- 1 oracle dba  2048 Jan 25 09:15 old.log
-rw-r--r-- 1 oracle dba  1024 Jan 29 18:30 app.log
-rw-r--r-- 1 oracle dba   512 Jan 30 22:10 alert.log

🧩--DIR
There is NO standard dir command in classic Unix

But…
👉 Linux (GNU coreutils) provides a dir command
👉 It behaves almost like ls
👉 It doesnt highlights the Directories, shell scipts, txt files differently as is in case of ls cmd.
dir -lr
-rwxrwxrwx 1 sameer sameer  137 Jan  3  2024 proc_ex.sh
-rw-r--r-- 1 sameer sameer 1125 Jan  3  2024 fruits.txt
-rwxrwxrwx 1 sameer sameer  163 Jan  3  2024 err_msg.sh
-rw-r--r-- 1 sameer sameer 1616 Nov 25  2023 emp.txt
-rwxr--r-- 1 sameer sameer   28 Nov 25  2023 abc.sh
drwxrwxr-x 1 sameer sameer  512 Nov 26  2023 TCS
drwxrwxr-x 1 sameer sameer  512 Nov 26  2023 CTS

🧩--TOUCH 
It creatse an empty zero byte file.
touch sameer.txt

🧩--VI command -> Creating any shell file
#!/bin/bash		-> esc 
echo "Hello Unix"		-> i -> or entering text
-> esc -> for coming out of Insert mode
-> :wq! for saving 


What happens if we do touch script.sh and then ./script.sh?
✔️ Correct answer:
Touch only creates or updates the file timestamp. 
The script won’t execute unless it has execute permission and a valid interpreter.


🧩--The Three File Timestamps
--stat file.txt Commands for getting al the three times

	Time		  Full Form				   What changes it
	mtime		Modification time		File content changes
	ctime		Change time				Metadata changes
	atime		Access time				File is read/accessed

mtime  -> When the data, context with in the file is updated, modified
ex.. echo "hi" >> test.sh
cmd$ ls -lt

ctime -> Chaneg time, permission change (chown. chmod), file renamed, content changed.
cmd$ ls -lc

atime -> file is read 
ex...
	cat file.txt.
cmd$ ls -lu	

sameer@Administrator:~$ stat test.sh
  File: test.sh
  Size: 56              Blocks: 0          IO Block: 512    regular file
Device: 2h/2d   Inode: 8444249301552639  Links: 1
Access: (0755/-rwxr-xr-x)  Uid: ( 1000/  sameer)   Gid: ( 1000/  sameer)
Access: 2026-02-01 00:32:08.426978400 +0530
Modify: 2026-02-01 00:29:19.047707100 +0530
Change: 2026-02-01 00:29:19.056510700 +0530
 Birth: -
 
🧩-- FIND -- Finding any file throghiout any Dir/Sub-dir
ex..
	find /home/ -name "a.log"
	find ~ -iname "Test*"  --> Searchign from the root Directory, ignorign case sensitiveness
	find ~ -type f -name "affan*"		--Searching only files
	find ~ -type d -name "scripts"		--Searching only diretries
	
	grep -R "ERROR" ~ 2>/dev/null		--Serching by file content
	grep -R "ERROR" ~
	
	find ~ -size +100M		--> Searching fiel larger than a size





🧩--SU - Switch User being used to switch to root user & then givign all permissions to Sameer	
sudo chmod 777 sameer	

🧩-- CD Change Directory
cd ~ --> Working Directry
cd / --> Root Directory
cd .. --> Previos DIRECTORY

🧩--CHMOD Changing file permission from anywhere outside
	ex.. R- Read. W-Write, X-Execute
			4		2		1
🧩--CHOWN Changing ownership of file, also the group to which file belonsg to
	ex..
			Chown username file

🧩--RM Removign files & its CONTENTS
rm - rf -> Forecfully Deleting
rm -f -> Not to ask anything
rm -i -> not to ask whether to delete or Not

	🚨 EXTREMELY DANGEROUS (NEVER DO THIS)
	rm -rf /
	rm -rf *
	rm -rf /home

4️⃣ Protect yourself (VERY IMPORTANT)
alias rm='rm -i'
	
	
🧩--Craetign any design pattern

jack jack jack jack jack jack
jack jack jack jack
jack jack jack
jack jack
jack


#!/bin/bash

for i in 6 4 3 2 1
do
  for ((j=1; j<=i; j++))
  do
    echo -n "jack "
  done
  echo
done
	
