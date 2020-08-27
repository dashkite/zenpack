# zenpack

Combinators for configuring and running webpack.

Easily create functions that encapsulate base configurations:

```coffeescript
import * as w from "@dashkite/zenpack"

# base webpack bundle
bundle = (source, build) ->
  pipe [
    w.config source, build
    w.mainField "main:coffee"
    w.extension ".coffee"
    w.rule
      test: /.coffee$/
      loader: "coffee-loader"
    w.rule
      test: /.pug$/
      loader: "pug-loader"
      options: filters: {markdown}
  ]
```

… and then extend them in build tasks:

```coffeescript
define "build:development", pipe [
  bundle source, build
  w.mode "development"
  w.sourcemaps
  w.run
]

define "build:production", pipe [
  bundle source, build
  w.mode "production"
  w.run  
]
```

## Installation

```
npm i -D @dashkite/zenpack
```

## API

### Combinators

#### config *source*, *build*

Returns a function that will create a default Webpack configuration.

#### mode *name*

Set the mode for the configuration, usually _development_ or _production_.

#### target *name*

Set the Webpack build target, ex: _web_.

#### node *value*

Set the `node` configuration option.

#### nodeEnv *value*

Explicitly set the NODE_ENV environment variable.

#### entry *path*

Set the Webpack entry point.

#### path *path*

Set the Webpack output path.

#### libraryTarget *target*

Set the Webpack output library target, ex: `umd`.

#### rule *description*

Add a loader rule.

#### extension *file-extension*

Add a file extension. Prepends the given extension to the `extensions` configuration value.

#### sourcemaps

Add support for inline source-maps.

#### mainField *name*

Add a field name for resolving module entry points. Prepends the given name to the `mainFields` configuration value.

#### alias *dictionary*

Adds a dictionary of aliases for module resolution.

#### run

Runs Webpack with the resulting configuration.
