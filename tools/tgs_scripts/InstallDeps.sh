#!/bin/bash

#find out what we have (+e is important for this)
set +e
has_git="$(command -v git)"
has_curl="$(command -v curl)"
has_cargo="$(command -v ~/.cargo/bin/cargo)"
has_sudo="$(command -v sudo)"
has_youtubedl="$(command -v youtube-dl)"
has_pip3="$(command -v pip3)"
set -e
set -x

# apt packages, libssl needed by rust-g but not included in TGS barebones install
echo "Installing apt dependencies..."
if ! [ -x "$has_sudo" ]; then
	dpkg --add-architecture i386
	apt-get update
	apt-get install -y lib32z1 git pkg-config libssl-dev:i386 libssl-dev zlib1g-dev:i386 curl || true
	apt-get install -y libncurses5:i386 libstdc++6:i386 || true
	apt-get update || true
	apt-get remove -y libssl1.1:amd64 || true
	apt-get install libgcc-s1:i386 || true
	apt-get install -o APT::Immediate-Configure=false libc6:i386 || true
	curl -O http://ftp.de.debian.org/debian/pool/main/o/openssl/libssl1.1_1.1.1n-0+deb11u4_i386.deb || true
	dpkg -i libssl1.1_1.1.1n-0+deb11u4_i386.deb || true
else
	sudo dpkg --add-architecture i386
	sudo apt-get update
	sudo apt-get install -y lib32z1 git pkg-config libssl-dev:i386 libssl-dev zlib1g-dev:i386 curl || true
	sudo apt-get install -y libncurses5:i386 libstdc++6:i386 || true
	sudo apt-get update || true
	sudo apt-get remove -y libssl1.1:amd64 || true
	sudo apt-get install libgcc-s1:i386
	sudo apt-get install -o APT::Immediate-Configure=false libc6:i386 || true
	curl -O http://ftp.de.debian.org/debian/pool/main/o/openssl/libssl1.1_1.1.1n-0+deb11u4_i386.deb || true
	sudo dpkg -i libssl1.1_1.1.1n-0+deb11u4_i386.deb || true
fi

# install cargo if needed
if ! [ -x "$has_cargo" ]; then
	echo "Installing rust..."
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
	. ~/.profile
fi

# install or update youtube-dl when not present, or if it is present with pip3,
# which we assume was used to install it
if ! [ -x "$has_youtubedl" ]; then
	echo "Installing youtube-dl with pip3..."
	if ! [ -x "$has_sudo" ]; then
		apt-get update
		apt-get install -y python3 python3-pip
	else
		sudo apt-get update
		sudo apt-get install -y python3 python3-pip
	fi
	pip3 install youtube-dl
elif [ -x "$has_pip3" ]; then
	echo "Ensuring youtube-dl is up-to-date with pip3..."
	pip3 install youtube-dl -U
fi
