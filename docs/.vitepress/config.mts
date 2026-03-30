import { defineConfig } from "vitepress";

export default defineConfig({
  title: "Nicy",
  description: "Official documentation for Nicy CLI and nicyrtdyn runtime",
  lang: "en-US",
  base: "/nicy-docs/",
  cleanUrls: true,
  lastUpdated: true,
  themeConfig: {
    logo: "/logo.svg",
    nav: [
      { text: "Home", link: "/" },
      { text: "Install", link: "/install" },
      { text: "CLI", link: "/cli" },
      { text: "Runtime", link: "/runtime" },
      { text: "FFI", link: "/ffi-bare-metal" },
      { text: "GitHub", link: "https://github.com/nicy-luau" }
    ],
    sidebar: [
      {
        text: "Nicy",
        items: [
          { text: "Introduction", link: "/" },
          { text: "Installation", link: "/install" },
          { text: "CLI", link: "/cli" }
        ]
      },
      {
        text: "Runtime",
        items: [
          { text: "Overview", link: "/runtime" },
          { text: "Task Scheduler", link: "/task" },
          { text: "Require and Cache", link: "/require-cache" },
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

