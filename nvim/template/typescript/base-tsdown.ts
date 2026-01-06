import { defineConfig } from 'tsdown';

const config: ReturnType<typeof defineConfig> = defineConfig({
	outDir: 'dist',
	entry: 'src/index.ts{{_cursor_}}',
	fixedExtension: true,
	dts: true,
	clean: true,
	unused: { level: 'error' },
	publint: true,
});

export default config;
