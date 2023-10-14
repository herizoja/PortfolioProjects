# Based on tutorial from (https://www.youtube.com/watch?v=ey1VNjU0YbM&list=PLUaB-1hjhk8FE_XZ87vPPSfHqb6OcM0cF&index=51) 


name = input('Enter your name: ')


weight = int(input("Enter your weight in pounds: "))


height = int(input("Enter your weight in inches: "))


BMI = (weight * 703) / (height * height)
print(BMI)




Under 18.5	Underweight	Minimal
18.5 - 24.9	Normal Weight	Minimal
25 - 29.9	Overweight	Increased
30 - 34.9	Obese	High
35 - 39.9	Severely Obese	Very High
40 and over	Morbidly Obese	Extremely High




if BMI>0:
    if(BMI<18.5):
        print(name +", you are underwight.")
    elif (BMI<=24.9):
        print(name +", you are normal weight.")
    elif (BMI<29.9):
        print(name +", you are overweight.")
    elif (BMI<34.9):
        print(name +", you are obese.")
    elif (BMI<39.9):
        print(name +", you are severely obese.")
    else:
        print(name +", you are morbidly obese.")
else:
    print("Enter valid input")







