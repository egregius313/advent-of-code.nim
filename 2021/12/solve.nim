import tables, sets, strutils, strformat

type
  Vertex = string
  Graph = object
    edges: Table[Vertex, HashSet[Vertex]]

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

proc find_paths_impl(g: var Graph; src, dst: Vertex; seen: var HashSet[Vertex]; path: var seq[Vertex]): int =
  if src == dst:
    return 1

  var sum = 0
  path.add src
  for next in g.edges[src]:
    if next.isSmall and next in seen:
      continue

    seen.incl src
    sum += g.find_paths_impl(next, dst, seen, path)
    seen.excl src
  discard path.pop

  return sum

proc find_paths(g: var Graph; src, dst: Vertex): int =
  var
    seen = initHashSet[Vertex]()
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
echo g.find_paths("start", "end")
