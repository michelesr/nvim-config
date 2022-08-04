FROM docker.io/library/archlinux:latest

RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm \
        neovim nodejs npm ranger fzf \
        the_silver_searcher ctags git \
        tmux highlight gcc make && \
    rm /var/cache/pacman -rf && \
    ln -s /bin/nvim /usr/local/bin/vim && \
    ln -s /bin/nvim /usr/local/bin/vi

ENV RANGER_LOAD_DEFAULT_RC=FALSE \
    EDITOR=vim \
    VISUAL=vim

RUN mkdir -p ~/.config/ranger && \
    TERM=xterm ranger --copy-config scope && \
    TERM=xterm ranger --copy-config rc

# patch ranger to allow previews for root user
RUN nvim --headless --cmd ':silent' \
    -c "/if fm.username == 'root'" -c 'norm 4dd' -c 'wq' \
    /usr/lib/python3.*/site-packages/ranger/core/main.py

RUN echo 'source /usr/share/fzf/completion.bash' >> ~/.bashrc && \
    echo 'source /usr/share/fzf/key-bindings.bash' >> ~/.bashrc && \
    echo 'source ~/.bashrc' >> ~/.bash_profile && \
    echo 'set editing-mode vi' > ~/.inputrc && \
    echo 'set keymap vi-command' >> ~/.inputrc

# add tmux.conf but without powerline
RUN curl https://raw.githubusercontent.com/michelesr/zsh-config/master/tmux.conf | \
    sed '/powerline/d' > ~/.tmux.conf

COPY init.vim /root/.config/nvim/
COPY lua /root/.config/nvim/lua

RUN git clone --depth 1 https://github.com/wbthomason/packer.nvim \
    ~/.local/share/nvim/site/pack/packer/start/packer.nvim && \
    nvim --headless --cmd ':silent' -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

WORKDIR /root
