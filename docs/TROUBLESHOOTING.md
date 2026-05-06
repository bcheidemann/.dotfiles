# Troubleshooting

## Linux Post-Update Screen Resolution Issue (Nvidia)

If after an update:

```sh
$ nvidia-smi
NVIDIA-SMI has failed because it couldn't communicate with the NVIDIA driver. Make sure that the latest NVIDIA driver is installed and running.
```

Attempt:

```sh
$ sudo ubuntu-drivers autoinstall
```

Alternatively, open "Additional Drivers" (in "Software & Updates") and choose a different driver compatible with the system.
