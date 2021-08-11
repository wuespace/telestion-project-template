# Telestion Application Template

This is a template for Telestion applications.
It helps you to set up the publishing of Telestion applications.
Dependencies to the [main repo](https://github.com/wuespace/telestion-core) are included, too.

## Initialization

Please go to the _Actions_ Tab in the GitHub UI and choose the `Initialize` Action.
Then click `Run workflow` and enter your preferences like so:

![Screenshot_20210427_091359](https://user-images.githubusercontent.com/52416718/116217289-01329a00-a739-11eb-811a-08bee30de8b7.png)

> It is recommended to follow [Maven Central `groupId` naming conventions](https://maven.apache.org/guides/mini/guide-naming-conventions.html),
> e.g. beginning with the company url in reverse.

Let GitHub Actions initialize your project.

## Additional Changes

- [ ] `conf/config.json` - adapt to fit your needs
- [ ] `src/main/java` - add your source code
- [ ] install the Telestion Client PSC (see [`client/README.md`](client/README.md) for further information)
- [ ] update the README (remove the Initialization and this section)

## Example Project

Good example projects are:
- [RocketSound Project](https://github.com/wuespace/telestion-project-rocketsound)
- [Daedalus2 Project](https://github.com/wuespace/telestion-project-daedalus2)

## Installation

### The Application

To set up the Telestion Application, please go to the latest release of the project
and download the `##REPO_NAME##-vX.X.X.zip`:
https://github.com/##REPO_USER##/##REPO_NAME##/releases/latest

Extract it with your favorite archiver.

Start the application with `docker-compose`.
Type in your terminal:

```shell
docker-compose up -d
```

and `docker-compose` does the rest for you. :wink:

When you want to stop the Application, call:

```
docker-compose down
```

## Building

 To build the projects from source,
 please take a look into the part specific descriptions:

 - [Application](./application/README.md)
 - [Client](./client/README.md)

## This repository

The overall file structure of this monorepo looks like this:

```
.
├── .github
│   ├── workflows (CI configuration)
│   └── dependabot.yml (Dependabot config)
├── application
|   ├── conf (the verticle configuration for the Application)
|   ├── src (the source files of the Telestion Application)
|   ├── Dockerfile (the definition to successfully build a Docker image from the compiled Application sources)
|   ├── build.gradle (manages dependencies and the build process via Gradle)
|   ├── gradle.properties (contains the required tokens to access required dependencies)
|   ├── gradlew (the current gradle executable for UNIX-based systems)
|   └── gradlew.bat (the current gradle executable for Windows systems)
├── client
|   ├── public (template webpage folder where React will engage)
|   ├── src (the source files of the Telestion Client)
|   └── package.json (manages dependencies and the build process via npm)
├── CHANGELOG.md (DON'T TOUCH! Automatically generated Changelog)
├── README.md (you're here :P)
├── project.json (contains the current project information like the current version etc.)
└── telestion-application (DON'T TOUCH! Used as an indicator for our automation tools)
```

**The [Application](./application/README.md) and the [Client](./client/README.md) folders contain their own `README.md` that describe the different parts more specific.**

 ### Contributing

 For the documentation on contributing to this repository, please take a look at the [Contributing Guidelines](./CONTRIBUTING.md).

 ## Contributors

Thank you to all contributors of this repository:

[![Contributors](https://contrib.rocks/image?repo=wuespace/telestion-project-daedalus2)](https://github.com/wuespace/telestion-project-daedalus2/graphs/contributors)

Made with [contributors-img](https://contrib.rocks).

## About

Running [Telestion](https://telestion.wuespace.de/), a project by [WüSpace e.V.](https://www.wuespace.de/).
