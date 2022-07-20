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
