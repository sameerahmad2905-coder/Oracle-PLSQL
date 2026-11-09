# from pathlib import Path

# def readfileandfolder():
#     path = Path('')
#     print("Current folder:", path.resolve())

#     items = list(path.glob('*'))
#     print("Total items found:", len(items))

#     for i, item in enumerate(items, start=1):
#         print(f"{i} : {item}")

# readfileandfolder()


from pathlib import Path
#library thru which can read the current folder
 
def readfileandfolder():
    path = Path('')         #Path('') means current folder

# path = Path('')
# Path → class just like list() and dict() are classes.
# '' → current directory
# path → variable holding a Path object

    print("Current folder:", path.resolve())    #Getting the curr fol name
    items = list(path.glob('*'))   #creating a list & storing 
                                    #all files & folders into items.
    #recursive globe - provides all file in courrent folder & subfolder.
    #glob - Only with in this folder, not in subfolder
    for i, items in enumerate(items):
        print(f"{i+1} : {items}")  
readfileandfolder()        