import algorithm, math, sequtils, strutils, stats

func median[T: SomeInteger](ns: openArray[T]): T =
  let
    n = ns.len
    data = sorted ns
    mid = n div 2
  if n == 0:
    raise newException(ArithmeticDefect, "Cannot get median of empty sequence.")
  elif n mod 2 == 1:
    result = data[mid]
  else:
    result = (data[mid - 1] + data[mid]) div 2

func total_fuel1(positions: openArray[int], target: int): int =
  result = positions.mapIt(abs(it - target)).sum

func triangle(n: int): int = n*(n+1) div 2

func total_fuel2(positions: openArray[int], target: int): int =
  result = positions.mapIt(abs(it - target).triangle).sum

let
  input = "input"
  f = open(input)
  positions = readLine(f).split(',').map(parseInt)
  median_target = positions.median
  mean_target = positions.mean.toInt

echo total_fuel1(positions, median_target)
echo min(positions.total_fuel2(mean_target),
         positions.total_fuel2(mean_target - 1))
