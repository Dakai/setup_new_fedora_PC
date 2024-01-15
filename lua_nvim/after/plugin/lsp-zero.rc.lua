-- vim.g.lsp_zero_extend_lspconfig = 0
local lsp = require('lsp-zero')
-- local lsp = require('lsp-zero')
lsp.extend_lspconfig()

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({ buffer = bufnr })
end)

lsp.setup_servers({
  'bashls',
  'html',
  'lua_ls',
  'svelte',
  'tailwindcss',
  'intelephense',
  'pyright',
  'tsserver',
  --'eslint',
  -- 'grammerly',
  'jsonls',
  'yamlls',
  'toml',
})

lsp.setup()

lsp.format_on_save({
  format_opts = {
    async = false,
    timeout_ms = 5000,
  },
  servers = {
    ['jsonls'] = { 'json' },
    ['lua_ls'] = { 'lua' },
    ['pyright'] = { 'python' },
    ['prettierd'] = { 'yaml' },
    ['svelte'] = { 'svelte' },
    ['tailwindcss'] = { 'css' },
    -- ['intelephense'] = { 'php' },
    ['tsserver'] = { 'javascript', 'typescript' },
    ['bashls'] = { 'bash' },
    ['html'] = { 'html' },
    ['taplo'] = { 'toml' },
  }
})

-- CMP popup window color
-- gray
vim.api.nvim_set_hl(0, 'CmpItemAbbrDeprecated', { bg = 'NONE', strikethrough = true, fg = '#8A889D' })
-- blue
vim.api.nvim_set_hl(0, 'CmpItemAbbrMatch', { bg = 'NONE', fg = '#78A8FF' })
vim.api.nvim_set_hl(0, 'CmpItemAbbrMatchFuzzy', { link = 'CmpIntemAbbrMatch' })
-- light blue
vim.api.nvim_set_hl(0, 'CmpItemKindVariable', { bg = 'NONE', fg = '#91DDFF' })
vim.api.nvim_set_hl(0, 'CmpItemKindInterface', { link = 'CmpItemKindVariable' })
vim.api.nvim_set_hl(0, 'CmpItemKindText', { link = 'CmpItemKindVariable' })
-- pink
vim.api.nvim_set_hl(0, 'CmpItemKindFunction', { bg = 'NONE', fg = '#F48FB1' })
vim.api.nvim_set_hl(0, 'CmpItemKindMethod', { link = 'CmpItemKindFunction' })
-- front
vim.api.nvim_set_hl(0, 'CmpItemKindKeyword', { bg = 'NONE', fg = '#CBE3E7' })
vim.api.nvim_set_hl(0, 'CmpItemKindProperty', { link = 'CmpItemKindKeyword' })
vim.api.nvim_set_hl(0, 'CmpItemKindUnit', { link = 'CmpItemKindKeyword' })

-- Select item color
vim.api.nvim_set_hl(0, 'PmenuSel', { bg = '#1C1A2E', fg = 'NONE' })


-- You need to setup `cmp` after lsp-zero
local cmp = require('cmp')
local compare = cmp.config.compare
-- local cmp_action = require('lsp-zero').cmp_action()
local lspkind = require('lspkind')



cmp.setup({
  -- Make the first item in completion menu always be selected.
  preselect = 'item',
  completion = {
    completeopt = 'menu,menuone,noinsert'
  },

  mapping = cmp.mapping.preset.insert({
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    --['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true
    }),
  }),
  sources = cmp.config.sources({
    { name = "jupynium", priority = 1000 }, -- consider higher priority than LSP
    { name = 'path' },
    { name = "nvim_lsp", priority = 100 },
    { name = 'buffer',   keyword_length = 3 },
    { name = 'luasnip',  keyword_length = 2 },
  }),
  --  configure nvim-cmp to show Jupyter kernel completion
  sorting = {
    priority_weight = 1.0,
    comparators = {
      compare.score, -- Jupyter kernel completion shows prior to LSP
      compare.recently_used,
      compare.locality,
    },
  },
  formatting = {
    fields = {
      cmp.ItemField.Menu,
      cmp.ItemField.Abbr,
      cmp.ItemField.Kind,
    },
    format = lspkind.cmp_format({
      mode = 'symbol_text',  -- show only symbol annotations
      maxwidth = 80,         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
      menu = {
        buffer = "[BUF]",
        nvim_lsp = "[LSP]",
        nvim_lua = "[LUA]",
        path = "[PATH]",
        luasnip = "[SNIP]",
      },
      -- The function below will be called before any actual modifications from lspkind
      -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
      --before = function(entry, vim_item)
      --  vim_item = require('tailwindcss-colorizer-cmp').formatter(entry, vim_item)
      --  return vim_item
      --end
      before = require('tailwindcss-colorizer-cmp').formatter
    })
  },
})
