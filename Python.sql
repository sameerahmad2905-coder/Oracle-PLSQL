https://www.apnacollege.in/course/prime-ai
https://www.apnacollege.in/course/sigma-prime

https://www.youtube.com/watch?v=t2_Q2BRzeEE



https://www.youtube.com/watch?v=QXeEoD0pB3E&list=PLsyeobzWxl7poL9JTVyndKe62ieoN-MZ3&index=1
https://www.codewithharry.com/
https://www.youtube.com/watch?v=UrsmFxEIp5k			---- Code With HAry Pyhton
https://www.youtube.com/watch?v=gfDE2a7MKjA


https://www.youtube.com/watch?v=iIkJrwVUl1c&list=PLu0W_9lII9ai6fAMHp-acBmJONT7Y4BSG&index=21	---ML using Pyhton



https://www.youtube.com/playlist?list=PLGjplNEQ1it8-0CmoljS5yeV-GlKSUEt0	---Python Classes

https://www.youtube.com/watch?v=jdXXA5l3KzE&list=PLbGui_ZYuhijd1hUF2VWiKt8FHNBa7kGb		--Adv Python


Commenting Multiple lines ----> cntrl + \

type Casting -> just like to_Number, To_Char in Oracle SQL
a=20
b=int(a) ---> 20 in number. Means charcater to number

name = input(enter your name :) --#-- Input value is always String in Pyhton
print(name)

Examle if want to get the number (INTEGER) 
num1 = int(input(Enter your age: ))
print(type(num1)) ----> Integer

----------------------------Chapter2->Strings------------

\n ----> for moving the text to next lines

Slicing -- > Starting Index : Ending Index
str=Samer Ahmad
print(str[1:6])  ---> ameer 


Negative Slicing

str = Apple
str[-3,-1]
print(str[-5:1])

--Normal Functions

1 - endswith --> Check whther the txt or any word ends with the givn charecters or not. if yes thn Rturn 'True' else False'
Example
		name = Sameer Ahmad
		print(name.endswith(mad)) --> True

2 - capitalize --> Capitalize the firts character of any word, only once, if want we can fix it also by storing th cpitalize value into another 					vriable...
							name = sameer ahmad
							print(name.capitalize())  ---> Sameer ahmad
					--if want to fix it.
							name = sameer ahmad
							name = (name.capitalize())
							print(name)
							
3 - replace(old,new) -->	replace the old word with the new one
4 - find(word)		 --> 	returns 1st index of 1st occurer
5 - name.count(am)      --> 	counts the occurec of substr am word in the sentence  -- Sameer ahamad ----> 2


---Conditions - If-Elif-else

# age = 100
# if(age >= 18):
#     print(Can apply for license & vote)
# if(age < 18):
#     print(Need to be of 18)  
# else: (End)  

if (a>b and a>c)
		if (a>d):
				then (A is Highest)
			else:
			(D is highest)
elif(b>a and b>c and b>d):
		then (b is highest)
else:
	(c is highest)
		


---------------------Chapter-3-->List & Tupples-------------------------

------Strings in Pyhton -> Immutable    --> a=sam --> a[0]=h --> nt allowed, chnaging the value of s to h
						once index declared cannot be incremented
						
-------Lists in Pyhton -> Mutable (can  be changed) -->a=[a,23,m,3.14]	--> a[0]=b --> permissible

--Functions for list
1 - append
2 - sort
3 - sort(reverse=True)
4 - reverse  		---> Reverse the complete List from last to Start
5 - insert(idx, value) --> To add/insert any value in the list at a declared index
6 - remove(1)			---> remove any firts occurence of number/char
7 - pop(2)			----> remove the number/char from the index - 2

-----Tuples in Python
A built in Data type that let us to create immutable sequences of values, CANNOT BE CHANGED
A list of values with normal brcket just like Strings, but needs normal bracket -> (1,2,3,4,9)
* Needs a comma(,) in case theres only one value in Tupple
	ex... tup=(1,)
			print(tup)		--> 1,
			print(type(tup))	--> tuple

---Methods in Tuple

# list1 = [1,2,3,2,1,1]
# list2 = [1,2,3,4,5]

# copy_list1 = list1.copy()
# copy_list1.reverse()

# if(copy_list1 == list1):
#     print(list1 is Palindrome)
# else:
#     print(Not Palindrome)    
# grade=list1.count(1)   
# print(grade) 

------------------------Chapter4 - Dictionary in Python--------------------

Dictionaries are used to store data values in Key:Value pairs
words - Meanings -- just like in Dictionary
Values in Dictinaries are Mutables just like List

examples...

info = {
name : Sameer,
age : 38,
Gender : male,
Nationality : Indian,
studies : (Diploma,B.E.),					#Tuple
locations : [Delhi,Pune,Hyderabad]		# List
}

print(info[Gender])

**For Keys we cant use list & Dictionary --
Only Tuples can be used as Key, since it cant get changed, rest others can get changed so....

info[name] = Affan		----> Renaming Name in Dicionary
info[surname] = Ahmad		----> Renaming Name Surnam in Dicionary

----Dictionary Methods




---Nested Dictionary

Student = {
name