# OpenLane-RTL-to-GDSII
This repository documents the complete ASIC physical design flow using OpenLane, covering the transformation of an RTL design into a manufacturable GDSII layout through the open-source EDA toolchain.

The repository includes hands-on implementations of the major physical design stages, including floorplanning, placement, Clock Tree Synthesis (CTS), routing, parasitic extraction, timing analysis, DRC verification, and final GDSII generation. It also demonstrates the use of key design artifacts such as LEF, DEF, Liberty (.lib), SDC, JSON configuration files, and OpenLane configuration files, along with generated reports and layouts.  

## 📁 Creating a New Design Directory in OpenLane

Follow these steps to create a new design workspace inside the `OpenLane` environment.

### Step 1: Launch OpenLane

```bash
openlane
```
### Step 2: Verify Current Directory Contents

```bash
ls
```
### Step 3: Navigate to the `designs` Directory

```bash
cd designs
```
### Step 4: Create a New Design Directory

Replace `<design_name>` with your project name.

```bash
mkdir <design_name>
```
### Step 5: Enter the Design Directory

```bash
cd <design_name>
```

**Current Location:**

```text
openlane/designs/<design_name>/
```

### Step 6: Create the Source Directory

```bash
mkdir src
```

### Step 7: Create the RTL (Verilog) File

Navigate to the `src` folder and create your Verilog source file.

```bash
cd src
```

```bash
gvim <design_name>.v
# or
vi <design_name>.v
```

**Current Location:**

```text
openlane/designs/<design_name>/src/
```

### Step 8: Return to the Design Directory

```bash
cd ..
```

**Current Location:**

```text
openlane/designs/<design_name>/
```

### Step 9: Create the OpenLane Configuration Files

Create the required configuration files.

```bash
gvim config.json
```

```bash
gvim config.tcl
```

```bash
gvim <design_name>.sdc
```

---

## 📂 Final Directory Structure

```text
openlane/
└── designs/
    └── <design_name>/
        ├── src/
        │   └── <design_name>.v
        ├── config.json
        ├── config.tcl
        └── <design_name>.sdc
```


## Part 2: Running the OpenLane Flow

### 1. Launch OpenLane

```bash
openlane
```

### 2. Start Interactive Mode

```bash
flow.tcl -interactive
```

### 3. Prepare the Design

Replace `top` with your top-level module name.

```bash
prep -design top
```

### 4. Execute the Flow

```bash
run_synthesis              # Logic Synthesis
run_floorplan              # Floorplanning
run_placement              # Standard Cell Placement
run_cts                    # Clock Tree Synthesis
run_routing                # Global & Detailed Routing
run_magic                  # Layout Generation
run_magic_spice_export     # SPICE Netlist Export
run_magic_drc              # Design Rule Check (DRC)
run_klayout                # Open Layout in KLayout
run_lvs                    # Layout Versus Schematic (LVS)
```






# Part 3: Viewing and Analyzing OpenLane Results

In this section, we will understand how to locate, open, and analyze the generated files after executing the OpenLane flow.

---

## Navigate to the Run Directory

After running the design flow, go to your design's run directory:

```bash
OpenLaneUser/designs/<design_name>/runs/<RUN_DIRECTORY>/
```

Inside the run directory, you will find the following folders:

```text
logs/
reports/
results/
tmp/
```

---

## Folder Structure

```text
runs/
├── logs/
├── reports/
├── results/
└── tmp/
```

### Important Subdirectories

```text
logs/
├── synthesis/
├── floorplan/
├── placement/
├── cts/
├── routing/
└── signoff/
```

---

# 1. Floorplan

Navigate to:

```text
results/floorplan/
```

Locate the generated DEF file.

Example:

```text
top.def
```

Open it using KLayout:

```bash
klayout top.def
```

---

# 2. Placement

Navigate to:

```text
results/placement/
```

Copy the generated DEF file (`top.def`) and paste it into the `tmp/` directory where `merged.nom.lef` is located.

Open both files together:

```bash
klayout top.def merged.nom.lef
```

---

# 3. Clock Tree Synthesis (CTS)

Navigate to:

```text
results/cts/
```

Copy the generated DEF file (`top.def`) and paste it into the `tmp/` directory.

Open it using:

```bash
klayout top.def merged.nom.lef
```

---

# 4. Routing

Navigate to:

```text
results/routing/
```

Copy the generated DEF file (`top.def`) and paste it into the `tmp/` directory.

Open it using:

```bash
klayout top.def merged.nom.lef
```

---

# 5. Signoff

Navigate to:

```text
results/signoff/
```

Copy the generated DEF file (`top.def`) and paste it into the `tmp/` directory.

Open it using:

```bash
klayout top.def merged.nom.lef
```

---

# Viewing the Final GDSII Layout

Navigate to:

```text
results/signoff/
```

Locate the generated GDSII file:

```text
top.gds
```

Open it using:

```bash
klayout top.gds
```

---

# Viewing Reports

All generated reports are available inside the `reports/` directory.

Navigate to the required report folder and open the report using:

```bash
vi <report_name>.rpt
```

### Examples

```bash
vi 13-cts_sta.summary.rpt
```

```bash
vi drc.rpt
```

```bash
vi 30-top.lvs.rpt
```

---

# OpenLane Run Directory Structure

```text
runs/
├── logs/
│   ├── synthesis/
│   ├── floorplan/
│   ├── placement/
│   ├── cts/
│   ├── routing/
│   └── signoff/
│
├── reports/
│   ├── synthesis/
│   ├── floorplan/
│   ├── placement/
│   ├── cts/
│   ├── routing/
│   └── signoff/
│
├── results/
│   ├── floorplan/
│   ├── placement/
│   ├── cts/
│   ├── routing/
│   └── signoff/
│
└── tmp/
    └── merged.nom.lef
```

---

## Quick Summary

| Stage | Folder | Command |
|--------|--------|---------|
| Floorplan | `results/floorplan/` | `klayout top.def` |
| Placement | `results/placement/` | `klayout top.def merged.nom.lef` |
| CTS | `results/cts/` | `klayout top.def merged.nom.lef` |
| Routing | `results/routing/` | `klayout top.def merged.nom.lef` |
| Signoff | `results/signoff/` | `klayout top.def merged.nom.lef` |
| Final Layout | `results/signoff/` | `klayout top.gds` |
| Reports | `reports/` | `vi <report_name>.rpt` |











Designed as a practical learning resource, this repository provides step-by-step examples, commands, design outputs, and documentation to help understand the complete RTL-to-GDSII ASIC implementation flow using OpenLane and OpenROAD.

<img width="361" height="398" alt="Screenshot 2026-06-22 181216" src="https://github.com/user-attachments/assets/c8d411b7-31e8-4c57-8481-16df3dcda91f" />  <img width="248" height="252" alt="image" src="https://github.com/user-attachments/assets/23f5de7b-e3f8-4bb3-bde0-fca51ebd0462" />

<img width="747" height="196" alt="image" src="https://github.com/user-attachments/assets/de47a44f-f11f-4744-b027-a6f12899014b" /> <img width="800" height="500" alt="731e0aa9-098e-4925-a4a2-74c2a07de2a0" src="https://github.com/user-attachments/assets/25ff6036-810c-475d-9fa6-dd7a191801b8" />



