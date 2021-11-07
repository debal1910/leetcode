# Given an array of integers nums and an integer target, return indices of the two numbers such that they add up to target.
# You may assume that each input would have exactly one solution, and you may not use the same element twice.
# You can return the answer in any order.

# Example 1:
# Input: nums = [2,7,11,15], target = 9
# Output: [0,1]
# Output: Because nums[0] + nums[1] == 9, we return [0, 1].

# Example 2:
# Input: nums = [3,2,4], target = 6
# Output: [1,2]

# Example 3:
# Input: nums = [3,3], target = 6
# Output: [0,1]
 
# Constraints:
# 2 <= nums.length <= 104
# -109 <= nums[i] <= 109
# -109 <= target <= 109
# Only one valid answer exists.
 
# Follow-up: Can you come up with an algorithm that is less than O(n2) time complexity?


#This is the bruteforce method
nums = [2,7,11,15]
target = 9
output = []
flag = False

for i in enumerate(nums):
    for j in enumerate(nums):
        if i[0] == j[0] :
            continue
        if i[1] + j[1] == target:
            output = [i[0],j[0]]
            flag = True
    if flag :
        break
print(output)

nums = [3,3]
target = 6
hashtable = {}
for index, num in enumerate(nums):
    remainder = target - num
    if remainder in hashtable:
        print(index,hashtable.get(remainder))
    else :
        hashtable[num] = index
