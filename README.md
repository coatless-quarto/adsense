# quarto-adsense: A Quarto Extension for Google Adsense

The `adsense` extension allows you to incorporate [Google Adsense (GADS)](https://adsense.google.com/start/) ad's on various [Quarto](https://quarto.org/) formats, including [HTML](https://quarto.org/docs/output-formats/html-basics.html), [Websites](https://quarto.org/docs/websites/), and [Books](https://quarto.org/docs/books). 

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

There are two modes available for the extension: 

1. A global configuration that allows a consistent option to be set for multiple pages with an option to opt a page out.
2. A localized single page configuration.

**Note:** Ads may take up to an hour to appear on the page/project.

### Multi-page Projects: Websites and Books

If you have a website or book, you can use either the [`_quarto.yml`](https://quarto.org/docs/projects/quarto-projects.html#project-metadata) or [`_metadata.yml`](https://quarto.org/docs/projects/quarto-projects.html#directory-metadata) files to avoid needing to consistently set the value. Add into the configuration file: 

```yml
adsense:
  publisher-id: ca-pub-XXXXXXXXXXXXXXXX

filters:
- adsense
```

where `ca-pub-XXXXXXXXXXXXXXXX` in `publisher-id` is your Google Adsense [Publisher ID](https://support.google.com/adsense/answer/105516?hl=en).

If you wish to disable ads on a specific page, then add to the Quarto document's YAML header area:

```yml
adsense:
  enable-ads: false
```

For more information, please see Quarto's documentation on [Shared Metadata](https://quarto.org/docs/projects/quarto-projects.html#shared-metadata).

### Single Page Projects: HTML Document

If you only have one HTML document, we recommend setting up the extension by placing the required fields into the document's header section, e.g.

```yml
---
title: "Demo Setup"
author: "FirstName LastName"
adsense:
  publisher-id: ca-pub-XXXXXXXXXXXXXXXX
filters:
- adsense
---
```

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

## Disclaimer

This Quarto extension is open source software and is **not affiliated with** Google. The extension is at best a community effort to simplify the integration of Google's Adsense product inside of Quarto websites.
