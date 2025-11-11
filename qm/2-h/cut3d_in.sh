#!/bin/bash

WFKFILE="abo_WFK"
OUTPUTROOT="abo_WFK"

# --- First band --- #
cut3d << EOF
$WFKFILE      # WFK file
1             # Band 1
0             # Not GW
0             # Atomic analysis radius
14            # Output option (e.g., cube/xsf)
$OUTPUTROOT   # Output root
1             # Run interpolation

2             # Band 2
0             # Not GW
0             # Atomic analysis radius
14            # Output option (e.g., cube/xsf)
$OUTPUTROOT   # Output root
1             # Run interpolation

3             # Band 2
0             # Not GW
0             # Atomic analysis radius
14            # Output option (e.g., cube/xsf)
$OUTPUTROOT   # Output root
1             # Run interpolation

4             # Band 2
0             # Not GW
0             # Atomic analysis radius
14            # Output option (e.g., cube/xsf)
$OUTPUTROOT   # Output root
1             # Run interpolation

5             # Band 2
0             # Not GW
0             # Atomic analysis radius
14            # Output option (e.g., cube/xsf)
$OUTPUTROOT   # Output root
1             # Run interpolation

6             # Band 2
0             # Not GW
0             # Atomic analysis radius
14            # Output option (e.g., cube/xsf)
$OUTPUTROOT   # Output root
1             # Run interpolation

7             # Band 2
0             # Not GW
0             # Atomic analysis radius
14            # Output option (e.g., cube/xsf)
$OUTPUTROOT   # Output root
1             # Run interpolation

8             # Band 2
0             # Not GW
0             # Atomic analysis radius
14            # Output option (e.g., cube/xsf)
$OUTPUTROOT   # Output root
1             # Run interpolation

9             # Band 2
0             # Not GW
0             # Atomic analysis radius
14            # Output option (e.g., cube/xsf)
$OUTPUTROOT   # Output root
1             # Run interpolation

10             # Band 2
0             # Not GW
0             # Atomic analysis radius
14            # Output option (e.g., cube/xsf)
$OUTPUTROOT   # Output root
1             # Run interpolation

11             # Band 2
0             # Not GW
0             # Atomic analysis radius
14            # Output option (e.g., cube/xsf)
$OUTPUTROOT   # Output root
1             # Run interpolation

12             # Band 2
0             # Not GW
0             # Atomic analysis radius
14            # Output option (e.g., cube/xsf)
$OUTPUTROOT   # Output root
1             # Run interpolation

13             # Band 2
0             # Not GW
0             # Atomic analysis radius
14            # Output option (e.g., cube/xsf)
$OUTPUTROOT   # Output root
1             # Run interpolation

14             # Band 2
0             # Not GW
0             # Atomic analysis radius
14            # Output option (e.g., cube/xsf)
$OUTPUTROOT   # Output root
1             # Run interpolation

15             # Band 2
0             # Not GW
0             # Atomic analysis radius
14            # Output option (e.g., cube/xsf)
$OUTPUTROOT   # Output root
0             # Run interpolation
EOF

for f in abo_WFK_k1_b*; do
    mv "$f" "$f.cube"
done

exit 0
