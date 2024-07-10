---
title: 'Protecting your server'
description: 'General practices to avoid the most common and easiest attacks by patching the most common vulnerabilities.'
date: 2022-05-19
categories:
    - Linux
    - Server admin
tags:
    - Advice
    - Protection
cover:
    image: '/images/2022-05-19_protecting-your-server/firewall.png'
---

I recently watched a NetworkChuck's video where he explained how to protect your linux server (Dedicated to Ubuntu, but I plan on covering more than just that distro), so I thought that I could do some sort of writeup of the video as well as extend the info that is shown in it.

Securing your linux server is an essential aspect to keep it running and to avoid any infiltrations in your network that could lead to data breaches, which nobody wants.

## A big first disclaimer

Security is a continuous thing, after following these tips you won't automatically be secure.

These are just some measures you can take to cover the easiest ways of entry into your server, which can reduce the amount of attacks you receive, specially from "script kiddies".

There are many more things you can do, and you don't need to do all of the ones listed here.
This serves as a staring point. The best way to keep your server safe is not exposing it to the Internet, but that's not want you want, I guess ;).

## 0. Using a non-root user account

I've given it number 0 because this is a basic configuration to prevent any random person from making changes to your relevant config files, and it should be already done in your server.

In this section I'll assume that you are logged in as root, but for the rest of the article I'll assume that you are logged in as your unprivileged user.

The steps are quite easy to follow:

1. Create the user

    ```bash
    useradd <username>
    ```

1. Create a password for the user

    ```bash
    passwd <username>
    ```

1. Add user to wheel group (the one that grants sudo privileges)

    ```bash
    usermod -aG wheel <username>
    ```

    If it raises an error saying that `usermod` does not exist (it should be installed by default in Ubuntu), you can install it with the package `shadow`:

    ```bash
    pacman -Sy shadow                      # On Arch
    apt update && sudo apt install shadow  # Debian and Debian-based
    apk update && sudo apk add shadow      # Alpine Linux
    ```

    If the first command raises an error saying that the group wheel was not found, run this command and rerun the first one to create it:

    ```bash
    groupadd wheel # Also from the package `shadow`, install it if this also throws an error
    ```

1. Allow group wheel to run sudo

    ```bash
    visudo
    ```

    In that file, you will need to find the line `#%wheel ALL=(ALL:ALL) ALL` (close to the end), and remove the `#` at the beginning, then press `:`, write `wq` and press `enter` to exit saving changes.

1. To continue with the post, log in as your unprivileged user:

    ```bash
    su <username>
    ```

## 1. Enabling automatic updates

This is easier to do in debian-based distros where the package `unattended-upgrades` is available. However, as always on the linux world, there exist alternatives and other packages that basically do the same job in many other distros.

- ### Debian-based distro

    1. Install the corresponding package:

        ```bash
        sudo apt install unattended-upgrades # Add '-y' if you don't want to press enter.
        ```

        Unattended upgrades is the most well-known package for doing this, and generally the recommended one, as it's the easiest and it just works.

    1. Enable the service and make it run.

        In this step you are configuring your install. You will need to run this command and press enter to enable automatic updates.

        ```bash
        sudo dpkg-reconfigure --priority=low unattended-upgrades
        ```

- ### Arch-based distro

    In this case, there isn't any community package that implements this functionality, as this is really againt [Arch's way of doing things](https://github.com/steadfasterX/arch_uau/#the-usual-arch-upgrade-flow). However, many people don't follow that rules, so why don't automate the process?

    1. Install the corresponding package. We'll be using [Pacroller](https://github.com/isjerryxiao/pacroller):

        ```bash
        yay -S pacroller
        ```

    1. Configure your installation.

        ```bash
        sudo <editor> /etc/pacroller/config.json
        ```

        You should set `clear_pkg_cache` to `true` in your config to save some space if your network connection is enough to redownload the files if needed. (A huge bandwith isn't needed)

        If you want to enable smtp to receive emails when an update is completed, you can configure the details in `/etc/pacroller/smtp.json`

    Keep in mind that this package has some [limitations](https://github.com/isjerryxiao/pacroller#limitations) even though it works well. There is an [alternative package](https://github.com/steadfasterX/arch_uau/) which gave me some problems on installation (with yay) but that has some improvements over pacroller.

- ### Alpine linux

    I haven't found any official way of installation. However, and as a general way of implementing something like this, you can use cron jobs to make a command run every x time, so it updates all your packages.

    Using cron is discouraged in some aspects as it doesn't have a logging system as good as the other alternatives in this post, and you need to write your code by yourself.

    Add this to your root crontab (using `sudo crontab -e`).

    ```bash
    0 0 * * * /bin/bash apk update && apk upgrade
    ```

- ### Others

    I currently don't have any other distro to use this package so I have no idea on how to implement it.

    However, you can look it up like `<distro name> unattended upgrades` and you'll find something for sure.

    In case you don't, or you want a fast and easy solution, you can always implement it the Alpine Linux way, changing `apk` to the package manager from your distro, and `update` and `upgrade` to the corresponding arguments.

## 2. Hardening SSH

There are many thing to protect incoming SSH connections to your server, but the main ones are changing the port, allowing only key-based authentication and limiting the keys used.
All of the changes made in this section are going to be inside the `/etc/ssh/sshd_config`  file, so go ahead and open it with your favourite editor as root: `sudo <editor> /etc/ssh/sshd_config`.

You can find the default config for Arch Linux [here](https://gist.githubusercontent.com/aaronjanse/fe7410850f743802227ed7523f07fb49/raw/b121048f7a517d98f6fa9035aa0f6b8df70a9c2f/sshd_config), but it should already be there.

1. ### Changing the SSH port

    You will need to find the line `#Port 22` (line `13` in a default config), remove the `#` and change the number `22` for any other unused port.
    It will be in general less prone to scans if you use a port number higher than `10000`, though it's really easy to scan those ports too.

    Note: To connect again to your server, you will need an extra argument in your ssh command:

    ```bash
    ssh <username>@<host> -p<port>
    ```

1. ### Removing password authentication and enabling public/private keys

    The relevant lines for this on a default config are lines `32`, `41`, `57` and `58`.
    - `PermitRootLogin` should be set to `no` (Blocks root login attempts).
    - `AuthorizedKeysFile` to `.ssh/authorized_keys`, to allow ssh to auto add keys.
    - `PasswordAuthentication` to `no` (**Important note on this**: Please register a key in the machine **before** enbaling this. Otherwise you will be **unable to log back in**!).
    - And `PermitEmptyPasswords` to `no` (I'm not completely sure that this explicit config servers any purpose if passwords are disabled but it's an extra measure in case they are left enabled).

1. ### Limiting key ecryptions used

    Some algorithms used to generate keys are less secure than others, and even though opinions may vary, here I will include what works for me.
    The relevant lines now are `18-20`. The three lines specify different encoding protocols. I prefer ed25519 as it's one of the most recent ones and it offers very secure but small keys, when compared to RSA (specially 4096 bit, the one used in SSH).

    That's why the order I have the 3 lines is:

    ```bash
    HostKey /etc/ssh/ssh_host_ed25519_key
    HostKey /etc/ssh/ssh_host_rsa_key
    #HostKey /etc/ssh/ssh_host_ecdsa_key
    ```

    Yes, I have disabled ECDSA, it may be controversial, but I just don't need it. I keep RSA for backwards compatibility and I now only generate ED25519 keys in my machines, so I don't see the need for it.

1. ### EXTRA: Endlessh

    I have [another blog post regarding this topic](https://blog.appu.ltd/endlessh/) which explains the installation and setup of the service. It basically sets up a honeypot to stop scripted attacks to your machines by sending an endless ssh banner, which freezes their connection until terminated from their end.

## 3. Firewall it up

Firewalls are utilities which can select which ports to allow traffic through as well as the ones in which they should drop all connections, working both for incoming and outgoing traffic.

The easiest one to install and configure and that works in most systems is `ufw` (it stands for UncomplicatedFireWall), which comes by default in Ubuntu systems. It is defined as a tool to 'ease iptables firewall configuration, ufw provides a user friendly way to create an IPv4 or IPv6 host-based firewall', according to [their website](https://help.ubuntu.com/community/UFW).

- ### Installation steps

    This step is not required if you're using Ubuntu.
    Also, if you're using a distro that is not Arch-based, Debian-based or Alpine linux, you will need to look up the way to install ufw, the package should be named `ufw`, you can either search it on a graphical app store or look up the commands to install it from the command-line.

    ```bash
    sudo pacman -Sy ufw                     # On Arch
    sudo apt update && sudo apt install ufw # Debian and Debian-based
    sudo apk update && sudo apk add ufw     # Alpine Linux
    ```

- ### Enable UFW

    In this case, all the configuration can be made from the command line with the ufw command (as root).

    The firewall comes disabled by default. Do not enable it now if you're connecting through SSH, as you'll be locked outside.

- ### Set up UFW

    There are many different configurations to UFW, it is a tool that has many more utilities than the ones shown in this config. However, sticking to the basics, we'll setup basic blocking using predefined profiles in UFW. You can see a full list of the included profiles using:

    ```bash
    sudo ufw app list
    ```

  - Allow incomming SSH connections on port 22.
        If you've changed the port this will not help you (to not be kicked out):

        ```bash
        sudo ufw allow ssh
        ```

    - If you've changed the SSH port, run:

            ```bash
            sudo ufw allow <port>/tcp
            ```

  - For any other service that you may need to access from outside your computer in the future, add a rule to ufw to allow incoming connections with the command above.
    The firewall will block by default all incoming connections, so remember to allow all the ones you need.
  - Once you've allowed all the necessary ports, enable UFW with:

        ```bash
        sudo ufw enable
        ```

        It will warn you about ongoing SSH connections, but if you've allowed the port, you don't need to worry.

- ### Other useful commands

  - To see the enabled rules, run:

    ```bash
    sudo ufw status numbered
    ```

  - You can delete rules with:

    ```bash
    sudo ufw delete <number from above command> # Some of the numbers will change after this
    ```

  - If you change anything from now, you'll need to reload the firewall for the changes to take effect using:

    ```bash
    sudo ufw reload
    ```

  - To disable the firewall, run:

    ```bash
    sudo ufw disable
    ```

  - You can reset the firewall to its defaults (usually without any rules) with:

    ```bash
    sudo ufw reset
    ```

- ### GUI

    There is a graphical user interface for those who prefer to manage their firewall using a graphical application. To use it, just install the package `gufw`. Also note that some desktop environments ship a firewall GUI by default (e.g. KDE).

## References

- [NetworkChuck's video](https://www.youtube.com/watch?v=ZhMw53Ud2tY).

## Conclusions

Keeping hackers off your server is becoming easier for the general public as more and more utilities to easily manage your protection become available. With some simple steps like the ones shown here, you can go a long way. There are more thing to protect but this should set a base that will do more than enough for a basic homelab.

If you're going to expose many different services to the Internet, you may want to set up some kind of authentication to protect admin panels and similar pages. I'll talk about it in a future post, stay tuned for it!

---

Thanks for reading!

Done with 🖤 by Appu.
