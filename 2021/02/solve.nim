import
  std/[strutils, sequtils],
  system/io

type
  Direction = enum
    dForward = "forward", dUp = "up", dDown = "down"

proc final_position(f: string): tuple[depth: int, length: int] =
  var
    depth = 0
    length = 0
  let fp = open(f, fmRead)
  defer: fp.close()
  for line in fp.lines:
    let parts = line.splitWhitespace
    let direction: Direction = parseEnum[Direction](parts[0])
    let magnitude = parts[1].parseInt
    case direction
    of dForward:
      length += magnitude
    of dUp:
      depth -= magnitude
    of dDown:
      depth += magnitude

  result = (depth: depth, length: length)

proc final_position_2(f: string): tuple[depth: int, length: int] =
  var
    depth = 0
    length = 0
    aim = 0
  let fp = open(f, fmRead)
  defer: fp.close()
  for line in fp.lines:
    let parts = line.splitWhitespace
    let direction: Direction = parseEnum[Direction](parts[0])
    let magnitude = parts[1].parseInt
    case direction
    of dForward:
      length += magnitude
      depth += aim * magnitude
    of dUp:
      aim -= magnitude
    of dDown:
      aim += magnitude

  result = (depth: depth, length: length)


let pos = final_position("input")
echo pos.depth * pos.length
let pos2 = final_position_2("input")
echo pos2.depth * pos2.length
