-- {{< site-tabs >}}: renders the page tabs, marking the current page active.
-- To add a page, add a line here.
local tabs = {
  { label = "Publications", href = "index.html",    file = "index.qmd" },
  { label = "Software",     href = "software.html", file = "software.qmd" },
}

return {
  ["site-tabs"] = function()
    local current = pandoc.path.filename(quarto.doc.input_file or "")
    local items = {}
    for _, t in ipairs(tabs) do
      local active = (t.file == current)
      items[#items + 1] = pandoc.RawInline("html", string.format(
        '<li class="nav-item"><a class="nav-link%s" href="%s"%s>%s</a></li>',
        active and " active" or "", t.href,
        active and ' aria-current="page"' or "", t.label))
    end
    local html = '<nav class="site-tabs" aria-label="Main"><ul class="nav nav-tabs">'
      .. table.concat(pandoc.List(items):map(function(i) return i.text end))
      .. '</ul></nav>'
    return pandoc.RawBlock("html", html)
  end
}
