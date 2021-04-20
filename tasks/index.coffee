import * as t from "@dashkite/genie"
import * as b from "@dashkite/masonry"
import {coffee} from "@dashkite/masonry/coffee"
import * as q from "panda-quill"

t.define "clean", -> q.rmr "build"

t.define "build", "clean", b.start [
  b.glob [ "{src,test}/**/*.coffee" ], "."
  b.read
  b.tr coffee target: "node"
  b.extension ".js"
  b.write "build"
]

t.define "test", "build", ->
  b.node "build/test/index.js", [ "--enable-source.maps" ]
