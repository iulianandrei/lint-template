# Commit hooks setup

## Intro

This document describes a series of steps to follow in order to setup git commit hooks. We will be adding the following
hooks with the respective packages attached:

1. commit-msg

   This hook will run only one package: [commit-lint](https://www.npmjs.com/package/@commitlint/cli). This helps adhere
   to [commit conventions](https://www.conventionalcommits.org/en/v1.0.0/#summary).

2. pre-commit

   This hook will run [lint-staged](https://github.com/okonet/lint-staged) on staged files. We add the following rules:

   - For CSS and SCSS files, [stylelint](https://stylelint.io/) and [prettier](https://prettier.io/) will run.
   - For JS, TS, JSX and TSX, [eslint](https://eslint.org/) and [prettier](https://prettier.io/) will run.
   - For markdown files, only [prettier](https://prettier.io/) will run.

## Script

There is a setup bash script included in this repo which takes all the necessary steps automatically. It can be useful
for setting up a new project, but it will replace existing files on an existing project, if it uses configuration files
needed for the packages. Even though it includes warning and confirmation steps, you should read the script and use it
at your own risk.

## Steps

Assuming an npm project already exists (run `npm init` if not) and a git repository was already initialized (run
`git init` if not), here are the steps to follow to setup the project:

### 1. Install all necessary packages as development dependencies:

```
npm i -D \
husky \
lint-staged \
@commitlint/cli @commitlint/config-conventional \
prettier \
stylelint stylelint-scss stylelint-config-standard stylelint-config-prettier stylelint-config-standard-scss \
eslint eslint-config-prettier \
@typescript-eslint/eslint-plugin @typescript-eslint/parser
```

### 2. Setup husky

We need to create a ["prepare" npm script](https://docs.npmjs.com/cli/v8/using-npm/scripts#life-cycle-scripts) so that
husky is installed and the hooks are set in place for any developer the clones the repo locally.

```
npm set-script prepare "husky install"
```

> Note: if youalready have an npm "prepare" script, add `husky install` to the chain of commands.

Then, run the script locally:

```
npm run prepare
```

### 3. Add git hooks with husky

#### Commit Message Hook

```
npx husky add .husky/commit-msg "npx --no -- commitlint --edit $1"
```

#### Pre-commit hook

```
npx husky add .husky/pre-commit "npx lint-staged --config lint-staged.config.js"
```

### 4. Add configuration files for all packages that need them

Here are just some example configurations that can be used as defaults. Adapt them according to needs and preferences.

#### Commit lint

Create a `commitlint.config.js` file with the following content:

```
module.exports = {
  extends: ["@commitlint/config-conventional"],
  rules: {
    "header-max-length": [0, "always", 140],
  },
};
```

#### Lint-staged

Create a `lint-staged.config.js` file with the following content:

```
module.exports = {
  "*.{css,scss}": ["stylelint --fix", "prettier --config .prettierrc --write"],
  "*.{js,ts,jsx,tsx}": ["eslint --fix --max-warnings=0", "prettier --config .prettierrc --write"],
  "*.md": "prettier --config .prettierrc --write",
};
```

#### Prettier

Create a `.prettierrc` file with the following content:

```
{
  "printWidth": 120,

  "useTabs": false,
  "tabWidth": 2,

  "semi": true,
  "singleQuote": false,
  "jsxSingleQuote": false,
  "arrowParens": "always",

  "bracketSameLine": false,
  "bracketSpacing": true,

  "endOfLine": "lf",

  "htmlWhitespaceSensitivity": "css",
  "proseWrap": "always",
  "quoteProps": "as-needed",

  "trailingComma": "es5"
}
```

#### Eslint

Create a `.eslintrc` file with the following content:

```
{
  "env": {
    "es2021": true,
    "browser": true,
    "node": true
  },
  // It is important that "prettier" is last
  "extends": ["eslint:recommended", "plugin:@typescript-eslint/recommended", "prettier"],
  "parser": "@typescript-eslint/parser",
  "parserOptions": {
    "ecmaVersion": "latest",
    "sourceType": "module"
  },
  "plugins": ["@typescript-eslint"],
  "rules": {}
}
```

> Note: change the `env` field according to needs.

#### Stylelint

Create a `stylelint.config.js` file with the following content:

```
module.exports = {
  extends: ["stylelint-config-standard-scss", "stylelint-config-prettier"],
  rules: {
    "selector-class-pattern": "[A-Za-z]+[A-Za-z_-]*",
    "selector-pseudo-class-no-unknown": [
      true,
      {
        ignorePseudoClasses: ["global", "export"],
      },
    ],
    "property-no-unknown": [
      true,
      {
        ignoreSelectors: [":export"],
      },
    ],
  },
};
```
