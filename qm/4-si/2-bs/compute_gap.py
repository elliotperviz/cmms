#!/usr/bin/env python3
"""
Compute band gap (and direct/indirect nature) from ABINIT ASCII outputs.

Usage:
    python compute_abinit_gap.py ab.abo abo_DS3_EIG [--fermi-index N] [--unit ev|hartree] [--tol HARTREE]

Defaults:
    - Uses the last 'fermie' entry in ab.abo unless --fermi-index is given (0-based).
    - Reports energies in eV by default.
    - Tolerance (tol) defaults to 1e-6 hartree when comparing to Fermi.

Output:
    Prints per-k VBM/CBM, global VBM/CBM, band gap, and whether gap is direct or indirect.
"""
from __future__ import annotations
import sys
import re
import argparse
from typing import List, Tuple, Optional

# Conversion
HARTREE_TO_EV = 27.211386245988  # recommended conversion factor

def parse_fermi_from_abo(abo_path: str) -> List[float]:
    """Return list of fermie values (in hartree) as they appear in file (in order)."""
    fermies = []
    p = re.compile(r'fermie\s*[:=]\s*([+-]?[0-9]*\.?[0-9]+([Ee][+-]?\d+)?)', re.IGNORECASE)
    with open(abo_path, 'r', encoding='utf-8', errors='ignore') as fh:
        for line in fh:
            m = p.search(line)
            if m:
                fermies.append(float(m.group(1)))
    return fermies

def parse_eigen_ascii(eig_path: str) -> List[Tuple[int, int, List[float]]]:
    """
    Parse an ABINIT eigenvalue ascii file.

    Returns a list of tuples per k-point:
      (kpt_number, nband, [ev_1, ev_2, ..., ev_nband]) with energies in hartree.
    """
    kpts = []
    # regex to find 'kpt#   1, nband= 20, wtk=  1.00000, kpt=  0.0000  0.0000  0.0000'
    header_re = re.compile(r'kpt#\s*(\d+)\s*,\s*nband\s*=\s*(\d+)', re.IGNORECASE)
    number_re = re.compile(r'([+-]?\d*\.\d+|\d+)([Ee][+-]?\d+)?')
    with open(eig_path, 'r', encoding='utf-8', errors='ignore') as fh:
        lines = fh.readlines()

    i = 0
    while i < len(lines):
        line = lines[i]
        m = header_re.search(line)
        if m:
            kptnum = int(m.group(1))
            nband = int(m.group(2))
            # collect numbers from subsequent lines until we've got nband floats
            vals: List[float] = []
            j = i + 1
            while j < len(lines) and len(vals) < nband:
                # extract floats from the line
                found = number_re.findall(lines[j])
                # each match is a tuple (mantissa, exponent) because of our regex; rebuild
                for tup in found:
                    s = tup[0]
                    if tup[1]:
                        s += tup[1]
                    # attempt conversion
                    try:
                        vals.append(float(s))
                    except ValueError:
                        pass
                j += 1
            if len(vals) != nband:
                raise ValueError(f"Expected {nband} eigenvalues for kpt {kptnum}, found {len(vals)}. "
                                 "Check file format or nband parsing.")
            kpts.append((kptnum, nband, vals))
            i = j
        else:
            i += 1
    return kpts

def find_vbm_cbm_for_k(evs: List[float], fermie: float, tol: float = 1e-8) -> Tuple[Optional[Tuple[int,float]], Optional[Tuple[int,float]]]:
    """
    For a single k-point:
      - VBM: (band_index (1-based), energy) = largest eigenvalue <= fermie + tol
      - CBM: (band_index (1-based), energy) = smallest eigenvalue >= fermie - tol (strictly above Fermi if needed)
    Returns None for VBM/CBM if not found (shouldn't happen in normal cases).
    """
    # find occupied (<= fermie + tol) and unoccupied (> fermie + tol)
    occ_indices = [ (idx+1, e) for idx, e in enumerate(evs) if e <= fermie + tol ]
    unocc_indices = [ (idx+1, e) for idx, e in enumerate(evs) if e > fermie + tol ]

    vbm = max(occ_indices, key=lambda x: x[1]) if occ_indices else None
    cbm = min(unocc_indices, key=lambda x: x[1]) if unocc_indices else None
    return vbm, cbm

def main(argv=None):
    parser = argparse.ArgumentParser(description='Compute band gap from ABINIT outputs.')
    parser.add_argument('abo', help='path to ab.abo (contains fermie outputs)')
    parser.add_argument('eig', help='path to eigenvalues ascii file (e.g. abo_DS3_EIG)')
    parser.add_argument('--fermi-index', type=int, default=None,
                        help='0-based index of which fermie line to use from ab.abo (default: last)')
    parser.add_argument('--unit', choices=['ev','hartree'], default='ev', help='output energy unit')
    parser.add_argument('--tol', type=float, default=1e-6, help='tolerance in hartree for comparing to Fermi')
    parser.add_argument('--dump-csv', default=None, help='optional CSV path to write per-k VBM/CBM')
    args = parser.parse_args(argv)

    fermies = parse_fermi_from_abo(args.abo)
    if not fermies:
        print("No 'fermie' entries found in the provided ab.abo file.", file=sys.stderr)
        sys.exit(2)
    if args.fermi_index is None:
        fermie = fermies[-1]
        fidx = len(fermies)-1
    else:
        if args.fermi_index < 0 or args.fermi_index >= len(fermies):
            print(f"Provided --fermi-index {args.fermi_index} out of range (0..{len(fermies)-1}).", file=sys.stderr)
            sys.exit(2)
        fermie = fermies[args.fermi_index]
        fidx = args.fermi_index

    print(f"Using fermie index {fidx} -> fermie = {fermie:.8e} hartree")

    kpt_data = parse_eigen_ascii(args.eig)
    if not kpt_data:
        print("No k-points parsed from eigenvalues file; check file format.", file=sys.stderr)
        sys.exit(3)

    per_k_results = []
    for kidx, (knum, nband, evs) in enumerate(kpt_data, start=1):
        vbm, cbm = find_vbm_cbm_for_k(evs, fermie, tol=args.tol)
        per_k_results.append({
            'kpt_index': knum,
            'nband': nband,
            'vbm': vbm,   # (band_index, energy) or None
            'cbm': cbm
        })

    # global VBM = max over k of vbm.energy
    global_vbm = None  # (kpt_index, band_index, energy)
    global_cbm = None
    for rec in per_k_results:
        if rec['vbm'] is not None:
            bidx, energy = rec['vbm']
            if global_vbm is None or energy > global_vbm[2]:
                global_vbm = (rec['kpt_index'], bidx, energy)
        if rec['cbm'] is not None:
            bidx, energy = rec['cbm']
            if global_cbm is None or energy < global_cbm[2]:
                global_cbm = (rec['kpt_index'], bidx, energy)

    if global_vbm is None or global_cbm is None:
        print("Could not determine global VBM/CBM. Check eigenvalues and Fermi energy.", file=sys.stderr)
        sys.exit(4)

    gap_hartree = global_cbm[2] - global_vbm[2]
    gap_ev = gap_hartree * HARTREE_TO_EV

    if args.unit == 'ev':
        gap_str = f"{gap_ev:.6f} eV ({gap_hartree:.8e} hartree)"
    else:
        gap_str = f"{gap_hartree:.8e} hartree ({gap_ev:.6f} eV)"

    direct = (global_vbm[0] == global_cbm[0])

    print("\nGlobal results:")
    print(f"  VBM: kpt #{global_vbm[0]}, band #{global_vbm[1]}, energy = {global_vbm[2]:.8e} hartree "
          f"({global_vbm[2]*HARTREE_TO_EV:.6f} eV)")
    print(f"  CBM: kpt #{global_cbm[0]}, band #{global_cbm[1]}, energy = {global_cbm[2]:.8e} hartree "
          f"({global_cbm[2]*HARTREE_TO_EV:.6f} eV)")
    print(f"  Band gap: {gap_str}")
    print(f"  Nature: {'direct' if direct else 'indirect'}")
    if not direct:
        print(f"    VBM at kpt #{global_vbm[0]}, CBM at kpt #{global_cbm[0]}")

    # Optionally dump per-k results CSV
    if args.dump_csv:
        import csv
        with open(args.dump_csv, 'w', newline='') as csvf:
            writer = csv.writer(csvf)
            writer.writerow(['kpt_index','nband','vbm_band','vbm_energy_hartree','cbm_band','cbm_energy_hartree'])
            for rec in per_k_results:
                vbm = rec['vbm']
                cbm = rec['cbm']
                writer.writerow([
                    rec['kpt_index'],
                    rec['nband'],
                    vbm[0] if vbm else '',
                    vbm[1] if vbm else '',
                    cbm[0] if cbm else '',
                    cbm[1] if cbm else '',
                ])
        print(f"\nPer-k VBM/CBM written to {args.dump_csv}")

if __name__ == '__main__':
    main()

