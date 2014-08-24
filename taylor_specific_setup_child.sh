{
    git init
    git remote add origin https://github.com/taylormonacelli/dotfiles.git
    git fetch --all
    git reset --hard origin/master

} 2>&1 | tee $0.log
