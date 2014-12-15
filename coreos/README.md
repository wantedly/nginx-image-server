## CoreOS
## Running nginx-image-server on CoreOS
There is cloud-config to run nginx-image-server as systemd unit on CoreOS.
So you need to just set some environment variables to `.env`.

```bash
$ cd nginx-image-server/coreos
$ cp .env.sample .env
$ vi .env
```

or you can have your own config for nginx-image-server by overwriting `user-data.erb.yml`.

### Launch CoreOS on Virtualbox

```bash
$ vagrant up
```

### Launch CoreOS on EC2

```bash
$ vagrant up
```

Then `user-data` file will be created.
Launch EC2 CoreOS machines with it.

See [Running CoreOS on EC2](https://coreos.com/docs/running-coreos/cloud-providers/ec2/)
