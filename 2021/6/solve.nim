import sequtils, strutils, math

type
  LanternFish = int
  School = array[0..8, int]

func toSchool(fish: seq[LanternFish]): School =
  for f in fish:
    result[f] += 1

proc next_generation(school: School): School {.inline.} =
  result[6] = school[0]
  result[8] = school[0]
  for i in 1..8:
    result[i - 1] += school[i]

proc after_generations(school: School, ngen: int): School =
  result = school
  for gen in 1..ngen:
    result = next_generation result

let
  input = "input"
  f = open(input)
  fish = readLine(f).split(',').map(parseInt)

echo fish.toSchool.after_generations(80).sum
echo fish.toSchool.after_generations(256).sum
