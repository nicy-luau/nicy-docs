import { defineConfig } from "vitepress";

export default defineConfig({
  title: "Nicy",
  description: "Documentação oficial do Nicy CLI e do runtime nicyrtdyn",
  lang: "pt-BR",
  base: "/nicy-docs/",
  cleanUrls: true,
  lastUpdated: true,
  themeConfig: {
    logo: "/logo.svg",
    nav: [
      { text: "Início", link: "/" },
      { text: "Instalação", link: "/install" },
      { text: "Runtime", link: "/runtime" },
      { text: "FFI", link: "/ffi-bare-metal" },
      { text: "GitHub", link: "https://github.com/nicy-luau" }
    ],
    sidebar: [
      {
        text: "Nicy",
        items: [
          { text: "Introdução", link: "/" },
          { text: "Instalação", link: "/install" },
          { text: "CLI", link: "/cli" }
        ]
      },
      {
        text: "Runtime",
        items: [
          { text: "Visão Geral", link: "/runtime" },
          { text: "Task Scheduler", link: "/task" },
          { text: "Require e Cache", link: "/require-cache" },
          { text: "nicyrtdyn (Host API)", link: "/nicyrtdyn" },
          { text: "FFI / Bare Metal", link: "/ffi-bare-metal" }
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

