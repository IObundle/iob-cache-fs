# FuseSoC Prebuilt IOb-Cache Core Repository

This repository contains a prebuilt version of the [iob\_cache](https://github.com/IObundle/iob-cache) core, exported and packaged to be FuseSoC-compatible.

The structure and metadata in this repository follow the standard layout expected by FuseSoC and are ready for publishing to the FuseSoC Cores Index.

The prebuilt sources of this repository were taken from the latest release assets of the iob\_cache project: https://github.com/IObundle/iob-cache/releases/latest

## Overview

This repository includes everything required for FuseSoC to recognize and use this core, including:

The core description file (.core file)

Prebuilt or preprocessed source files

Any associated simulation or synthesis configurations

The source and build artifacts were exported from the original development environment into this format to simplify integration with FuseSoC projects.

## Usage

You can reference this prebuilt core in your FuseSoC environment by adding this repository as a core library:

```bash
fusesoc library add <library_name> https://github.com/IObundle/iob-cache.git
```

After adding the library, the core will be available for use and can be listed with:

```bash
fusesoc core list
```

## Notes

This repository does not contain editable source code for the core itself—only the prebuilt/exported version.

For upstream development or modifications, please refer to the original project repository.

