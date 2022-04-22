---
layout: single
title: 'Protecting your server'
excerpt: 'General practices to avoid the most common and easiest attacks by patching the most common vulnerabilities.'
date: 2022-04-22
classes: wide
header:
  teaser: /assets/images/20220422-protecting-your-server/firewall.png
  teaser_home_page: true
categories:
  - Server admin
  - Linux
tags:
  - Advice
  - Protection
---

I have recently watched a NetworkChuck's video where he explained how to protect your linux server (Dedicated to Ubuntu but I plan on covering more than just that distro), so I thought that I could do some sort of writeup of the video as well as expand the info that is shown in it.

Securing your linux server is an essential aspect to keep it running and to avoid any infiltrations in your network that could lead to data breaches, which nobody wants.

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

    ---

- ### Arch-based distro

  In this case, there isn't any community package that implements this functionality, as this is really againt [Arch's way of doing things](https://github.com/steadfasterX/arch_uau/#the-usual-arch-upgrade-flow). However, many people don't follow that rules, so why don't automate the process?

1. Install the corresponding package. We'll be using [Pacroller](https://github.com/isjerryxiao/pacroller):

    ```bash
    yay -S aur/pacroller
    ```

1. Configure your installation.

    ```bash
    # Usually people using Arch are comfortable with vim, but feel free to use nano if you like it better.
    sudo vim /etc/pacroller/config.json
    ```

    You should set `clear_pkg_cache` to true in your config to save some space if your network connection is enough to redownload the files if needed. (A huge bandwith isn't needed)

    If you want to enable smtp to receive emails when an update is completed, you can configure the details in `/etc/pacroller/smtp.json`

    Keep in mind that this package has some [limitations](https://github.com/isjerryxiao/pacroller#limitations) even though it works well. There is an [alternative package](https://github.com/steadfasterX/arch_uau/) that gave me some problems when installing with yay but that has some improvements over pacroller.

    ---

- ### Alpine linux

  I haven't found any official way of installation. However, and as a general way of implementing something like this, you can use cron jobs to make a command run every x time, so it updates all your packages.
  Using cron is discouraged in some aspects as it doesn't have a logging system as good as the other alternatives in this post, and you need to write your code by yourself.

  Add `apk update && apk upgrade` to your crontab (using `sudo crontab -e`).

    ---

- ### Others

  I currently don't have any other distro to use this package so I have no idea on how to implement it.
  However, you can look it up like `<distro name> unattended upgrades` and you'll find something for sure.

  If you don't, you can always implement it the Alpine Linux way, changing `apk` to the package manager of your distro, and `update` and `upgrade` to the corresponding arguments.

## 2. Hardening SSH

## References

- [NetworkChuck's video](https://www.youtube.com/watch?v=ZhMw53Ud2tY).

## Conclusions

Keeping hackers off your server is becoming easier for the general public as more and more utilities to easily manage your protection become available. With some simple steps like the ones shown here, you can go a long way. There are more thing to protect but this should set a base that will do more than enough for a home-lab.

Thanks for reading!

Done with :black_heart: by Appu.
