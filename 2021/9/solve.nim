import sequtils, sugar, tables, math
import disjoint_sets

type
  Grid[T] = seq[seq[T]]

func height[T](grid: Grid[T]): int {.inline.} = grid.len
func width[T](grid: Grid[T]): int {.inline.} = grid[0].len
func size[T](grid: Grid[T]): int {.inline.} = grid.height * grid.width

func in_bounds[T](grid: Grid[T]; h, w: int): bool {.inline.} =
  return h in 0..<grid.height and w in 0..<grid.width

iterator neighbors[T](grid: Grid[T]; h, w: int): tuple[y: int, x: int, value: T] =
  for dy, dx in [(-1, 0), (1, 0), (0, -1), (0, 1)].items:
    if grid.in_bounds((h + dy), (w + dx)):
      yield (h + dy, w + dx, grid[h + dy][w + dx])

iterator low_points[T](grid: Grid[T]): T =
  for h in 0..<grid.len:
    for w in 0..<grid[0].len:
      let v = grid[h][w]
      let ns = neighbors(grid, h, w).toSeq
      if ns.allIt(it.value > v):
        yield v

func riskLevel(point: int): int = point + 1

proc toSets[T](grid: Grid[T]): DisjointSet =
  result.initDisjointSet(grid.size + 1)

  let width = grid.width
  for h, row in grid:
    for w, col in row:
      if grid[h][w] == 9:
        result[h * width + w] = grid.size
      else:
        for (y, x, n) in grid.neighbors(h, w):
          if n != 9:
            result.join(h * width + w, y * width + x)

proc readGrid[T](f: File): Grid[T] =
  for line in f.lines:
    let values = collect(for c in line: ord(c) - ord('0'))
    result.add values

proc top3(table: CountTable[int], length: int): (int, int, int) =
  var
    ct = table
    elems = newSeq[int]()
  sort ct
  for k, v in ct.pairs:
    if elems.len == 3:
      break
    if k == length:
      continue
    elems.add v

  result = (elems[0], elems[1], elems[2])

let
  input = "input"
  f = open(input)
  grid = readGrid[int](f)
  sets = grid.toSets

# Total sum of risk levels of all low points
echo "Sum ", grid.low_points.toSeq.map(riskLevel).sum

let counts = sets.count_sets
let (ta, tb, tc) = counts.top3 grid.size
echo ta * tb * tc
