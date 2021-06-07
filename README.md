### `freenom-docker`, a wrapper for `freenom-script` intended for use with cloud providers.

---

**Usage**:

1) Build the container with your email and password.
    * `docker build . -t freenom-docker --build-arg FREENOM_EMAIL="me@example.com" --build-arg FREENOM_PASSWORD="YOUR_PASSWORD_HERE"`

2) Run the container.
    * `docker run -it freenom-docker -- -l` (List domain(s))
    * `docker run -it freenom-docker -- -r example.com` (Renew domain(s))
    * Other commands, such as DNS modification, are not intended by this wrapper but still work. For documentation of these, see [`freenom-script`'s README](https://github.com/mkorthof/freenom-script/blob/master/README.md)

3) (Optional) Export the container for cloud providers.
    * **Warning**: Any moderately skilled software engineer will be able to reverse engineer your email and password from the docker image. Only share it with cloud providers you trust!
    * `docker save freenom-docker > freenom.tar`
