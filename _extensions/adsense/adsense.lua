local isAdsenseUnitMissing = true

local function isEmptyString(s)
  return s == nil or s == ''
end

local function stringHasContents(s)
  return not isEmptyString(s)
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

  local adsense_meta = m.adsense
  if isEmptyString(adsense_meta) then
    quarto.log.error("The Quarto project is missing the `adsense` key in either the document header, `_quarto.yml`, or `_metadata.yml`.")
  end

  -- Detect HTML format (excluding epub which won't handle fa)
  if quarto.doc.is_format("html:js") then
    
    -- Retrieve publisherID from meta
    local publisher_id = pandoc.utils.stringify(adsense_meta['publisher-id'])
    if stringHasContents(publisher_id) then
      if isAdsenseUnitMissing then
        -- Avoid re-running insertion
        isAdsenseUnitMissing = false
        -- Customize the ad unit script tag
        local adsense_customized_adunit_html = adsense_html(publisher_id)
        -- Inject the customized unit into the HTML document's header section 
        -- using Quarto's API.
        quarto.doc.include_text("in-header", adsense_customized_adunit_html)
      end
    else 
      quarto.log.error("The `publisher-id` is not set. Please set the `publisher-id` by either the value in the current document, the projects `_quarto.yml`, or `_metadata.yml` for the directory.")
    end 
  else 
    quarto.log.error("The `adsense` extensions works only on HTML powered Quarto projects.")
  end 

  return m
end
