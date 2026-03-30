import { ssrRenderAttrs } from "vue/server-renderer";
import { useSSRContext } from "vue";
import { _ as _export_sfc } from "./plugin-vue_export-helper.1tPrXgE0.js";
const __pageData = JSON.parse('{"title":"Nicy Documentation","description":"","frontmatter":{},"headers":[],"relativePath":"index.md","filePath":"index.md","lastUpdated":null}');
const _sfc_main = { name: "index.md" };
function _sfc_ssrRender(_ctx, _push, _parent, _attrs, $props, $setup, $data, $options) {
  _push(`<div${ssrRenderAttrs(_attrs)}><h1 id="nicy-documentation" tabindex="-1">Nicy Documentation <a class="header-anchor" href="#nicy-documentation" aria-label="Permalink to &quot;Nicy Documentation&quot;">​</a></h1><p>Nicy é um runtime/tooling para Luau com foco em distribuição de binários pronta para uso.</p><h2 id="objetivo" tabindex="-1">Objetivo <a class="header-anchor" href="#objetivo" aria-label="Permalink to &quot;Objetivo&quot;">​</a></h2><ul><li>Instalação simples</li><li>Runtime nativo separado</li><li>Releases multi-plataforma</li></ul><h2 id="comece-agora" tabindex="-1">Comece agora <a class="header-anchor" href="#comece-agora" aria-label="Permalink to &quot;Comece agora&quot;">​</a></h2><ul><li>Vá para <a href="/install">Instalação</a></li><li>Repositórios: <a href="https://github.com/nicy-luau/nicy" target="_blank" rel="noreferrer">nicy</a> e <a href="https://github.com/nicy-luau/nicyrtdyn" target="_blank" rel="noreferrer">nicyrtdyn</a></li></ul></div>`);
}
const _sfc_setup = _sfc_main.setup;
_sfc_main.setup = (props, ctx) => {
  const ssrContext = useSSRContext();
  (ssrContext.modules || (ssrContext.modules = /* @__PURE__ */ new Set())).add("index.md");
  return _sfc_setup ? _sfc_setup(props, ctx) : void 0;
};
const index = /* @__PURE__ */ _export_sfc(_sfc_main, [["ssrRender", _sfc_ssrRender]]);
export {
  __pageData,
  index as default
};
