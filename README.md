# Arch Linux Installation Medium on NixOS

![This screenshot may be outdated](screenshots/pacstrap.png)

Great thanks [@NickCao](https://github.com/NickCao) and other members of [NixOS Chinese Telegram Group](https://t.me/nixos_zhcn) for their help on this project!

## Build instructions

1. Clone this repository.

```sh
git clone https://github.com/SamLukeYes/my-livecd.git
cd my-livecd/
```

2. Have a look at `mirror.nix`, `reverse-proxy.nix` and `makeiso.sh`. Modify them according to their comments. You can also edit `iso.nix` for further customization.

3. Run `makeiso.sh`.

```sh
chmod +x makeiso.sh
./makeiso.sh
```

4. Get the iso file in `result/iso` directory.