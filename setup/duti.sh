#? /bin/bash
#
# Change default editor for the listed filetypes on MacOS.
# Required duti to be installed. `brew install duti`

#  parent UTIs to bind to Cursor (safe – won’t steal PDFs, Office docs, images, etc.)
duti_utis=(
  public.source-code      # language files
  public.script           # generic scripts
  public.make-source      # Make/Autotools
  public.shell-script     # sh, zsh, bash, fish…
  public.css              # CSS
  public.yaml             # YAML
  public.json             # JSON
  public.xml              # XML/SVG
  public.plain-text       # txt, md, log
  public.log              # macOS unified-log bundles
)

# individual extensions & filename-only items to bind directly
duti_extensions=(
  # ── modern web / frameworks ───────────────────────────────
  .html .css .astro .svelte .vue .mdx .jsx .tsx .ts .cjs .mjs .cjsx
  .graphql .coffee .less .sass .scss .postcss
  .map .js.map .ts.map .tsx.map .jsx.map .scss.map .jsonc

  # ── infra / build / IaC ───────────────────────────────────
  .tf .tfvars .tfstate .hcl .toml .gradle .kts .bazel .bzl .ninja
  .dockerignore BUILD WORKSPACE CMakeLists MesonBuild

  # ── extra languages / data files macOS leaves as “public.data” ──
  .cppm .cs .go .hs .rs .nim .zig .d .elm .purs
  .ex .exs .erl .hrl .fs .fsi .fsx .ml .mli .scala .sc .kt
  .dart .hx .gd .proto .wgsl .glsl .vert .frag .vb .wasm

  # ── configs & dotfiles ────────────────────────────────────
  .bashrc .builder .config .editorconfig .env .envrc .env.example
  .gemspec .gitattributes .gitconfig .gitignore .gitmodules
  .npmrc .lock .p12 .pem .prettierrc .eslintrc .stylelintrc
  .browserslistrc .ps1 .fish .pylintrc .flake8 .yamllint
  .cfg .conf .ini .properties .json5
  .csr .crt .der .key
  .zshrc .bazel

  # ── markup / docs / templates ─────────────────────────────
  .erb .haml .hbs .rdoc .rjs .rst .adoc .asciidoc .org .resx

  # ── misc dev artefacts ────────────────────────────────────
  .rake .puma .rbi .rbs .ruby-version .targets .sh.example
  .ico .ics .postcss .patch

  # ── filename-only project manifests ───────────────────────
  Dockerfile Gemfile Makefile Procfile Rakefile
  Jenkinsfile Vagrantfile Brewfile Capfile Podfile Fastfile Guardfile
  Dangerfile Taskfile Tiltfile Caddyfile
)

vscodeinsiders=com.microsoft.VSCodeInsiders
vscode=com.microsoft.VSCode
cursor=com.todesktop.230313mzl4w4u92
windsurf=com.exafunction.windsurf
atom=com.github.atom
sublime2=com.sublimetext.2
sublime3=com.sublimetext.3
macvim=org.vim.MacVim

# editor=$vscode
editor=$cursor

# editors=("Atom" "MacVim" "SublimeText2" "SublimeText3" "VisualStudioCode" "VisualStudioCodeInsiders")

# echo "Which editor would you like to be default?"

# select opt in ${editors[@]}; do
#   if [ "$opt" = "Atom" ]; then
#     editor=$atom
#     break
#   elif [ "$opt" = "MacVim" ]; then
#     editor=$macvim
#     break
#   elif [ "$opt" = "SublimeText2" ]; then
#     editor=$sublime2
#     break
#   elif [ "$opt" = "SublimeText3" ]; then
#     editor=$sublime3
#     break
#   elif [ "$opt" = "VisualStudioCode" ]; then
#     editor=$vscode
#     break
#   elif [ "$opt" = "VisualStudioCodeInsiders" ]; then
#     editor=$vscodeinsiders
#     break
#   fi
# done

echo "Setting default editor to $editor"
echo "-----------------------------------------"

for uti in "${duti_utis[@]}"; do
  echo "duti -s $editor $uti"
  duti -s $editor "$uti" all
done

for extension in "${duti_extensions[@]}"; do
  echo "duti -s $editor $extension"
  duti -s $editor "$extension" all
done
