import { defineConfig } from "vitepress";

export default defineConfig({
  title: "Nicy",
  description: "Modern Luau runtime and tooling docs",
  lang: "pt-BR",
  cleanUrls: true,
  lastUpdated: true,
  themeConfig: {
    logo: "/logo.svg",
    nav: [
      { text: "Início", link: "/" },
      { text: "Instalação", link: "/install" },
      { text: "GitHub", link: "https://github.com/nicy-luau" }
    ],
    sidebar: [
      {
        text: "Guia",
        items: [
          { text: "Introdução", link: "/" },
          { text: "Instalação", link: "/install" }
        ]
      }
    ],
    socialLinks: [{ icon: "github", link: "https://github.com/nicy-luau" }],
    footer: {
      message: "Nicy Luau",
      copyright: "Copyright © 2026"
    }
  }
});

