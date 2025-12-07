import { defineConfig } from 'vite';
import { resolve } from 'path';

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
        exclude: ['order_engine.js'],
    },
    assetsInclude: ['**/*.wasm'],
});

