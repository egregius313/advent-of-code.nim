import parseutils, sequtils, strutils, math


const
  BoardHeight = 5
  BoardWidth = 5

type
  Roll = seq[int]
  Board = object
    data: array[BoardHeight, array[BoardWidth, int]]
    state: array[BoardHeight, array[BoardWidth, bool]]

func wins(b: Board): bool {.inline.} =
  for i in 0..<BoardHeight:
    if allIt(0..<BoardWidth, b.state[i][it]):
      return true
  for i in 0..<BoardHeight:
    if allIt(0..<BoardWidth, b.state[it][i]):
      return true

func add(b: var Board; value: int) =
  for i in 0..<BoardHeight:
    for j in 0..<BoardWidth:
      if b.data[i][j] == value:
        b.state[i][j] = true
        return

iterator unmarked(b: Board): int =
  for i in 0..<BoardHeight:
    for j in 0..<BoardWidth:
      if not b.state[i][j]:
        yield b.data[i][j]

func readBoard(lines: seq[string], start: int): Board =
  for i in 0..<BoardHeight:
    let values = lines[start + i].splitWhitespace.map(parseInt)
    for j in 0..<BoardWidth:
      result.data[i][j] = values[j]

func parseRoll(line: string): Roll = line.split(',').map(parseInt).Roll

func whenWins(b: var Board, roll: Roll): int =
  result = -1
  for i, value in roll:
    b.add(value)
    if b.wins:
      result = i
      break

func winnerLoser(boards: var openArray[Board], roll: Roll): tuple[
    winner: tuple[value: int, board: Board],
    loser: tuple[value: int, board: Board]] =
  var
    minWin = high(int)
    winningIndex = -1
    winningValue = -1

    maxWin = low(int)
    losingIndex = -1
    losingValue = -1

  for i in 0..<boards.len:
    let whenWin = boards[i].whenWins roll
    if whenWin < minWin:
      minWin = whenWin
      winningIndex = i
      winningValue = roll[whenWin]

    if whenWin > maxWin:
      maxWin = whenWin
      losingIndex = i
      losingValue = roll[whenWin]

  result = (winner: (value: winningValue, board: boards[winningIndex]),
            loser: (value: losingValue, board: boards[losingIndex]))

func score(b: Board): int = b.unmarked.toSeq.sum

let
  input = "input"
  f = open(input)
  inputLines = f.lines.toSeq

var
  roll: Roll = parseRoll(inputLines[0])
  boards: seq[Board] = @[]

for i in countup(2, inputLines.len, BoardHeight + 1):
  boards.add readBoard(inputLines, i)

let
  (winner, loser) = boards.winnerLoser roll
  (w_win, b_win) = winner
  (w_lose, b_lose) = loser

echo "Challenge #1 ", w_win * b_win.score
echo w_lose, " ", b_lose
echo "Challenge #2 ", w_lose * b_lose.score
