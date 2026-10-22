----
--- Configuration

---@class AdsenseConfig
---@field enable_ads boolean Whether to add the ad unit to the page, from `enable-ads` (default `true`)
---@field publisher_id? string The Google Adsense `publisher-id`, e.g. `ca-pub-XXXXXXXXXXXXXXXX`

----
--- Process initialization

-- Retrieve an option as a string, or nil when it is missing or the empty string
---@param options table The `adsense` metadata
---@param key string The option name
---@return string?
local function read_option(options, key)
  local value = options[key]
  if value == nil or value == '' then
    return nil
  end
  return pandoc.utils.stringify(value)
end

-- Coerce "true" or "false", in any letter case, to `true`/`false`; anything else is nil
---@param value string
---@return boolean?
local function to_boolean(value)
  local lowercase_value = value:lower()
  if lowercase_value == "true" then
    return true
  elseif lowercase_value == "false" then
    return false
  end
  return nil
end

-- Read the `adsense` metadata into an AdsenseConfig
---@param options table The `adsense` metadata
---@return AdsenseConfig
local function read_config(options)
  ---@type AdsenseConfig
  local config = {
    enable_ads = true,
    publisher_id = read_option(options, 'publisher-id')
  }

  local enable_ads = read_option(options, 'enable-ads')
  if enable_ads then
    local value = to_boolean(enable_ads)
    if value == nil then
      quarto.log.error("The `enable-ads` must be either `true` or `false`, not `" .. enable_ads .. "`." ..
      "\nPlease fix by correcting the value supplied to `enable-ads` in the current document.")
    end
    -- Any value other than `true` disables ads
    config.enable_ads = value == true
  end

  return config
end

-- Ad unit HTML
---@param publisher_id string
---@return string
local function adsense_html(publisher_id)
  local html_text = '<script async'..
  ' src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=' .. publisher_id .. '"' ..
  ' crossorigin="anonymous">' ..
  '</script>'

  return html_text
end


-- Retrieve publisher and setup ad unit
---@param meta pandoc.Meta
---@return pandoc.Meta
local function add_ad_unit(meta)

  -- The ad unit script needs an HTML format that runs JavaScript, which excludes EPUB
  if not quarto.doc.is_format("html:js") then
    quarto.log.error("The `adsense` extensions works only on HTML powered Quarto projects.")
    return meta
  end

  -- Check for configuration
  local options = meta.adsense
  if options == nil or options == '' then
    quarto.log.error(
      "The Quarto project is missing the `adsense` key in either" ..
       "\n - the document header,\n - `_quarto.yml`, or\n - `_metadata.yml`."
    )
    return meta
  end

  local config = read_config(type(options) == "table" and options or {})

  -- If ads should be disabled; exit here to avoid running into a publisher-id unset error.
  if not config.enable_ads then
    return meta
  end

  if not config.publisher_id then
    quarto.log.error(
      "The `publisher-id` is not set. Please set the `publisher-id` by either:" ..
      "\n - the value in the current document," ..
      "\n - the projects `_quarto.yml`, or" ..
      "\n - `_metadata.yml` for the directory.\n")
    return meta
  end

  -- Inject the customized unit into the HTML document's header section
  -- using Quarto's API.
  quarto.doc.include_text("in-header", adsense_html(config.publisher_id))

  return meta
end

return {
  { Meta = add_ad_unit }
}
