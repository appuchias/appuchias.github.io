---
title: 'QuickEMU+SSH for school-related projects'
description: 'Install what you need without messing up your OS'
author: Appuchia
date: 2024-03-31
lastmod: 2024-05-11
categories:
  - Development
  - Class
tags:
  - QuickEMU
  - SSH
  - VSCode
# cover:
#     image: '/images/2024 03 31_QuickEMU_for_classes'
---

I recently had to install some software in my computer that I knew would mess
with system libraries and give me some trouble in the future, so it occurred to
me that using a VM and connecting to it through the VSCode SSH Tunnel extension
to write the code I needed could be a great alternative to installing it directly
and it wouldn't break anythin in my OS.

# Introduction

## My current setup

This is a bit of a disclaimer of sorts.

My Linux distro of choice is Arch.
I've been using it for some years now and I'm
pleased with it.

This post covers my setup, using VSCode (for in-class simultaneous editing), the fish shell and Arch Linux.
If you're running any other setup, you'll need to adapt some aspects to how you do things.

> 2024-05-11: I'm now using zsh instead of fish, but the function I created for fish can be easily adapted to zsh. I added the zsh equivalent after the fish function.

## What is QuickEMU

[QuickEMU](https://github.com/quickemu-project/quickemu) is a really quick way to create VMs of any OS using QEMU and KVM.

For installation instructions, go to the project's homepage.

After you have it installed, you can use it as easy as:
```shell
quickget <OS/Distro> <version> <variant>
```

and

```shell
quickemu --vm <.conf file>
```

You can reference both commands' options using `--help`.

There's also an official GUI application available [here](https://github.com/quickemu-project/quickgui).

## What I needed

I needed to install Julia, but not only Julia.

I needed some libraries, including Flux and Scikit-Learn.

This will explain some things that happen after

---

# The idea

## Creating an Arch Linux VM

To do this, just run `quickget archlinux latest` and then
`quickemu --vm archlinux-latest.conf` in that same folder.

That will download the ISO and run the VM for the first time.
The `quickemu` command will also print all the info you might need to connect to
the running VM in case you accidentally close the SPICE connection that will start.

To use a better SPICE client, simply add `--display=spice`.
This will launch a different app to view the VM's screen output.
To release the mouse and keyboard from this app, you'll need to press `SHIFT+F12`.

It will give the VM (at least in my machine) a 16GB qcow2 disk, 4 cores and 8GB of RAM.

### Installation

It'll be better if you use Arch installed rather than the live ISO, so once you
boot the VM for the first time, install it as you normally would (`archinstall`
comes handy).

My recommendations for archinstall are:

- Use a best-effort partitioning for your disks with ext4
- Use systemd-boot
- No swap
- Create a sudo user (apart from root)
- Profile: Minimal
- No audio server
- `linux` kernel
- Add the vim, git and base-devel packages
- Copy the ISO network config
- Add the multilib repo if you think you'll need it

However, feel free to install it as you please.

After installation, don't chroot and run `poweroff`.

Then, start back the VM with the same display mode and log in as your user before continuing.

## SSH-ing easily

To use SSH, you'll need to install the `openssh` package with `sudo pacman -S openssh`
After installation, enable it and start it with `sudo systemctl enable --now sshd`

QuickEMU automatically redirects your guest's port 22 to your host's port 22220,
so, to SSH into the VM you can run `ssh user@localhost -p 22220`.

For a more permanent solution, I added the following to my `~/.ssh/config`:
```shell
QuickVM
    HostName localhost
    Port 22220
    User user
```

Having this config makes connecting to the VM as easy as `ssh QuickVM`

But there's a catch.
If you start another VM after this one (not simultaneously), you won't be able
to connect to it immediately, as the guest VM SSH keys will be different and
OpenSSH will reasonably complain to protect you from a [MITM attack](https://en.wikipedia.org/wiki/Man-in-the-middle_attack).

To remove the notice (DO IT ONLY IF YOU'RE SURE IT MAY HAVE CHANGED, WORRY OTHERWISE)
run `ssh-keygen -R [localhost]:22220`.

## Configuring and workflow

### Configuration

I created this fish function to start the VM without a display, connect to it
through SSH, and kill it once you end the SSH session, which turns it off.

It uses `~/VMs/QuickEMU/` as the base path for existing VMs.

```fish
function quickvm -d "Start a QuickEMU VM from anywhere"
  set vm_name $argv[1]

  # Set the user
  if test $argv[2]
    set user $argv[2]
  else
    set user YOUR_USER_HERE
  end

  cd ~/VMs/QuickEMU/

  quickemu --vm $vm_name.conf --display none; ssh-keygen -R [localhost]:22220; ssh $user@localhost -p 22220; cat $vm_name/$vm_name.pid | xargs kill

  cd -
end
```

> 2024-05-11: Here's a zsh equivalent:
> ```zsh
> quickvm() {
>     export vm_name=$argv[1]
>     export user=$(whoami)
> 
>     # if [ -n "$argv[2]" ]; then
>     #     export user=$argv[2]
>     # fi
> 
>     cd $QUICKEMU_DIR
> 
>     # Headless VM
>     quickemu --vm $vm_name.conf --display none
> 
>     # SSH into the VM
>     ssh-keygen -R '[localhost]:22220'
>     ssh $user@localhost -p 22220
> 
>     # Kill the VM
>     cat $vm_name/$vm_name.pid | xargs kill
> }
> ```
>
> This could be improved, but it works for now.
>
> Also, I'm using the `QUICKEMU_DIR` variable to store the path to the VMs. (`~/VMs/QuickEMU/` in the fish function)

QuickEMU is smart enough to only start the VM if it isn't already running, so
don't worry if you run it twice.

It removes the stored SSH keys for `localhost:22220` every time it runs, which
may be unsafe depending on your needs and environment, so change it as you see fit.
This implies that you'll need to type "yes" on every connection, which can mess
with automated scripts.

To avoid having to type your guest password every time you start the VM, you can
run `ssh-copy-id -p 22220 user@localhost` from your host when the VM is running
to copy your SSH key to the VM's authorized keys list.
This will come handy when connecting from VSCode.

Another recommendation is to create a SSH key in the VM (`ssh-keygen -t ed25519`
for an elliptic-curve key), and then adding it to your GitHub associated SSH keys
[here](https://github.com/settings/keys).
This will allow you to clone your private repos and push commits easily, just
make sure to use the git URL instead of the HTTPS one.

Don't forget to set your git `user.name` and `user.email` configs!
```shell
git config --global user.name NAME # Also user.email
```

Another option is to use the shared folder QuickEMU creates, although I haven't
tried it. In theory it should work fine and you could commit from your host.

### Workflow

The whole point of this setup is running software you don't want in your computer
inside a VM to keep things separate. And finally it's the time to do it.

If SSH is enough for you, this may be all you need to start working!
Install whatever software you need and go ahead.

If you want to use VSCode, you need some more things, mainly installing the SSH
remote extension in VSCode. [Here's a link](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh).

Once installed, you'll see the remote icon on the bottom left of your screen.
It should look like 2 little arrows pointing at each other, someting like ><.

Press it and then select "Connect Current Window to Host" or "Connect to Host",
the latter creating a new window.
Then choose `QuickVM` if you configured it in `~/.ssh/config` or type the address
at the top.

There might appear more popups, but they should be straight-forward.

After it connects, you're in!
Select the folder you want to work in or clone a repo and start coding as you
normally would.

The only difference you will find is that you'll need to install the extensions
again in the remote machine, but you can do it from your VSCode app, just choosing
"Install in SSH: QuickVM" instead of simply "Install" for new extensions.

---

# My experience

I was mad at Julia for installing conda in my laptop without me noticing, and I
didn't want to mess my pc, so I decided to use this setup for it.

Installing Julia gave me some trouble, as I tried many distros until I finally ended
up using Arch:

- Debian 12.5 didn't have the binary???
- Debian 11 was too old for the packages I needed.
- I didn't even bother with Ubuntu.
- I tried alpine, but I couldn't get it configured quickly enough and I was really tired of trying. (Probably skill issues)

Finally, I settled with Arch.

Following the [Arch Wiki](https://wiki.archlinux.org/title/Julia) I installed Julia (`paru -S julia-bin`), and then the packages I needed (`sudo pacman -S python-scikit-learn`).
I also installed `Flux` with `julia`'s package manager inside the REPL.

I installed the `Julia` extension in VSCode and connected to the VM with the SSH extension.

I cloned my repo and started working on it.

Take into account that commits won't be signed unless you copy your keys to the VM,
and that you'll need to add the VM's SSH key to your GitHub account in order to clone private repos.

## Some tips learned

Originally I was going to roast Julia in this section, but I have learned to bear with it.

It has its benefits and it's quite quick after the first execution, so I'm mostly happy with it.

I'm not sure if this covers all the things I wanted to say, but I think it's enough for now.
For any questions, feel free to ask me, you can find my socials in the homepage.

---

Thanks for reading!

Done with 🖤 by Appu.
