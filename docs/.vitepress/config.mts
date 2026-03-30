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
      { text: "Getting Started", link: "/getting-started" },
      { text: "Tutorials", link: "/tutorials/first-project" },
      { text: "How-to", link: "/how-to/install-and-verify" },
      { text: "Reference", link: "/reference/runtime-api" },
      { text: "GitHub", link: "https://github.com/nicy-luau" }
    ],
    sidebar: [
      {
        text: "Getting Started",
        items: [
          { text: "Project Overview", link: "/getting-started" },
          { text: "Installation", link: "/how-to/install-and-verify" },
          { text: "CLI Basics", link: "/reference/cli" }
        ]
      },
      {
        text: "Tutorials",
        items: [
          { text: "Your First Nicy Project", link: "/tutorials/first-project" },
          { text: "Build a Native Module", link: "/tutorials/native-module-c" }
        ]
      },
      {
        text: "How-to Guides",
        items: [
          { text: "Install and Verify", link: "/how-to/install-and-verify" },
          { text: "Enable JIT in Modules", link: "/how-to/enable-jit" },
          { text: "Load Native Libraries", link: "/how-to/load-native-libraries" },
          { text: "Fix Common Runtime Errors", link: "/how-to/fix-common-errors" }
        ]
      },
      {
        text: "Reference",
        items: [
          { text: "CLI", link: "/reference/cli" },
          { text: "Runtime API", link: "/reference/runtime-api" },
          { text: "Task API", link: "/reference/task-api" },
          { text: "Require and Cache", link: "/reference/require-cache" },
          { text: "Host API (nicyrtdyn)", link: "/reference/host-api" },
          { text: "FFI / Bare Metal ABI", link: "/reference/ffi-bare-metal" },
          { text: "Error Catalog", link: "/reference/error-catalog" }
        ]
      },
      {
        text: "Explanation",
        items: [
          { text: "Architecture", link: "/explanation/architecture" },
          { text: "JIT and Module Boundaries", link: "/explanation/jit-model" }
        ]
      },
      {
        text: "Specifications",
        items: [
          { text: "Module Resolution Spec", link: "/specifications/module-resolution" },
          { text: "ABI and Compatibility", link: "/specifications/abi-compatibility" },
          { text: "Platform Matrix", link: "/specifications/platform-matrix" }
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
