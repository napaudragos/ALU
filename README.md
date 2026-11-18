# 🔢 ALU pe 8 biți (Verilog)

Unitate aritmetică pe 8 biți, scrisă în **Verilog**, care face **adunare, scădere, înmulțire și împărțire**. Proiect în echipă.

## Arhitectură
ALU-ul are două module principale, legate în `top.v`:
- **Control Unit** (`control_unit.v`): FSM-uri separate pentru fiecare operație (`add_sum_fsm`, `mul_fsm`, `div_fsm`), care generează semnalele de control C0–C10.
- **Arithmetic Unit** (`arithmetic_unit.v`): registrele A, Q, M, Q[-1], un sumator/scăzător pe 8 biți, un shift register pe 16 biți și un contor.

| `op` | Operație | Algoritm |
| :---: | :--- | :--- |
| `00` | Adunare | sumator pe 8 biți |
| `01` | Scădere | sumator pe 8 biți (complement față de 2) |
| `10` | Înmulțire | **Booth radix-2** |
| `11` | Împărțire | **Restoring division** |

Datele intră pe `inbus` (8 biți), iar rezultatul iese pe `outbus` (16 biți).

## Rulare (ModelSim)
```tcl
cd ALU_files
do run_alu.tcl
```

## Documentație
Schemele, FSM-urile și testarea sunt în [`ALU_documentation/ALU_doc.pptx`](ALU_documentation/ALU_doc.pptx).
