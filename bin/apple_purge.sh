#!/usr/bin/env bash
#!/usr/bin/env -S bash -e


rm -f ~/.bash_history
rm -f ~/.zsh_history
sudo rm -rfv /Library/Logs/*
rm -rfv ~/Library/Containers/com.apple.mail/Data/Library/Logs/Mail/*
sudo rm -rfv /var/audit/*
sudo rm -rfv /private/var/audit/*
sudo rm -rfv ~/Library/Logs/*
sudo rm -fv /System/Library/LaunchDaemons/com.apple.periodic-*.plist
sudo rm -rfv /var/db/receipts/*
sudo rm -vf /Library/Receipts/InstallHistory.plist
sudo rm -rfv /private/var/db/diagnostics/*
sudo rm -rfv /var/db/diagnostics/*
sudo rm -rfv /private/var/db/uuidtext/
sudo rm -rfv /var/db/uuidtext/
sudo rm -rfv /private/var/log/asl/*
sudo rm -rfv /var/log/asl/*
sudo rm -fv /var/log/asl.log # Legacy ASL (10.4)
sudo rm -fv /var/log/asl.db
sudo rm -fv /var/log/install.log
sudo rm -rfv /var/log/*
sudo rm -rfv /Library/Caches/* &>/dev/null
sudo rm -rfv /System/Library/Caches/* &>/dev/null
sudo rm -rfv ~/Library/Caches/* &>/dev/null
sudo rm -rfv /var/spool/cups/c0*
sudo rm -rfv /var/spool/cups/tmp/*
sudo rm -rfv /var/spool/cups/cache/job.cache*
sudo rm -rfv ~/.Trash/* &>/dev/null
rm -rfv ~/Library/Developer/Xcode/DerivedData/* &>/dev/null
rm -rfv ~/Library/Developer/Xcode/Archives/* &>/dev/null
rm -rfv ~/Library/Developer/Xcode/iOS Device Logs/* &>/dev/null
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder
sudo purge
defaults write com.apple.assistant.support 'Assistant Enabled' -bool false
defaults write com.apple.assistant.backedup 'Use device speaker for TTS' -int 3
launchctl disable "user/$UID/com.apple.assistantd"
launchctl disable "gui/$UID/com.apple.assistantd"
sudo launchctl disable 'system/com.apple.assistantd'
launchctl disable "user/$UID/com.apple.Siri.agent"
launchctl disable "gui/$UID/com.apple.Siri.agent"
sudo launchctl disable 'system/com.apple.Siri.agent'
defaults write com.apple.SetupAssistant 'DidSeeSiriSetup' -bool True
defaults write com.apple.systemuiserver 'NSStatusItem Visible Siri' 0
defaults write com.apple.Siri 'StatusMenuVisible' -bool false
defaults write com.apple.Siri 'UserHasDeclinedEnable' -bool true
defaults write com.apple.assistant.support 'Siri Data Sharing Opt-In Status' -int 2
sudo systemsetup -setremotelogin off
sudo launchctl disable 'system/com.apple.tftpd'
sudo defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool true
sudo launchctl disable system/com.apple.telnetd
cupsctl --no-share-printers
cupsctl --no-remote-any
cupsctl --no-remote-admin

