import
  std/[sequtils, parseutils, sets, sugar],
  system/io

type
  Counts = array['0'..'1', int]
  PositionCounts = array[12, Counts]

proc get_counts(lines: openArray[string]): PositionCounts =
  for line in lines:
    for i, c in pairs(line):
      result[i][c] += 1

func gamma(pc: PositionCounts): int =
  result = pc.foldl((a shl 1) + maxIndex(b), 0)

func epsilon(pc: PositionCounts): int =
  result = pc.foldl((a shl 1) + minIndex(b), 0)

func oxygen_gen(lines: seq[string]): int =
  var
    counts = lines.get_counts
    maxes = counts.mapIt(if it['0'] > it['1']: '0' else: '1')
    values = lines.toHashSet
    i = 0
    nread: int

  while values.len > 1:
    values = collect(initHashSet):
      for value in values:
        if value[i] == maxes[i]:
          {value}
    counts = values.toSeq.get_counts
    maxes = counts.mapIt(if it['0'] > it['1']: '0' else: '1')
    i += 1

  nread = values.pop.parseBin(result)

proc co2_scrubber(lines: seq[string]): int =
  var
    counts = lines.get_counts
    maxes = counts.mapIt(if it['0'] <= it['1']: '0' else: '1')
    values = lines.toHashSet
    i = 0
    nread: int

  while values.len > 1:
    values = collect(initHashSet):
      for value in values:
        if value[i] == maxes[i]:
          {value}
    counts = values.toSeq.get_counts
    maxes = counts.mapIt(if it['0'] <= it['1']: '0' else: '1')
    i += 1

  nread = values.pop.parseBin(result)

const
  input = "input"

let
  f = open(input)
  values = f.lines.toSeq
  counts = values.get_counts

echo "Challenge #1: ", counts.gamma * counts.epsilon
let
  oxy = values.oxygen_gen
  co2 = values.co2_scrubber
echo "Challenge #2: ", oxy, " * ", co2, " = ", oxy * co2
