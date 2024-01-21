---
title: 'The Mysterium dVPN'
excerpt: 'A way to monetize your spare bandwidth and earn some money back.'
date: 2022-05-30
categories:
    - "Linux - 1 (basic)"
    - "Server admin"
tags:
    - Utility
    - Blockchain
    - VPN
cover:
    image: /images/2022-05-30_mysterium-dvpn/myst.jpg
---

In the last days I set up a node of a decentralized VPN using the Mysterium network. This was mainly to get profits from the Internet bandwidth I don't use and to help provide freedom of speech for those who need it.

## What is Mysterium?

Mysterium is 'a global, distributed network powered by everyday people. Network participants are incentivised to share their resources in a supply and demand marketplace, helping others gain access to the open internet'.
It is basically a blockchain-operated VPN service, where customers pay with the MYST token to connect to the nodes ran by volunteers who receive a compensation for it, also in MYST.
The main benefits are that the exit IP addresses of your connection are the ones of regular people and not well-known business IPs, which makes it harder for content providers to deny your access to content they usually block for VPN users.
Node runners, in return, receive a cryptocurrency that can be exchanged for many others. It isn't very valuable for now (1MYST=0.17$ at the time of writing), but it's for sure a compensation for a service that some would provide for free.

## How do I install it?

The easiest way to use this is through a Raspberry Pi. They consume almost nothing and get the job done effortlessly. Model 4 would be best as the RPi3's bandwidth is limited to 100Mbps with the default ethernet adapter, something that may limit your earnings.
If you already have such device, great! Else, you may want to wait as they are currently very overpriced. The software can be installed in many other ways, so check out [their website](https://mystnodes.com/onboarding) for more info, as even though some parts of this guide may be the same, this may not work due to various reasons on other OSs.

1. ### Prerequisites

    - Some crypto knowledge would come handy, specially to avoid losing some small amounts of money along the way, ask me how I know.
    - You will need an ERC-20 account. The easiest way to create one is with Metamask (either the browser extension or the mobile app). There are plenty guides online, but make sure to keep your private key secure and not lose access to it.
    - Internet connection (duh), some spare bandwidth (it can be limited, so don't worry about your 4K streams lagging) and some time.
    - Some MYST, MATIC or other Polygon token // A credit or debit card or Paypal. You will be creating a public record, which has a small fee (Usually ~5cents), but you will probably will need to pay a bit extra (the extra funds you add will be in the node's crypto wallet and you can withdraw them at any time)

1. ### Install the OS and prepare the installation

    The raspberry team have done a better job than what I could do explaining this. My distro of choice is Raspberry Pi OS Lite, so refer [here](https://www.raspberrypi.com/documentation/computers/getting-started.html#using-raspberry-pi-imager) for the installation steps, but feel free to install the Full version if you'd like to have a desktop.
    You will need to have terminal access to it, either through SSH or with a keyboard and monitor connected.
  
    Once you have it installed, you will need to refresh the package manager's cache and install all available updates to your OS.

    ```console
    sudo apt update && sudo apt upgrade -y  # -y makes it not prompt for confirmation. If you have a fresh install, this should't cause any problem.
    ```
  
    The previous command may take a long time depending on your hardware and the age of the OS you installed. Make sure your connection is not interrupted during the update, or you may need to fix some packages.

1. ### Add the mysterium PPA to apt and verify its validity

    In their website, you can find the [RPi installation steps](https://mystnodes.com/onboarding/rpi/existing/0), which include the following command. It adds their 'repository' to apt to allow apt to find the `myst` package and install it.
  
    ```console
    grep -qxF 'deb http://ppa.launchpad.net/mysteriumnetwork/node/ubuntu focal main' /etc/apt/sources.list || echo 'deb http://ppa.launchpad.net/mysteriumnetwork/node/ubuntu focal main' | sudo tee -a /etc/apt/sources.list > /dev/null
    ```

    However, that command does not verify the author's PGP key, so apt will refuse to install the myst package directly. To fix that, you will need to download the key and add it to APT:

    ```console
    gpg --no-default-keyring --keyring ~/.gnupg/mysterium-network-keyring.gpg --keyserver keyserver.ubuntu.com --recv-keys ECCB6A56B22C536D # If this raises an error saying that the directory does not exist, run `mkdir ~/.gnupg`
    sudo mv ~/.gnupg/mysterium-network-keyring.gpg /usr/share/keyrings/
    ```
  
    Followed by replacing the last line of `/etc/apt/sources.list` with this one:

    ```console
    deb [signed-by=/usr/share/keyrings/mysterium-network-keyring.gpg] http://ppa.launchpad.net/mysteriumnetwork/node/ubuntu focal main
    ```

1. ### Install myst

    ```console
    sudo apt update # Yes, again
    sudo apt install myst
    ```
  
    Just before finishing, it will prompt you to accept the terms of service.
    Once it finishes, it will start a web server on port 4449, so you can access it on `http://<raspberry_ip>:4449` from any device in your local network.

1. ### Configure myst

    If you're already connected, great! You're half the way there.

    Press `Start node setup` and you will be presented with a screen like this:
    ![Setup image 01](/image/2022-05-30_mysterium-dvpn/setup01.png)

    Now it's the time to pay to be registered. Follow the instructions on the web, either paying a cryptocurrency or with a fiat coin.

    After you pay, you will be presented with the screen that asks you to enter your withdrawal account. This should be the account where you want your earnings to be deposited. (I leave there my address in case you want to send me something :P)
    ![Setup image 02](/image/2022-05-30_mysterium-dvpn/setup02.png)

    Then you will be prompted for a password to acces your admin panel, and after a short wait you will be redirected to your main dashboard, which should look like this:
    ![Setup image 03](/image/2022-05-30_mysterium-dvpn/setup03.png)

1. ### MystNodes

    There is a service to monitor your nodes and admin them from a central location. You will need to create an account at [their official website](https://mystnodes.com/registration), which will then give you an API key. (Look [here](https://mystnodes.com/me) after logging in if you can't find it).

    This API key wil allow you to add your node to [their admin panel](https://mystnodes.com/nodes), where you can see you nodes' status and access their admin panels.

    To add it to your node, go to the settings tab and paste it in the top right menu.
    ![Setup image 04](/image/2022-05-30_mysterium-dvpn/setup04.png)

    Then, when you access your admin panel, you should see something like this, showing that your node has been recognized. It may take a few minutes to be set as online, so don't worry if it isn't online yet.
    ![Setup image 05](/image/2022-05-30_mysterium-dvpn/setup05.png)

1. ### Terms of the dashboard

    - Unsettled earnings: What you earn directly from connections before fees.
    - Settle: Apply fees and transfer your earnings to the node's wallet. Settlement fee is 20% plus current blockchain fees (0.0129997 MYST when writing).
    - Withdraw: Transfer your settled earnings to your external wallet, aplying network fees (0.0147109 MYST when writing). These fees will depend on the amount of traffic of the network at that moment.

1. ### Other notes

    All movements of cryptocurrencies take some time, so be patient. The usually finish in under a minute, but depending on when it's made, it could take longer.

    If you're having problems getting your node running, check out their wiki for more info that I may have missed or not needed [here](https://docs.mysterium.network/for-node-runners/intros-mysterium-node).

    Avoid swapping coins as much as you can, as every swap implies a fee.

## Conclusions

Having a dVPN node in your network can be useful if you want to contribute to a growing network of users providing freedom at a low price, while earning something in return (which then you can use to connect to ther nodes). It is also a great way of learning about cryptocurrencies, the blockchain concept and decentralized services.

---

Thanks for reading!

Done with 🖤 by Appu.
