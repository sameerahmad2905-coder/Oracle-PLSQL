# File Handling means - Creating/Reading/Upadting/Deleting

# v = open(r'D:\Pyhton\Python\Exceptions.py')
# print(v.read())

# l = open(r'D:\Pyhton\Python\file_Handling.py')
# print(l.read())

# print("----MOdes of File ----------")
# print("r - Read files that must exist")
# print("w - Write/Creates file or overwrites it")
# print("a - Append to end of file")
# print("x - Creates a new file fails if it's exists")

r = open("Hello.py",'w')
r.write("Hi")
r.close()

print("Done")

# import os

# print(os.getcwd())


# r = open("help.txt",'a')
# r.write("now appeending")
# r.close


# a = [1,2,3,4,5,6]
# for i, a in enumerate(a):       #enumerate being used for having 
#     print(i ,"-", a)        #both index & value at the same time

# open("help2.txt", "r")
#     r.write("Hello This is Sameer")


# import os
# print(os.getcwd())


# list() → creates a list
# dict() → creates a dictionary
# Path() → creates a path object (file/folder location)