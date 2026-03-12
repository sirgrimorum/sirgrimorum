import { defineConfig } from 'astro/config';

export default defineConfig({
  site: 'https://sirgrimorum.com',
  output: 'static',
  i18n: {
    defaultLocale: 'en',
    locales: ['en', 'es', 'pt-br'],
    routing: {
      prefixDefaultLocale: false, // / → en, /es/ → es, /pt-br/ → pt-br
    },
  },
});
