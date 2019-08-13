import strutils, sequtils, sugar

type
  FormatType = enum
    ftBitMap = "P1"
    ftGrayMap = "P2"
    ftPixMap = "P3"

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

method `$`(img: Image): string {.base.} =
  return "Image [$#]: $#x$#" % [$img.format, $img.width, $img.height]

proc fileToImage(input: TaintedString): Image =
  ## Converts file input (as string) to an Image object.

  # split input by lines, and remove any comments
  let splitLines = input.splitLines().filter(p => not p.startsWith('#'))

  for index in 0..splitLines.high:
    let row = splitLines[index]

    if index == 0:
      # first line should be the image format type
      result = Image(format: parseEnum[FormatType](row))

    if index == 1:
      # second line should be the image width x height
      let splitRow = row.split(' ')

      result.width = (uint16)parseUInt(splitRow[0])
      result.height = (uint16)parseUInt(splitRow[1])

when isMainModule:
  var fileContents = readFile("./test.pgm")

  let img = fileToImage(fileContents)
  echo $img

