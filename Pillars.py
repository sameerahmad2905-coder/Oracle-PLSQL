# Inheritance - Propery or any possession that comes to heir(son/grandson)

# Syntax...
class parent:           #parent class
    a = "Attribute inside parent"
    def speak(self):
        print("This is the parent class")

class child(parent):        #child class
    pass

obj = parent()
print(obj.a)
obj.speak()

obj1 = child()      #Child class 
print(obj1.a)
print(obj1.speak())