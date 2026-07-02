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









/

Designed as a practical learning resource, this repository provides step-by-step examples, commands, design outputs, and documentation to help understand the complete RTL-to-GDSII ASIC implementation flow using OpenLane and OpenROAD.

<img width="361" height="398" alt="Screenshot 2026-06-22 181216" src="https://github.com/user-attachments/assets/c8d411b7-31e8-4c57-8481-16df3dcda91f" />  <img width="248" height="252" alt="image" src="https://github.com/user-attachments/assets/23f5de7b-e3f8-4bb3-bde0-fca51ebd0462" />

<img width="747" height="196" alt="image" src="https://github.com/user-attachments/assets/de47a44f-f11f-4744-b027-a6f12899014b" />

