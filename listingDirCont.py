import os       
# Step 1 -> Importing the Module
#  
# Specify the directory path
directory_path = "D:/"

# Get all files and folders using the OS module
contents = os.listdir(directory_path)
print(contents)
# print("Contents of directory:")
        # for item in contents: -----> using for i (indexing)
        #    print(item)        ----> so as to get it as a list
