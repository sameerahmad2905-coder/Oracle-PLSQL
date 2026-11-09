a = int(input("Enter the number : "))

try:    #wrap teh blk of code that might cause an exception
    print(10/a)
except ZeroDivisionError:  #Handle the exception if it occurs
    print("Sorry you cannot divide by 0")

# else:       #Run code only if no exception occurs

# finally:    #Run code no matter what, whether there's an exception or not   
print("Division completed")




a = int(input("Enter the number : "))

try:    
    print(10/a)
except Exception as err:
    print(f"Sorry there's an error - {err}")
else:
    print("Good there is no exception ")
finally:
    print("I will run no matter whatever happens")    
print("Division completed")


print("---------Raise exception - Manually---------")

age = int(input("Enter your age :- "))

try:
    if age > 18 or age < 10:
        raise ArithmeticError("Your age must be between 10 and 18")
    else:
        print("Welcome")
except Exception as err:
    print(f"Got an error as {err}")
print("The club will start soon")