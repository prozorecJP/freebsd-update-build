# What is this package?

This is modified freebsd-update-server to perform cross build for arm and arm64 on amd64 platform. The steps and procedure is same as the original tool, so that please read and understand the official one[1].

# Extra step to create pseudo DVD ISO image

Since the tool uses installation DVD ISO image, but there isn’t a such one for cross build purpose, we have to create pseudo DVD ISO image. There are 2 shell scripts under tool directory.

## Download necessary files
The tool uses files on DVD ISO image and the files are

| name | purpose |
-------|--------
| base.txz | target architecture |
| base-dbg.txz |  target architecture |
| kernel.txz | target architecture |
| kernel-dbg.txz | target architecture |
| src.txz | target architecture |

Moreover we need base.txz for host architecture and this file is used to setup jail environment for build the system. The file is renamed to be able to identify the host architecture.

| name | purpose |
-------|--------
| amd64_base.txz | host architecture |
| amd64_base-dbg.txz | host architecture |

Probably amd64_base-dbg.txz isn’t used during building but this is downloaded to minimize the script changes.

FreeBSD doesn’t release  base.txz, kernel.txz, base-dbg.txz and kernel-dbg.txz for arm, so that these files are created from SD card image. This approach isn’t sophisticated and is rather tricky. Anyway SD card image is downloaded for arm.

There are 2 shell script to download all necessary files to remote machine.

| name | purpose |
-------|--------
| download_arm.sh | arm |
| download_arm64.sh | arm64 (aarch64) |

## Create pseudo DVD ISO image
Once all necessary files are available on local machine, we just need to pack them into DVD ISO image. There 2 script for this purpose.

| name | purpose |
-------|--------
| create_iso_arm.sh | arm |
| create_iso_arm64.sh | arm64 (aarch64) |

After creating pseudo DVD ISO image, sha512 must be calculated and set on RELH in build.conf.

## Tweak variables in build.conf
| Varable | Example | Explanation |
-----------|------------|------------------
| FTP | /opt/arm64/ISO-IMAGES/13.0 | the place where the pseudo DVD ISO image is located. |
| EOL | 1719673200 | this is end of life value for this release. I don’t know the exact date. |

# Test
The tool was tested on NanoPI NEO2 (arm64) and cubox-i (arm).

# Know issue
Somehow diff.sh doesn’t update “/bin/freebsd-version” on arm. The file itself is generated during build but sha256 on INDEX file isn’t updated so that the file isn’t selected as updated one.



[1] https://docs.freebsd.org/en/articles/freebsd-update-server/

