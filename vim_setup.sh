#!/bin/bash
# Set up vim from Ultimate Vim Config (http://spf13.com/post/ultimate-vim-config)
git clone git://github.com/spf13/spf13-vim.git /tmp/spf13-vim
pushd /tmp/spf13-vim
git submodule update --init
rm -rf ~/.vim
mv /tmp/spf13-vim/.vimrc ~/.vimrc
mv /tmp/spf13-vim/.vim ~/.vim
popd
rm -rf /tmp/spf13-vim
# set candycode colorscheme
mkdir -p ~/.vim/colors
cp assets/candycode.vim ~/.vim/colors
sed -i s%solarized%candycode%g ~/.vimrc
sed -i "s%set laststatus=2%set laststatus=2\n        :so bundle/fugitive/plugin/fugitive.vim%g" ~/.vimrc

