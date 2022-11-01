import
  std/[parseutils, strutils, strformat],
  std/sequtils,
  std/sets

type
  Interpreter = tuple
    value: int
    position: int
    tape: seq[Instruction]

  InstructionType = enum
    nop, acc, jmp

  Instruction = tuple
    itype: InstructionType
    arg: int

  EndState = enum
    unknown, loop, terminate

func initInterpreter(tape: seq[Instruction]): Interpreter =
  ## Create a new interpreter
  return (value: 0, position: 0, tape: tape)

proc restart(i: var Interpreter) =
  i.position = 0
  i.value = 0

proc execute(i: var Interpreter) =
  let ins = i.tape[i.position]
  case ins.itype
  of nop:
     i.position += 1
  of acc:
     i.value += ins.arg
     i.position += 1
  of jmp:
     i.position += ins.arg

proc executeUntilLoop(i: var Interpreter): EndState =
  var seen = initHashSet[int]()
  while true:
    if i.position in seen:
      return loop
    if i.position >= i.tape.len:
      return terminate
    seen.incl i.position
    execute(i)

proc trySwapping(i: var Interpreter): int =
  for idx, instruction in i.tape.pairs:
    restart i
    case instruction.itype
    of nop:
      i.tape[idx].itype = jmp
      if i.executeUntilLoop == terminate:
        return i.value
      else:
        i.tape[idx].itype = nop
    of jmp:
      i.tape[idx].itype = nop
      if executeUntilLoop(i) == terminate:
        return i.value
      else:
        i.tape[idx].itype = jmp
    of acc:
      continue
    
func parseInstruction(s: string): Instruction =
  let parts = s.split(' ')
  let itype = parseEnum[InstructionType](parts[0])
  let arg = parseInt(parts[1])
  return (itype, arg)

let
  input = "input"
  f = open(input)
  instructions = f.lines.toSeq.map(parseInstruction)

var interpreter = initInterpreter(instructions)

discard interpreter.executeUntilLoop()
echo interpreter.value

restart interpreter
echo interpreter.trySwapping
