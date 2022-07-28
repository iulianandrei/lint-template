import type { UserConfig } from "@commitlint/types";

const Configuration: UserConfig = {
  extends: ["@commitlint/config-conventional"],
  rules: {
    "header-max-length": [0, "always", 140],
  },
};

module.exports = Configuration;
