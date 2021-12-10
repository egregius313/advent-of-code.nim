import algorithm,  strutils, sequtils, sugar, math, stats

#   0:      1:      2:      3:      4:
#  aaaa    ....    aaaa    aaaa    ....
# b    c  .    c  .    c  .    c  b    c
# b    c  .    c  .    c  .    c  b    c
#  ....    ....    dddd    dddd    dddd
# e    f  .    f  e    .  .    f  .    f
# e    f  .    f  e    .  .    f  .    f
#  gggg    ....    gggg    gggg    ....
#
#   5:      6:      7:      8:      9:
#  aaaa    aaaa    aaaa    aaaa    aaaa
# b    .  b    .  .    c  b    c  b    c
# b    .  b    .  .    c  b    c  b    c
#  dddd    dddd    ....    dddd    dddd
# .    f  e    f  .    f  e    f  .    f
# .    f  e    f  .    f  e    f  .    f
#  gggg    gggg    ....    gggg    gggg

type
  SignalPattern = string
  PatternLength = int

  ProbMatrix = array['a'..'g', array['a'..'g', float]]

  Translation = array['a'..'g', char]

func mean[I, T](arrays: openArray[array[I, T]]): array[I, T] =
  ## The mean of each column in a sequence of arrays.
  if arrays.len == 0:
    for i in low(result)..high(result):
      result[i] = 0.0
  else:
    for i in low(result)..high(result):
      result[i] = arrays.mapIt(it[i]).mean

func build_prob(placement: SignalPattern): array['a'..'g', float] =
  let prob = 1/placement.len
  for c in placement:
    result[c] = prob

func build_prob(placements: openArray[SignalPattern]): array[0..9, array['a'..'g', float]] =
  ## Build the default probability for each length

  # Generate the probability rows and group by placement length
  var by_length = newSeq[seq[array['a'..'g', float]]](result.len)
  for placement in placements:
    by_length[placement.len].add placement.build_prob

  for i in low(result)..high(result):
    result[i] = by_length[i].mean

const
  placements = [
    "abcefg",
    "cf",
    "acdeg",
    "acdfg",
    "bcdf",
    "abdfg",
    "abdefg",
    "acf",
    "abcdefg",
    "abcdfg"
  ]
  ndigits = collect(for placement in placements: placement.len)
  probs = placements.build_prob

# echo "#digits ", ndigits
# echo "Probs ", probs

proc toProbMatrix(patterns: seq[SignalPattern]): ProbMatrix =
  for pattern in patterns:
    let prob = probs[pattern.len]
    for c in pattern:
      for i in 'a'..'g':
        result[c][i] += prob[i]

func toTranslation(pm: ProbMatrix): Translation =
  var
    source_seen: set[char] = {}
    dest_seen: set[char] = {}
    i = 0

  let
    with_weight = collect:
      for source in 'a'..'g':
        for dest in 'a'..'g':
          let weight = pm[source][dest]
          (weight: weight, source: source, destination: dest)
    by_weight = sorted(with_weight, order=SortOrder.Descending)

  while source_seen.len < 7:
    while by_weight[i].source in source_seen or by_weight[i].destination in dest_seen:
      i += 1
    let (_, source, destination) = by_weight[i]
    result[source] = destination
    source_seen.incl source
    dest_seen.incl destination

func readInput(line: string): tuple[patterns: seq[SignalPattern], output: seq[SignalPattern]] =
  let parts = line.split(" | ")
  return (
    patterns: parts[0].split(' '),
    output: parts[1].split(' ')
  )

func translate(t: Translation, s: SignalPattern): int =
  let key = s.mapIt(t[it]).sorted.join ""
  for i in 0..9:
    if placements[i] == key:
      return i

func translate(t: Translation, readings: openArray[SignalPattern]): int =
  for reading in readings:
    result *= 10
    result += t.translate reading

# echo [1,4,7,8].mapIt(ndigits[it])

proc is1478(pattern: SignalPattern): bool = pattern.len in [1,4,7,8].mapIt(ndigits[it])

let
  input = "input"
  f = open(input)

let input_output =  f.lines.toSeq.map(readInput)

echo input_output.mapIt(it.output).mapIt(it.filter(pat => pat.is1478).len).sum

let total = sum:
  collect:
    for line in input_output:
      let
        pm = line.patterns.toProbMatrix
        t = pm.toTranslation
      t.translate line.output
echo total
