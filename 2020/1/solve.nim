import sets, strutils, sugar, strformat

func twoSum(numbers: openArray[int], sum: int): (int, int) =
  let numberSet = numbers.toHashSet
  for n in numberSet:
    if sum - n in numberSet:
      return (n, sum - n)

func threeSum(numbers: openArray[int], sum: int): (int, int, int) =
  let numberSet = numbers.toHashSet
  for i in 0..<numbers.len:
    for j in i..<numbers.len:
      let
        x = numbers[i]
        y = numbers[j]
        target = sum - x - y
      if target in numberSet:
        return (x, y, target)


let input = "input"
let f = open(input)
let numbers = collect:
  for line in f.lines:
    line.parseInt

let (x, y) = numbers.twoSum(2020)
echo fmt"{x} * {y} = {x*y}"

let (a, b, c) = numbers.threeSum(2020)
echo fmt"{a} * {b} * {c} = {a*b*c}"
