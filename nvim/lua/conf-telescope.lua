local telescope = require('telescope')
-- enable fzf
telescope.load_extension('fzf')

-- keymaps
local builtin = function() return require('telescope.builtin') end

vim.keymap.set('n', '<C-p>', function() return builtin().find_files({
    hidden = true
  })
end)

vim.keymap.set('n', '<Leader>ff', function() return builtin().find_files({
    hidden = true,
    ignore = true
  })
end)

vim.keymap.set('n', '<Leader>fg', function()
  return builtin().live_grep()
end)

vim.keymap.set('n', '<Leader>fb', function()
  return builtin().buffers()
end)

vim.keymap.set('n', '<Leader>fh', function()
  return builtin().help_tags()
end)
