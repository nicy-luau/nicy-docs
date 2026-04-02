import { defineConfig } from "vitepress";

export default defineConfig({
  sitemap: {
    hostname: "https://nicy-luau.github.io/nicy-docs/",
  },

  title: "Nicy",
  description:
    "Nicy and nicyrtdyn documentation: runtime usage, native modules, and ABI reference",
  lang: "en-US",
  base: "/nicy-docs/",
  cleanUrls: true,
  lastUpdated: true,
  head: [
    ["link", { rel: "icon", href: "/nicy-docs/favicon.png", sizes: "any" }],
    ["link", { rel: "apple-touch-icon", href: "/nicy-docs/favicon.png" }],
  ],
  themeConfig: {
    logo: "/nicy-docs/favicon.png",
    nav: [
      { text: "Home", link: "/" },
      { text: "Install", link: "/install" },
      { text: "Runtime", link: "/runtime" },
      { text: "Native Modules", link: "/ffi-bare-metal" },
      { text: "Troubleshooting", link: "/troubleshooting" },
      { text: "GitHub", link: "https://github.com/nicy-luau" },
    ],
    sidebar: [
      {
        text: "Start",
        items: [
          { text: "What is Nicy", link: "/" },
          { text: "Install", link: "/install" },
          { text: "Troubleshooting", link: "/troubleshooting" },
        ],
      },
      {
        text: "Runtime Usage",
        items: [
          { text: "Runtime Guide", link: "/runtime" },
          { text: "Task Guide", link: "/task" },
          { text: "Require & Cache Guide", link: "/require-cache" },
        ],
      },
      {
        text: "Engine & Native",
        items: [
          { text: "nicyrtdyn Guide", link: "/nicyrtdyn" },
          { text: "FFI / Bare Metal Guide", link: "/ffi-bare-metal" },
        ],
      },
      {
        text: "Appendix Reference",
        items: [
          { text: "CLI Reference", link: "/reference/cli" },
          { text: "Runtime API Reference", link: "/reference/runtime-api" },
          { text: "Task API Reference", link: "/reference/task-api" },
          {
            text: "Require & Cache Reference",
            link: "/reference/require-cache",
          },
          { text: "Host API Reference", link: "/reference/host-api" },
          { text: "FFI ABI Reference", link: "/reference/ffi-bare-metal" },
          { text: "Error Catalog", link: "/reference/error-catalog" },
        ],
      },
    ],
    socialLinks: [{ icon: "github", link: "https://github.com/nicy-luau" }],
    footer: {
      message: "Nicy Luau",
      copyright: "Copyright © 2026",
    },
  },
});
