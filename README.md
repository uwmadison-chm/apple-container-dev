# apple-container-dev
A Dockerfile and entrypoint script for launching agents with Apple's [container](https://github.com/apple/container).

Sets up a fairly minimal environment, adding a local user with matching username and uid for
your current user. Also has an entrypoint script that fixes permissions on $SSH_AUTH_SOCK inside the container, so your user can use it.

Expect to tweak the Dockerfile a bit to suit your needs, but this is a good starting point.

Build with:

```
container build --build-arg USER=$USER --build-arg UID=$UID --tag <image_tag> .
```

Run with:

```
container run --ssh -it --name <container_name> <image_tag>
```

... and, of course, you may want to mount data into it with `-v` as well.

## Why not `container machine`?

`container machine` fixes permissions and maps your user account much more simply, but! It automatically mounts $HOME into your container. If you're using containers as a _data isloation boundary_ -- in particular to prevent exfiltration of data restricted by HIPAA or and NDA or the like -- you can't do that.

Yes, I know: Don't store that data in $HOME. But people are people and if you work with that data, it's very easy to make mistakes.
