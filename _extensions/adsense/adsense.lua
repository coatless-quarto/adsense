----
--- Setup variables for default initialization

-- Check to see if we've already defined the adsense Unit
-- Note: This should only trigger _once_
local isAdsenseUnitMissing = true

-- Check to see if we should show ads on the given page
local enableAds = true

----
--- Process initialization

-- Check if variable is present and not just the empty string
local function isVariableEmpty(s)
  return s == nil or s == ''
end

local function isVariablePopulated(s)
  return not isVariableEmpty(s)
end

-- Check if a value is true or false, including string representations
local function isBoolean(value)
  if type(value) == "boolean" then
    return true
  elseif type(value) == "string" then
    local lowercaseValue = value:lower()
    return lowercaseValue == "true" or lowercaseValue == "false"
  else
    return false
  end
end

-- Coerce a "true" or "false" string to `true`/`false`.
local function stringToBoolean(str)
  return str == "true" and true or false
end

-- Ad unit HTML
local function adsense_html(publisher_id)
  local html_text = '<script async'..
  ' src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=' .. publisher_id .. '"' ..
  ' crossorigin="anonymous">' ..
  '</script>'

  return html_text
end


-- Retrieve publisher and setup ad unit
function Meta(m)

  -- Detect HTML format (excluding epub which won't handle fa)
  if not quarto.doc.is_format("html:js") then
    quarto.log.error("The `adsense` extensions works only on HTML powered Quarto projects.")
  end 

  -- Check for configuration
  local adsense_meta = m.adsense
  if isVariableEmpty(adsense_meta) then
    quarto.log.error(
      "The Quarto project is missing the `adsense` key in either" ..
       "\n - the document header,\n - `_quarto.yml`, or\n - `_metadata.yml`."
    )
  end

  -- Retrieve enable-ads from meta
  if isVariablePopulated(adsense_meta['enable-ads']) then
    enableAds = pandoc.utils.stringify(adsense_meta['enable-ads'])

    if not isBoolean(enableAds) then
      quarto.log.error("The `enable-ads` must be either `true` or `false`, not `" .. enableAds .. "`." ..
      "\nPlease fix by correcting the value supplied to `enable-ads` in the current document.")
    end

    -- Apply conversion from string to boolean
    enableAds = stringToBoolean(enableAds)

    -- If ads should be disabled; exit here to avoid running into a publisher-id unset error.
    if enableAds == false then
      return m
    end 
  end

  -- Retrieve publisherID from meta
  local publisher_id = nil
  if isVariablePopulated(adsense_meta['publisher-id']) then
    publisher_id = pandoc.utils.stringify(adsense_meta['publisher-id'])
  else 
    quarto.log.error(
      "The `publisher-id` is not set. Please set the `publisher-id` by either:" ..
      "\n - the value in the current document," .. 
      "\n - the projects `_quarto.yml`, or" ..
      "\n - `_metadata.yml` for the directory.\n")
  end 

  if enableAds and isAdsenseUnitMissing then
    -- Avoid re-running insertion
    isAdsenseUnitMissing = false
    -- Customize the ad unit script tag
    local adsense_customized_adunit_html = adsense_html(publisher_id)
    -- Inject the customized unit into the HTML document's header section 
    -- using Quarto's API.
    quarto.doc.include_text("in-header", adsense_customized_adunit_html)
  end

  return m
end
