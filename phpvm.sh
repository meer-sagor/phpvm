#!/bin/bash

PHP_PPA="ppa:ondrej/php"
PHP_VERSIONS_DIR="/usr/bin/php"

function add_php_repository() {
    if ! grep -q "^deb .*ondrej/php" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
        sudo add-apt-repository -y "$PHP_PPA"
        sudo apt update
    fi
}

function get_latest_php_version() {
    add_php_repository
    sudo apt update >/dev/null 2>&1
    local latest_version
    latest_version=$(apt-cache search php | grep -oP '^php[0-9]+\.[0-9]+' | sort -V | tail -1 | grep -oP '[0-9]+\.[0-9]+')
    echo "$latest_version"
}

function install_php_version() {
    local version=$1
    if [[ -z "$version" ]]; then
        version=$(get_latest_php_version)
        echo "No PHP version specified. Installing the latest version: PHP $version."
    fi

    add_php_repository
    sudo apt install -y "php$version" "php$version-fpm" "php$version-cli" "php$version-common"

    if [[ $? -eq 0 ]]; then
        echo "PHP $version installed successfully."
    else
        echo "Failed to install PHP $version."
        return 1
    fi
}

function switch_php_version() {
    local version=$1
    if [[ -z "$version" ]]; then
        echo "Usage: $0 switch <php-version>"
        return 1
    fi

    local php_bin="/usr/bin/php$version"
    if [[ ! -f "$php_bin" ]]; then
        echo "PHP version $version is not installed."
        return 1
    fi

    sudo update-alternatives --set php "$php_bin"

    # For Apache
    if [[ -d /etc/apache2 ]]; then
        sudo a2dismod php* >/dev/null 2>&1
        sudo a2enmod "php$version"
        sudo systemctl restart apache2
    fi

    # For Nginx with PHP-FPM
    if [[ -d /etc/nginx ]]; then
        sudo systemctl disable php*-fpm >/dev/null 2>&1
        sudo systemctl enable "php$version-fpm"
        sudo systemctl restart nginx
    fi

    echo "Switched to PHP $version."
}

function current_php_version() {
    php -v | head -n 1 | awk '{print $2}'
}

function list_installed_php_versions() {
    # ls -1 /usr/bin/php* | grep -oP 'php[0-9]+\.[0-9]+' | sort -u
    # dpkg --get-selections | grep -oP '^php[0-9]+\.[0-9]+' | sort -u
    dpkg-query -W -f='${binary:Package}\n' | grep -oP '^php[0-9]+\.[0-9]+' | sort -u
}

function remove_php_version() {
    local version=$1
    if [[ -z "$version" ]]; then
        echo "Usage: phpvm remove <php-version>"
        return 1
    fi

    local php_packages=("php$version" "php$version-fpm" "php$version-cli" "php$version-common")

    for package in "${php_packages[@]}"; do
        if ! dpkg -l "$package" &>/dev/null; then
            echo "PHP version $version is not installed."
            return 1
        fi
    done

    sudo apt purge -y "${php_packages[@]}"
    sudo apt autoremove -y

    echo "PHP version $version has been removed."
}

function remove_all_php_versions() {
    local versions
    versions=$(list_installed_php_versions)

    if [[ -z "$versions" ]]; then
        echo "No PHP versions are installed."
        return 0
    fi

    for version in $versions; do
        sudo apt purge -y "$version" "${version}-fpm" "${version}-cli" "${version}-common"
    done

    sudo apt autoremove -y
    echo "All PHP versions have been removed."
}

function show_usage() {
    echo "Usage: phpvm <command> [<args>]"
    echo
    echo "Commands:"
    echo "  install [<php-version>]   Install the specified PHP version or the latest version if not specified"
    echo "  switch <php-version>      Switch to the specified PHP version"
    echo "  list                      List all installed PHP versions"
    echo "  current                   Show the current active PHP version"
    echo "  remove <php-version>      Remove the specified PHP version"
    echo "  remove_all                Remove all installed PHP versions"
}

case "$1" in
install)
    install_php_version "$2"
    ;;
switch)
    switch_php_version "$2"
    ;;
list)
    list_installed_php_versions
    ;;
current)
    current_php_version
    ;;
remove)
    remove_php_version "$2"
    ;;
remove_all)
    remove_all_php_versions
    ;;
*)
    show_usage
    ;;
esac
