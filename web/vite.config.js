import { defineConfig } from 'vite';
import { resolve } from 'path';
import { readFileSync, existsSync } from 'fs';

// Read project config from central source
// Try ../project.json first (when running from web/), then ../../project.json (when running from build-wasm/web/)
let projectJsonPath = resolve(__dirname, '../project.json');
if (!existsSync(projectJsonPath)) {
    projectJsonPath = resolve(__dirname, '../../project.json');
}
const projectConfig = JSON.parse(
    readFileSync(projectJsonPath, 'utf-8')
);

export default defineConfig({
    root: '.',
    base: './',
    build: {
        outDir: 'dist',
        emptyOutDir: true,
        rollupOptions: {
            input: {
                main: resolve(__dirname, 'index.html'),
            },
        },
    },
    server: {
        port: 3000,
        open: true,
    },
    preview: {
        port: 4173,
    },
    optimizeDeps: {
        exclude: [`${projectConfig.name}.js`],
    },
    assetsInclude: ['**/*.wasm'],
    define: {
        __PROJECT_NAME__: JSON.stringify(projectConfig.name),
        __PROJECT_DISPLAY_NAME__: JSON.stringify(projectConfig.display_name),
        __WASM_MODULE_PATH__: JSON.stringify(`./${projectConfig.name}.js`),
    },
});

