# Given an integer array nums, find the contiguous subarray (containing at least one number) which has the largest sum and return its sum.
# A subarray is a contiguous part of an array.
# Example 1:
# Input: nums = [-2,1,-3,4,-1,2,1,-5,4]
# Output: 6
# Explanation: [4,-1,2,1] has the largest sum = 6.

# Example 2:
# Input: nums = [1]
# Output: 1

# Example 3:
# Input: nums = [5,4,-1,7,8]
# Output: 23
 
# Constraints:
# 1 <= nums.length <= 105
# -104 <= nums[i] <= 104

#Solution 1 : The brute force method. Fix on first element and then start adding next numbers to the sum check if sum greater then replace.
# repeat by increasing i by 1 until end of list
#Time complexity of O(n^2)

nums = [-2,1,-3,4,-1,2,1,-5,4]
# nums = [1]
# nums = [5,4,-1,7,8]
sum = nums[0]
largeSum = nums[0]

for i in range(0,len(nums)) :
    sum = nums[i]
    for j in range(i+1,len(nums)) :
        sum = sum + nums[j]
        if sum > largeSum :
            largeSum = sum
print (largeSum)

# Kandane's algorithm 
# set first element as max_so_far and max_ending_here. Then start looping from second element
# find the max of max_ending_here + ith element and ith element
# find the max of max_ending_here and max_so_far
# Time complexity is O(n)

nums = [-2,1,-3,4,-1,2,1,-5,4]
# nums = [1]
# nums = [5,4,-1,7,8]

max_so_far = nums[0]
max_ending_here = nums[0]

for i in range (1, len(nums)):
    max_ending_here = max(max_ending_here + nums[i], nums[i])
    max_so_far = max(max_ending_here,max_so_far)

print(max_so_far)