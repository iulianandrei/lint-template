module.exports = {
  "*.{css,scss}": ["stylelint --fix", "prettier --config .prettierrc --write"],
  "*.{js,ts,jsx,tsx}": ["eslint --fix --max-warnings=0", "prettier --config .prettierrc --write"],
  "*.md": "prettier --config .prettierrc --write",
};
