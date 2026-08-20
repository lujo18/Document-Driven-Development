#!/usr/bin/env node
"use strict";

const { execFileSync } = require("child_process");
const path = require("path");
const fs = require("fs");

const ROOT = path.resolve(__dirname, "..");
const SCRIPT = path.join(ROOT, "scripts", "install.sh");

if (!fs.existsSync(SCRIPT)) {
  console.error("Error: scripts/install.sh not found in", ROOT);
  process.exit(1);
}

try {
  execFileSync("sh", [SCRIPT, ...process.argv.slice(2)], {
    cwd: ROOT,
    stdio: "inherit",
  });
} catch (err) {
  process.exit(err.status ?? 1);
}
