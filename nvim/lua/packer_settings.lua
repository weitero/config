local ensure_packer=function()
  local install_path=vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if vim.fn.empty(vim.fn.glob(install_path))>0 then
    vim.fn.system({
      'git',
      'clone',
      '--depth','1',
      'https://github.com/wbthomason/packer.nvim.git',
      install_path,
    })
    vim.cmd[[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap=ensure_packer()

require('packer').startup({
  config={luarocks={python_cmd='python3',},},
  function(use)
    use 'Mofiqul/vscode.nvim'
    use 'SmiteshP/nvim-navic'
    use 'ggandor/leap.nvim'
    use 'kylechui/nvim-surround'
    use 'lukas-reineke/indent-blankline.nvim'
    use 'mfussenegger/nvim-dap'
    use 'neovim/nvim-lspconfig'
    use 'norcalli/nvim-colorizer.lua'
    use 'nvim-treesitter/nvim-treesitter-context'
    use 'preservim/tagbar'
    use 'rcarriga/nvim-dap-ui'
    use 'terrortylor/nvim-comment'
    use 'theHamsta/nvim-dap-virtual-text'
    use 'wbthomason/packer.nvim'
    use 'windwp/nvim-autopairs'

    use {
      'L3MON4D3/LuaSnip',
      requires='rafamadriz/friendly-snippets',
    }
    use {
      'feline-nvim/feline.nvim',
      requires='nvim-tree/nvim-web-devicons',
    }
    use {
      'goolord/alpha-nvim',
      requires='nvim-tree/nvim-web-devicons',
    }
    use {
      'hrsh7th/nvim-cmp',
      requires={
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-nvim-lua',
        'hrsh7th/cmp-path',
        'saadparwaiz1/cmp_luasnip',
      },
    }
    use {
      'nvim-tree/nvim-tree.lua',
      requires='nvim-tree/nvim-web-devicons',
    }
    use {
      'lewis6991/gitsigns.nvim',
      config=function()
        require('gitsigns').setup()
      end,
      requires={'nvim-lua/plenary.nvim',},
    }
    use {
      'nvim-treesitter/nvim-treesitter',
      run=':TSUpdate',
    }

    if packer_bootstrap then
      require('packer').sync()
    end
  end,
})
