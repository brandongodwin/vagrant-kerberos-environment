set-location "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3"
new-itemproperty . -Name 1A00 -Value 0 -Type DWORD -Force