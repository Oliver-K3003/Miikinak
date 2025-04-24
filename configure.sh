#!/bin/bash
source utils.sh

BARE_REPO=$HOME/.cfg

cd ~

if ! git_installed; then
    "git must be installed to continue"
    exit 1
fi

git clone --bare https://github.com/Oliver-K3003/dotfiles.git $BARE_REPO

dotsync() {
    /usr/bin/git --git-dir=$BARE_REPO --work-tree=$HOME $@
}

mkdir -p .config-backup
dotsync checkout

if [ $? = 0 ]; then
    echo "Config setup complete"
else
    echo "Dotfiles already exist, making backup..."
    dotsync checkout 2>&1 | grep -E "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
fi

dotsync checkout
dotsync config status.showUntrackedFiles no
