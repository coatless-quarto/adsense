-- adsense tests. Run from the repo root: quarto pandoc lua path/to/qtest.lua
local t = require("qtest")

local SCRIPT = '<script async="" src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-1234567890123456" crossorigin="anonymous">'

t.test("html: publisher-id adds the AdSense script to the page head", function()
  local r = t.render("page.qmd", "html")
  r:succeeded()
  t.count(r.text, "adsbygoogle.js", 1)
  t.in_order(r.text, { "<head>", SCRIPT, "</head>" })
end)

t.test("revealjs: the slides get the AdSense script too", function()
  local r = t.render("page.qmd", "revealjs")
  r:succeeded()
  t.count(r.text, SCRIPT, 1)
end)

t.test("in a project, enable-ads: false on a page turns off the shared ads", function()
  local r = t.render("site", "html", { output = "site/on.html", read = { "site/off.html" } })
  r:succeeded()
  t.count(r.text, SCRIPT, 1)
  t.ok(r.extra["site/off.html"], "off.html was rendered")
  t.not_contains(r.extra["site/off.html"], "adsbygoogle.js")
end)

-- Regression: the filter added the script to non-HTML output anyway, so Typst
-- failed to compile and Markdown got raw HTML.
t.test("typst, pdf and markdown render without the script, with a warning", function()
  for _, format in ipairs({ "typst", "latex", "gfm" }) do
    local r = t.render("page.qmd", format)
    r:succeeded()
    t.not_contains(r.text, "adsbygoogle.js")
    t.contains(r.log, "works only with HTML formats")
  end
end)

-- Regression: a page without an `adsense` key crashed the filter.
t.test("a page without an adsense key renders without ads, with a warning", function()
  local r = t.render("no-key.qmd", "html")
  r:succeeded()
  t.not_contains(r.text, "adsbygoogle.js")
  t.contains(r.log, "The `adsense` key is missing")
end)

-- Regression: a missing publisher-id crashed the render instead of skipping
-- the script.
t.test("a page without a publisher-id renders without ads, with a warning", function()
  local r = t.render("no-id.qmd", "html")
  r:succeeded()
  t.not_contains(r.text, "adsbygoogle.js")
  t.contains(r.log, "The `publisher-id` is not set")
end)
