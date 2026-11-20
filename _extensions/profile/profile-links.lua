-- {{< profile-links >}}: renders a list of profile links from _variables.yml.
-- Only keys that are present and non-empty are shown; nothing else is emitted.
local links = {
  { key = "github",   label = "GitHub" },
  { key = "orcid",    label = "ORCID" },
  { key = "scholar",  label = "Google Scholar" },
  { key = "wehi",     label = "WEHI profile" },
  { key = "linkedin", label = "LinkedIn" },
  { key = "email",    label = "Email", prefix = "mailto:" },
  { key = "cv",       label = "CV" },
}

return {
  ["profile-links"] = function()
    local items = {}
    for _, l in ipairs(links) do
      local v = quarto.variables.get(l.key)
      local url = v and pandoc.utils.stringify(v) or ""
      if url ~= "" then
        items[#items + 1] = { pandoc.Plain({
          pandoc.Link(l.label, (l.prefix or "") .. url)
        }) }
      end
    end
    if #items == 0 then return pandoc.Null() end
    return pandoc.Div({ pandoc.BulletList(items) }, pandoc.Attr("", { "profile-links" }))
  end
}
