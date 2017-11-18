#!/bin/sh

## README
# /!\ Ce script d'installation est conçu pour mon usage. Ne le lancez pas sans vérifier chaque commande ! /!\

## La base : Homebrew et les lignes de commande
if test ! $(which brew)
then
	echo 'Installation de Homebrew'
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Vérifier que tout est bien à jour
brew update

## Utilitaires pour les autres apps : Cask et mas (Mac App Store)
echo 'Installation de mas, pour installer les apps du Mac App Store.'
brew install mas
echo "Saisir le mail du compte iTunes :"
read COMPTE
echo "Saisir le mot de passe du compte : $COMPTE"
read PASSWORD
mas signin $COMPTE "$PASSWORD"

# Installation d'apps avec mas (source : https://github.com/argon/mas/issues/41#issuecomment-245846651)
function install () {
	# Check if the App is already installed
	mas list | grep -i "$1" > /dev/null

	if [ "$?" == 0 ]; then
		echo "==> $1 est déjà installée"
	else
		echo "==> Installation de $1..."
		mas search "$1" | { read app_ident app_name ; mas install $app_ident ; }
	fi
}

echo 'Installation de Cask, pour installer les autres apps.'
brew tap caskroom/cask

## Installations des logiciels
echo 'Installation des outils en ligne de commande.'
brew install git ffmpeg libssh sshfs opencv htop noe python3 yarn

# Installer oh My zsh & met ZSH par default
brew install fish
chsh -s `which fish`


echo 'Installation des apps via brew cask'
brew cask install alfred caption dashlane docker-toolbox firefox franz google-backup-and-sync google-chrome handbrake handbrakebatch hazel imageoptim insomnia iterm2 kap macs-fan-control  molotov muzzle ngrok numi openoffice sketch spotify the-unarchiver trailer transmit transmission tunnelbear tweeten viscosity visual-studio-code vlc zoom

## Add theme to oh-my-zsh
curl -L https://get.oh-my.fish | fish

## Install police  powerfont for terminal
sh ./fonts-master/install.sh

#echo "Ouverture de Google Drive pour commencer la synchronisation"
open -a Google\ Drive

## ************************* CONFIGURATION ********************************
echo "Configuration de quelques paramètres par défaut…"

## Desactive la surveillance des disque (pour un ssd)
sudo pmset -a sms 0

## FINDER

# Affichage de la bibliothèque
chflags nohidden ~/Library

# Finder : affichage de la barre latérale / affichage par défaut en mode liste / affichage chemin accès / extensions toujours affichées
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string “Nlsv”
defaults write com.apple.finder ShowPathbar -bool true
sudo defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Afficher le dossier maison par défaut
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

#Afficher disques externe sur le bureau
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Recherche dans le dossier en cours par défaut
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Coup d'œîl : sélection de texte
defaults write com.apple.finder QLEnableTextSelection -bool true

# Pas de création de fichiers .DS_STORE
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Affichage dossier cachés par default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Rend les icones des app cachés transluicides
defaults write com.apple.dock showhidden -bool true

# Mot de passe demandé immédiatement quand l'économiseur d'écran s'active
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

## CLAVIER ET TRACKPAD

# Désactivation du scroll naturel
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Accès au clavier complet (tabulation dans les boîtes de dialogue)
sudo defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

## Aficher la batterie en %
defaults write com.apple.menuextra.battery ShowPercent -string "YES"
defaults write com.apple.menuextra.battery ShowTime -string "NO"

## Active clique droit
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

# Arrêt pop-up clavier façon iOS
sudo defaults write -g ApplePressAndHoldEnabled -bool false

# Répétition touches plus rapide
sudo defaults write NSGlobalDomain KeyRepeat -int 1
# Délai avant répétition des touches
sudo defaults write NSGlobalDomain InitialKeyRepeat -int 10

# Alertes sonores quand on modifie le volume
sudo defaults write ~/Library/Preferences/.GlobalPreferences.plist -int 0

# Réglages Trackpad : toucher pour cliquer
sudo defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
sudo defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Trier l'activité du moniteur par CPU
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

# Desactivation du fast User switch
sudo defaults write /Library/Preferences/.GlobalPreferences MultipleSessionEnabled -bool false

# Desactive TimeMachien sur les nouveaux volumes
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

## Activation de debug dans utilitaire de disque
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
defaults write com.apple.DiskUtility advanced-image-options -bool true

## APPS

# Safari : menu développeur / URL en bas à gauche / URL complète en haut / Do Not Track / affichage barre favoris
defaults write com.apple.safari IncludeDevelopMenu -int 1
defaults write com.apple.safari ShowOverlayStatusBar -int 1
defaults write com.apple.safari ShowFullURLInSmartSearchField -int 1
defaults write com.apple.safari SendDoNotTrackHTTPHeader -int 1
defaults write com.apple.Safari ShowFavoritesBar -bool true

# Desactivation des miniatures safari
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

# Activation du retour arriére avec backspace safari
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true

# Photos : pas d'affichage pour les iPhone
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool YES

# TextEdit : .txt par défaut
defaults write com.apple.TextEdit RichText -int 0

## ************ Fin de l'installation *********
echo "Finder et Dock relancés… redémarrage nécessaire pour terminer."
killall Dock
killall Finder


echo "Derniers nettoyages…"
brew cleanup
rm -f -r /Library/Caches/Homebrew/*

echo "Installation terminée !"

# Active le trimeForce (Pour les SSD)
echo "Le trimeforce va etre activé pour votre SSD , un redemarage est requis, executez script post-cloud.sh aprés le redemarage"
trimforce enable
