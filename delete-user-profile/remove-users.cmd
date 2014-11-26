rem http://techibee.com/powershell/powershell-script-to-delete-windows-user-profiles-on-windows-7windows-2008-r2/1556

powershell -inputformat none -executionpolicy bypass -noprofile -noninteractive -file Remove-UserProfile.ps1 -username sshd_account <NUL
