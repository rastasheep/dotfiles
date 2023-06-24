# Fleek Configuration

nix home-manager configs created by [fleek](https://github.com/ublue-os/fleek).

## Reference

- [home-manager](https://nix-community.github.io/home-manager/)
- [home-manager options](https://nix-community.github.io/home-manager/options.html)

## Usage

Aliases were added to the config to make it easier to use. To use them, run the following commands:

```bash
# To change into the fleek generated home-manager directory
$ fleeks
# To apply the configuration
$ apply-$(hostname)
```

Your actual aliases are listed below:
    .. = "cd ..";

    ack = "ag";

    apply-mbp = "nix run github:ublue-os/fleek -- apply -l src/github.com/rastasheep/dotfiles";

    dc = "docker compose";

    df = "df -hT";

    e = "vim";

    f = "fg";

    fleeks = "cd ~/src/github.com/rastasheep/dotfiles";

    history = "fc -El 1";

    j = "jobs";

    ll = "ls -lah";
