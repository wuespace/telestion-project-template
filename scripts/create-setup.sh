#!/bin/sh

# Creates a setup zip file for the current release.
# (c) WüSpace e. V.

REAL_PATH="$(realpath "$0")"
SCRIPT_DIR="$(dirname "$REAL_PATH")"
SCRIPT_NAME="$(basename "$REAL_PATH")"

. "${SCRIPT_DIR}/env.sh"

BANNER="Telestion Project Setup Generator (POSIX) $VERSION
(c) WüSpace e. V."

HELP_TEXT="$BANNER

A POSIX script to create a setup zip file contains the necessary files to deploy
a Telestion application on a production server.

Usage: $SCRIPT_NAME <options>
Options:
    -m, --tmp-dir <path>    path to the temporary directory the creator should use
    -t, --tag <tag>         the tag to use during packaging (e.g. v0.8.1)
    -n, --repo-name <name>  name of the Git repository
    -h, --help              print this help
    --version               print the version number of this tool

Exit codes:
   1 generic error code
   2 no terminal connected, cannot ask interactively for information
   3 project is not initialized
"

# parse arguments
while [ "$#" -gt 0 ]; do
  case "$1" in
    -m|--tmp-dir)
      if [ "$#" -lt 2 ]; then
        printf 'Path required\n'
        exit 1
      fi
      tmp_dir="$2"
      shift
      ;;
    -t|--tag)
      if [ "$#" -lt 2 ]; then
        printf 'Tag required\n'
        exit 1
      fi
      tag="$2"
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

if ! [ -f "$LOCK_FILE" ]; then
  error 'Project is not yet initialized, use the "initialize.sh" script and try again' 3
fi

# banner+version
printf "${CL_BLD}%s${CL_RST}\n\n" "$BANNER"

section 'Configuration'
# ask user on missing but required arguments
if [ -z "$tmp_dir" ]; then
  tmp_dir="/tmp/telestion"
fi
step "Temporary directory: $tmp_dir"

if [ -z "$tag" ]; then
  tag="v$(cat "$PROJECT_ROOT/version.txt")"
fi
step "Tag: $tag"

if [ -z "$repo_name" ]; then
  repo_name="$(get_git_repo_name)"
fi
step "Repository name: $repo_name"

# startup
old_cwd="$(pwd)"
cd "$PROJECT_ROOT" || {
  error "Cannot change into project root directory: $PROJECT_ROOT" 1
}

# create temporary directory and copy stuff
FILES="$PROJECT_ROOT/application/docker-compose.prod.yml
$PROJECT_ROOT/application/conf
$PROJECT_ROOT/application/data"
setup_dir="$tmp_dir/$repo_name-$tag"

section "Prepare setup directory"

step "Create output directory"
mkdir -p "$PROJECT_ROOT/build"

if [ -e "$setup_dir" ]; then
  step "Remove existing temporary directory"
  rm -r "$setup_dir"
fi

step "Create temporary directory: $setup_dir"
mkdir -p "$setup_dir"

for file in $FILES; do
  if [ -e "$file" ]; then
    step "Copy $file"
    cp -r "$file" "$setup_dir/"
  else
    step "${CL_YEL}WARNING:${CL_RST} ${CL_BLD}$file does not exist"
  fi
done

step "Move docker-compose.prod.yml -> docker-compose.yml"
mv "$setup_dir/docker-compose.prod.yml" "$setup_dir/docker-compose.yml"

PATTERN="##TAG##"
version="$(printf '%s\n' "$tag" | cut -c2-)"
step "Insert version into docker-compose.yml: $version"
sed -i "s/$PATTERN/${version}/g" "$setup_dir/docker-compose.yml"

section "Finalization"
cd "$tmp_dir" || {
  error "Cannot change into temporary directory: $tmp_dir"
}
step "Compress setup"
zip -r "$setup_dir.zip" "$setup_dir"
cd "$PROJECT_ROOT" || {
  error "Cannot change into project root directory: $PROJECT_ROOT" 1
}

if [ -f "$PROJECT_ROOT/build/$repo_name-$tag.zip" ]; then
  step "${CL_YEL}WARNING:${CL_RST} ${CL_BLD}Setup file already exist. Overwriting"
fi
step "Move compressed setup"
mv -f "$setup_dir.zip" "$PROJECT_ROOT/build/"

# appendix
APPENDIX="${CL_BLD}The setup has been successfully built. You can find it under:

  ${CL_YEL}build/$repo_name-$tag.zip${CL_RST}

${CL_BLD}Copy it to your production system and extract it with:

  ${CL_MGN}unzip $repo_name-$tag.zip

${CL_CYA}Telestion${CL_RST}${CL_BLD} wishes you happy monitoring!${CL_RST}
"

printf '\n%s\n' "$APPENDIX"

# shutdown
cd "$old_cwd" || {
  error "Cannot switch back to initial current working directory: $old_cwd, exiting uncleanly" 1
}
