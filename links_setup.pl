#!perl
while(<DATA>)
{
    chomp;
    $binpath=$_;
    s{^\s+$}{};
    next unless "$_";

    if (-f "$binpath")
    {
        $f=(split '/',$binpath)[-1];
        print qq{ln -f -s "$binpath" /usr/local/bin/$f\n};
    }
}

#another way
@array = <DATA>;
print "@array";

__DATA__
/c/Program Files/Windows Embedded Standard 7/Tools/x86/oscdimg.exe
/c/Program Files/Windows Kits/8.0/Assessment and Deployment Kit/Deployment Tools/x86/Oscdimg/oscdimg.exe
/c/Program Files/Windows AIK/Tools/x86/oscdimg.exe

/c/Program Files/Windows Kits/8.1/bin/x86/makecert.exe

/c/Program Files (x86)/7-ZIP/7z.exe
/c/Program Files/7-ZIP/7z.exe

/c/Program Files (x86)/WinCDEmu/batchmnt.exe
/c/Program Files/WinCDEmu/batchmnt.exe

/c/Program Files (x86)/Oracle/VirtualBox/VBoxManage.exe
/c/Program Files/Oracle/VirtualBox/VBoxManage.exe

/c/Windows/Microsoft.NET/Framework/v2.0.50727/MSBuild.exe
/c/Windows/Microsoft.NET/Framework/v3.5/MSBuild.exe
/c/Windows/Microsoft.NET/Framework/v4.0.30319/MSBuild.exe
