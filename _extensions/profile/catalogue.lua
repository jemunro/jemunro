-- {{< catalogue publications >}} / {{< catalogue software >}}
-- Renders content/<kind>/*.md (YAML front matter + Markdown body) as the compact catalogue list.
-- Layout/markup lives here and in styles.scss; entries are data only. Adding, editing or
-- removing an entry means editing files in content/ - never this file.
-- (Why not a native Quarto listing: it cannot show the Markdown body as the description and
-- would generate an unwanted detail page per entry. See PLAN.md, Stage 3.)

local ROLE_LABELS = {
  first = "First author", senior = "Senior author",
  corresponding = "Corresponding author", coauthor = nil,  -- coauthor: no badge (default)
}
local VALID_ROLES = { first = true, senior = true, corresponding = true, coauthor = true }
local VALID_STATUS = { preprint = true, published = true }

local function esc(s)
  return (tostring(s):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub('"', "&quot;"))
end

-- Metadata helpers (pandoc gives MetaInlines/MetaList/booleans)
local function str(v)
  if v == nil then return nil end
  if type(v) == "boolean" then return tostring(v) end
  return pandoc.utils.stringify(v)
end
local function list(v)
  local out = {}
  if v == nil then return out end
  if type(v) == "table" and v.t == nil then
    for _, x in ipairs(v) do out[#out + 1] = str(x) end
  else
    out[1] = str(v)
  end
  return out
end
local function flag(v)
  return v == true or (type(v) ~= "nil" and str(v) == "true")
end

local function fail(file, msg)
  error(string.format("catalogue: %s: %s", file, msg), 0)
end

-- Sort key: "YYYY[-MM[-DD]]"; a missing month/day sorts as the latest of that period.
local function date_key(d)
  local y, m, day = (d or ""):match("^(%d%d%d%d)-?(%d*)-?(%d*)")
  if not y then return "0000-00-00" end
  return string.format("%s-%s-%s", y, m ~= "" and m or "99", day ~= "" and day or "99")
end

local function load_entries(kind)
  local root = quarto.project.directory or "."
  local dir = pandoc.path.join({ root, "content", kind })
  local names = pandoc.system.list_directory(dir)
  table.sort(names)
  local entries, seen = {}, {}
  for _, name in ipairs(names) do
    if name:match("%.md$") and not name:match("^[_.]") then
      local path = pandoc.path.join({ dir, name })
      local fh = assert(io.open(path, "r"))
      local text = fh:read("a"); fh:close()
      local doc = pandoc.read(text, "markdown")
      local m = doc.meta
      local e = {
        file = "content/" .. kind .. "/" .. name,
        id = str(m.id), title = str(m.title), date = str(m.date),
        featured = flag(m.featured), exclude = flag(m.exclude),
        tags = list(m.tags), body = doc.blocks, meta = m,
      }
      if not e.id then fail(e.file, "missing required field 'id'") end
      if seen[e.id] then fail(e.file, "duplicate id '" .. e.id .. "'") end
      seen[e.id] = true
      if not e.title then fail(e.file, "missing required field 'title'") end
      e.sort = date_key(e.date)
      entries[#entries + 1] = e
    end
  end
  return entries
end

local function by_id(entries)
  local t = {}
  for _, e in ipairs(entries) do t[e.id] = e end
  return t
end

-- Featured first, then newest first, then title (stable, deterministic).
local function sort_entries(entries)
  table.sort(entries, function(a, b)
    if a.featured ~= b.featured then return a.featured end
    if a.sort ~= b.sort then return a.sort > b.sort end
    return a.title:lower() < b.title:lower()
  end)
end

local function description_html(e)
  local out = {}
  for _, b in ipairs(e.body) do
    if b.t == "Para" or b.t == "Plain" then
      local h = pandoc.write(pandoc.Pandoc({ pandoc.Plain(b.content) }), "html"):gsub("%s+$", "")
      out[#out + 1] = '<p class="entry-desc">' .. h .. '</p>'
    else
      out[#out + 1] = pandoc.write(pandoc.Pandoc({ b }), "html"):gsub("%s+$", "")
    end
  end
  return table.concat(out, "\n")
end

local function render_entry(prefix, e, title_url, meta_html, links)
  local tags = {}
  for _, t in ipairs(e.tags) do tags[#tags + 1] = '<span class="tag">' .. esc(t) .. '</span>' end
  local lk = {}
  for _, l in ipairs(links) do lk[#lk + 1] = '<a href="' .. esc(l.url) .. '">' .. esc(l.label) .. '</a>' end
  return table.concat({
    string.format('<li class="entry%s" id="%s-%s">', e.featured and " featured" or "", prefix, esc(e.id)),
    '<div class="entry-title">' .. (e.featured and '<span class="tag tag-featured">Featured</span> ' or "")
      .. '<a href="' .. esc(title_url) .. '">' .. esc(e.title) .. '</a></div>',
    '<div class="entry-meta">' .. meta_html .. '</div>',
    description_html(e),
    '<div class="entry-foot"><span class="entry-tags">' .. table.concat(tags, " ") .. '</span>',
    '<span class="entry-links">' .. table.concat(lk, " · ") .. '</span></div>',
    '</li>',
  }, "\n")
end

local function doi_url(doi) return "https://doi.org/" .. doi end

local function build(kind)
  local pubs = load_entries("publications")
  local sws = load_entries("software")
  local pub_by, sw_by = by_id(pubs), by_id(sws)

  -- Validate and read type-specific fields
  for _, p in ipairs(pubs) do
    local m = p.meta
    p.doi, p.venue = str(m.doi), str(m.venue)
    p.authors = list(m.authors)
    p.status = str(m.status) or "published"
    p.roles = list(m.roles)
    p.related = list(m["related-software"])
    if not p.doi then fail(p.file, "missing required field 'doi'") end
    if not VALID_STATUS[p.status] then fail(p.file, "status must be preprint or published") end
    for _, r in ipairs(p.roles) do
      if not VALID_ROLES[r] then fail(p.file, "unknown role '" .. r .. "'") end
    end
    for _, id in ipairs(p.related) do
      if not sw_by[id] then quarto.log.warning(p.file .. ": related-software '" .. id .. "' not found") end
    end
  end
  for _, s in ipairs(sws) do
    s.github = str(s.meta.github)
    s.related = list(s.meta["related-publications"])
    if not s.github then fail(s.file, "missing required field 'github'") end
    for _, id in ipairs(s.related) do
      if not pub_by[id] then quarto.log.warning(s.file .. ": related-publications '" .. id .. "' not found") end
    end
  end

  local out = {}
  if kind == "publications" then
    sort_entries(pubs)
    for _, p in ipairs(pubs) do
      if not p.exclude then
        local meta = {}
        if #p.authors > 0 then meta[#meta + 1] = esc(table.concat(p.authors, ", ")) end
        if p.date then meta[#meta + 1] = esc(p.date:sub(1, 4)) end
        local venue = p.venue and (p.status == "preprint" and p.venue .. " preprint" or p.venue)
          or (p.status == "preprint" and "Preprint" or nil)
        if venue then meta[#meta + 1] = esc(venue) end
        local mh = table.concat(meta, " · ")
        for _, r in ipairs(p.roles) do
          if ROLE_LABELS[r] then mh = mh .. ' <span class="tag tag-role">' .. ROLE_LABELS[r] .. '</span>' end
        end
        local links = { { label = p.venue or "DOI", url = doi_url(p.doi) } }
        for _, id in ipairs(p.related) do
          local s = sw_by[id]
          if s and not s.exclude then links[#links + 1] = { label = "GitHub", url = s.github } end
        end
        out[#out + 1] = render_entry("pub", p, doi_url(p.doi), mh, links)
      end
    end
  else
    sort_entries(sws)
    for _, s in ipairs(sws) do
      if not s.exclude then
        local links = { { label = "GitHub", url = s.github } }
        for _, id in ipairs(s.related) do
          local p = pub_by[id]
          if p and not p.exclude then links[#links + 1] = { label = p.venue or "DOI", url = doi_url(p.doi) } end
        end
        out[#out + 1] = render_entry("sw", s, s.github, "GitHub repository", links)
      end
    end
  end
  return '<ul class="catalogue">\n' .. table.concat(out, "\n") .. '\n</ul>'
end

return {
  ["catalogue"] = function(args)
    local kind = pandoc.utils.stringify(args[1] or "")
    if kind ~= "publications" and kind ~= "software" then
      error("catalogue: argument must be 'publications' or 'software'", 0)
    end
    return pandoc.RawBlock("html", build(kind))
  end
}
