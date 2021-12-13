import tables, math, sequtils, sugar, algorithm

const
  openers = {
    '(', '[', '{', '<'
  }

  closers = {
    ')', ']', '}', '>'
  }

  opener = {
    ')': '(',
    ']': '[',
    '}': '{',
    '>': '<'
  }.toTable

  miss_values = {
    ')': 3,
    ']': 57,
    '}': 1197,
    '>': 25137,
  }.toTable

  autocomplete_values = {
    '(': 1,
    '[': 2,
    '{': 3,
    '<': 4,
  }.toTable

func miss_or_autocomplete(s: string): tuple[miss: char, score: int] =
  var stack = newSeq[char]()

  for c in s:
    if c in openers:
      stack.add c
    elif c in closers:
      if stack[^1] == opener[c]:
        discard stack.pop
      else:
        return (miss: c, score: -1)

  while stack.len > 0:
    result.score *= 5
    result.score += autocomplete_values[stack.pop]

let
  input = "input"
  f = open(input)
  patterns = f.lines.toSeq

var
  missing_score = 0
  autocomplete_scores = newSeq[int]()

for pattern in patterns:
  let (missing, auto_score) = pattern.miss_or_autocomplete
  echo pattern.miss_or_autocomplete
  if missing in closers:
    missing_score += miss_values[missing]
  else:
    autocomplete_scores.add auto_score

sort autocomplete_scores

echo missing_score
echo autocomplete_scores[autocomplete_scores.len div 2]
