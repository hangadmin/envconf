#!/bin/bash

_PWD=$PWD
RC_DIR="$HOME/.rc.d"

PYTHON_VERSION='3.7.3'
OH_MY_ZSH_URL='https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh'
POWERLINE_FONTS_URL='https://github.com/powerline/fonts.git'
PYENV_URL='https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer'
RC_URL='https://github.com/hangadmin/envconf.git'

# check cmd exist
exist() {
    if which $1 > /dev/null; then
        return 0
    else
        return 1
    fi
}


sudo apt update -y
sudo apt-get install -y zsh git curl wget
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libffi-dev libreadline-dev libsqlite3-dev llvm libncurses5-dev libncursesw5-dev \
xz-utils tk-dev libffi-dev liblzma-dev python-openssl

chsh -s /bin/zsh

# install powerline fonts
if [ ! -d $HOME/.powerline-fonts ]; then
    git clone --depth=1 $POWERLINE_FONTS_URL $HOME/.powerline-fonts
    $HOME/.powerline-fonts/install.sh
else
    echo "powerline-fonts is already installed"
fi

# install oh-my-zsh
if [ ! -d $HOME/.oh-my-zsh ]; then
    bash -c "$(curl -fsSL $OH_MY_ZSH_URL)"
else
    echo "oh-my-zsh is already installed"
fi

if [ ! -d $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
else
    echo "zsh-autosuggestions is already installed"
fi


# install pyenv
if [ ! -d $HOME/.pyenv ]; then
    curl -L $PYENV_URL | bash
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
    pyenv update
else
    echo "pyenv is already installed"
fi


# clone rc.d
if [ ! -d $RC_DIR ]; then
    git clone $RC_URL $RC_DIR
else
    echo "rc.d is already cloned"
fi


mkdir -p $HOME/.pyenv/cache
mv $RC_DIR/Python-2.7.16.tar.xz $HOME/.pyenv/cache
mv $RC_DIR/Python-3.6.9.tar.xz $HOME/.pyenv/cache
mv $RC_DIR/Python-3.7.3.tar.xz $HOME/.pyenv/cache
pyenv install 2.7.16
#pyenv install 3.6.9
pyenv install 3.7.3



# link rc files
cd $HOME
ln -sf .rc.d/gitconfig .gitconfig
ln -sf .rc.d/vimrc .vimrc
ln -sf .rc.d/zshrc .zshrc


# link zsh themes
cd $HOME/.oh-my-zsh/custom/themes
for name in `ls $RC_DIR/omz-theme`
do
    ln -sf $RC_DIR/omz-theme/$name $name
done

exec "$SHELL"

# install python requirements
pyenv global $PYTHON_VERSION

source ~/.zshrc

cd $_PWD

echo "all done please restart!! "

