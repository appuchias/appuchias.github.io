---
title: 'Endlessh: SSH Honeypot'
description: 'Setting up a SSH honeypot to trap hackers'
date: 2022-04-13
categories:
    - Linux
    - Server admin
tags:
    - SSH
    - Utility
    - Protection
cover:
    image: '/images/2022-04-13_endlessh/skeeto_endlessh.png'
---

## What's this

Endlessh is a piece of software that sets up a ssh honeypot for all the random people that may try to attack you by trying common username and password combinations to see if they can get access. In return, this program slows their access down hugely, and in a way someone with a script to do the attack won't notice (most people doing these kind of attacks will be using scripts).

### A little bit of context

SSH connections have something called the _SSH banner_, which, if set up, sends some information from the server to the client connecting. What's special about it is thar no one set a limit on its length, so you see where this is going.
By setting the banner to an inmensely large amount of random information, you can freeze the attack, as the client needs the full banner to start the connection, and it is receiving some part of the banner every x seconds and waiting for the rest
, effectively stopping the connection.
If you have a program to generate a large banner and send it little by little, you have an SSH honeypot, and that's exactly what endlessh does.

In this case I will be moving the real SSH port to a random one, like 71 or 2222, for example. This allows me to still be abe to connect to the server but requires anyone who tries to enter to know thich one is the real SSH port, as port 22 will
be used by the honeypot.

Important note: I'm taking inspiration for this article from Reed's one from Smart Home Solver YT channel, which will be linked below.

## Installation

1. First of all, you will need to clone the repo, which you can find [here](https://github.com/skeeto/endlessh), and don't forget to support the author.

   ```bash
   git clone https://github.com/skeeto/endlessh
   cd endlessh
   ```

2. Compile the binary

   ```bash
   make # Took around 10-20s on my Raspberry Pi 3
   
   # If you're on Debian or Ubuntu, you may need to run this second line for it to compile.
   sudo apt install libc6-dev
   ```

3. Move the binary to a folder in the PATH (this is for ease of use, not mandatory but highly encouraged)

   ```bash
   sudo mv ./endlessh /usr/local/bin/
   # Make sure it is in the PATH by running `which endlessh`, which should return /usr/local/bin
   ```

4. Copy the systemd unit file for endlessh

   ```bash
   sudo cp util/endlessh.service /etc/systemd/system/
   ```

   **[ ! ] Important note**: If you're using Openrc instead of systemd, these are the commands you will need to:

   1. Edit root's crontab (Only if you're using a port < 1024, else your crontab is ok)

      ```bash
      sudo crontab -e
      ```

   1. At the bottom of the file, add the following

      ```bash
      @reboot /usr/local/bin/endlessh
      ```

5. Create the config file

   ```bash
   sudo mkdir -p /etc/endlessh
   sudo vim /etc/endlessh/config
   ```

   ```bash
   # The port on which to listen for new SSH connections.
   Port 22

   # The endless banner is sent one line at a time. This is the delay
   # in milliseconds between individual lines.
   Delay 10000

   # The length of each line is randomized. This controls the maximum
   # length of each line. Shorter lines may keep clients on for longer if
   # they give up after a certain number of bytes.
   MaxLineLength 16

   # Maximum number of connections to accept at a time. Connections beyond
   # this are not immediately rejected, but will wait in the queue.
   MaxClients 4096

   # Set the detail level for the log.
   #   0 = Quiet
   #   1 = Standard, useful log messages
   #   2 = Very noisy debugging information
   LogLevel 1

   # Set the family of the listening socket
   #   0 = Use IPv4 Mapped IPv6 (Both v4 and v6, default)
   #   4 = Use IPv4 only
   #   6 = Use IPv6 only
   BindFamily 0
   ```

   **[ ! ] Important note**: if you're running this using a port < 1024 and using systemd, you need to make some changes in `/etc/systemd/system/endlessh.service`: uncomment line `31` and comment line `33` (by adding # at the beginning).
6. Once you have the config, you will have to enable and start the service and it will be up and running for you!

   ```bash
   sudo systemctl enable --now endlessh.service
   ```

### Attacker's POV

This is what everyone will see when trying to access your server using the endlessh port:

```bash
ssh username@host
|
```

The only way there is to know what is really happening is to add `-v` at the end of the command, which enables verbose mode and throws out a bunch more information about what's happening with the connection. Here you can see the output using `ssh username@host -v`

``` bash
debug1: Local version string SSH-2.0-OpenSSH_8.9
debug1: kex_exchange_identification: banner line 0: 3`CO^[AZ`$Ie(
debug1: kex_exchange_identification: banner line 1: k$A
debug1: kex_exchange_identification: banner line 2: NP},A36/ZN
debug1: kex_exchange_identification: banner line 3: e
debug1: kex_exchange_identification: banner line 4: 7=WUl
debug1: kex_exchange_identification: banner line 5: vM(ydqF
debug1: kex_exchange_identification: banner line 6: }|DH^/~#J
debug1: kex_exchange_identification: banner line 7: a.pc+(
debug1: kex_exchange_identification: banner line 8: }5sk<l69z^GX
debug1: kex_exchange_identification: banner line 9: <nI ;!SJAQo~
debug1: kex_exchange_identification: banner line 10: M8
debug1: kex_exchange_identification: banner line 11: (a
debug1: kex_exchange_identification: banner line 12: KSyU#4Jx@0
debug1: kex_exchange_identification: banner line 13: l`<QufAX7pA
debug1: kex_exchange_identification: banner line 14: iNz,$hn
debug1: kex_exchange_identification: banner line 15: jp
debug1: kex_exchange_identification: banner line 16: trta5u{[~vK=
debug1: kex_exchange_identification: banner line 17: o3EjE>\\g3
debug1: kex_exchange_identification: banner line 18: J\\/I]|[
```

## References

- [Wolfgang's channel video](https://www.youtube.com/watch?v=SKhKNUo6rJU)
- [Skeeto's GitHub repo](https://github.com/skeeto/endlessh)

## Conclusions

This is overall what I consider a basic security measure as it will make anyone trying to access your server have to find the exact port your ssh server is on, potentially leaving more traces on your network which could be used to track down the author.
With this setup as well as having pings disabled from your system can enhance your protection against intrusions. I'm writing a follow-up post about protecting your server, so expect to read in a few days!

---

Thanks for reading!

Done with 🖤 by Appu.
