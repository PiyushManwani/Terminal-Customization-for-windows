# terminal-windows-customization

A collection of configuration files, color schemes, themes, keybindings, scripts, and tools for customizing Windows Terminal. The goal is to provide a well-organized, ready-to-use setup that makes the terminal visually appealing and more productive.

---

## Repository Structure

```
terminal-windows-customization/
├── color-schemes/      # JSON color scheme definitions
├── config/             # Base configuration files
├── configs/            # Named theme configuration files
├── docs/               # Documentation and guides
├── keybindings/        # Custom keybinding definitions
├── presets/            # Ready-to-use terminal presets
├── scripts/            # Utility and validation scripts
└── tools/              # Helper tools
```

---

## Getting Started

### Prerequisites

- Windows 10 or Windows 11
- [Windows Terminal](https://aka.ms/terminal) installed
- PowerShell 5.1 or later (PowerShell 7+ recommended)

### Installation

1. Clone the repository:

   ```powershell
   git clone https://github.com/PiyushManwani/terminal-windows-customization.git
   cd terminal-windows-customization
   ```

2. Choose a theme from the `configs/` folder and copy the contents into your Windows Terminal `settings.json`.

   The settings file is typically located at:

   ```
   C:\Users\<username>\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
   ```

3. Copy the desired color scheme from `color-schemes/` into the `schemes` array in your `settings.json`.

4. Apply any keybindings from the `keybindings/` folder by merging them into the `keybindings` section of your `settings.json`.

5. To validate all JSON files before applying, run:

   ```powershell
   .\scripts\validate-json.ps1
   ```

---

## Features

- Multiple pre-built color schemes
- Named theme configurations for different use cases and preferences
- Custom keybinding profiles
- Ready-to-apply terminal presets
- PowerShell and Lua utility scripts
- JSON validation script to catch errors before applying changes

---

## Usage

### Applying a Theme

1. Open `configs/` and pick a theme configuration (e.g., `my-theme.json`).
2. Merge the relevant sections into your `settings.json`.
3. Restart Windows Terminal.

### Using a Color Scheme

1. Open `color-schemes/` and select a scheme.
2. Add its contents to the `schemes` array in `settings.json`.
3. Set `"colorScheme": "<scheme-name>"` in the profile you want to use it with.

### Using Presets

The `presets/` folder contains complete, ready-to-use configurations. These can be applied directly to `settings.json` with minimal modification.

---

## Contributing

Contributions are welcome. Please read [CONTRIBUTING.md](CONTRIBUTING.md) before submitting a pull request.

### Adding a New Theme

1. Create the config file at `configs/my-theme.json`.
2. Create the matching color scheme at `color-schemes/my-theme.json`.
3. Update this README with a brief description or preview.
4. Submit a pull request.

### Code Style

- Format all JSON with proper indentation (4 spaces).
- Include comments for non-obvious settings where the format supports it.
- Validate all JSON at [jsonlint.com](https://jsonlint.com/) or using the provided script before submitting.

### Reporting Issues

Use GitHub Issues to report bugs, request features, or suggest documentation improvements. Label your issue appropriately: Bug, Enhancement, or Documentation.

---

## License

This project is licensed under the MIT License. See the [licence](licence) file for details.
