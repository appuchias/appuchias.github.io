---
title: MSI Prestige 14H B12U
description: A review based in around a month of use
date: 2023-11-21
lastmod: 2024-01-23
categories:
    - Products
tags:
    - Reviews
    - Utility
cover:
    image: '/images/2023-11-21_msi_prestige/laptop-side.png'
---

I recently bought this laptop and I wanted to test it to see if it fitted me, so I thought I would publish the results in case it helps anyone with their decisions.

These results won't be scientific, but they can serve as a guideline to estimate the performance of this and similar processors taking also into account other measurements from more scientific sources such as [CPUMark](https://www.cpubenchmark.net/singleCompare.php) or [Geekbench](https://browser.geekbench.com/).
They won't be perfect either, no test ultimately is, but I think they're worth taking into account.

# Laptop specs

The version I bought has the following specs:

- Core i7-12650H processor.
- LPDDR5 16GB **soldered** RAM.
- 1TB SSD PCIe Gen4x4 (Performance below).
- RTX 2050 4GB GDDR6 GPU + integrated graphics.
- 14" FHD+ (1920x1200) 100%sRGB 400nits IPS screeen.
- Thunderbolt™ 4 support
- Intel® Killer™ AX Wi-Fi 6E + Bluetooth 5.3
- 4 cell, 72Whr battery
- Single Backlit Keyboard (White)

With these ports available:

- On the left (from back to front)
	- 1x HDMI™ 2.1 (4K @ 60Hz)
	- 2x Type-C (USB / DP / Thunderbolt™ 4) with PD charging
- On the right (from back to front)
	- 1x Type-A USB3.2 Gen2
	- Camera switch (not a port but useful nonetheless)
	- 1x Micro SD Card Reader
	- Combo jack 3.5mm headphones + microphone

I bought this laptop for around 920€ in November 2023.

# Out of the box experience

The packaging is very nice, although everything is in plastic bags.
I'd have preferred everything to use paper or cardboard packaging.

The version I bought came without an OS[^1], so after copying the latest Windows 11 installer to my Ventoy drive and disabling Secure Boot in the BIOS, I booted from the USB drive and installed Windows.

[^1]: Actually it had FreeDOS but I don't really know anything about it.

> Note: The keys to enter the BIOS and Boot Menu on this laptop are `Delete` and `F11`, respectively.

## Windows installation

After booting the installer I noticed the trackpad wasn't working, so I had to go through the installer only using the keyboard, which was a bit messy as some options (specially at the beginning of the installer, where they look like Windows 7) that are very unintuitive.

After skipping the network setup (lucky me) using the `Shift+F10`, then typing `oobe\bypassnro` ([Here is the guide I followed](https://pureinfotech.com/bypass-internet-connection-install-windows-11/)), I set up a local account without a password and continued on.

After it finished installing (around 10min), I was greeted with the Windows 11 desktop, with no network device available, without trackpad (it wasn't disabled, I tried) and at full brrightness.

As I didn't have a network connection, no updates were available, so I couldn't install the drivers required for the integrated NIC.
Luckily, I have a USB NIC that worked with the pre-installed drivers in Windows, without it it would be impossible to update it (no ethernet).

After all updates finished, which took several reboots lasting around 1h, the device was ready.
Now all required devices were working (finally).

## Ubuntu installation

This felt much simpler.

After booting the Ubuntu ISO, the trackpad also didn't work, but the Ubuntu installer was shorter and easier to follow just using `Tab` and `Space`.

The install process was much quicker than Windows', but with the same issue, no Internet connection available on install.

However, when I rebooted the device after install, the wifi module was recognized and worked without issue, so unlike in Windows, I could install all updates (also much quicker) without needing the USB NIC.

Even after this, the trackpad only works briefly after unlocking the device and logging in, and in that time it works perfectly.
No messages were logged to `dmesg` when it stopped working, so I didn't explore further as I wasn't worried because Ubuntu wouldn't be my final distro.

## Arch linux installation

I had almost no issues.

I used archinstall to start faster and created a system with awesomewm and KDE in a bit over an hour.
The wireless module was available from the live USB so it was easy to configure the network either with wpa_supplicant or iwconfig. ([Official Arch Wiki page on wireless network config](https://wiki.archlinux.org/title/Network_configuration/Wireless))

Same issue with the trackpad. Only this time I searched for some info online and found similar problems from another MSI laptop (I can't find where it was from).
I'll detail the solution later.

## Thoughts

Windows is usually shown as the "Just works" OS, but Ubuntu was much easier and quicker to install (and it doesn't spy me).

I don't know if the problem is that the laptop is recent and both kernels don't have the base drivers yet, but it has a 12th gen processor that launched Q1 2022 and we are in Q4 2023, so IMO it's been more than enough time.

It's surprising that the distro I had less trouble with was Arch, I expected it to be a bit more of a headache.

# Benchmarks and other tests

In each OS I tried, I ran at least a CPU benchmark and a battery test.

For all battery tests, I left a YT video ([This one](https://www.youtube.com/watch?v=njX2bu-_Vw4)) on loop at 50% brightness and power saving enabled.

It may or may not be representative of real use.
I don't really care, I just wanted a measurement to base future experiences from.

Here are the results:

## Windows

### Cinebench R24

I chose it mainly because it's a standard, it's R24 and not R23 because I didn't want to spend more than 5 minutes looking for it and R24 was the first result even when searching the R23 release.

I ran the tests with the laptop unplugged (I know, that's not fair for Windows, but it's the only OS where I ran it and I didn't really care about the result).
It was almost full battery, in my lap at around 19º ambient temperature.

I didn't wait for the full tests to finish, I took the numbers after 5 minutes of each test.

The results were:

- Single core: ~70
- Multi-core: ~470

### Battery test

I installed firefox, opened YT, loaded the video and left the PC unplugged with 50% brightness and power saving enabled playing the video on loop.

It lasted around 5h 30min.

## Ubuntu 23.10

### Geekbench 6

This was ran with almost full battery, unplugged in a desk at around 20º ambient temperature.

The scores are available [here](https://browser.geekbench.com/v6/cpu/3653695), but, as a quick summary:

- Single core: 2543
- Multi core: 8209

### Battery test

With firefox installed by default (using a snap I think), brightness to 50% and power saving mode enabled.

It lasted around 6h15min.

## Arch linux

### Geekbench 6

The test was ran in the same conditions as the Ubuntu one. The results are [here](https://browser.geekbench.com/v6/cpu/4147775).

- Single core: 2691
- Multi core: 10190

Quite impressive that it beats ubuntu by so much. It's almost as if it had another core...

### Battery test

I ran it in awesomewm with the exact same conditions as the other 2 times, but without power saving as it is Arch and I don't know if there's a way to enable such thing.

It lasted more than 7h. It was around 7h5min.

> #### Update (2024-01-23)
>
> After some time using the laptop, the battery duration numbers for typical use are the following:
>
> - Light use (Mostly following an in-person presentation with Okular): 5-6h.
> - Slightly heavier use ("Lab" classes coding in Python/MATLAB/R): 4h with 10-15% remaining.
> - Even heavier use (multitasking while powering a 5V device through USB-A and capturing packets with Wireshark): Around 4h.

# Current setup

I'm currently running Arch with AwesomeWM (and KDE as a backup in case I need something in Wayland), with the default kernel (I tried the zen kernel and it was similar but it required the Nvidia DKMS driver and recompiling, so I removed it).

I have the 1920x1200 16:10 screen with no scaling enabled, and it's quite decent, not tiny but definitely in the small size.

I'm overall happy with the end result.
The laptop works great and it isn't loud even when under sustained full load.[^2]

The keyboard gets a bit warm after some time but it isn't uncomfortable.

[^2]: **Update (2024-01-23)**: It now sometimes keeps the fan on while doing some light tasks, but I don't think is something to worry about, probably just what happens when you have it on your lap.

# Other considerations

**A spare mouse and wireless adapter will be needed** if you decide to buy this laptop to use Windows.
It runs really nice but default drivers aren't ready (as of now).

## Touchpad problem

The problems with the touchpad ended being the PCI Power Management configuration.
It was solved after disabling it for the NVIDIA graphics card.
I wrote a full solution [here](https://unix.stackexchange.com/a/765596/498196).

If you need more help with configuring it, I may be able to help you :) (contact me [in any of these ways](https://links.appu.ltd/?utm_source=Blog))

# Final opinion

To sum up, I won't use Windows again on a laptop.

People are not ready to hear it, but Linux can be as good as or better than Windows given the same time to configure it to your likings (something usually easier on Linux).[^3]

[^3]: I’d just like to interject for a moment. What you’re refering to as Linux, is in fact, GNU/Linux, or as I’ve recently taken to calling it, GNU plus Linux.
    Linux is not an operating system unto itself, but rather another free component of a fully functioning GNU system made useful by the GNU corelibs, shell utilities and vital system components comprising a full OS as defined by POSIX.
    (...)

I've been using the laptop in class for 3 weeks or so, and it runs MATLAB and RStudio with no trouble, and the battery lasts easily the whole day of use (while in class).

I'm happy with it and I would recommend it after reading the considerations.

---

Thanks for reading!

Done with 🖤 by Appu.
