import strutils, sequtils, sugar, options

type
  FormatType = enum
    ftBitMap = "P1"
    ftGrayMap = "P2"
    ftPixMap = "P3"

  Image = ref object
    width: int
    height: int
    data: seq[seq[int]]
    case format: FormatType
    of ftBitMap:
      discard
    of ftGrayMap:
      maxWhiteColor: int
    of ftPixMap:
      maxColorValue: int

method `$`(img: Image): string {.base.} =
  return "Image [$#]: $#x$#" % [$img.format, $img.width, $img.height]

method readDimensions(img: Image, line: string): void {.base.} =
  let splitRow = line.splitWhitespace()

  img.width = parseInt(splitRow[0])
  img.height = parseInt(splitRow[1])

method readMaxColorValue(img: Image, line: string): void {.base.} =
  if img.format == FormatType.ftGrayMap:
    img.maxWhiteColor = parseInt(line)
  if img.format == FormatType.ftPixMap:
    img.maxColorValue = parseInt(line)

proc fileToImage*(input: TaintedString): Image =
  ## Converts file input (as string) to an Image object.

  # split input by lines, and remove any comments
  let splitLines = input.splitLines().filter(p => not p.startsWith('#'))

  if splitLines.len() < 2:
    raise newException(ValueError, "Invalid image header length.")

  result = Image(format: parseEnum[FormatType](splitLines[0]))

  # second line should be the image width x height
  result.readDimensions(splitLines[1])
  result.data = newSeqWith(result.width, newSeq[int](result.height))

  # third line is max color value for p2 and p3
  result.readMaxColorValue(splitLines[2])

  for index in 3..splitLines.high:
    let row = splitLines[index]
    let splitRow = row.splitWhitespace()

    if len(splitRow) > result.width:
      raise newException(ValueError, "Row [$#] has an invalid width $#, expecting [$#]" %
          [$index, $len(splitRow), $result.width])

    result.data[index - 3].add(splitRow.map(parseInt))

when isMainModule:
  var fileContents = readFile("./test.pgm")

  let img = fileToImage(fileContents)
  echo $img
  echo $img.data

