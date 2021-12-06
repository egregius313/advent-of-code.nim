import
  std/[strutils, strformat],
  std/sequtils

type
  Policy = tuple
    x, y: int
    character: char

  RangePolicy = tuple
    minimum, maximum: int
    character: char

  PositionPolicy = tuple
    x, y: int
    character: char

  Password = string

func toRangePolicy(p: Policy): RangePolicy =
  return (minimum: p.x, maximum: p.y, character: p.character)

func toPositionPolicy(p: Policy): PositionPolicy =
  return (x: p.x, y: p.y, character: p.character)

func match(p: RangePolicy, pass: Password): bool =
  let count = pass.countIt(it == p.character)
  return p.minimum <= count and count <= p.maximum

func match(p: PositionPolicy, pass: Password): bool =
  # return (p.x < pass.len and pass[p.x] == p.character) xor (p.y < pass.len and pass[p.y] == p.character)
  return pass[p.x - 1] == p.character xor pass[p.y - 1] == p.character

func parsePolicy(s: string): Policy =
  let parts = s.split(' ')
  let ints = parts[0].split('-').map(parseInt)
  return (x: ints[0], y: ints[1], character: parts[1][0])

func parseLine(line: string): (Policy, Password) =
  let parts = line.split(": ")
  return (parsePolicy(parts[0]), parts[1])

let
  input = "input"
  f = open(input)

var
  count_range = 0
  count_position = 0
for line in f.lines:
  let (policy, password) = line.parseLine
  if policy.toRangePolicy.match password:
    count_range += 1
  if policy.toPositionPolicy.match password:
    count_position += 1

echo fmt"{count_range} password(s) match by range."
echo fmt"{count_position} password(s) match by position."
