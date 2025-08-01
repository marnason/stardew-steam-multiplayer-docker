# Stardew Valley Multiplayer Docker Compose

This project aims to autostart a Stardew Valley Multiplayer Server as easy as possible.

## Notes

- Previous versions provided game files to create the server with the Docker container. To respect ConcernedApe's work and follow intellectual property law, this will no longer be the case. Users will now be required to use their own copy of the game.
- Thanks printfuck and cavazos-apps for the base code.

<a href="https://www.buymeacoffee.com/huntercavazos" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="41" width="174"></a>


## Setup

### Steam

This image will download the game from Steam server using [steamcmd](https://developer.valvesoftware.com/wiki/SteamCMD) if you own the game. It requires a Steam login key for authentication.

#### Setup Process

**Step 1: Generate a Steam Login Key**

Run the provided script to generate your login key:

```bash
./get-steam-login-key.sh
```

This script will:
- Prompt for your Steam username, password, and Steam Guard code
- Authenticate with Steam and generate a login key
- Display instructions for the next step

**Step 2: Configure Override File**

Edit `docker-compose-steam.override.yml` and add your credentials:

```yaml
services:
  valley:
    build:
      args:
        STEAM_USER: "your_username"
        STEAM_LOGIN_KEY: "your_generated_login_key"
```

**Step 3: Run the Server**

```bash
./install-stardew.sh
```

#### Manual Setup

If you prefer to generate the login key manually:

```bash
# Generate login key
steamcmd +login your_username your_password your_steam_guard_code +quit

# Copy the displayed login key and add it to docker-compose-steam.override.yml
# Then run:
docker compose -f docker-compose-steam.yml -f docker-compose-steam.override.yml up --build -d
```

#### Why This Approach?

This workflow separates credential generation from server deployment:

- **Security**: Credentials are stored in the override file (can be gitignored)
- **Simplicity**: One-time setup, then `./install-stardew.sh` always works
- **Reliability**: Login keys don't expire quickly and work consistently
- **Automation-Friendly**: Perfect for CI/CD or repeated deployments

#### Security Notes

- Add `docker-compose-steam.override.yml` to your `.gitignore` to avoid committing credentials
- Login keys provide the same access as your password, store them securely
- You can revoke login keys from your Steam account settings if needed
### Configuration

Write Steam username and password into, and edit the `docker-compose-steam.override.yml` with your desired configuration settings. Values in `docker-compose-steam.yml` are quite descriptive as to what they set.

## Game Setup

Initially, you have to create or load a game once via VNC or web interface. After that, the Autoload Mod jumps into the previously loaded game save everytime you restart or rebuild the container. The AutoLoad Mod config file is by default mounted as a volume, since it keeps the state of the ongoing game save, but you can also copy your existing game save to the `Saves` volume and define the game save's name in the environment variables. Once started, press the Always On Hotkey (default F9) to enter server mode.

### VNC

Use a VNC client like `TightVNC` on Windows or plain `vncviewer` on any Linux distribution to connect to the server. You can modify the VNC Port and IP address and Password in the `docker-compose-steam.yml` file like this:

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
