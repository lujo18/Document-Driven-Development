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

function findSh() {
  if (process.platform !== "win32") return "sh";

  const candidates = [
    "C:\\Program Files\\Git\\bin\\sh.exe",
    "C:\\Program Files (x86)\\Git\\bin\\sh.exe",
    path.join(process.env.GIT_INSTALL_ROOT || "", "bin", "sh.exe"),
  ];
  for (const p of candidates) {
    if (fs.existsSync(p)) return p;
  }

  try {
    execFileSync("git", ["--exec-path"], { stdio: "pipe" });
    return "sh";
  } catch {}

  console.error(
    "Error: sh not found. Install Git for Windows: https://git-scm.com/download/win"
  );
  process.exit(1);
}

try {
  execFileSync(findSh(), [SCRIPT, ...process.argv.slice(2)], {
    cwd: process.cwd(),
    stdio: "inherit",
  });
} catch (err) {
  process.exit(err.status ?? 1);
}
