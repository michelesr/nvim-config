FROM docker.io/library/archlinux:latest

RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm \
        neovim nodejs npm ranger fzf \
        the_silver_searcher ctags git \
        tmux highlight && \
    pacman -Scc --noconfirm && \
    ln -s /bin/nvim /usr/local/bin/vim && \
    ln -s /bin/nvim /usr/local/bin/vi

RUN git clone https://github.com/michelesr/nvim-config ~/.config/nvim && \
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' && \
    nvim --headless --cmd ':silent' -c ':PlugUpgrade|:PlugUpdate|qa'

ENV RANGER_LOAD_DEFAULT_RC=FALSE \
    EDITOR=vim \
    VISUAL=vim

RUN mkdir ~/.config/ranger && \
    TERM=xterm ranger --copy-config scope && \
    TERM=xterm ranger --copy-config rc

# patch ranger to allow previews for root user
RUN nvim --headless --cmd ':silent' \
    -c "/if fm.username == 'root'" -c 'norm 4dd' -c 'wq' \
    /usr/lib/python3.*/site-packages/ranger/core/main.py

WORKDIR /root
