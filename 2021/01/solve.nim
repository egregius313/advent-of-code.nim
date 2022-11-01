import
  math,
  system/io,
  std/[sequtils, strutils]

func count_increasing*[T](s: openArray[T]): int {.inline.} =
  ## Count the number of times adjacent elements increment
  result = countIt 1..<s.len: s[it-1] < s[it]

iterator window_sums*[T](s: openArray[T]; w: int): int =
  ## Sliding window sums for windows of length `w`.
  var wsum = s[0..<w].sum
  yield wsum
  for i in w..<s.len:
    wsum -= s[i - w]
    wsum += s[i]
    yield wsum

var f = open("input")
# defer: f.close()
let values = f.lines.toSeq.map(parseInt)

echo values.count_increasing
echo values.window_sums(3).toSeq.count_increasing
