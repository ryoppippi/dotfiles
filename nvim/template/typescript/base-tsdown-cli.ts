import { defineConfig } from "tsdown";
import { bin } from "./package.json";
import * as fs from "node:fs";

const config: ReturnType<typeof defineConfig> = defineConfig({
  outDir: "dist",
  entry: "src/index.ts{{_cursor_}}",
  fixedExtension: true,
  dts: false,
  clean: true,
  unused: { level: "error" },
  publint: true,
  outputOptions: {
    banner: "#!/usr/bin/env node\n",
  },
  onSuccess: () => {
    // Make the output file executable
    fs.chmodSync(bin, 0o755);
  },
});

export default config;
