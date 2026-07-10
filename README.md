# Erymont

Erymont is a branded cloud installer and management suite packaged for fast local use from a single archive.

## Start

```bash
chmod +x ery
./ery
```

## Direct commands

```bash
./ery help
./ery version
./ery panel
./ery wings
./ery themes
./ery vm
./ery tools
./ery infra
```

## What is included

- Panel installers
- Wings management
- Theme and blueprint management
- VM setup helpers
- Infrastructure utilities
- A single Erymont launcher

## Improvements in this rewrite

- Removed legacy branding everywhere
- Replaced internal remote self-fetches with local bundled modules
- Added a single top-level launcher
- Added a cleaner command interface and safer module dispatch
- Kept the project compact and easy to edit on mobile

## Troubleshooting

- Run the launcher from the extracted project root.
- Use a root shell for system installers.
- If a module expects network access, verify the device is online.
- If a command fails, rerun it from the main `ery` dashboard or use `ery help`.

## Contributing

Open a branch, make a focused change, test the affected script with `bash -n`, and keep the Erymont branding intact.

## License

See `LICENSE`.
