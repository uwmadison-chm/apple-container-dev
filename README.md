# apple-container-dev

A Dockerfile and supporting functions (these are zsh but you could do other things) to set you up with a decent starting point for development -- you should have your SSH agent passed through to your container environment.

Gives you:

* ubuntu resolute
* openssh client
* github client
* and a few other packages

## The zsh functions

You might want these in your .zshrc:

```
acbuild() {
  # Build an image, by default tag it `dev`, you should run it the apple-container-dev dir
  local image="${2:-dev}"
  container build --tag "$image" .
}

acsh() {
  # Start a container using the dev image
  local name="${1:?usage: acsh NAME [IMAGE]}"
  local image="${2:-dev}"
  local src="${CSHELL_SRC:-$PWD}"
  local target="/home/dev/src"

  if ! container inspect "$name" &>/dev/null; then
    # Start the container running a neverending process
    container run -d --name "$name" --ssh -v "$src:$target" "$image" sleep infinity || return 1
  else
    container start "$name" &>/dev/null
  fi

  container exec -u root "$name" sh -c '[ -n "$SSH_AUTH_SOCK" ] && chmod 666 "$SSH_AUTH_SOCK"' 2>/dev/null
  container exec -it --workdir "$target" "$name" bash
}

acroot() { container exec -u root -it "$1" bash; }

acnuke() { container stop "$1" &>/dev/null; container rm "$1"; }
```

## Usage

Normal use:

1. Clone this repo, add the functions to your `.zshrc`, head into your the apple-container-dev directory and do `acbuild`
2. Go into the source directory you want to work on, do `acsh <some_name>`
3. Install whatever you need to do you work efficiently. See **Recommendations** below
4. If you need to get in as root to install packages, do `acroot <some_name>`
5. If you want to totally blow away that container, do `acnuke <some_name>`

## Recommendations

* Use 1Password's ssh agent and set up SSH_AUTH_SOCK in your host OS to use it. It's convenient. It's also secure -- the container can't exfiltrate your private key because it can never see the key at all.
* If you're using `uv`, set `UV_PROJECT_ENVIRONMENT="/home/dev/.local/venv"` in your container's `.profile` so your host and container venv directories don't fight
