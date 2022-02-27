#!/bin/sh

VERSION="0.1"

PROJECT_ROOT="$(realpath "$(dirname "$REAL_PATH")/..")"
LOCK_FILE="$PROJECT_ROOT/.github/initialized"

if tput colors > /dev/null 2>&1; then
  CL_RST="$(tput sgr0)"
  CL_BLD="$(tput bold)"
  CL_RED="$(tput setaf 1)"
  CL_GRN="$(tput setaf 2)"
  CL_YEL="$(tput setaf 3)"
  CL_BLU="$(tput setaf 4)"
  CL_MGN="$(tput setaf 5)"
  CL_CYA="$(tput setaf 6)"
else
  CL_RST=""
  CL_BLD=""
  CL_RED=""
  CL_GRN=""
  CL_YEL=""
  CL_BLU=""
  CL_MGN=""
  CL_CYA=""
fi

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

  user="$(git remote get-url "$remote" | awk -F "/" '{print $(NF-1)}' | awk -F ":" '{print $NF}')"
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

  name="$(git remote get-url "$remote" | awk -F "/" '{print $NF}' | cut -d"." -f1)"
  printf '%s\n' "$name"
}
