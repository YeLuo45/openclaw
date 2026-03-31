#!/usr/bin/env node

import module from "node:module";
import os from "node:os";
import path from "node:path";

// Pin state dir before any dist import so CONFIG_DIR resolves consistently.
// On Windows, prefer USERPROFILE so data lands in e.g. C:\Users\<you>\.openclaw.
if (!process.env.OPENCLAW_STATE_DIR?.trim()) {
  const winProfile = process.platform === "win32" && process.env.USERPROFILE?.trim();
  process.env.OPENCLAW_STATE_DIR = winProfile
    ? path.join(winProfile, ".openclaw")
    : path.join(os.homedir(), ".openclaw");
}

// https://nodejs.org/api/module.html#module-compile-cache
if (module.enableCompileCache && !process.env.NODE_DISABLE_COMPILE_CACHE) {
  try {
    module.enableCompileCache();
  } catch {
    // Ignore errors
  }
}

await import("./dist/entry.js");
