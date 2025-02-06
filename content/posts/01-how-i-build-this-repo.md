+++
title = "How I Built My Portfolio"
date = "2023-10-01"
description = "A brief overview of how I built my portfolio/blog website using Hugo and GitHub Actions."
tags = [
    "hugo",
    "github-actions",
    "portfolio",
    "devops"
]
categories = [
    "projects",
    "devops"
]
+++

# How I Built My Portfolio

In this post, I will walk you through how I built my portfolio website using Hugo, a static site generator, and automated the deployment process using GitHub Actions.

## Tools and Technologies

- **Hugo**: A fast and flexible static site generator.
- **GitHub Actions**: A CI/CD tool to automate the deployment process.
- **GitHub Pages**: A hosting service for static websites.

## Project Structure

The project structure is as follows:
```

.github/
workflows/
.gitignore
assets/
build/
content/
public/
themes/

hugo.toml

Makefile

README.md

````

## Setting Up Hugo

First, I set up Hugo by creating a new site and adding the `hugo-coder` theme:

```sh
hugo new site my-portfolio
cd my-portfolio
git submodule add https://github.com/luizdepra/hugo-coder.git themes/hugo-coder
````

I then configured the

hugo.toml

file to use the `hugo-coder` theme and added my personal information.

## Automating Deployment with GitHub Actions

To automate the deployment process, I created a GitHub Actions workflow in

main.yml

:

```yml
name: FTPS Deployment

on:
  push:
    branches: [main]

jobs:
  deploy:
    name: 🚀 Deploy
    runs-on: ubuntu-latest
    steps:
      - name: 🚚 Get latest code
        uses: actions/checkout@v4
        with:
          submodules: true
          fetch-depth: 0

      - name: 🤠 Setup Hugo
        uses: peaceiris/actions-hugo@v3
        with:
          hugo-version: "latest"
          extended: true

      - name: 🔨 Build
        run: hugo --minify

      - name: 🐛 Test SFTP Connection
        run: |
          sudo apt-get install -y lftp
          lftp -u "${{ secrets.FTP_USERNAME }},${{ secrets.FTP_PASSWORD }}" -e "set sftp:connect-program 'ssh -o StrictHostKeyChecking=no'; ls; bye" sftp://${{ secrets.FTP_HOST }}

      - name: 📦 Deploy via SFTP
        uses: Dylan700/sftp-upload-action@latest
        with:
          server: ${{ secrets.FTP_HOST }}
          username: ${{ secrets.FTP_USERNAME }}
          password: ${{secrets.FTP_PASSWORD}}
          port: 22
          uploads: |
            ./public => ./public_html/
```

This workflow checks out the latest code, sets up Hugo, builds the site, tests the SFTP connection, and deploys the site via SFTP.

### Configuring GitHub Repository Secrets

To securely store the FTP credentials, I configured GitHub Repository Secrets:

1. Navigate to your GitHub repository and click on "Settings".
2. Click on "Secrets and variables" in the left menu, then "Actions".
3. Add the following secrets:
    - `FTP_HOST`: The URL or IP address of your FTP server.
    - `FTP_USERNAME`: The username for FTP access.
    - `FTP_PASSWORD`: The password for FTP access.

## Conclusion

By using Hugo and GitHub Actions, I was able to create and deploy my portfolio website efficiently. The automation provided by GitHub Actions ensures that my site is always up-to-date with the latest changes.

You can check out the source code for my portfolio on [GitHub](https://github.com/alican-uelger/alican-uelger.com).

Feel free to reach out if you have any questions or suggestions!

---

**Ali Can Ülger**
