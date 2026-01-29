### Module 1 Assignments
#### 1) Create a file and add executable permission to all users (user, group and others)
1) Create a file `sample.txt` using 

           `
           touch sample.txt
           `

3) List the content of directory and use grep to filter the file created and view the permissions:
   
           `
           ls -l | grep sample
           `

    we notice that the executable permission (x) is npt provided for owner, group or others.

5) Modify the permission, to provide executable permission to all users using:
   
            `
           chmod a+x sample.txt
           `

where:
        `a` - all users
        `x` - executable permission
        
7) Now view the permissions of all users usnig the list command. You will find the executable permission available to all users, denoted by the `x`

![Image](task1.png)


#### 2) Create a file and remove write permission for group user alone
#### 3) Create a file and add a softlink to the file in different directory (Eg : Create a file in dir1/dir2/file and create a softlink for file inside dir1)
#### 4) Use ps command with options to display all active process running on the system
#### 5) Create 3 files in a dir1 and re-direct the output of list command with sorted by timestamp of the files to a file
