# Steam Deck Optimized
Optimizations and fixes for the Steam Deck.

# What does this include?
There are several issues I encountered on my first day with my Steam Deck, but Arch Linux is my jam
and fixing them was a quick and easy endevour. I have had a lot of experience in virtualization and native
Linux gaming and decided this was a worthy opponent!

Keep in mind, I have had my Steam Deck for a single day so far. There is more to be done! I will add to
this as I fully learn and understand this system. Theres a lot of good resources out there and I encourage
everyone to participate in this project!

These are the improvements,
* Enable SSH
* Secure SSH by locking root and password login
* Add UFW as a firewall, enable it, and allow SSH
* Prevent sleep mode when SSH sessions are active, but let the screen turn off
* On wake, restart PipeWire to solve the distorted audio on wake issue. Testable with Hades (Vulkan Mode).
* Add persistent directories and enable files for update persistence

# How to install
Theres a few steps here, and they are ALL mandatory, and need to be in order.

First, enter Desktop mode and launch `Konsole`

Then from the terminal run the following command to set your password for the `deck` user.
```
passwd
```

Login as root,
```
sudo su
```

Install Steam Deck Optimized,
```
curl -q https://raw.githubusercontent.com/eb3095/steamdeck-optimized/master/setup.sh | bash
```

Easy right? Now you are stylin!

# When you do an update
How this works is still a little shaky with me. I install this to the home directory for the `deck` user
to avoid being wiped in their flash, but this is not currently guaranteed. Reach out if this needs updated!

To re-enable after an update,

Login as root,
```
sudo su
```

Re-enable
```
/home/deck/.steamdeck-optimized/setup.sh
```

# I love this, can I help?
Well, theres two ways you can help,

* Add code via Pull Requests
* If you have the ability to speak to someone at Valve, please have them reach out! I would love to establish
  a line of communication between them and the company I work for. We are looking to enter the Cloud Gaming arena
  and we would very much like Valve to be involved, but we will settle with permission for us to include Steam ourselves!
  