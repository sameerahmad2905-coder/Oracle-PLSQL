# class Animal:
#     def __init__(self,name):
#         self.name = name

#     def __str__(self):
#         return f"Hello how are you {self.name}" 

# obj = Animal("Lion")       
# print(obj)    


# class Animal:
#     def __init__(self,name,age):
#         self.name = name
#         self.age = age

#     def __str__(self):
#         return f"Hello how are you {self.name}" 

#     def __add__(self,age):
#         # return f"Sum of both your name is {self.name + self2.name}"
#         return f"Sum of both your age is {self.age + age.age}"
        
    
# obj = Animal("Lion",12)     
# obj2 = Animal("Tiger",14)  
# print(obj + obj2)    



# class Animal:
#     def __init__(self,name,age):
#         self.name = name
#         self.age = age

#     # def __str__(self):
#     #     return f"Hello how are you {self.name}" 

#     def __add__(self,age):
#         # return f"Sum of both your name is {self.name + self2.name}"
#         sum = 0
#         for i in age:
#             sum = sum + i.age
#         return f"Sum of both your age is {self.age + sum}"
        
    
# obj = Animal("Lion",12)     
# obj2 = Animal("Tiger",14)  
# obj3 = Animal("Python",14)
# obj4 = Animal("Test",12)
# print(obj + (obj2,obj3,obj4))      

class Animal:
    def __init__(self,age):
        self.age = age
  
    def __add__(self,age):
        sum = 0
        for i in age:
            sum = sum + i.age
        return f"Sum of both your age is {self.age + sum}"
        
    
obj = Animal(12)     
obj2 = Animal(14)  
obj3 = Animal(14)
obj4 = Animal(12)
print(obj + (obj2,obj3,obj4))     