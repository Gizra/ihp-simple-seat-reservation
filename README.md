# IHP Simple Seat Reservation

## GitPod

<a href="https://gitpod.io/#https://github.com/Gizra/ihp-simple-seat-reservation"><img src="https://gitpod.io/button/open-in-gitpod.svg"/></a>

## Local

1. After following the steps to install [IHP](https://ihp.digitallyinduced.com/Guide/installation.html), you can run this app locally by running:

```bash
direnv allow
devenv up
```

2. In another tab execute `make tailwind-dev` to compile the CSS.
3. On a third tab you can execute `mailhog`, and watch the emails under http://0.0.0.0:8025/ ([how to install `mailhog`](https://github.com/mailhog/MailHog?tab=readme-ov-file#installation))
4. Create 20 reservations in parallel in another tab. You can see the number of reservations increase at localhost:8001/ShowEvent:
```
time seq 20 | parallel -n0 "curl 'http://localhost:8002/CreateReservation' -H 'content-type: application/x-www-form-urlencoded' --data-raw 'eventId=7a7e856f-8475-48f5-977b-21bb85133a88&personIdentifier=1234' --compressed"
```

## Test

```
nix-shell
ghci
:l Test/Main
main
```

If you get an error [see this](https://ihp.digitallyinduced.com/Guide/testing.html#:~:text=Please%20note%20that%20when%20entering).
