# adsense: A Quarto Extension for Adding Google Adsense to Quarto HTML Projects

The `adsense` extension allows you to incorporate [Google Adsense](https://adsense.google.com/start/) ad's on various [Quarto](https://quarto.org/) formats, including [HTML](https://quarto.org/docs/output-formats/html-basics.html), [Websites](https://quarto.org/docs/websites/), and [Books](https://quarto.org/docs/books). 

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/coatless-quarto/adsense)

This extension is required as [Quarto does **not** natively support Google Adsense](https://github.com/quarto-dev/quarto-cli/discussions/2898#discussioncomment-3905621), but [does have support for Google Analytics](https://quarto.org/docs/websites/website-tools.html#google-analytics).

## Installation

To install the `adsense` extension, follow these steps:

1. Open your terminal.

2. Execute the following command:

```bash
quarto add coatless-quarto/adsense
```

This command will download and install the extension under the `_extensions` subdirectory of your Quarto project. If you are using version control, ensure that you include this directory in your repository.

## Usage

Open either the [`_quarto.yml`](https://quarto.org/docs/projects/quarto-projects.html#project-metadata) or [`_metadata.yml`](https://quarto.org/docs/projects/quarto-projects.html#directory-metadata) Project file and add the following:

```yml
adsense:
  publisher-id: ca-pub-XXXXXXXXXXXXXXXX

filters:
- adsense
```

where `ca-pub-XXXXXXXXXXXXXXXX` in `publisher-id` is your Google Adsense [Publisher ID](https://support.google.com/adsense/answer/105516?hl=en).

**Note:** Ads may take up to an hour to appear on the page/project.

## References

- Google Adsense
    - [Google Adsense: Find Publisher ID](https://support.google.com/adsense/answer/105516?hl=en)
    - [Google Adsense: Get and copy the AdSense code](https://support.google.com/adsense/answer/9274019?hl=en)
    - [Google Adsense: Where to place the AdSense code in your HTML](https://support.google.com/adsense/answer/9274516?sjid=14850419192472362507-NC)
- Quarto
    - [Quarto: Lua API Reference](https://quarto.org/docs/extensions/lua-api.html)
    - [Quarto: Lua Development](https://quarto.org/docs/extensions/lua.html)
- Pandoc
    - [Pandoc: Lua Filters](https://pandoc.org/lua-filters.html)
    - [Pandoc: Lua type reference](https://pandoc.org/lua-filters.html#lua-type-reference)
    - [Lua: Manual](https://www.lua.org/manual/5.4/)
