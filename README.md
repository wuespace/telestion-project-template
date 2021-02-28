# template-telestion-application

This is a template for Telestion applications.
It helps you to set up the publishing of Telestion applications.
Dependencies to the [main repo](https://github.com/TelestionTeam/telestion) are included, too.

# Necessary Changes

1. `settings.gradle` - set `rootProject.name`.
2. `Dockerfile` - replace `TelestionTemplate` in the CMD block by the new project name 
3. `build.gradle` - replace `group` by your group name
4. `.github/workflows/publishImage.yml` - update `ORGANIZATION_OR_USER_NAME/REPO_NAME/IMAGE_NAME`
5. `conf/config.json` - adapt to fit your needs
6. `src/main/java` - add your source code

# Example Project

A working example is provided in the [RocketSound repository](https://github.com/TelestionTeam/telestion-rocketsound).
