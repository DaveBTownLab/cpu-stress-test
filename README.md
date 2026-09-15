# stressmon-ng

A lightweight Linux CPU stress testing and monitoring tool built around **stress-ng**.

Unlike a simple stress-ng wrapper, **stressmon-ng** launches a CPU stress test together with a live monitoring window that displays CPU usage, frequency and temperature while automatically tracking minimum and maximum values over time.

---

## Features

- Launches a configurable `stress-ng` CPU workload
- Live CPU usage
- Live CPU frequency
- Live CPU temperature
- Lowest CPU frequency with timestamp
- Highest CPU temperature with timestamp
- Lightweight and dependency-free Bash scripts
- Relative paths (can be launched from anywhere)
- Separate monitoring window using Konsole

---

## Requirements

- bash
- stress-ng
- lm-sensors
- procps-ng
- konsole (default terminal)

---

## Folder Structure

```text
stressmon-ng/
├── LICENSE
├── README.md
├── stressmon-ng.sh
└── scripts/
    ├── stresscpu.sh
    └── stressmon.sh
```

---

## Usage

Run a 60 second stress test:

```bash
./stressmon-ng.sh
```

Run a 5 minute stress test:

```bash
./stressmon-ng.sh 300
```

Run only the CPU stress test:

```bash
./scripts/stresscpu.sh 300
```

Run only the monitoring window:

```bash
./scripts/stressmon.sh
```

---

## Example Output

```text
==========================================================
Stress Monitor
==========================================================

CPU:    AMD A9-9420 Radeon R5
Usage:  100%
Freq:   3.31 GHz     Min: 3.29 GHz @ 32s
Temp:   85.5°C       Max: 85.5°C @ 46s
```

---

## How it works

`stressmon-ng` starts two independent processes:

- **stresscpu.sh** starts the CPU workload using `stress-ng`
- **stressmon.sh** continuously monitors:
  - CPU usage
  - CPU frequency
  - CPU temperature
  - lowest recorded frequency
  - highest recorded temperature

This makes it easy to evaluate cooling performance, CPU boosting behaviour and thermal throttling.

---

## Customization

The launcher currently uses **Konsole**.

If you prefer another terminal emulator (Kitty, Alacritty, GNOME Terminal, etc.), simply replace the `konsole` command inside `stressmon-ng.sh`.

---

## License

MIT