-- {{< profile-links >}}: renders a list of profile links from _variables.yml.
-- Only keys that are present and non-empty are shown; nothing else is emitted.
-- Icons come from Bootstrap Icons (bundled with Quarto); ORCID has no glyph there, so CSS draws it.
local links = {
  { key = "github",   label = "GitHub",         icon = "bi bi-github" },
  { key = "orcid",    label = "ORCID",          icon = "pl-orcid" },
  { key = "scholar",  label = "Google Scholar", icon = "bi bi-mortarboard" },
  { key = "wehi",     label = "WEHI profile",   icon = "bi bi-building" },
  { key = "linkedin", label = "LinkedIn",       icon = "bi bi-linkedin" },
  { key = "email",    label = "Email",          icon = "bi bi-envelope", prefix = "mailto:" },
  { key = "cv",       label = "CV",             icon = "bi bi-file-earmark-text" },
}

local function icon(cls)
  return pandoc.RawInline("html", '<i class="pl-icon ' .. cls .. '" aria-hidden="true"></i>')
end

return {
  ["profile-links"] = function()
    local items = {}
    for _, l in ipairs(links) do
      local v = quarto.variables.get(l.key)
      local url = v and pandoc.utils.stringify(v) or ""
      if url ~= "" then
        items[#items + 1] = { pandoc.Plain({
          pandoc.Link({ icon(l.icon), pandoc.Str(l.label) }, (l.prefix or "") .. url)
        }) }
      end
    end
    if #items == 0 then return pandoc.Null() end
    return pandoc.Div({ pandoc.BulletList(items) }, pandoc.Attr("", { "profile-links" }))
  end,

  -- {{< research-focus >}}: the research_focus variable ("A · B · C") shown as compact keyword tags.
  ["research-focus"] = function()
    local v = quarto.variables.get("research_focus")
    local s = v and pandoc.utils.stringify(v) or ""
    local tags = {}
    for part in s:gmatch("[^·]+") do
      part = part:gsub("^%s+", ""):gsub("%s+$", "")
      if part ~= "" then tags[#tags + 1] = '<span class="tag">' .. part .. '</span>' end
    end
    if #tags == 0 then return pandoc.Null() end
    return pandoc.RawBlock("html", '<div class="focus-tags">' .. table.concat(tags, " ") .. '</div>')
  end
}
