_An experimental documentation convention for EOSIO based repositories. Not suitable for production integration, hard-coded configurations are present._

# Docs: CPP
For implementing EOSIO Docs with CPP

# Dependencies
- NPM/Nodejs
- Doxygen
- [Doxybook](https://github.com/dskvr/doxybook)

# Quickstart
Open terminal and CD to the root directory of your project.
```bash
cd ./path/to/project
```

## Add submodule
```bash
git submodule add https://github.com/EOSIO/util-docs-cpp.git .docs
```

## Add scripts to project's `package.json`
```json
...
"scripts" : {
  ...
  "docs:init": "sh .docs/scripts/init.sh",
  "docs:build": "sh .docs/scripts/build.sh",
  "docs:serve": "sh .docs/scripts/serve.sh",
  "docs:publish": "sh .docs/scripts/publish.sh",
},
...
```

### Add eosio.doc.json

In the root of your project, modify **name, target, module** as needed.
```
{
  "project": "nameofrepository"
}
```

### Add Doxyfile to root directory of project

Set the following
- `GENERATE_XML=TRUE`
- `GENERATE_HTML=FALSE`

Additional configurations may need to be made to produce the output you desire, such as setting Doxygen variables for source directories, inclusion/exclusion rules and documentation parameters.

## Install

```bash
npm run docs-init
```
_injects gitbook dependencies into project_


## build
Build. Will use `git describe` to derive the most recent tag associated with the branch, and place the generated documentation files into `./docs/history/3.2.1`

```bash
npm run docs:build
```

## serve locally
```bash
npm run docs:serve
```

# Conventions

## docs Filesystem Convention (strict)
- A `./static` directory can contain markdown files for tutorials, etc. Using numbers and capitalization can be used to control presentation. For example `1.-Hello-World.md`. There is presently no support for subdirectories.
- `./docs/build` directory will be created by build scripts.
- Compliance is easiest when location of source code is `./src`

```
/project
  package.json
  /static
  /tmp
```

## Typescript Versioning
* `TypeScript >= 2.9.1 use TypeDoc ^0.12.0` _default_ |
* `TypeScript <= 2.9.0 use TypeDoc < 0.12.0 ` |

## Doc Scripts

Execute these commands from the root directory of your project.

## AutoRun: Install, Build & Serve
```
npm run docs
```

## install
```
npm run docs-install
```

## Build
```
npm run docs-build
```

## Serve docs Locally
```
npm run docs-serve
```

# Todo
- Convert Bash setup scripts to JS or GO
- `npm` package
- Standardize a `eosio.book.json` (Typedoc and gitbook default overwrides)
- `eosbook init` (replaces `npm run docs-install` and adds scaffolding)
- Remove Submodule dependencies
- Standardize language support.
- Implement multi-book for suite releases.
