# Class - Group of 
#         i. Variables named Attributes
#         ii. Functions named Methods
#         iii. Dunder Functions having double underscore ex "__inti__"
# Objects are child of Class & has the same power that of Class.

# class Factory():
#     a = "Sameer"
#     def hello(self):
#         print(f"How are you...{Factory().a}?")

# Factory().hello()       #This cmd class.method is retrieving methd
# print(Factory().a)
# print("This one my first Class n Object")

# obj = Factory().hello()
# obj = print(Factory().a)


#------------Using Object in Class---------

# class Factory():
#     a = "Sameer"
#     def hello(self):  # self, declared here is having loc of Object-obj
#         print(f"How are you...{Factory().a}?")
# Factory().hello()
# print(Factory().a)
# print("This one my first Class n Object")

# obj = Factory().hello()  #Objects
# obj = print(Factory().a)
# obj1 = Factory()

#------------Constructor---------------
#Constructor func is been used with in teh Class through 
# a __init__ Method using Self & any variable to get the 
# value been 
# assigned ...ex

# Making use of Constructors we can get the values of 
# required Parameters in defined Methods (Func) in Class
# It runs automatically when we call a class & this Constructor fucn will
# target the object location, means store the values of Parameters, like
# Name, age, sex, city, etc... in the location of Object defined.


# class Factory:
#     def __init__(self,materials,zips,pockets):
#         self.materials = materials
#         self.zips = zips
#         self.pockets = pockets
#         print(self)
#     def show(self):
#         print(f"Your materials {self.materials}, {self.zips},{self.pockets}")

# Reebok = Factory("Leather",3,2)    #Defined Object, child of Class

# Puma   = Factory("Nylon",2,4)    #Defined Object, child of Class

# print(f"{Puma.zips} zips are required for Bags of Puma")
# print(Reebok.materials)

# Reebok.show()     #using object along with the Class Method - 'show'


#--------------Types of Attribute---------

# 1 Class Attribute - A normal variable created inside a class.
# 2 Instance (Object or location of the Object) Attribute -
#              Any Attribute created using an Instance like 
#                         self.name, self.age etc...

# class care:
#         wheels = 4      #Class Attribute

#         def __init__(self,colour):
#                 self.colour = colour    #Instance Attribute


#--------------Types of Methods-------------

# 1 Instance Methods - Instance Method works with Instance (Object) of the 
#                 class. This method can access & modify instance attributes.
                # It points to teh locations of Objects
#     class Myclass:
#         def instance_methods(self):
#                 print("This is Instanec Method")

# 2 Class Method - Uses '@' before declared method name, 
#           it is used to have different Methods within it having
            # parameter poiting to the location of Class under which this
            # Methos is coming

# 3 Static Method   - @staticmethod  - This method doesn't access class
                # or Instance directly, it uses as decorator @. It just acts
                # as regular function placed inside a class.
      

# class Animal:
#     name = "Lion"

#     def __init__(self,age):
#         self.age = age #Instance Attribute
    
#     def show(self): #Instance Method
#         print(f"how are you, is your age {self.age}....?")
    
#     @classmethod        #Class Method
#     def hello(abc):
#         print("How are you")        
    
#     @staticmethod       #Static Method
#     def static():
#         print("Hi, how are you")

# obj = Animal(12) #Declaring object as Class alonmg with any parameter def
# #--Needs the decalaration once i.e. Any child object related to 
# # Parent Class, here it is 'OBJ'

# print(Animal.name)
# #Making use of the declared Object to execute the declared Methods
# obj.show()      
# obj.hello()
# obj.static()

# # obj = print(Factory().a)



# class Animal:
#     name = "Lion"      # Class Attribute

#     def __init__(self, age):
#         self.age = age     # Instance Attribute

#     def show(self):        # Instance Method
#         print(f"How are you, is your age {self.age}?")

#     @classmethod
#     def hello(cls):        # Class Method
#         print("How are you")

#     @staticmethod
#     def static():          # Static Method
#         print("Hi, how are you")


# obj = Animal(12)  # Object Creation for the class, once declared
#                         #need not to use the class name anymore

# print(obj.name)        # Access Class Attribute

# obj.show()                # Instance Method
# obj.hello()               # Class Method
# obj.static()              # Static Method
# obj = Animal(12)

# print(obj.age)

# class Animal:
#     def __init__(self,name):  #Constructor having param for Class
#         self.name = name
#     def show(self):
#         print(f"Nice {self.name}") 

# class Human(Animal):
#     pass

# obj = Animal("Tiger")
# obj.show()

#---------------------Inheritance---------------------
#----------Single Inheritance-------------------
# class Animal:
#     def __init__(self, name, location):
#         self.name = name
#         self.location = location

#     def show(self):
#         print(f"Nice {self.name} from {self.location}")


# class Human(Animal):
#     def __init__(self,name,location,age):
#         super().__init__(name,location)
#         self.age = age

#     def show(self):
#         print(f"How are you {self.name},{self.age},"
#               f"from {self.location}"
#               )
        

# obj = Animal("Lion","Amazon")
# obj.show()
# obj = Human("Sameer","Delhi",23)
# obj.show()

# obj1 = Animal("Tiger","Amazon")
# obj1.show()


#--------------Multiple Inheritance--------------
#MRO - Method Resolution Order
# class Animal:
#     name = "Lion"

# class location:
#     location = "Amazon"    

# class Robot(location,Animal):
#     Age = 12

# obj = Robot()
# print(f"{obj.name} from {obj.location} of {obj.Age}")

#--------------Multi level Inheritance--------------


# class Factory:
#     def __init__(self,material,zip):
#         self.material = material
#         self.zip = zip
#     def show(self):
#         print(f"{self.material},{self.zip} ")

# class DelhiFactory(Factory):
#     def __init__(self,material,zip,colour):
#         super().__init__(material,zip)
#         self.colour = colour
#     def show(self):
#         print(f"{self.material},{self.zip},{self.zip}")    

# class OkhlaFactory(DelhiFactory):
#     def __init__(self,material,zip,colour,pockets):
#         super().__init__(material,zip,colour)
#         self.pockets = pockets
#     def show(self):
#         print(f"{self.material},{self.zip},{self.colour},{self.pockets}") 

# obj = OkhlaFactory("leather",3,"Blue",4)        
# obj.show()
 

# class Factory:
#     def __init__(self, material, zip):
#         self.material = material
#         self.zip = zip

#     def show(self):
#         print(f"{self.material}, {self.zip}")


# class DelhiFactory(Factory):
#     def __init__(self, material, zip, colour):
#         super().__init__(material, zip)
#         self.colour = colour

#     def show(self):
#         print(f"{self.material}, {self.zip}, {self.colour}")


# class OkhlaFactory(DelhiFactory):
#     def __init__(self, material, zip, colour, pockets):
#         super().__init__(material, zip, colour)
#         self.pockets = pockets

#     def show(self):
#         print(
#             f"{self.material}, {self.zip}, "
#             f"{self.colour}, {self.pockets}"
#         )


# obj = OkhlaFactory("leather", 3, "Blue", 4)
# obj.show()


# ------------------Abstraction Method------------

from abc import ABC, abstractmethod

class Abstract(ABC):
    @abstractmethod
    def perimeter(self):
        pass

    @abstractmethod
    def area(self):
        pass

class Rectangle(Abstract):
    def __init__(self,length,breadth):
        self.length = length
        self.breadth = breadth

    def perimeter(self):
            print(f"Permeter is {2*(self.length + self.breadth)}")
    
    def area(self):
            pass
    
class Square:
    def __init__(self,breadth):
        self.breadth = breadth        

obj = Rectangle(5,6) 
obj.perimeter() 
