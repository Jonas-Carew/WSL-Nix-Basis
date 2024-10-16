# WSL NixOS Install Guide

This is a step-by-step guide on how to install NixOS on WSL2 for windows 10 & 11. It uses both Home-manager and Nix Flakes to personalize and compartmentalize the configuration.

## Setting up a nice CLI

Your CLI (Command Line Interface) is where you'll do a lot of work, and so it is important that it looks nice. In this section we'll install PowerShell and Windows Terminal and have the opportunity to beautify them.

### Windows Shells are Dumb

All Windows machines come preinstalled with Windows PowerShell, but that hasn't been updated since 2016. Instead we want PowerShell - which, despite the name, is a different program. To get PowerShell through the CLI you already have:

- Open Command Prompt
  
  - Search for "Command Prompt" or "cmd" in the Windows search bar

- Run the following snippet in Command Prompt
  
  ```powershell
  winget install --id Microsoft.PowerShell --source winget
  ```
  
  And it's done! You have PowerShell installed and we'll get to use it shortly.

### Your Terminal and You

For your terminal emulator (the GUI for your CLI) I recommend Windows Terminal, which can be installed from the Microsoft Store [here](https://apps.microsoft.com/detail/9n0dx20hk701).

Windows Terminal is highly customizable, in its settings menu (<kbd>Ctrl</kbd> + <kbd>,</kbd>) and some recommendations are below.

- To set PowerShell as your default shell, go to *Startup&rarr;Default profile* and select PowerShell.
- To set Windows Terminal as your default Terminal Emulator, go to *Startup&rarr;Default terminal application* and select Windows Terminal.
- To set Light/Dark theme, go to *Appearance&rarr;Application Theme* and choose your desired theme.
- Other appearance preferences are in your profile - Changing *Defaults* is my go-to so I don't have to worry if I use a different shell. My favorites are below:
  - Color scheme: One Half Dark (preinstalled)
  - Font face: FiraCode Nerd Font (Found on the [Nerd Fonts Page](https://www.nerdfonts.com/font-downloads))
  - Font size: 12
  - Cursor shape: Bar ( **|** )

## Getting WSL with NixOS

Now that we have a pretty CLI, we can really get started with WSL. In this section we will install WSL without a distribution, download and install NixOS, and use GitHub to install a flake with a bunch of nice settings.

### NixOS on WSL

Installing WSL normally will include Ubuntu with it, but we won't need that, so run

```powershell
wsl --install --no-distribution
```

To get NixOS itself, we'll download the latest release of NixOS from GitHub. To do this, visit the [NixOS latest release](https://github.com/nix-community/NixOS-WSL/releases/latest) on GitHub and scroll down until you find a list of files. Download `nixos-wsl.tar.gz`, the NixOS tarball.
From here, we have to create a folder to store your NixOS related files. I'll be naming mine "NixOS" and placing it on my desktop, although you can place it anywhere. We can then move the NixOS tarball we downloaded into our NixOS folder.

***Important: WSL requires virtualization ON in your BIOS. There is a good chance it is on by default, but if you run into an error, this is important to check.***

To install NixOS onto WSL we first move into our NixOS folder:

```powershell
cd C:\Users\<USERNAME>\Desktop\NixOS\
```

then we add NixOS to WSL

```powershell
wsl --import NixOS . .\nixos-wsl.tar.gz
```

And to make NixOS our default Linux distribution we can use

```powershell
wsl --set-default NixOS
```

And finally to enter into NixOS we can use

```powershell
wsl
```

### A Couple Tiny Changes

The wonders of NixOS allow us to create our hardware and system configuration declaratively, meaning you can simply download a configuration from GitHub or get one from a friend!

To do this, we have to change the configuration a little bit. To access the configuration we'll navigate to the configuration directory:

```bash
cd /etc/nixos
```

and edit the configuration in the only text editor we have: Nano

```bash
sudo nano configuration.nix
```

This file is written in the nix language which has many cool properties, but for now we just need a little snippet to give us some useful tools such as vim and git. Enter this snippet of code right before the final curly brace of your configuration:

```nix
environment.systemPackages = with pkgs; [
    xclip
    vim
    git
];
```

Finish by pressing <kbd>Ctrl</kbd>+<kbd>x</kbd> to exit, <kbd>y</kbd> to save, and <kbd>enter</kbd> to save as the same name.
To reload our declarative configuration we'll use a command which you'll see often:

```bash
sudo nixos-rebuild switch
```

### NixOS is Declarative!

We're now going to use github to clone and fork this repository so that you have your own NixOS configuration locally which is backed up to github! Before we do this, we first have to be able to use this directory as your user and not ROOT. To do this, we will run

```
sudo chown nixos .
```

From here, you can fork this repository to have your own copy and record of all of your system versions. To fork this repository, click the down arrow next to the **Fork** button at the top right of the screen. The defaults all work here, so click **Create Fork** to have your own repo. Next, clone your new repository by clicking on clicking on the green **Code** button, copying the url, and running

```
git clone <YOUR URL>
```

You now have the entire configuration on your local system, and we just need to move into the directory

```
cd WSL-Nix-Basis
```

and build the configuration

```
sudo nixos-rebuild switch --flake .#wsl
```

## Read the wiki!

To learn more about how to use all of the different modules, tools, and aliases in this setup, check the [wiki](https://github.com/Jonas-Carew/WSL-Nix-Basis/wiki)!
