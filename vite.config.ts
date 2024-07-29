import { resolve } from 'path'
import { defineConfig, Terser } from 'vite'
import { glob } from 'glob'

export default defineConfig({

  build: {
    minify: 'terser',
    lib: {
      // https://gist.github.com/jasenmichael/58dd3a4f8e7ec1d003e88907bba392d7
      entry: glob.sync(resolve(__dirname, 'wpn-utils/*.ts')),
      formats: ["es"],
    },
    outDir: resolve(__dirname, 'html/js'),
    rollupOptions: {
      // make sure to externalize deps that shouldn't be bundled
      // into your library
    },
  },
})