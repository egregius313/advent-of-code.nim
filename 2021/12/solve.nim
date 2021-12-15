import tables, sets, strutils

type
  Vertex = string
  Graph = object
    edges: Table[Vertex, HashSet[Vertex]]

  Rule = enum
    OnlyOnce, OneTwice

  Seen = object
    rule: Rule
    seen: HashSet[Vertex]
    seenTwice: Vertex

const
  unseen: Vertex = ""
  start: Vertex = "start"

proc initGraph(g: var Graph) =
  g.edges = initTable[Vertex, HashSet[Vertex]]()

proc add_vertex(g: var Graph; v: Vertex) =
  if not g.edges.hasKey(v):
    g.edges[v] = initHashSet[Vertex]()

func isSmall(v: Vertex): bool = v[0] in 'a'..'z'

proc add_edge(g: var Graph; src, dst: Vertex) =
  g.add_vertex src
  g.add_vertex dst

  g.edges[src].incl dst
  g.edges[dst].incl src

proc initSeen(rule: Rule): Seen =
  result.rule = rule
  result.seen = initHashSet[Vertex]()
  result.seenTwice = unseen

proc see(seen: var Seen, v: Vertex): bool {.inline.} =
  if not v.isSmall:
    return true
  elif v notin seen.seen:
    seen.seen.incl v
    return true
  # Seen at least once:
  elif v == start:
    return false
  elif seen.rule == OneTwice and seen.seenTwice == unseen:
    seen.seenTwice = v
    return true

  return false

proc unsee(seen: var Seen, v: Vertex) {.inline.} =
  if seen.seenTwice == v:
    seen.seenTwice = unseen
  elif v in seen.seen:
    seen.seen.excl v

proc find_paths_impl(g: Graph; src, dst: Vertex; seen: var Seen; path: var seq[Vertex]): int =
  if src == dst:
    return 1

  var sum = 0
  path.add src
  for next in g.edges[src]:
    if seen.see(src):
      sum += g.find_paths_impl(next, dst, seen, path)
      seen.unsee src
  discard path.pop

  return sum

proc find_paths(g: var Graph; src, dst: Vertex, rule: Rule): int =
  var
    seen = initSeen(rule)
    path = newSeq[Vertex]()

  return find_paths_impl(g, src, dst, seen, path)

proc readGraph(f: File): Graph =
  result.initGraph

  for line in f.lines:
    let
      src_dst = line.split('-')
      src = src_dst[0]
      dst = src_dst[1]
    result.add_edge(src, dst)

let
  input = "input"
  f = open(input)

var
  g = readGraph(f)

echo g
echo g.find_paths("start", "end", OnlyOnce)
echo "---------------------------------------------------"
echo g.find_paths("start", "end", OneTwice)
