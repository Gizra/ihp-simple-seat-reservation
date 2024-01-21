# IHP Simple Seat Reservation

## Local

1. After following the steps to install [IHP](https://ihp.digitallyinduced.com/Guide/installation.html), you can run this app locally by running:

```bash
direnv allow
devenv up
```

2. In another tab execute `make tailwind-dev` to compile the CSS.

`MailHog` is running with `devenv up`, so you can see the emails under http://0.0.0.0:8025/

## Test

```
nix-shell
ghci
:l Test/Main
main
```

If you get an error [see this](https://ihp.digitallyinduced.com/Guide/testing.html#:~:text=Please%20note%20that%20when%20entering).

## GitPod

<a href="https://gitpod.io/#https://github.com/Gizra/ihp-simple-seat-reservation"><img src="https://gitpod.io/button/open-in-gitpod.svg"/></a>