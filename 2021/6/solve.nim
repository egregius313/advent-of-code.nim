import sequtils, strutils, math

type
  LanternFish* = int ## LanternFish are represented by their life-stage.
  School* = array[0..8, int] ## Representation of a school of lanternfish Since
                             ## lanternfish have a 9-stage lifecycle, we
                             ## represent a school of fish by 9 buckets (one per
                             ## life-stage).

func toSchool*(fish: seq[LanternFish]): School =
  ## Classify fish into their life-stages
  for f in fish:
    result[f] += 1

proc next_generation*(school: School): School {.inline.} =
  ## Calculate the next generation of a school of fish
  ##
  ## fish in state 0 go to state 6 and spawn another fish (starting in stage 8)
  ## otherwise the fish go to the next generation
  result[6] = school[0]
  result[8] = school[0]
  for i in 1..8:
    result[i - 1] += school[i]

proc after_generations*(school: School, ngen: int): School =
  ## Calculate the state of `school` after `ngen` generations.
  result = school
  for gen in 1..ngen:
    result = next_generation result

let
  input = "input"
  f = open(input)
  fish = readLine(f).split(',').map(parseInt)

echo fish.toSchool.after_generations(80).sum
echo fish.toSchool.after_generations(256).sum
