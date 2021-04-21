# Telestion Application Template

This is a template for Telestion applications.
It helps you to set up the publishing of Telestion applications.
Dependencies to the [main repo](https://github.com/TelestionTeam/telestion) are included, too.

## Necessary Changes

* [ ] `settings.gradle` - set `rootProject.name`
* [ ] `Dockerfile` - replace `TelestionTemplate` in the CMD block by the new project's name (they must match exactly!)
* [ ] `build.gradle` - replace `group` by your group name (it is recommended to follow [Maven Central `groupId` naming conventions](https://maven.apache.org/guides/mini/guide-naming-conventions.html), i.e., beginning with the company url in reverse)
* [ ] `.github/workflows/publishImage.yml` - update `ORGANIZATION_OR_USER_NAME/REPO_NAME/IMAGE_NAME`. Here, `IMAGE_NAME` doesn't have to match the project's name, but has to follow the rules for Docker Image names, cf. https://docs.docker.com/docker-hub/repos/#creating-repositories.
* [ ] `conf/config.json` - adapt to fit your needs
* [ ] `src/main/java` - add your source code
* [ ] Update readme

## Example Project

A working example is provided in the [RocketSound repository](https://github.com/TelestionTeam/telestion-rocketsound).
