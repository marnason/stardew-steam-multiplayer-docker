# Stardew Valley Multiplayer Docker Compose

This project aims to autostart a Stardew Valley Multiplayer Server as easy as possible.

## Notes

- Previous versions provided game files to create the server with the Docker container. To respect ConcernedApe's work and follow intellectual property law, this will no longer be the case. Users will now be required to use their own copy of the game.
- Thanks printfuck and cavazos-apps for the base code.

<a href="https://www.buymeacoffee.com/huntercavazos" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="41" width="174"></a>


## Setup

### Steam

This image will download the game from Steam server using [steamcmd](https://developer.valvesoftware.com/wiki/SteamCMD) if you own the game. For that, it requires your Steam login.

The credential variables are required only during building, not during game runtime.

```
## Set these variables only during the first build or during updates
export STEAM_USER=<steamUsername>
export STEAM_PASS=<steamPassword>
export STEAM_GUARD=<lastesSteamGuardCode> # If you account is not protected, don't set

docker compose -f docker-compose-steam.yml up
```

#### Steam Guard

If your account is protected by Steam Guard, the build is a little time sensitive. You must open your app and export the current Steam Guard to `STEAM_GUARD` environment variable code right before building.

**Note: the code lasts a little longer than shown but not much.**

After starting build, pay attention to your app. Even with the code, it will request for authorization which must be granted.

If the build fails or when you want to update with `docker compose -f docker-compose-steam.yml build --no-cache`, you should set the newer `STEAM_GUARD` again.

```
## Remove env variables after build
unset STEAM_USER STEAM_PASS STEAM_GUARD
```
### Configuration

Edit the docker-compose-steam.override.yml with your desired configuration settings. Setting values in docker-compose-steam.yml are quite descriptive as to what they set.

## Game Setup

Initially, you have to create or load a game once via VNC or web interface. After that, the Autoload Mod jumps into the previously loaded game save everytime you restart or rebuild the container. The AutoLoad Mod config file is by default mounted as a volume, since it keeps the state of the ongoing game save, but you can also copy your existing game save to the `Saves` volume and define the game save's name in the environment variables. Once started, press the Always On Hotkey (default F9) to enter server mode.

### VNC

Use a VNC client like `TightVNC` on Windows or plain `vncviewer` on any Linux distribution to connect to the server. You can modify the VNC Port and IP address and Password in the `docker-compose.yml` file like this:

Localhost:

```
   # Server is only reachable on localhost on port 5902...
   ports:
     - 127.0.0.1:5902:5900
   # ... with the password "insecure"
   environment:
     - VNCPASS=insecure
```

### Web Interface

On port 5800 (mapped to 5801 by default) inside the container is a web interface. This is a bit easier and more accessible than just the VNC interface. Although you will be asked for the vnc password, I wouldn't recommend exposing the port to the outside world.

![img](https://store.eris.cc/uploads/859865e1ab5b23fb223923d9a7e4806b.PNG)

## Accessing the server

- Direct IP: You will need to set a up direct IP access over the internet "Join LAN Game" by opening (or forwarding) port 24642. Feel free to change this mapping in the compose file. People can then "Join LAN Game" via your external IP.

(Taken from mod description. See [Always On Server](https://www.nexusmods.com/stardewvalley/mods/2677?tab=description)
for more info.)

## Mods

- [Always On Server](https://www.nexusmods.com/stardewvalley/mods/34403) (Default: Required)
- [Auto Load Game](https://www.nexusmods.com/stardewvalley/mods/2509) (Default: On)
- [Crops Anytime Anywhere](https://www.nexusmods.com/stardewvalley/mods/3000) (Default: Off)
- [Friends Forever](https://www.nexusmods.com/stardewvalley/mods/1738) (Default: Off)
- [No Fence Decay](https://www.nexusmods.com/stardewvalley/mods/1180) (Default: Off)
- [Non Destructive NPCs](https://www.nexusmods.com/stardewvalley/mods/5176) (Default: Off)
- [Remote Control](https://github.com/Novex/stardew-remote-control) (Default: On)
- [TimeSpeed](https://www.nexusmods.com/stardewvalley/mods/169) (Default: Off)
- [Unlimited Players](https://www.nexusmods.com/stardewvalley/mods/2213) (Default: On)

## Troubleshooting

### Waiting for Day to End

Check VNC just to make sure the host hasn't gotten stuck on a prompt.

### Error Messages in Console

Usually you should be able to ignore any message there. If the game doesn't start or any errors appear, you should look for messages like "cannot open display", which would most likely indicate permission errors.

### VNC

Access the game via VNC to initially load or start a pre-generated game save. You can control the server from there or edit the config.json files in the configs folder.
