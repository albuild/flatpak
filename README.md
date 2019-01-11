# albuild-flatpak

A set of prebuilt Flatpak binaries for Amazon Linux 2.

## Install (Amazon WorkSpaces)

### Instructions

1. Download the prebuilt package from [the Release page](https://github.com/albuild/flatpak/releases/tag/0.2.0).

1. Install the package.

    ```
    sudo yum install -y albuild-flatpak-0.2.0-1.amzn2.x86_64.rpm
    ```

1. Logout and login.

## Build (Amazon WorkSpaces)

### System Requirements

* Docker

### Instructions

1. Clone this repository.

    ```
    git clone https://github.com/albuild/flatpak.git
    ```

1. Go to the repository.

    ```
    cd flatpak
    ```

1. Build a new image.

    ```
    bin/build
    ```

1. Extract a built package from the built image. The package will be copied to the ./rpm directory.

    ```
    bin/cp
    ```

1. Delete the built image.

    ```
    bin/rmi
    ```
