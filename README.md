# PHP Version Manager (phpvm)

`phpvm` is a command-line tool to manage multiple PHP versions on your Linux system, inspired by `nvm` for Node.js. It allows you to easily install, switch, list, and remove PHP versions.

## Features

- Install specific PHP versions or the latest version.
- Switch between installed PHP versions.
- List all installed PHP versions.
- Display the current active PHP version.
- Remove specific PHP versions.
- Remove all installed PHP versions.

## Installation

You can install `phpvm` using the one-liner command below:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/meer-sagor/phpvm/install_phpvm.sh)"

## Usage

### Install PHP

- **Install the latest PHP version:**
    ```bash
    phpvm install
    ```

- **Install a specific PHP version:**
    ```bash
    phpvm install <php-version>
    ```
    Example:
    ```bash
    phpvm install 7.4
    ```

### Switch PHP Version

- **Switch to a specific PHP version:**
    ```bash
    phpvm switch <php-version>
    ```
    Example:
    ```bash
    phpvm switch 8.0
    ```

### List Installed PHP Versions

- **List all installed PHP versions:**
    ```bash
    phpvm list
    ```

### Current PHP Version

- **Show the current active PHP version:**
    ```bash
    phpvm current
    ```

- **Remove a specific PHP version:**
    ```bash
    phpvm remove <php-version>
    ```
    Example:
    ```bash
    phpvm remove 7.4
    ```

### Remove All PHP Versions

- **Remove all installed PHP versions:**
    ```bash
    phpvm remove_all
    ```

## Notes

- This script uses the Ondřej Surý PPA for PHP versions. Make sure you have `sudo` privileges to install, switch, and remove PHP versions.
- After switching PHP versions, the script will attempt to restart Apache or Nginx services if they are installed and configured to use PHP.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request with your changes.

## License

This project is licensed under the MIT License.
