#!/bin/sh

VERSION="0.1"

# Script to initialize the Telestion Project.
# Run it with your preferred shell.
# (c) WüSpace e. V.

REAL_PATH="$(realpath "$0")"
PROJECT_ROOT="$(realpath "$(dirname "$REAL_PATH")/..")"
SCRIPT_NAME="$(basename "$REAL_PATH")"
LOCK_FILE="$PROJECT_ROOT/.github/initialized"

CL_RST="$(tput sgr0)"
CL_BLD="$(tput bold)"
CL_RED="$(tput setaf 1)"
CL_GRN="$(tput setaf 2)"
CL_YEL="$(tput setaf 3)"
CL_BLU="$(tput setaf 4)"
CL_MGN="$(tput setaf 5)"
CL_CYA="$(tput setaf 6)"

BANNER="Telestion Project Initializer (POSIX) $VERSION
(c) WüSpace e. V."

HELP_TEXT="$BANNER

A POSIX script to initialize your Telestion Project.

Usage: $SCRIPT_NAME <options>
Options:
    -g, --gradle-group-name <name>  the Gradle Group Name to use
    -u, --repo-user-name <name>     name of the user that owns the Git repository
    -n, --repo-name <name>          name of the Git repository
    -h, --help                      print this help
    --version                       print the version number of this tool

Exit codes:
   1 generic error code
   2 no terminal connected, cannot ask interactively for information
   3 project is already initialized
"

APPENDIX="${CL_BLD}The project has been successfully initialized.
Please commit the changes and push them to your remote:

  ${CL_MGN}git add .
  git commit -m \"feat: Initialize project\"
  git push

${CL_CYA}Telestion${CL_RST}${CL_BLD} wishes you happy hacking!${CL_RST}
"

# $1 - error message
# $2 - exit code
error() {
  msg="$1"
  exit_code="$2"

  printf "${CL_BLD}${CL_RED}==> ERROR:${CL_RST} ${CL_BLD}%s${CL_RST}\n" "$msg"
  exit "$exit_code"
}

# $1 - section name
section() {
  name="$1"
  printf "${CL_BLD}${CL_GRN}==>${CL_RST} ${CL_BLD}%s${CL_RST}\n" "$name"
}

# $1 - step name
# $2 - when set no LF
step() {
  name="$1"
  if [ -z "$2" ]; then
    printf "   ${CL_BLD}${CL_BLU}->${CL_RST} ${CL_BLD}%s${CL_RST}\n" "$name"
  else
    printf "   ${CL_BLD}${CL_BLU}->${CL_RST} ${CL_BLD}%s${CL_RST}" "$name"
  fi
}

get_git_repo_user() {
  if ! git status > /dev/null 2>&1; then
    error 'Not in a git repository. Specify repository user manually with \"--repo-user-name <name>\" or create a repository with \"git init\"' 2
  fi
  # first remote wins
  remote="$(git remote show 2> /dev/null | head -n 1)"
  if [ -z "$remote" ]; then
    error "Git repository doesn\'t contain a remote. Specify repository user manually with \"--repo-user-name <name>\" or set a remote with \"git remote add <name> <url>\"" 2
  fi

  user="$(git remote get-url "$remote" | cut -d":" -f2- | cut -d"/" -f1)"
  printf '%s\n' "$user"
}

get_git_repo_name() {
  if ! git status > /dev/null 2>&1; then
    error 'Not in a git repository. Specify repository user manually with \"--repo-user-name <name>\" or create a repository with \"git init\"' 2
  fi
  # first remote wins
  remote="$(git remote show 2> /dev/null | head -n 1)"
  if [ -z "$remote" ]; then
    error "Git repository doesn\'t contain a remote. Specify repository user manually with \"--repo-user-name <name>\" or set a remote with \"git remote add <name> <url>\"" 2
  fi

  name="$(git remote get-url "$remote" | cut -d"/" -f2- | cut -d"." -f1)"
  printf '%s\n' "$name"
}

# parse arguments
while [ "$#" -gt 0 ]; do
  case "$1" in
    -g|--gradle-group-name)
      if [ "$#" -lt 2 ]; then
        printf 'Name required\n'
        exit 1
      fi

      gradle_group_name="$2"
      shift
      ;;
    -u|--repo-user-name)
      if [ "$#" -lt 2 ]; then
        printf 'Name required\n'
        exit 1
      fi

      repo_user_name="$2"
      shift
      ;;
    -n|--repo-name)
      if [ "$#" -lt 2 ]; then
        printf 'Name required\n'
        exit 1
      fi

      repo_name="$2"
      shift
      ;;
    -h|--help)
      printf '%s\n' "$HELP_TEXT"
      exit 0
      ;;
    --version)
      printf '%s\n' "$VERSION"
      exit 0
      ;;
    *)
      printf 'Unknown option: %s\n' "$1"
      exit 1
      ;;
  esac
  shift
done

# banner + version
printf "${CL_BLD}%s${CL_RST}\n\n" "$BANNER"

if [ -f "$LOCK_FILE" ]; then
  error 'Project is already initialized' 3
fi

section 'Configuration'
# ask user on missing but required arguments
if [ -z "$gradle_group_name" ]; then
  if ! [ -t 0 ]; then
    error 'No terminal connected, cannot ask interactively for Gradle Group Name' 2
  fi

  step 'Gradle Group Name (e.g. de.wuespace.telestion.project.playground): ' no-lf
  read -r gradle_group_name
else
  step "Gradle Group Name: $gradle_group_name"
fi

if [ -z "$repo_user_name" ]; then
  repo_user_name="$(get_git_repo_user)"
fi
step "Repository user: $repo_user_name"

if [ -z "$repo_name" ]; then
  repo_name="$(get_git_repo_name)"
fi
step "Repository name: $repo_name"

# startup
old_cwd="$(pwd)"
cd "$PROJECT_ROOT" || {
  error "Cannot change into project root directory: $PROJECT_ROOT" 1
}

# repository user
PATTERN="##REPO_USER##"
FILES="$PROJECT_ROOT/application/docker-compose.yml
$PROJECT_ROOT/application/docker-compose.prod.yml
$PROJECT_ROOT/README.md"

section "Insert repository user: $PATTERN -> $repo_user_name"

for file in $FILES; do
  step "Update $file"
  sed -i "s/$PATTERN/${repo_user_name}/g" "$file"
done

# repository name
PATTERN="##REPO_NAME##"
FILES="$PROJECT_ROOT/.github/workflows/release.yml
$PROJECT_ROOT/application/docker-compose.yml
$PROJECT_ROOT/application/docker-compose.prod.yml
$PROJECT_ROOT/application/Dockerfile
$PROJECT_ROOT/application/settings.gradle
$PROJECT_ROOT/README.md"

section "Insert repository name: $PATTERN -> $repo_name"

for file in $FILES; do
  step "Update $file"
  sed -i "s/$PATTERN/${repo_name}/g" "$file"
done

# gradle group name
PATTERN="##GROUP_ID##"
FILES="$PROJECT_ROOT/application/build.gradle"

section "Insert Gradle Group Name: $PATTERN -> $gradle_group_name"

for file in $FILES; do
  step "Update $file"
  sed -i "s/$PATTERN/${gradle_group_name}/g" "$file"
done

# application folder structure
SRC_DIR="$PROJECT_ROOT/application/src/main/java"
FILES="$SRC_DIR/SimpleVerticle.java"
main_package_dir="$SRC_DIR/$(echo "$gradle_group_name" | sed -e 's/\./\//g')"

section "Generate Application source files"

step "Create folder path: $main_package_dir"
mkdir -p "$main_package_dir"

for file in $FILES; do
  step "Move $file"
  mv "$file" "$main_package_dir/"
  step "Attach package path to Java source"
  sed -i "1s/^/package ${gradle_group_name};\n\n/" "$main_package_dir/$(basename "$file")"
done

# locking
section "Lock project"
printf 'This project was initialized with Github Actions\n' > "$LOCK_FILE"

# appendix
printf '\n%s\n' "$APPENDIX"

# shutdown
cd "$old_cwd" || {
  error "Cannot switch back to initial current working directory: $old_cwd, exiting uncleanly" 1
}
