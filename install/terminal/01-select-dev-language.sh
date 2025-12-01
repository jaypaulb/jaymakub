#!/bin/bash

# Install default programming languages
if [[ -v OMAKUB_FIRST_RUN_LANGUAGES ]]; then
  languages=$OMAKUB_FIRST_RUN_LANGUAGES
else
  AVAILABLE_LANGUAGES=("Node.js" "Go" "Python" "Java" "C++" "Flutter" "Ruby on Rails" "PHP" "Elixir" "Rust")
  languages=$(gum choose "${AVAILABLE_LANGUAGES[@]}" --no-limit --height 12 --header "Select programming languages")
fi

if [[ -n "$languages" ]]; then
  for language in $languages; do
    case $language in
    Ruby)
      mise use --global ruby@latest
      mise settings add idiomatic_version_file_enable_tools ruby
      mise x ruby -- gem install rails --no-document
      ;;
    Node.js)
      mise use --global node@lts
      ;;
    Go)
      mise use --global go@latest
      ;;
    PHP)
      sudo apt -y install php php-{curl,apcu,intl,mbstring,opcache,pgsql,mysql,sqlite3,redis,xml,zip} --no-install-recommends
      php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
      php composer-setup.php --quiet && sudo mv composer.phar /usr/local/bin/composer
      rm composer-setup.php
      ;;
    Python)
      mise use --global python@latest
      ;;
    Elixir)
      mise use --global erlang@latest
      mise use --global elixir@latest
      mise x elixir -- mix local.hex --force
      ;;
    Rust)
      bash -c "$(curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs)" -- -y
      ;;
    Java)
      mise use --global java@latest
      ;;
    C++)
      sudo apt install -y build-essential g++ cmake gdb
      ;;
    Flutter)
      if [[ ! -d "$HOME/.flutter" ]]; then
        git clone https://github.com/flutter/flutter.git -b stable "$HOME/.flutter"
        echo 'export PATH="$PATH:$HOME/.flutter/bin"' >> "$HOME/.bashrc"
        export PATH="$PATH:$HOME/.flutter/bin"
        flutter precache
        flutter doctor
      fi
      ;;
    esac
  done
fi
