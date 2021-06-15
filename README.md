# New dotfiles repo

Starting from scratch rather than doing a messy clearup; my old dotfiles repo
is full of now useless crap.

On MacOS, you will need to have coreutils installed via e.g. homebrew. Sorry.
Other dependencies are git, m4, other shit idk read scripts before you run
them.

Run the install-*.sh scripts to install the components.

For contributing, this will get the pre-commit hook set up:

```shell
#install shellcheck
emerge shellcheck
#install pre-commit
pip install pre-commit
#get into the repo
cd path/to/repo
#install hook(s)
pre-commit install
```

## Copying

Files under the `fonts/` subdirectory have their own copyright notices. I'll
endeavour to keep mirrored stuff marked as not mine, but otherwise it's
Copyright © japanoise 2016-2019, licensed under the MIT license.

- `bin/imgur` [copyright © Philip Tang](https://github.com/tangphillip/Imgur-Uploader)
- `bin/bash_prompt.bash` edited from [the original by Artem Sapegin](https://github.com/sapegin/dotfiles/blob/dd063f9c30de7d2234e8accdb5272a5cc0a3388b/includes/bash_prompt.bash)
