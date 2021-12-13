import tables, sequtils

type
  DisjointSet* = seq[int]

proc initDisjointSet*(s: var DisjointSet, length: int) =
  s.newSeq length
  for i in 0..<length:
    s[i] = i

func initDisjointSet*(length: int): DisjointSet =
  result.initDisjointSet(length)

func root*(ds: DisjointSet, i: int): int =
  var p = ds[i]
  while p != ds[p]:
    p = ds[p]
  # ds[i] = p
  return p

proc join*(ds: var DisjointSet; i, j: int) =
  let
    pi = ds.root i
    pj = ds.root j
    p = min(pi, pj)

  ds[i] = p
  ds[j] = p
  ds[pi] = p
  ds[pj] = p


func count_sets*(ds: DisjointSet): CountTable[int] = ds.mapIt(ds.root(it)).toCountTable
