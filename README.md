# Neovim configuration

My [neovim](https://neovim.io/) configuration.

## Installation

```bash
git clone --depth 1 https://github.com/wbthomason/packer.nvim \
    ~/.local/share/nvim/site/pack/packer/start/packer.nvim
nvim --headless --cmd ':silent' -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
```

Install plugins using `:PlugInstall` and update with `:PlugUpdate`.
