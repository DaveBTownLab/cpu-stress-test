# CPU Stress Test

This tool is designed to help analyze CPU cooling performance, monitor temperatures and detect thermal throttling during sustained CPU load. It is intended as a diagnostic utility rather than a benchmark.

## Features

- CPU stress test using `stress-ng`
- Live CPU frequency
- Live CPU usage
- Live CPU temperature
- Records the lowest CPU frequency under load
- Records the highest CPU temperature under load
- Configurable test duration in seconds

## Requirements

- bash
- stress-ng
- lm-sensors
- xfce4-terminal

## Folder Structure

```
cpu-stress-toolkit/
├── stresstest.sh
└── scripts/
    ├── stresscpu.sh
    └── stressmon.sh
```

## Usage

Run a 60-second stress test:

```bash
./stresstest.sh
```

Run a 5-minute stress test:

```bash
./stresstest.sh 300
```

Run only the stress test:

```bash
./scripts/stresscpu.sh 300
```

Run only the monitor:

```bash
./scripts/stressmon.sh
```

## Output

The monitor displays:

- CPU model
- CPU usage
- Current frequency
- Lowest frequency reached
- Current temperature
- Highest temperature reached

## Notes

The launcher currently uses `xfce4-terminal` to open the stress test and monitor in separate windows.

If you want to use a different terminal emulator, simply replace the `xfce4-terminal`
command in `stresstest.sh`.

## License

MIT
