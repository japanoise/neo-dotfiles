# New dotfiles repo

Starting from scratch rather than doing a messy clearup; my old dotfiles repo
is full of now useless crap.

Run install.sh. (shellcheck returns only 1 useless warning)

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

Except dotfiles/.spacemacs, which is heavily based on the default spacemacs
config, the contents of the fonts/ subdirectory, and bin/imgur, which is copyright [Philip
Tang](https://github.com/tangphillip/Imgur-Uploader), all files are copyright ©
2016-2017 japanoise, released under the MIT license; see the LICENSE file for
license text.
