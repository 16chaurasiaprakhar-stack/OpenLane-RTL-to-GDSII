import os
import struct
import datetime

MACRO_NAME = "sky130_sram_1k"
WIDTH = 480.0
HEIGHT = 600.0

PINS_IN = ["clk", "csb", "web"] + [f"wmask[{i}]" for i in range(4)] + [f"addr[{i}]" for i in range(10)] + [f"din[{i}]" for i in range(32)]
PINS_OUT = [f"dout[{i}]" for i in range(32)]
ALL_PINS = PINS_IN + PINS_OUT

BASE_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
MACROS_DIR = os.path.join(BASE_DIR, "macros")
LEF_DIR = os.path.join(MACROS_DIR, "lef")
LIB_DIR = os.path.join(MACROS_DIR, "lib")
GDS_DIR = os.path.join(MACROS_DIR, "gds")

os.makedirs(LEF_DIR, exist_ok=True)
os.makedirs(LIB_DIR, exist_ok=True)
os.makedirs(GDS_DIR, exist_ok=True)

# -------------------------------------------------------------
# 1. LEF GENERATION
# -------------------------------------------------------------
def generate_lef():
    lef_path = os.path.join(LEF_DIR, f"{MACRO_NAME}.lef")
    with open(lef_path, "w") as f:
        f.write(f"""VERSION 5.8 ;
BUSBITCHARS "[]" ;
DIVIDERCHAR "/" ;

MACRO {MACRO_NAME}
  CLASS BLOCK ;
  ORIGIN 0.000 0.000 ;
  FOREIGN {MACRO_NAME} 0.000 0.000 ;
  SIZE {WIDTH:.3f} BY {HEIGHT:.3f} ;
  SYMMETRY X Y ;
""")
        # Power pins
        f.write("""  PIN vccd1
    DIRECTION INOUT ;
    USE POWER ;
    PORT
      LAYER met4 ;
        RECT 10.000 590.000 470.000 596.000 ;
        RECT 10.000 10.000 470.000 16.000 ;
    END
  END vccd1
  PIN vssd1
    DIRECTION INOUT ;
    USE GROUND ;
    PORT
      LAYER met4 ;
        RECT 10.000 580.000 470.000 586.000 ;
        RECT 10.000 20.000 470.000 26.000 ;
    END
  END vssd1
""")
        # Signal pins along bottom and side on met3 (snapped to 0.005 um manufacturing grid)
        y_pos = 35.0
        pitch = (HEIGHT - 70.0) / len(ALL_PINS)
        for i, pin in enumerate(ALL_PINS):
            direction = "INPUT" if pin in PINS_IN else "OUTPUT"
            y_snap = round(round(y_pos / 0.005) * 0.005, 3)
            f.write(f"""  PIN {pin}
    DIRECTION {direction} ;
    USE SIGNAL ;
    PORT
      LAYER met3 ;
        RECT 2.000 {y_snap:.3f} 6.500 {y_snap+0.680:.3f} ;
    END
  END {pin}
""")
            y_pos += pitch

        # Obstruction layer
        f.write(f"""  OBS
    LAYER met1 ;
      RECT 0.000 0.000 {WIDTH:.3f} {HEIGHT:.3f} ;
    LAYER met2 ;
      RECT 0.000 0.000 {WIDTH:.3f} {HEIGHT:.3f} ;
    LAYER met3 ;
      RECT 10.000 10.000 {WIDTH-10.0:.3f} {HEIGHT-10.0:.3f} ;
    LAYER met4 ;
      RECT 10.000 30.000 {WIDTH-10.0:.3f} {HEIGHT-30.0:.3f} ;
  END
END {MACRO_NAME}
END LIBRARY
""")
    print(f"Generated LEF: {lef_path}")

# -------------------------------------------------------------
# 2. LIBERTY (.lib) GENERATION (TT, SS, FF)
# -------------------------------------------------------------
def generate_lib(corner, volt, temp, clk_q, setup_t, hold_t):
    v_str = f"{volt:.2f}".replace(".", "v")
    t_str = f"n{abs(temp):02d}C" if temp < 0 else f"{temp:03d}C"
    filename = f"{MACRO_NAME}_{corner}_{t_str}_{v_str}.lib"
    lib_path = os.path.join(LIB_DIR, filename)
    with open(lib_path, "w") as f:
        f.write(f"""/* OpenRAM SkyWater 130nm 1KB SRAM Liberty Model */
/* Corner: {corner.upper()} | Temp: {temp}C | Voltage: {volt}V */

library ({MACRO_NAME}_{corner}_{abs(temp):03d}C_{str(volt).replace('.','v')}) {{
  technology (cmos);
  delay_model : table_lookup;
  bus_naming_style : "%s[%d]";
  time_unit : "1ns";
  voltage_unit : "1V";
  current_unit : "1mA";
  pulling_resistance_unit : "1kohm";
  leakage_power_unit : "1nW";
  capacitive_load_unit (1, pf);

  nom_process : 1.0;
  nom_temperature : {temp:.1f};
  nom_voltage : {volt:.2f};

  operating_conditions (typical) {{
    process : 1.0;
    temperature : {temp:.1f};
    voltage : {volt:.2f};
  }}
  default_operating_conditions : typical;

  lu_table_template(timing_template_2x2) {{
    variable_1 : total_output_net_capacitance;
    variable_2 : input_net_transition;
    index_1 ("0.001, 0.100");
    index_2 ("0.010, 0.500");
  }}

  cell ({MACRO_NAME}) {{
    area : {WIDTH * HEIGHT:.1f};
    dont_use : true;
    dont_touch : true;

    pg_pin (vccd1) {{
      voltage_name : VDD;
      pg_type : primary_power;
    }}
    pg_pin (vssd1) {{
      voltage_name : VSS;
      pg_type : primary_ground;
    }}

    pin (clk) {{
      direction : input;
      capacitance : 0.080; /* 80 fF high capacitive load */
      clock : true;
      min_pulse_width_high () {{
        timing_sense : non_unate;
        rise_constraint(scalar) {{ values("{setup_t*0.8:.3f}"); }}
      }}
      min_pulse_width_low () {{
        timing_sense : non_unate;
        fall_constraint(scalar) {{ values("{setup_t*0.8:.3f}"); }}
      }}
    }}
""")
        # Input pins (csb, web, wmask, addr, din)
        for pin in PINS_IN[1:]:
            f.write(f"""    pin ({pin}) {{
      direction : input;
      capacitance : 0.006;
      timing () {{
        related_pin : "clk";
        timing_type : setup_rising;
        rise_constraint(scalar) {{ values("{setup_t:.3f}"); }}
        fall_constraint(scalar) {{ values("{setup_t:.3f}"); }}
      }}
      timing () {{
        related_pin : "clk";
        timing_type : hold_rising;
        rise_constraint(scalar) {{ values("{hold_t:.3f}"); }}
        fall_constraint(scalar) {{ values("{hold_t:.3f}"); }}
      }}
    }}
""")
        # Output pins (dout)
        for pin in PINS_OUT:
            f.write(f"""    pin ({pin}) {{
      direction : output;
      max_capacitance : 0.150;
      timing () {{
        related_pin : "clk";
        timing_type : rising_edge;
        timing_sense : non_unate;
        cell_rise(timing_template_2x2) {{
          values ("{clk_q:.3f}, {clk_q*1.15:.3f}", \\
                  "{clk_q*1.05:.3f}, {clk_q*1.25:.3f}");
        }}
        cell_fall(timing_template_2x2) {{
          values ("{clk_q:.3f}, {clk_q*1.15:.3f}", \\
                  "{clk_q*1.05:.3f}, {clk_q*1.25:.3f}");
        }}
        rise_transition(timing_template_2x2) {{
          values ("0.050, 0.200", "0.060, 0.220");
        }}
        fall_transition(timing_template_2x2) {{
          values ("0.050, 0.200", "0.060, 0.220");
        }}
      }}
    }}
""")
        f.write("  }\n}\n")
    print(f"Generated LIB: {lib_path}")

# -------------------------------------------------------------
# 3. GDSII GENERATION (Standard Stream binary format)
# -------------------------------------------------------------
def generate_gds():
    gds_path = os.path.join(GDS_DIR, f"{MACRO_NAME}.gds")

    def rec(rec_type, data_bytes=b""):
        length = len(data_bytes) + 4
        return struct.pack(">HH", length, rec_type) + data_bytes

    now = datetime.datetime.now()
    date_bytes = struct.pack(">12H", now.year, now.month, now.day, now.hour, now.minute, now.second,
                                     now.year, now.month, now.day, now.hour, now.minute, now.second)

    def pad_str(s):
        b = s.encode("ascii")
        if len(b) % 2 != 0:
            b += b"\x00"
        return b

    out = bytearray()
    # HEADER
    out += rec(0x0002, struct.pack(">H", 600))
    # BGNLIB
    out += rec(0x0102, date_bytes)
    # LIBNAME
    out += rec(0x0206, pad_str(MACRO_NAME))
    # UNITS (0.001 user units per db unit, 1e-9 db units in meter)
    out += rec(0x0305, struct.pack(">dd", 0.001, 1e-9))
    # BGNSTR
    out += rec(0x0502, date_bytes)
    # STRNAME
    out += rec(0x0606, pad_str(MACRO_NAME))

    # BOUNDARY 1: PR boundary layer 235 datatype 4
    # Coords in nm (db units)
    w_nm = int(WIDTH * 1000)
    h_nm = int(HEIGHT * 1000)
    xy_coords = [(0, 0), (w_nm, 0), (w_nm, h_nm), (0, h_nm), (0, 0)]

    out += rec(0x0800) # BOUNDARY
    out += rec(0x0D02, struct.pack(">H", 235)) # LAYER
    out += rec(0x0E02, struct.pack(">H", 4))   # DATATYPE
    xy_bytes = b"".join(struct.pack(">ii", x, y) for x, y in xy_coords)
    out += rec(0x1003, xy_bytes) # XY
    out += rec(0x1100) # ENDEL

    # BOUNDARY 2: Metal3 power strap ring dummy layer 70 datatype 20
    out += rec(0x0800) # BOUNDARY
    out += rec(0x0D02, struct.pack(">H", 70)) # LAYER met4
    out += rec(0x0E02, struct.pack(">H", 20))  # DATATYPE
    ring_coords = [(10000, 10000), (w_nm-10000, 10000), (w_nm-10000, 20000), (10000, 20000), (10000, 10000)]
    xy_bytes2 = b"".join(struct.pack(">ii", x, y) for x, y in ring_coords)
    out += rec(0x1003, xy_bytes2)
    out += rec(0x1100)

    out += rec(0x0700) # ENDSTR
    out += rec(0x0400) # ENDLIB

    with open(gds_path, "wb") as f:
        f.write(out)
    print(f"Generated GDS: {gds_path}")

if __name__ == "__main__":
    generate_lef()
    # TT: 25C, 1.80V
    generate_lib("tt", 1.80, 25, clk_q=2.20, setup_t=0.80, hold_t=0.15)
    # SS: 100C, 1.60V
    generate_lib("ss", 1.60, 100, clk_q=3.50, setup_t=1.25, hold_t=0.10)
    # FF: -40C, 1.95V
    generate_lib("ff", 1.95, -40, clk_q=1.40, setup_t=0.50, hold_t=0.25)
    generate_gds()
