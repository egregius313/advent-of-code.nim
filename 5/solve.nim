import strutils, sequtils, strformat

type
  Point = tuple
    x: int
    y: int

  Line = tuple
    src: Point
    dst: Point

  Plane = array[1024, array[1024, int]]

func `$`(p: Point): string = fmt"{p.x}, {p.y}"
func `$`(line: Line): string = fmt"{line.src} -> {line.dst}"

func is_horizontal(l: Line): bool =
  ## Whether a line is horizontal
  result = l.src.y == l.dst.y

func is_vertical(l: Line): bool =
  ## Whether a line is vertical
  result = l.src.x == l.dst.x

func is_diagonal(l: Line): bool = abs(l.src.x - l.dst.x) == abs(l.src.y - l.dst.y)

iterator points(line: Line): Point =
  let
    dy = cmp(line.dst.y, line.src.y)
    dx = cmp(line.dst.x, line.src.x)
  var
    x = line.src.x
    y = line.src.y
    done = false
  while true:
    yield (x, y)
    if done:
      break
    x += dx
    y += dy
    done = (x == line.dst.x and y == line.dst.y)

func parsePoint(s: string): Point =
  let ints = s.split(',').map(parseInt)
  return (x: ints[0], y: ints[1])

func parseLine(s: string): Line =
  let points = s.split(" -> ").map(parsePoint)
  return (src: points[0], dst: points[1])

proc chartLines(lines: openArray[Line]): Plane =
  for line in lines:
    for point in line.points:
      result[point.y][point.x] += 1
    # if line.is_horizontal:
    #   for x in min(line.src.x, line.dst.x)..max(line.src.x, line.dst.x):
    #     result[line.src.y][x] += 1
    #     if result[line.src.y][x] > 1:
    #       echo x, line.src.y
    # if line.is_vertical:
    #   for y in min(line.src.y, line.dst.y)..max(line.src.y, line.dst.y):
    #     result[y][line.src.x] += 1
    #     if result[y][line.src.x] > 1:
    #       echo line.src.x, y

proc safePoints(pl: Plane): int =
  for i in 0..<high(pl):
    for j in 0..<high(pl[i]):
      if pl[i][j] > 1:
        result += 1

let input = "input"
let f = open(input)

let
  lines = f.lines.toSeq.map(parseLine)
  horver = lines.filter(proc (l: Line): bool = l.is_horizontal or l.is_vertical)
  hvplane = chartLines(horver)
  plane = chartLines(lines)

echo "Challenge #1: ", hvplane.safePoints
echo "Challenge #2: ", plane.safePoints
