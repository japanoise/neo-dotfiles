#!/bin/bash
err () {
	echo "$1" >&2
	exit 1
}

echo "Installing gitconfig."
echo "Make sure you've set user.name and user.email already, or specified them"
echo "on the command line, i.e. $0 <email> <username>"

email=$1
if [ -z "$email" ]
then
	email=$(git config --global user.email) || err "No email found"
fi

username=$2
if [ -z "$username" ]
then
	username=$(git config --global user.name) || err "No username found"
fi

m4 -D mygitusername="$username" -D mygitemail="$email" <dotfiles/.gitconfig >"$HOME"/.gitconfig

