#!/bin/bash

printf '1. This step will install the next npm packages:
--------------------------------
@commitlint/cli
@commitlint/config-conventional
@typescript-eslint/eslint-plugin
@typescript-eslint/parser
eslint
eslint-config-prettier
husky
lint-staged
prettier
stylelint
stylelint-scss
stylelint-config-standard
stylelint-config-prettier
stylelint-config-standard-scss
--------------------------------
'
printf "\nDo you wish to continue?\n"
select yn in "Yes" "No";
do
    case $yn in
        Yes ) break;;
        No ) exit;;
    esac
done

# Install deps
npm i -D \
husky \
lint-staged \
@commitlint/cli @commitlint/config-conventional \
prettier \
stylelint stylelint-scss stylelint-config-standard stylelint-config-prettier stylelint-config-standard-scss \
eslint eslint-config-prettier @typescript-eslint/eslint-plugin @typescript-eslint/parser


printf "\n\n"
printf '2. This step will set husky up and it will REPLACE the following files:

--------------------------------
.eslintrc
.prettierrc
commitlint.config.js
lint-staged.config.js
stylelint.config.js
--------------------------------
'

printf "\nDo you wish to continue?\n"
select yn in "Yes" "No";
do
    case $yn in
        Yes ) break;;
        No ) exit;;
    esac
done

# Set husky up
npm set-script prepare "husky install"
npm run prepare


# Add git commit-msg hook which runs commitlint
npx husky add .husky/commit-msg "npx --no -- commitlint --edit $1"
echo 'module.exports = {
  extends: ["@commitlint/config-conventional"],
  rules: {
    "header-max-length": [0, "always", 140],
  },
};
' > commitlint.config.js


# Add git pre-commit hook which runs lintstaged
npx husky add .husky/pre-commit "npx lint-staged --config lint-staged.config.js"
echo 'module.exports = {
  "*.{css,scss}": ["stylelint --fix", "prettier --config .prettierrc --write"],
  "*.{js,ts,jsx,tsx}": ["eslint --fix --max-warnings=0", "prettier --config .prettierrc --write"],
  "*.md": "prettier --config .prettierrc --write",
};

' > lint-staged.config.js

# Add prettier config
echo '{
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
}' > .prettierrc

# Add stylint config
echo 'module.exports = {
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
' > stylelint.config.js

# Add stylint eslint config
echo '{
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
' > .eslintrc