#!/usr/bin/env bash

function green_color() { echo "\033[0;32m\c"; }
function blue_color() { echo "\033[0;34m\c"; }
function reset_color() { echo "\033[0m\c"; }

function abort_if_prompted() {
  if [[ $1 != "y" ]]; then
    blue_color; echo "🙂 Alright then, another time maybe! 👋"; reset_color
    exit 1
  fi
}

function intro_message() {
  green_color
  echo "                                                                                "
  echo "                              __      __  _____ __                              "
  echo "                         ____/ /___  / /_/ __(_) /__  _____                     "
  echo "                        / __  / __ \/ __/ /_/ / / _ \/ ___/                     "
  echo "                      _/ /_/ / /_/ / /_/ __/ / /  __(__  )                      "
  echo "                     (_)__,_/\____/\__/_/ /_/_/\___/____/                       "
  echo "                                                                                "
  echo "                                 by @kplattret                                  "
  echo "                                                                                "
  blue_color
  echo "This script will guide you through installing your local development environment"
  echo "for Ruby on Rails and React applications, with Zsh, Git, Vim and other niceties."
  echo "Fear not, it will not install anything without asking you first!                "

  green_color; echo; read -p "✨ Shall we proceed with the installation? (y/N) " -n 1; echo
  abort_if_prompted $REPLY
}

function installation_commands() {
  emoji=$1; name=$2; condition=$3;

  blue_color; echo "\n$emoji Trying to detect installed $name..."

  if ! [[ $(eval $condition) ]]; then
    blue_color; echo "$emoji Looks like we don't have it, but it's needed for our setup."

    green_color; read -p "$emoji Shall we install $name? (y/N) " -n 1; echo
    abort_if_prompted $REPLY

    shift 3
    while test $# -gt 1; do
      blue_color; echo "$emoji $1"
      eval $2
      shift 2
    done

    blue_color; echo "$emoji $name installed successfully! 🎉"
  else
    blue_color; echo "$emoji Looks like we already have it! Moving on."
  fi

  reset_color; sleep 1
}

function installation_files() {
  emoji=$1; name=$2; kind=$3; app=$4;

  green_color; echo; read -p "$emoji Shall we install the $name $kind? (y/N) " -n 1; echo

  if [[ $REPLY == "y" ]]; then
    blue_color; echo "$emoji $app will open in 5 seconds. Install the $kind and close the app."
    sleep 5

    shift 4
    while test $# -gt 0; do
      open -W $1
      shift
    done

    blue_color; echo "$emoji $name $kind installed successfully! 🎉"
  else
    blue_color; echo "$emoji Skipping $name $kind installation."
  fi

  reset_color; sleep 1
}


# The script starts here
intro_message

installation_commands "🍏" "Command Line Tools" "xcode-select -p"\
  "Installing Command Line Tools..."\
  "xcode-select --install"

installation_commands "🍺" "Homebrew" "which brew"\
  "Installing Homebrew..."\
  'ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"'\
  "Updating Homebrew, upgrading packaging and verifying installation..."\
  "brew update && brew upgrade && brew cleanup && brew doctor"

installation_commands "🐚" "Zsh and Oh My Zsh" "which zsh"\
  "Installing Zsh..."\
  "brew install zsh zsh-completions"\
  "Setting Zsh as default shell..."\
  "chsh -s /bin/zsh"\
  "Installing Oh My Zsh..."\
  'sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"'

installation_commands "🔑" "SSH keys" 'ls ~/.ssh/ | grep "id_rsa.pub\|id_rsa\b"'\
  "Your ~/.ssh folder will open in 5 seconds. Add your keys and come back here."\
  "sleep 5; open ~/.ssh"\
  "Waiting for your keys..."\
  "until [[ -f ~/.ssh/id_rsa && -f ~/.ssh/id_rsa.pub ]]; do sleep 5; done; open -a Terminal.app"

installation_commands "📦" "Git and Vim" 'brew list | grep "git\|vim"'\
  "Installing Git..."\
  "brew install git"\
  "Installing Vim"\
  "brew install vim"\
  "Installing Z and the Silver Searcher..."\
  "brew install z the_silver_searcher"

installation_commands "📺" "iTerm" "ls /Applications/ | grep iTerm.app"\
  "Installing iTerm..."\
  "brew cask install iterm2"

installation_files "🎨" "One Dark" "color-scheme" "iTerm"\
  "./iterm/one-dark.itermcolors"

installation_files "🔠" "Menlo" "font-family" "Font Book"\
  "./iterm/menlo-powerline.ttf"\
  "./iterm/menlo-powerline-bold.ttf"\
  "./iterm/menlo-powerline-italic.ttf"\
  "./iterm/menlo-powerline-bold-italic.ttf"

blue_color; echo "\n😃 All done – happy coding! 🚀\n"; reset_color

unset -f green_color blue_color reset_color\
  intro_message installation_commands installation_files

exit 0
