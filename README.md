# 🌡 Industrial Temperature PID Control System

> **CONTROL CRAFT HACKATHON** — Real-time PID tuning dashboard with Simulink integration

---

## 📌 Problem Statement

Design and simulate an **Industrial Temperature Control System** using a PID controller for the first-order plant:

$$G(s) = \frac{2}{10s + 1}$$

The system must:
- Achieve setpoint tracking with minimal overshoot and fast settling
- Reject step disturbances
- Provide real-time tuning and visual performance feedback

---

## 🎯 Approach

The solution is built in two layers:

**1. MATLAB Script (`pid_temperature_control.m`)**  
Core analysis: closed-loop design, step response, disturbance rejection, Bode plot, and Root Locus.

**2. MATLAB App Designer Dashboard (`TemperatureControlDashboard.mlapp`)**  
Interactive GUI with live plots, sliders for Kp/Ki/Kd, gauges, and status indicators — all updating in real time.

**3. Simulink Model (`build_simulink_model.m` → `TempControl_PID.slx`)**  
Time-domain simulation with PID block, plant TF, disturbance injection at t = 15 s, and scopes.

---

## 🖥️ Dashboard Features

| Feature | Description |
|---|---|
| **PID Sliders** | Tune Kp, Ki, Kd in real time (0.1–20, 0–5, 0–10) |
| **Setpoint Spinner** | Adjust reference temperature |
| **Disturbance Control** | Set amplitude and injection time |
| **Step Response Plot** | Live closed-loop step response vs setpoint |
| **Disturbance Rejection Plot** | Output + disturbance overlay (dual y-axis) |
| **Bode Plot** | Open-loop frequency response |
| **Root Locus** | Poles/zeros of the plant |
| **Temperature Gauge** | Circular gauge showing final output temperature |
| **Overshoot Gauge** | 90° gauge with green/orange/red zones |
| **Status Lamps** | Stability ✅, Overshoot ✅, Steady-State Error ✅ |
| **Metrics Panel** | Rise time, Settling time, Overshoot %, SSE, Peak time |

---

## ⚙️ System Design

### Plant
$$G(s) = \frac{2}{10s + 1} \quad \text{(first-order, time constant = 10 s, gain = 2)}$$

### PID Controller (Default Tuning)
| Parameter | Value |
|-----------|-------|
| Kp | 3 |
| Ki | 0.5 |
| Kd | 1 |

### Closed-Loop
$$T(s) = \frac{C(s) \cdot G(s)}{1 + C(s) \cdot G(s)}$$

### Performance (Default Gains)
| Metric | Value |
|--------|-------|
| Rise Time | ~1.8 s |
| Settling Time | ~8 s |
| Overshoot | ~15% |
| Steady-State Error | ~0 |

---

## 🚀 How to Run

### Requirements
- MATLAB R2021a or later
- Control System Toolbox
- Simulink (for `.slx` model)

### Steps

**Option A — Run the App Dashboard (Recommended)**
```matlab
% In MATLAB Command Window:
TemperatureControlDashboard
```

**Option B — Run the basic script**
```matlab
run('pid_temperature_control.m')
```

**Option C — Build and run the Simulink model**
```matlab
run('build_simulink_model.m')       % Creates TempControl_PID.slx
sim('TempControl_PID')              % Run simulation
```

---

## 📁 Repository Structure

```
.
├── TemperatureControlDashboard.mlapp   # App Designer GUI Dashboard
├── pid_temperature_control.m           # Core MATLAB PID script
├── build_simulink_model.m              # Script to generate Simulink model
├── TempControl_PID.slx                 # Simulink model (auto-generated)
└── README.md
```

---

## 📈 Simulink Model Block Diagram

```
[Setpoint] ──►[+  ]──►[PID Controller]──►[Plant G(s)]──►[+ ]──►[Scope / Workspace]
              [- ↑]                                       [+↑]
              [   └──────────────── Feedback ────────────┘ ]
                                                          [↑ Disturbance (t=15s)]
```

---

## 💡 Creative / Additional Features

- **Dark-themed dashboard** styled for industrial HMI aesthetics
- **Dual-axis disturbance plot** showing input and output simultaneously
- **Color-coded status lamps**: green (good) → orange (warning) → red (critical)
- **Gauge color zones**: automatic thresholding for overshoot and temperature
- **Parametric Bode + Root Locus** update live with PID gains
- **Simulink model auto-generated** from script — no manual drag-and-drop required

---

## 👤 Author

  
CONTROL CRAFT Hackathon — Industrial Temperature Control Problem

---

## 📄 License

MIT License
