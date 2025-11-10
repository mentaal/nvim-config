-- git clone https://github.com/neovim/nvim-lspconfig ~/.config/nvim/pack/nvim/start/nvim-lspconfig
require("config.lazy")

require("lazy").setup({
  {"nvim-treesitter/nvim-treesitter", branch = 'master', lazy = false, build = ":TSUpdate"},
  {
      "vhyrro/luarocks.nvim",
      priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
      config = true,
  }
})

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}


require("dap-python").setup("uv")

-- xnoremap il ^og_
-- onoremap il :normal vil<CR>
vim.cmd("xnoremap il ^og_")
vim.cmd("onoremap il :normal vil<CR>")
-- vim.api.nvim_set_keymap("n", "il", "^og_", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("o", "il", ":normal vil<CR>", { noremap = true, silent = true })

function map(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

function nmap(shortcut, command)
  map('n', shortcut, command)
end

function imap(shortcut, command)
  map('i', shortcut, command)
end

vim.cmd("colorscheme gruvbox")
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.ruler = true
vim.opt.showcmd = true
vim.opt.autoindent = true
vim.opt.hidden = true
-- no idea what the default is, but I've been using this for ages
-- equivalent to: set bs=2
vim.opt.bs = {
    "indent",
    "eol",
    "start",
}
-- vim.opt.rulerformat = "%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)"
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.listchars = {
          tab = '→ ',
          space = '·',
          nbsp = '␣',
          trail = '•',
          eol = '¶',
          precedes = '«',
          extends = '»',
}
vim.opt.list = true
vim.opt.shiftwidth = 4
vim.opt.textwidth = 80
vim.opt.colorcolumn = '+1'
vim.opt.tabstop = 4
vim.opt.mouse = ""
nmap('>', ':tabn<CR>')
nmap('<', ':tabp<CR>')
nmap(',l', ':source ~/.config/nvim/init.lua<cr>')
nmap(',v', ':edit ~/.config/nvim/init.lua<cr>')

nmap('<C-J>', '<C-W>j')
nmap('<C-K>', '<C-W>k')
nmap('<C-L>', '<C-W>l')
nmap('<C-H>', '<C-W>h')

nmap('<A-1>', '1gt')
nmap('<A-2>', '2gt')
nmap('<A-3>', '3gt')
nmap('<A-4>', '4gt')
nmap('<A-5>', '5gt')
nmap('<A-6>', '6gt')
nmap('<A-7>', '7gt')
nmap('<A-8>', '8gt')
nmap('<A-9>', '9gt')


nmap(',pf', ':let @p = expand("%:p")<cr>')
nmap(',ph', ':let @p = expand("%:p:h")<cr>')
nmap(',pt', ':let @p = expand("%:t")<cr>')
nmap(',pn', ':let @p = expand("%:t:r")<cr>')
nmap(',pr', ':let @p = expand("%:~:.")<cr>')
nmap(',pl', ':let @p = join([expand("%"), line(".")], ":")<cr>')
nmap(',pL', ':let @p = join([expand("%:p"), line(".")], ":")<cr>')
--nmap(',pa', 'yil:let @a = join([join([expand("%"), line(".")], ":"), getreg('"')], "  ")<cr>')
nmap('<leader>o', ':lcd %:p:h<cr>')
nmap('<leader>n', ':set list!<CR>')
nmap(',e', ':Ex<cr>')

vim.api.nvim_exec(
[[
function DiffToggle()
    if &diff
        diffoff
    else
        diffthis
    endif
endfunction
]],
false
)

nmap('<leader>df', ':call DiffToggle()<CR>')
nmap(',,', ':nohls<cr>')

-- faster scrolling
nmap('<C-e>', '3<C-e>')
nmap('<C-y>', '3<C-y>')

-- add date shortcuts
nmap(',d', ':r! date "+\\%d.\\%m.\\%Y"<cr>')
nmap(',b', ':r! date "+[\\%d.\\%b.\\%Y]"<cr>')

-- yank matching
nmap('ym', 'qyq:%s//\\=setreg("Y", submatch(0), "V")/gn')

-- nnoremap ym qyq:%s//\=setreg('Y', submatch(0), 'V')/gn



-- configure telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
-- vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fo', builtin.oldfiles, {})
vim.keymap.set('n', '<leader>fc', builtin.commands, {})

vim.keymap.set('n', '<leader>fg', require("telescope").extensions.live_grep_args.live_grep_args, { noremap = true })

local telescope = require("telescope")
local lga_actions = require("telescope-live-grep-args.actions")

telescope.setup {
  defaults = {
    layout_strategy = 'vertical',
    layout_config = { height = 0.95 },
  },
  extensions = {
    live_grep_args = {
      auto_quoting = true, -- enable/disable auto-quoting
      -- define mappings, e.g.
      mappings = { -- extend mappings
        i = {
          ["<C-k>"] = lga_actions.quote_prompt(),
          ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
          -- freeze the current list and start a fuzzy search in the frozen list
          ["<C-f>"] = lga_actions.to_fuzzy_refine,
        },
      },
      -- ... also accepts theme settings, for example:
      -- theme = "dropdown", -- use dropdown theme
      -- theme = { }, -- use own theme spec
      -- layout_config = { mirror=true }, -- mirror preview pane
    }
  }
}

-- don't forget to load the extension
telescope.load_extension("live_grep_args")

vim.lsp.enable({
    'pyright',
    'ruff',
})


-- -- Set up lspconfig.
-- local capabilities = require('cmp_nvim_lsp').default_capabilities()

  -- require('lspconfig').pyright.setup{
  --   capabilities = capabilities
  -- }

-- -- Configure `ruff-lsp`.
-- -- See: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#ruff_lsp
-- -- For the default config, along with instructions on how to customize the settings
-- require('lspconfig').ruff.setup {
--   -- capabilities = capabilities,
--   -- init_options = {
--   --   settings = {
--   --     -- Any extra CLI arguments for `ruff` go here.
--   --     args = {},
--   --   }
--   -- }
-- }

-- https://vonheikemen.github.io/devlog/tools/neovim-lsp-client-guide/
-- you can add this in your init.lua
-- (note: diagnostics are not exclusive to LSP)
--
vim.deprecate = function() end 

-- Show diagnostics in a floating window
vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')

-- Move to the previous diagnostic
vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')

-- Move to the next diagnostic
vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local bufmap = function(mode, lhs, rhs)
      local opts = {buffer = event.buf}
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- You can find details of these function in the help page
    -- see for example, :help vim.lsp.buf.hover()

    -- Trigger code completion
    bufmap('i', '<C-Space>', '<C-x><C-o>')

    -- Display documentation of the symbol under the cursor
    bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')

    -- Jump to the definition
    bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')

    -- Jump to declaration
    bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')

    -- Lists all the implementations for the symbol under the cursor
    bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')

    -- Jumps to the definition of the type symbol
    bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')

    -- Lists all the references 
    bufmap('n', 'gR', '<cmd>lua vim.lsp.buf.references()<cr>')

    -- Displays a function's signature information
    bufmap('n', '<C-s>', '<cmd>lua vim.lsp.buf.signature_help()<cr>')

    -- Renames all references to the symbol under the cursor
    bufmap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>')

    -- Format current file
    bufmap('n', '<F3>', '<cmd>lua vim.lsp.buf.format()<cr>')

    -- Selects a code action available at the current cursor position
    bufmap('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>')
  end
})

-- configure lualine
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'gruvbox',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    --lualine_a = {'mode'},
      lualine_a = {
        {
          'buffers',
          show_filename_only = true,   -- Shows shortened relative path when set to false.
          hide_filename_extension = false,   -- Hide filename extension when set to true.
          show_modified_status = true, -- Shows indicator when the buffer is modified.
    
          mode = 4, -- 0: Shows buffer name
                    -- 1: Shows buffer index
                    -- 2: Shows buffer name + buffer index
                    -- 3: Shows buffer number
                    -- 4: Shows buffer name + buffer number
    
           max_length = 1,
           --max_length = vim.o.columns * 2 / 3, -- Maximum width of buffers component,
                                               -- it can also be a function that returns
                                               -- the value of `max_length` dynamically.
           filetype_names = {
             TelescopePrompt = 'Telescope',
             dashboard = 'Dashboard',
             packer = 'Packer',
             fzf = 'FZF',
             alpha = 'Alpha'
           }, -- Shows specific buffer name for that filetype ( { `filetype` = `buffer_name`, ... } )
    
           -- Automatically updates active buffer color to match color of other components (will be overidden if buffers_color is set)
           use_mode_colors = false,
    
           -- buffers_color = {
           --   -- Same values as the general color option can be used here.
           --   active = 'lualine_{section}_normal',     -- Color for active buffer.
           --   inactive = 'lualine_{section}_inactive', -- Color for inactive buffer.
           -- },
    
           symbols = {
             modified = ' ●',      -- Text to show when the buffer is modified
             alternate_file = '#', -- Text to show to identify the alternate file
             directory =  '',     -- Text to show when the buffer is a directory
           },
        }
      },
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

-- sane search
-- https://github.com/neovim/neovim/discussions/24285
local fn = vim.fn
vim.keymap.set("n", "*", function()
    fn.setreg("/", [[\V\<]] .. fn.escape(fn.expand("<cword>"), [[/\]]) .. [[\>]])
    fn.histadd("/", fn.getreg("/"))
    vim.o.hlsearch = true
end)

-- gtags config
nmap(',gd', ':Gtags <C-R><C-W><CR>')
nmap(',gp', ':Gtags -P <C-R><C-W><CR>')
nmap(',gs', ':Gtags -s <C-R><C-W><CR>')
nmap(',gr', ':Gtags -r <C-R><C-W><CR>')
nmap(',gg', ':Gtags -g <C-R><C-W><CR>')
nmap(',j', ':.!jira_url -j<CR>')
nmap(',J', ':.!jira_url<CR>')

-- -- use purescript
-- require('lspconfig').purescriptls.setup {
--   -- Your personal on_attach function referenced before to include
--   -- keymaps & other ls options
--   -- on_attach = on_attach,
--   settings = {
--     purescript = {
--       addSpagoSources = true -- e.g. any purescript language-server config here
--     }
--   },
--   flags = {
--     debounce_text_changes = 150,
--   }
-- }
--


local dap = require("dap")
dap.adapters.gdb = {
    id = 'gdb',
    type = 'executable',
    command = '/opt/st/stm32cubeclt_1.19.0/GNU-tools-for-STM32/bin/arm-none-eabi-gdb',
    args = { '--quiet', '--interpreter=dap' },
}
dap.configurations.c = {
  {
    name = "Launch",
    type = "gdb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    args = {}, -- provide arguments if needed
    cwd = "${workspaceFolder}",
    stopAtBeginningOfMainSubprogram = false,
  },
  {
    name = "Select and attach to process",
    type = "gdb",
    request = "attach",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    pid = function()
      local name = vim.fn.input('Executable name (filter): ')
      return require("dap.utils").pick_process({ filter = name })
    end,
    cwd = '${workspaceFolder}'
  },
  {
    name = 'Attach to gdbserver :3333',
    type = 'gdb',
    request = 'attach',
    target = 'localhost:3333',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}'
  }
}
dap.configurations.cpp = dap.configurations.c
dap.configurations.rust = dap.configurations.c
