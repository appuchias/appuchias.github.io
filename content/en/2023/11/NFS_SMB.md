---
title: 'NFS and SMB shares'
description: 'Creating and mounting NFS and SMB shares in Linux'
date: 2023-11-06
categories:
   - Linux
   - Server admin
tags:
    - Utility
---

Creating a NFS share is quite easy, and it's a fast way to share files between Linux hosts, and apparently even with recent Windows machines (untested).

Samba (SMB) is the native way to do it in Windows, but comes with some more overhead which reduces its file transfer speeds (untested).

# NFS

## Required packages

The required packages are the following:
```shell
# Arch Linux
sudo pacman -S nfs-utils

# Debian and derivatives (Ubuntu, etc.)
sudo apt install nfs-kernel-server
```

## Share creation

After choosing the folder you want to share, you'll need to define the shared folders inside the `/etc/exports` file (created after the package installation).

The format required for the shares defined in that file is the following:
```sh
/path/to/folder hostname1(options1) hostname2(options2) [others]
```

- The `/path/to/folder` needs to exist in your filesystem.
- `hostname1` can be either a hostname (`example.com`), an IP address (`192.168.1.3`) or a subnet address in CIDR (`10.0.0.0/8`).
- The `options` available can be found [here](https://man.archlinux.org/man/exports.5#General_Options).

After declaring the shares, you can start sharing with the following command:
```shell
exportfs -var
```

It will re-export all entries in `/etc/exports` and it will output al the changes made.

## As a client

After installing the corresponding package (`nfs-utils` for Arch Linux or `nfs-common` for Debian and derivatives), you can see the exports available from a server with `sudo showmount -e server-hostname` (the hostname can be an IP address), and then mount a share using:

```shell
sudo mount server-hostname:/path/to/share /path/to/local/folder
```

# SMB

## Required packages

```shell
# Arch linux
sudo pacman -S samba

# Debian and derivatives (Ubuntu, etc.)
sudo apt install samba
```

## Share creation

Once you know the path of the folder you want to share, you'll need to edit `/etc/samba/smb.conf`.

There will already be a section called `[homes]`, which is an automatic way of sharing your home folder just to your user.
If only you will access the share and what you want to share is in your home folder, that may be enough for you, so uncomment these lines and continue with the next section.

```shell
[homes]
   comment = Home Directories
   browseable = no

# By default, the home directories are exported read-only. Change the
# next parameter to 'no' if you want to be able to write to them.
   read only = yes

# File creation mask is set to 0700 for security reasons. If you want to
# create files with group=rw permissions, set next parameter to 0775.
   create mask = 0700

# Directory creation mask is set to 0700 for security reasons. If you want to
# create dirs. with group=rw permissions, set next parameter to 0775.
   directory mask = 0700

# By default, \\server\username shares can be connected to by anyone
# with access to the samba server.
# The following parameter makes sure that only "username" can connect
# to \\server\username
# This might need tweaking when using external authentication schemes
   valid users = %S
```

To add a share, you can follow the pattern of that section to create your own one:

```shell
[SHARENAME]
  comment = DESCRIPTION
  path = /PATH/TO/FOLDER
  browseable = yes
  read only = no
  guest ok = no
```
The fields of the share are:

 - `SHARENAME`: The name shown in the clients.
 - `DESCRIPTION`: Description of the share.
 - `path`: The full path to the shared folder.
 - `browseable`: Determines wether the share is shown to everyone or just accessible by name.
 - `read only`: Determines if the share is writeable or read-only.
 - `guest ok`: If guests can acccess.

To see the full options available, see [this article on the Arch Wiki](https://man.archlinux.org/man/smb.conf.5).

Once configured, you'll need to enable the samba service using `sudo systemctl enable --now samba` or `sudo systemctl enable --now smb` (if you use systemctl).

## As a client

From the terminal, you can use `smbclient`.

There are also plugins or integrations to many file managers that allow you to connect to SMB shares directly.

In case you're using Thunar, you'll need to install `gvfs` and `gvfs-smb` in Arch Linux.

After it, browseable shares will appear as network locations.

---

Thanks for reading!

Done with 🖤 by Appu.
