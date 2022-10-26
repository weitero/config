local ensure_packer=function()
  local fn=vim.fn
  local install_path=fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path))>0 then
    fn.system({'git','clone','--depth','1','https://github.com/wbthomason/packer.nvim.git',install_path,})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end
local packer_bootstrap=ensure_packer()

require('packer').startup({
  config={
    luarocks={python_cmd='python3',},
  },
  function(use)
    use 'Mofiqul/vscode.nvim'
    use 'glepnir/lspsaga.nvim'
    use 'kylechui/nvim-surround'
    use 'lukas-reineke/indent-blankline.nvim'
    use 'neovim/nvim-lspconfig'
    use 'norcalli/nvim-colorizer.lua'
    use 'preservim/tagbar'
    use 'terrortylor/nvim-comment'
    use 'wbthomason/packer.nvim'
    use 'windwp/nvim-autopairs'
    use {'L3MON4D3/LuaSnip',requires='rafamadriz/friendly-snippets',}
    use {'feline-nvim/feline.nvim',requires='kyazdani42/nvim-web-devicons',}
    use {'goolord/alpha-nvim',requires='kyazdani42/nvim-web-devicons',}
    use {'hrsh7th/nvim-cmp',requires={'hrsh7th/cmp-nvim-lsp','hrsh7th/cmp-buffer','hrsh7th/cmp-path','hrsh7th/cmp-cmdline','saadparwaiz1/cmp_luasnip','hrsh7th/cmp-nvim-lua',},}
    use {'kyazdani42/nvim-tree.lua',requires='kyazdani42/nvim-web-devicons',}
    use {'lewis6991/gitsigns.nvim',config=function()require('gitsigns').setup()end,requires={'nvim-lua/plenary.nvim',},}
    use {'nvim-treesitter/nvim-treesitter',run=':TSUpdate',}
    use {'phaazon/hop.nvim',branch='v2',}
    if packer_bootstrap then require('packer').sync()end
  end,
})
