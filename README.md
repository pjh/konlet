# Compute Engine Container Startup Agent

The Compute Engine container startup agent starts a container deployed on a VM
instance using [Deploying Containers on VMs and Managed Instance Groups](
https://cloud.google.com/compute/docs/instance-groups/deploying-docker-containers) method.

The agent parses container declaration that is stored in VM instance metadata
under `gce-container-declaration` key and starts the container with the declared
configuration options.

The agent is bundled with [Container-Optimized OS](
https://cloud.google.com/container-optimized-os/docs/) image, version 62 or higher.

## Building the agent

### Linux

Container startup agent is deployed as a Docker container and is hosted in
Container Registry:
[gcr.io/gce-containers/konlet](http://gcr.io/gce-containers/konlet).

To build the agent using bazel run these commands from the repository root:
```shell
$ pushd gce-containers-startup
$ bazel build :gce-containers-startup
$ popd
```

Export your GCP project name to an environment variable:
```shell
$ export MY_PROJECT=your-project-name
```

To build a Docker image, copy the build binary to the 'docker' directory and
invoke the docker build command:
```shell
$ cp gce-containers-startup/bazel-bin/gce-containers-startup docker/
$ docker build docker/ -t gcr.io/$MY_PROJECT/gce-containers-startup
```

To push resulting Docker image to Google Container Registry you can use [gcloud
command](https://cloud.google.com/container-registry/docs/pushing-and-pulling):
```shell
$ gcloud docker -- push gcr.io/$MY_PROJECT/gce-containers-startup
```

### Windows

The container startup agent works on Windows Server, version 1709 and later.

Container startup agent is deployed as a Docker container and is hosted in
Container Registry:
[gcr.io/gce-containers/konlet](http://gcr.io/gce-containers/konlet).

The container startup agent cannot be built on Windows using Bazel at this time because of
[limitations](https://github.com/bazelbuild/rules_go/issues/1007) with the Go
rules for Bazel. The agent can be cross-compiled for Windows on a Linux host by
using the Go compiler directly.

To do this, first make sure that this repository is located in an appropriate
location in your Go workspace, e.g.
`$HOME/go/src/github.com/GoogleCloudPlatform/konlet`.  Then, run these commands
from the repository root:

```shell
> go get github.com/Microsoft/go-winio

# If you fork the repository then substitute your github username for
# GoogleCloudPlatform:
> go build github.com/GoogleCloudPlatform/konlet/gce-containers-startup
```

The container startup agent can also be cross-compiled for Windows on a Linux
host by invoking these commands:

```shell
$ cd $HOME/go  # or $GOPATH
$ mkdir github.com/GoogleCloudPlatform
$ cd github.com/GoogleCloudPlatform
$ git clone git@github.com:GoogleCloudPlatform/konlet.git
$ cd konlet
# go get -d to download to the workspace but not install on the host.
$ GOOS=windows go get -d github.com/Microsoft/go-winio
$ GOOS=windows go build github.com/GoogleCloudPlatform/konlet/gce-containers-startup
```

Export your GCP project name to an environment variable in Powershell:
```shell
> $MY_PROJECT = "your-project-name"
```

To build a Docker image, run the following Powershell commands to copy the build
binary to the `docker` directory and perform the docker build:
```shell
> cp gce-containers-startup.exe .\docker-windows\
> docker build .\docker-windows\ -t gcr.io/$MY_PROJECT/gce-containers-startup
```

To push resulting Docker image to Google Container Registry you can use [gcloud
command](https://cloud.google.com/container-registry/docs/pushing-and-pulling):
```shell
> gcloud docker -- push gcr.io/$MY_PROJECT/gce-containers-startup
```

## Usage

If you would like to install the container startup agent on your VM, copy its systemd service definition and scripts:

* Copy `systemd` service definition `konlet-startup.service` into systemd services directory, e.g. `/usr/lib/systemd/system`.

* Copy `get_metadata_value` script to `/usr/share/google` directory.

* Copy `konlet-startup` script to `/var/lib/google` directory


You can also those scripts directly by a [startup script](https://cloud.google.com/compute/docs/startupscript),
`cloud-init` or `rc.d` scripts.


## License

Compute Engine container startup agent is licensed under Apache License 2.0. The
license is available in the [LICENSE file](LICENSE).

You can find out more about the Apache License 2.0 at:
[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0).
