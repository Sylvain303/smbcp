# Samba copy wrapper with to notify-send

Shell wrapper for linux, tested on xfce with notify-send.

Copy the given argument to a remote storage using smbclient.

## install

~~~
git clone smbcp
sudo apt-get install smbclient
~~~

## save config

~~~
# put your value in smbcp.conf
# smbcp overide config (this is bash code)
SHARE="//freebox_server/disque dur"
SMB_PATH="/Téléchargements/A Télécharger"
SMBUSER=freebox
SMBPASS=somepass4you
~~~


## Usage

~~~
smbcp path/to/somefile
~~~

~~~
smbcp local_path somefile
~~~


### cool usage !

from FireFox with your favorite torrent file to your Freebox seebox!

Test that it works from command line, first.

FireFox:

1. save the torrent file and check the box to remember
2. modify in preferences, execution program look for "torrent Seed"
3. browse to find smbcp

Debug look into `mozilla…/mimeTypes.rdf`, there should be an entry here for torrent.


Now ?

One click, save and dowload on your local seedbox, and share all those linux image you want and more !

Enjoy.

