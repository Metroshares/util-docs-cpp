_An experimental documentation convention for EOSIO based repositories. Not suitable for production integration, hard-coded configurations present._

# Docs: Typescript
For implementing EOSIO Docs with Typescript.

# Quickstart
Open terminal and CD to the root directory of your project.
```bash
cd ./path/to/project
```

## Add submodule
```bash
git submodule add https://github.com/EOSIO/util-docs-ts.git .docs
```

## Add scripts to project's `package.json`
```json
...
"scripts" : {
  ...
  "docs-build": "sh .docs/scripts/build.sh",
  "docs-serve": "sh .docs/scripts/serve.sh",
  "docs-init": "sh .docs/scripts/init.sh"
},
...
```

### Add typedoc.json

In the root of your project, modify **name, target, module** as needed.
```
{
  "name": "myproject",
  "target": "es5",
  "module": ["es2017","dom"],
  "ignoreCompilerErrors": true,
  "includeDeclarations": false,
  "excludeProtected": true,
  "excludePrivate": true,
  "mode": "modules",
  "out": "docs/build",
  "theme": "markdown",
  "mdEngine": "gitbook",
  "stripExternal": false,
  "exclude": ["**/index*","**/*.test.ts"],
  "readme": "README.md",
  "hideGenerator": "true",
  "verbose": true,
  "mdSourceRepo": "https://www.github.com/EOSIO/eosjs2"
}
```

## Install

If on TypeScript >= 2.9.1

```bash
npm run docs-init
```
_this installs typedoc packages and npm installs the submodule._

If on TypeScript <= 2.9.0

_Presently only support TypeScript 2.9.1+_

## build
Build. The previous build will be deleted and replaced
```bash
npm run docs-build
```

## serve locally
Requires python
```bash
npm run docs-serve
```

# Conventions

## docs Filesystem Convention (strict)
- A `./docs` should contain markdown files. Using numbers and capitalization is suggested to control presentation. For example `1.-Hello-World.md`;
- `./docs/build` directory will be created by build scripts.
- Compliance is easiest when location of source code is `./src`

```
/project
  package.json
  /docs
    /static
    /build
  /src
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
