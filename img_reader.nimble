# Package

version       = "0.1.0"
author        = "ganderzz"
description   = "A new awesome nimble package"
license       = "MIT"
srcDir        = "src"
bin           = @["img_reader"]

task run, "builds and runs":
  exec "nim c --outdir=build -r src/img_reader.nim"

# Dependencies

requires "nim >= 0.20.2"
