import strutils

type
  FormatType = enum
    ftBitMap  # P1
    ftGrayMap # P2
    ftPixMap  # P3

  Image = ref object
    width: uint16
    height: uint16
    data: seq[seq[uint16]]
    case format: FormatType
    of ftBitMap:
      discard
    of ftGrayMap:
      maxWhiteColor: uint16
    of ftPixMap:
      maxColorValue: uint16

proc getFormatFromString(input: string): FormatType =
  ## Figures out the format of the image based.
  if input == "P1":
    return FormatType.ftBitMap
  if input == "P2":
    return FormatType.ftGrayMap
  if input == "P3":
    return FormatType.ftPixmap

  raise newException(ObjectConversionError,
      "Could not get image format from $# (looking for: P1, P2, P3). " % [input])

proc fileToImage(input: TaintedString): Image =
  ## Converts file input (as string) to an Image object
  let splitLines = input.splitLines()

  for index in 0..splitLines.high:
    let row = splitLines[index]

    if index == 0:
      result = Image(format: getFormatFromString(row))


when isMainModule:
  var fileContents = readFile("./test.pgm")

  let img = fileToImage(fileContents)
  echo img.format

