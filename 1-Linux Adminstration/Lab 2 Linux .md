# Lab 2 Linux Administration
### Questions : 
 **1- Navigate to your home directory and then go to the directory for your user.**
			`cd /home`
			` cd abdelhamed/`
**2- create 3 directories project1, project2, and project 3.**

    mkdir project1 project2 project3

**3- Create another 3 directories using the brace extension for project 4, project 5, and project 6.**

    touch project{4..6}

**4- Create files name fileXY where X takes value from 1 to 6 and Y takes value from 1 to 2.**
			

    touch file{1..6}{1..2}

**5-** **Move file11 and file12 to Project1**
**file21 and file22 to project2**
**file 31 and file 32 to project 3**
**and so on till the current directory does not have any files.**

     mv file1* project1/
     mv file2* project2/
     mv file3* project3/

**6- Go to Project3 and copy all files inside it to project 6 in one command.**

    cd project3/ ; cp * ../project6 
    
**7- Go to directory Project1 and create 2 subdirectories myplan/importantfiles in one command.**

    cd project1 ; mkdir -p myplan/importantfiles

**8- Create a hard link for file 51 under myplan/importantfiles**
***Hard Link*** : The Linkage between the Target and the Destination is by the ***Inode Number***		, used for backup , when u delete the Original File , nothing happened to the Linked File as it have the Same ***inode***
			
    ln [Target] [Destination] 
    ln ../../../file51 file51HardLink
    

**9- Create a soft link for file 11 under myplan/importantfiles**
**Soft Link** :  The Linkage Between the Target and the Destination is by the ***Name of the Original file*** , if u changed the name of original file there is will be error misleading the linkage file , in case u changed the name or deleted the file , soft link is simple and used in directories 

    ln -s ../../../file11 file11SoftLink


**10- create a soft link to the directory project4 under /tmp** 

    ln -s project4 /tmp/

**11- Remove the Project1 directory without being asked for confirmation by the prompt.**

    rm -rf Project1

**12- Rename file22 to the last file.**

    mv file22 'last file'

