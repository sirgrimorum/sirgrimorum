export const LOCALES = ['en', 'es', 'pt-br'] as const;
export type Locale = (typeof LOCALES)[number];

/** BCP 47 language tags for html[lang] and hreflang attributes. */
export const localeLangTags: Record<Locale, string> = {
  en: 'en',
  es: 'es',
  'pt-br': 'pt-BR',
};

/** Non-localizable project metadata (url, accent, status). Names live in translations. */
export const PROJECT_META = [
  {
    key: 'cerebroExterno' as const,
    url: 'https://brain4ai.app',
    accent: '#5a9abe',
    status: 'alpha' as const,
  },
  {
    key: 'forgeMentor' as const,
    url: 'https://mentor4ai.app',
    accent: '#e8a317',
    status: 'alpha' as const,
  },
  {
    key: 'entrepreneurity' as const,
    url: 'https://entrepreneurity.app',
    accent: '#c0392b',
    status: 'coming-soon' as const,
  },
];

export type ProjectKey = (typeof PROJECT_META)[number]['key'];

export interface Translations {
  pageTitle: string;
  pageDescription: string;
  heroTagline: string;
  projectsLabel: string;
  badge: {
    alpha: string;
    comingSoon: string;
  };
  projects: Record<ProjectKey, { name: string; tagline: string; description: string }>;
  footerCopy: string;
}

export const translations: Record<Locale, Translations> = {
  en: {
    pageTitle: 'Sirgrimorum — Building tools for thinkers and builders',
    pageDescription:
      'Sirgrimorum — building AI tools for thinkers and builders. Cerebro Externo, Forge Mentor, Entrepreneurity.',
    heroTagline: 'Building tools for thinkers\nand builders.',
    projectsLabel: 'Projects',
    badge: { alpha: 'alpha', comingSoon: 'coming soon' },
    projects: {
      cerebroExterno: {
        name: 'Your external brain',
        tagline: 'Your AI external brain.',
        description:
          'Extracts your expertise through conversations and organizes it as a library your AI always has at hand.',
      },
      forgeMentor: {
        name: 'Your Forge Mentor',
        tagline: 'AI mentor for startup builders.',
        description:
          'An AI mentor forged from 10+ years of startup acceleration that tells you what to do today, not another framework.',
      },
      entrepreneurity: {
        name: 'Entrepreneurity',
        tagline: 'Learn business strategy by playing.',
        description:
          'A steampunk strategy game where you build and operate a business in living markets. Design experiments, face market waves, analyze results, adapt or die.',
      },
    },
    footerCopy: '© 2026 sirgrimorum',
  },

  es: {
    pageTitle: 'Sirgrimorum — Construyendo herramientas para pensadores y constructores',
    pageDescription:
      'Sirgrimorum — herramientas con IA para pensadores y constructores. Cerebro Externo, Forge Mentor, Entrepreneurity.',
    heroTagline: 'Construyendo herramientas para\npensadores y constructores.',
    projectsLabel: 'Proyectos',
    badge: { alpha: 'alfa', comingSoon: 'próximamente' },
    projects: {
      cerebroExterno: {
        name: 'Tu Cerebro Externo',
        tagline: 'Tu cerebro externo con IA.',
        description:
          'Extrae tu conocimiento a través de conversaciones y lo organiza como una biblioteca que tu IA siempre tiene a mano.',
      },
      forgeMentor: {
        name: 'Tu mentor de forja',
        tagline: 'Mentor IA para emprendedores.',
        description:
          'Un mentor IA forjado con más de 10 años de aceleración de startups que te dice qué hacer hoy, no otro framework más.',
      },
      entrepreneurity: {
        name: 'Entrepreneurity',
        tagline: 'Aprende estrategia de negocios jugando.',
        description:
          'Un juego de estrategia steampunk donde construyes y operas un negocio en mercados vivos. Diseña experimentos, enfrenta las olas del mercado, analiza resultados, adáptate o muere.',
      },
    },
    footerCopy: '© 2026 sirgrimorum',
  },

  'pt-br': {
    pageTitle: 'Sirgrimorum — Construindo ferramentas para pensadores e construtores',
    pageDescription:
      'Sirgrimorum — ferramentas com IA para pensadores e construtores. Cerebro Externo, Forge Mentor, Entrepreneurity.',
    heroTagline: 'Construindo ferramentas para\npensadores e construtores.',
    projectsLabel: 'Projetos',
    badge: { alpha: 'alfa', comingSoon: 'em breve' },
    projects: {
      cerebroExterno: {
        name: 'Seu Cérebro Externo',
        tagline: 'Seu cérebro externo com IA.',
        description:
          'Extrai seu conhecimento através de conversas e organiza como uma biblioteca que sua IA sempre tem à mão.',
      },
      forgeMentor: {
        name: 'Seu mentor de forja',
        tagline: 'Mentor IA para fundadores de startups.',
        description:
          'Um mentor IA forjado com mais de 10 anos de aceleração de startups que te diz o que fazer hoje, não mais um framework.',
      },
      entrepreneurity: {
        name: 'Entrepreneurity',
        tagline: 'Aprenda estratégia de negócios jogando.',
        description:
          'Um jogo de estratégia steampunk onde você constrói e opera um negócio em mercados vivos. Projete experimentos, enfrente ondas do mercado, analise resultados, adapte-se ou morra.',
      },
    },
    footerCopy: '© 2026 sirgrimorum',
  },
};

export function getTranslations(locale: Locale): Translations {
  return translations[locale];
}
