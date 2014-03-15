##############################
# /usr/local/bin/batchmnt.exe
##############################

f=/c/Program\ Files\ \(x86\)/WinCDEmu/batchmnt.exe

if test -f "$f"
then
    ln -f -s "$f" /usr/local/bin/batchmnt.exe
fi

f=/c/Program\ Files/WinCDEmu/batchmnt.exe

if test -f "$f"
then
    ln -f -s "$f" /usr/local/bin/batchmnt.exe
fi
