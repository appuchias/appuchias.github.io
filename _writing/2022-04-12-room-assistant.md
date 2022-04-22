---
layout: single
title: Room assistant
excerpt: "Setting up room assistant integrated with home assistant to unlock room presence automations!"
date: 2022-04-12
classes: wide
categories:
  - Home automation
  - Raspberry Pi 
tags:
  - Home assistant
  - Room assistant
  - Bluetooth
  - Raspberry
---


Hi there,

These days I've been **poking?????** around with a Raspberry Pi I wasn't using and I'm trying to get some use out of it by installing room assistant as a test machine for a future implementation. It'sa RPi 3B+ if anyone was wondering.

## What is room assistant?

Well, that's a good question. By itself, it's a piece of software which tries to ...

The use I'm looking for from it, is to use the Bluetooth HCI from the Raspberry and detect the position of my phone and consequently the room I'm at, based on the distance from the RPi to my phone.
This can be useful for those who are willing to trigger automations on arrive/leave from some specific room.
I know that motion sensors exist, but there's a big flaw in them: they can only detect motion, what happens if you are standing still in a room (sitting or laying on your bed, working with a computer...).There's where room assistant comes handy. It detects 'your position', so it's much more accurate detecting whether you're in a room or not, and it can also know who's in the room, another difference.

Important note: I'm taking inspiration for this article from Reed's one from Smart Home Solver YT channel, which will be linked below.

## Installation process

1. Install your preferred OS in the SD card of the RPi of choice (My installation is running on a RPI 3B+ with Raspberry Pi OS bullseye 64-bit Lite installed). I'm not going to cover the OS installation guide in this article in this post. I may cover it in the future, for now you can check the official webpage [in this link](https://www.raspberrypi.com/documentation/computers/getting-started.html#installing-the-operating-system). If this is your first Raspberry Pi and you don't have some experience with the terminal, it may be a good idea to install the full versin on Raspberry Pi OS.
1. Make sure all the basic requirements are met.
   - Your raspberry has an Internet connection.
   - You have access to a terminal (either through a [GUI](https://en.wikipedia.org/wiki/Graphical_user_interface), through [SSH](https://en.wikipedia.org/wiki/Secure_Shell) or from the tty).
   - You have changed the default password and you remember it.
   - You have changed the RPi's hostname (This is optional but useful in case you are going to use more than one raspberry).

1. Let's install the requirements!
   - Update repos and install upgrades

   ```bash
   sudo apt update && sudo apt upgrade -y
   ```

   - Node.js (16.x)

   ```bash
   curl -sL <https://deb.nodesource.com/setup_16.x> | sudo -E bash -
   sudo apt install -y nodejs
   ```

   - Other dependencies

   ```bash
   sudo apt install -y build-essential libavahi-compat-libdnssd-dev libsystemd-dev bluetooth libbluetooth-dev libudev-dev libcairo2-dev libpango1.0-dev libjpeg-dev libgif-dev librsvg2-dev
   ```

- Install room-assistant

   ```bash
   sudo npm i --global --unsafe-perm room-assistant
   ```

- Allow room assistant to use bluetooth

   ```bash
   sudo setcap cap_net_raw+eip $(eval readlink -f `which node`)
   sudo setcap cap_net_raw+eip $(eval readlink -f `which hcitool`)
   sudo setcap cap_net_admin+eip $(eval readlink -f `which hciconfig`)
   ```

## References

- [Reed's article on this same topic](https://smarthomesolver.com/reviews/futuristic-advanced-automations-with-room-assistant)
- [Reed's YT channel](https://www.youtube.com/c/smarthomesolver)
