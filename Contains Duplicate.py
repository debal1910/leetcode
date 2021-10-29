#Approach one is to first sort the list and check if the current element matches the previous element. 

nums = [1,1,1,3,3,4,3,2,4,2]

nums.sort()

flag = False

for i in range(1,len(nums)) :
    if nums[i] == nums [i-1] :
        flag = True
        break
print(flag)

#Approach two is to convert the list to set as set removes duplicates.
nums = [1,1,1,3,3,4,3,2,4,2]

numset = set(nums)
if len(nums) == len(numset) :
    print("False")
else:
    print("True")