# friends-player

A bunch of scripts used on my RPI based Friends video player.
You can use this repo to make a sequential media player with a Raspberry Pi.
Use a Raspbian image without X.

## Dependencies

- omxplayer
- actkbd
- fbi

## Usage

- Copy **config-sample** to **config** and edit it if necessary.
- Copy **gettitle-example.sh** to **gettitle.sh** and edit it if necessary.
- Copy the contents of **to-rc.local** to **/root**, copy it's **config-sample** to **config** and edit it if necessary.
- Add **/root/init.sh** to **/etc/rc.local**

## Notes

- If the background does not fill the entire framebuffer, then set
  **disable_overscan=1** in /boot/config.txt
