import { defineConfig } from "tsdown";

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
});

export default config;
