# Telestion Application Template

This is a template for Telestion applications.
It helps you to set up the publishing of Telestion applications.
Dependencies to the [main repo](https://github.com/wuespace/telestion-core) are included, too.

## Initialization

Please go to the _Actions_ Tab in the GitHub UI and choose the `Initialize` Action.
Then click `Run workflow` and enter your preferences like so:

![Screenshot_20210426_221738](https://user-images.githubusercontent.com/52416718/116158314-f991d780-a6dd-11eb-9961-0a80ce9b7950.png)

> It is recommended to follow [Maven Central `groupId` naming conventions](https://maven.apache.org/guides/mini/guide-naming-conventions.html),
> e.g. beginning with the company url in reverse.

Let GitHub Actions initialize your project.

## Additional Changes

- [ ] `conf/config.json` - adapt to fit your needs
- [ ] `src/main/java` - add your source code
- [ ] install the Telestion Client PSC (see [`client/README.md`](client/README.md) for further information)
- [ ] update the README

## Example Project

A working example is provided in the [RocketSound repository](https://github.com/wuespace/telestion-rocketsound).
