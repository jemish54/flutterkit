# Flutterkit

[![Pub Version](https://img.shields.io/pub/v/flutterkit)](https://pub.dev/packages/flutterkit)
[![GitHub License](https://img.shields.io/github/license/jemish54/flutterkit)](https://github.com/jemish54/flutterkit/blob/main/LICENSE)

## Overview

`flutterkit` is a command-line tool designed to streamline the process of creating Flutter projects by using custom templates hosted on GitHub. With this tool, users can quickly generate boilerplate Flutter app source code from their own pre-configured templates, allowing for fast and easy project setup.

## Features

- **Boilerplate Generation**: Quickly generate a Flutter project using your own template hosted on GitHub.
- **Customizable Templates**: Create and maintain your own Flutter project structure and code, then upload it to GitHub. The CLI allows you to reuse this template for future projects.
- **Seamless GitHub Integration**: The CLI fetches the template from your GitHub repository via a URL, ensuring your project is always up-to-date with your latest code.

## Installation

To install `flutterkit`, run the following command:

```bash
dart pub global activate flutterkit
```

Ensure that the Dart SDK is installed on your machine. If not, follow the instructions on [Dart's official website](https://dart.dev/get-dart).

## Usage

1. **Create a GitHub Repository for Your Template:**
   - Set up a Flutter project with your desired files ans folder using mustache syntax (There is a specific folder structure for templating) and boilerplate code or use my [template](https://github.com/jemish54/flutterkit_template) for demo as well as example.
   - You can set your own variables in flutterkit.yml file.
2. **Use the CLI to Generate a New Project:**

   ```bash
   flutterkit create <title> --org <org> --url <your_github_repo_url>
   ```

   Replace `<your_github_repo_url>` with the GitHub URL where your template is hosted.

   Example:

   ```bash
   flutterkit create example --url https://github.com/jemish54/flutterkit_template
   ```

3. **Start Building Your Project**:
   After running the command, the CLI will download your template, apply it to a new Flutter project, and set up the project with your custom boilerplate code.

## Example Workflow

1. Push your customized Flutter project to a GitHub repository:

   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/your_username/your_template_repo.git
   git push -u origin main
   ```

2. Run the `flutterkit` to generate a new project:

   ```bash
   flutterkit create <title_for_project> --url https://github.com/your_username/your_template_repo
   ```

3. Open the generated project in your IDE and start building your app.

## Contributions

Contributions are welcome! If you would like to contribute to this project, feel free to open a pull request or file an issue on the [GitHub repository](https://github.com/jemish54/flutterkit).

## License

This project is licensed under the MIT License. See the [LICENSE](https://github.com/jemish54/flutterkit/blob/main/LICENSE) file for details.

---

Feel free to customize the repository links and any additional details specific to your package. This should give your users clear guidance on how to install, use, and contribute to your package.
