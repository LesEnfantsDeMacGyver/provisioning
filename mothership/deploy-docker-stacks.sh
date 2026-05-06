#!/bin/bash
set -Eeuo pipefail

TARGET="${1:-pi@192.168.64.5}"
REPO_URL="${DOCKER_STACKS_REPO_URL:-https://github.com/LesEnfantsDeMacGyver/docker_stacks.git}"
BRANCH="${DOCKER_STACKS_BRANCH:-main}"
REMOTE_DIR="${DOCKER_STACKS_REMOTE_DIR:-/home/pi/docker_stacks}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_ENV_FILE="$(cd "${SCRIPT_DIR}/../.." && pwd)/docker_stacks/.env"
ENV_FILE="${DOCKER_STACKS_ENV_FILE:-${DEFAULT_ENV_FILE}}"

if [ ! -f "${ENV_FILE}" ]; then
    echo "Missing env file: ${ENV_FILE}" >&2
    echo "Set DOCKER_STACKS_ENV_FILE=/path/to/.env or run this from the EMG workspace layout." >&2
    exit 1
fi

ssh_target() {
    ssh -o StrictHostKeyChecking=accept-new "${TARGET}" "$@"
}

copy_env_file() {
    ssh_target "mkdir -p '${REMOTE_DIR}'"
    scp -o StrictHostKeyChecking=accept-new "${ENV_FILE}" "${TARGET}:${REMOTE_DIR}/.env"
}

echo "Deploying docker_stacks to ${TARGET}:${REMOTE_DIR}"

copy_env_file

ssh_target REPO_URL="${REPO_URL}" BRANCH="${BRANCH}" REMOTE_DIR="${REMOTE_DIR}" 'bash -s' <<'REMOTE'
set -Eeuo pipefail

if ! command -v git >/dev/null 2>&1; then
    sudo apt-get update -y
    sudo apt-get install -y git
fi

set -a
. "${REMOTE_DIR}/.env"
set +a

if [ -n "${GITHUB_TOKEN:-}" ]; then
    askpass="$(mktemp)"
    cat >"${askpass}" <<'ASKPASS'
#!/bin/sh
case "$1" in
    *Username*) printf '%s\n' "x-access-token" ;;
    *Password*) printf '%s\n' "${GITHUB_TOKEN}" ;;
    *) printf '\n' ;;
esac
ASKPASS
    chmod 700 "${askpass}"
    export GIT_ASKPASS="${askpass}"
    export GIT_TERMINAL_PROMPT=0
fi

if [ -d "${REMOTE_DIR}/.git" ]; then
    cd "${REMOTE_DIR}"
    git fetch --prune origin
    git checkout "${BRANCH}"
    git reset --hard "origin/${BRANCH}"
else
    tmp_dir="$(mktemp -d)"
    git clone --branch "${BRANCH}" "${REPO_URL}" "${tmp_dir}/docker_stacks"
    cp "${REMOTE_DIR}/.env" "${tmp_dir}/docker_stacks/.env"
    rm -rf "${REMOTE_DIR}"
    mv "${tmp_dir}/docker_stacks" "${REMOTE_DIR}"
    rmdir "${tmp_dir}"
fi

if [ -n "${askpass:-}" ]; then
    rm -f "${askpass}"
fi
REMOTE

ssh_target REMOTE_DIR="${REMOTE_DIR}" 'bash -s' <<'REMOTE'
set -Eeuo pipefail

cd "${REMOTE_DIR}"
sudo docker compose up -d --build
sudo docker compose ps
REMOTE
