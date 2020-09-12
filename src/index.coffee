import Path from "path"
import webpack from "webpack"
import {curry, tee, rtee} from "@pandastrike/garden"
import {write} from "panda-quill"

config = (source, build) ->
  ->
    target: "web"
    entry: application: Path.join source, "index.coffee"
    resolve:
      mainFiles: [ "index" ]
      mainFields: [ "browser", "module", "main" ]
      extensions: [ ".js" ]
      modules: [ "node_modules" ]
    output:
      path: build
      filename: "[name].js"

mode = curry rtee (name, config) -> config.mode = name

target = curry rtee (name, config) -> config.target = name

node = curry rtee (value, config) -> config.node = value

nodeEnv = curry rtee (value, config) ->
  config.optimization ?= {}
  config.optimization.nodeEnv = value

# TODO update output as well? or just use Webpack template?
entry = curry rtee (path, config) -> config.entry = path

path = curry rtee (path, config) -> config.output.path = path

libraryTarget = curry rtee (value, config) ->
  config.output.libraryTarget = value

rule = curry rtee (description, config) ->
  config.module ?= {}
  config.module.rules ?= []
  config.module.rules.push description

extension = curry rtee (name, config) ->
  config.resolve ?= {}
  config.resolve.extensions ?= []
  config.resolve.extensions.unshift name

sourcemaps = tee (config) -> config.devtool = "inline-source-map"

mainField = curry rtee (name, config) ->
  config.resolve ?= {}
  config.resolve.mainFields ?= []
  config.resolve.mainFields.unshift name

alias = curry rtee (dictionary, config) ->
  config.resolve.alias ?= {}
  for name, path of dictionary
    config.resolve.alias[name] = path

run = (config) ->
  new Promise (resolve, reject) ->
    webpack config
    .run (error, result) ->
      console.error result.toString colors: true
      if error? then reject error else resolve result

stats = (result) ->
  console.error "Writing stats data to webpack-stats.json..."
  await write "webpack-stats.json",
    JSON.stringify result.toJson(), null, 2

export {
  config
  mode
  target
  node
  nodeEnv
  entry
  path
  libraryTarget
  rule
  extension
  sourcemaps
  mainField
  alias
  run
  stats
}
