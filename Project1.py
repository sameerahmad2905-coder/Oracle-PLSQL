# pathlib is a built-in Python module (library).
# Think of it like a toolbox that contains tools 
# for working with files and folders.
    
# Path is a tool inside the pathlib toolbox that allows 
#         us to work with file and folder paths.
#         It is similar to list() and dict() which are built-in 
#         Python functions that create lists and dictionaries.

# import math --> gives you mathematical tools,
# import pathlib --> gives you tools for working with file paths.
# import random --> gives you random number tools,

# from math import sqrt      # sqrt comes from math
# from random import randint # randint comes from random
# from pathlib import Path   # Path comes from pathlib

# pathlib  --->  toolbox
# Path     --->  tool inside the toolbox

# pathlib  --->  toolbox
# Path
# PurePath
# PurePosixPath
# PureWindowsPath
# PosixPath
# WindowsPath

# from pathlib import Path --> MEans "Go into the pathlib module and "
#                             "bring me the Path tool."

# list() → creates a list
# dict() → creates a dictionary
# Path() → creates a path object (file/folder location)

#------------------------------------------------------------

#Before creating, finding what previous files exists in the folder, 
#library thru which can read the current folder
from pathlib import Path
def readfileandfolder():
    path = Path('')         #Path('') means current folder
    items = list(path.glob('*'))   #creating a list & storing 
                                    #all files & folders into items.
    #recursive globe - provides all file in courrent folder
    for i, items in enumerate(items):
        print(f"{i+1} : {items}")   #printing all files & folders in 
                                    #the current folder



#Before 
def createfile():   #Creating file
    try:
        readfileandfolder()  #calling the function to read all files & 
                            #folders in the current folder
        name = input("Please tell your file name : ")
        p = Path(name)      #added the name of the file given by the user into
                       #the Path of the current folder which is 'Path'                
        if not p.exists() and p.is_file():
            with open(p, 'w') as fs:
                data = input("What you want to write in this file ....? ")
                fs.write(data)
            print(f"File created successfully")
        else:
            print(f"File already exists ")
    except Exception as error:
        print(f"Error occurred while creating the file: {error}")

print("Enter 1 for creating a file : ")
print("Enter 2 for reading a file : ")
print("Enter 3 for updating a file : ")
print("Enter 4 for deleting a file : ")

def readfile():
    try:
        readfileandfolder()
        name = input("Which file do you want to read ...?  ")
        p = Path(name)
        if p.exists() and p.is_file():
            with open(p,'r') as fs:
                data = fs.read()
                print(data)
            print("Read successfully ")
        else:
            print("File doesn't exists ")    
    except Exception as err:
        print(f"Getting an error {err}")
check = int(input("please enter your choice : "))

if check == 1:
    createfile()

if check == 2:
    readfile()