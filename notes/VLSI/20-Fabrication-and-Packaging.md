# Fabrication and Packaging

> **Chapter Overview:** From verified layout to physical chips: masks with resolution enhancement, wafer fabrication (FEOL/BEOL), wafer test, packaging, final test, burn-in, and binning.

**Prerequisites:** [[14-Physical-Design-Basics]]  
**Related Topics:** [[19-Physical-Verification-and-Signoff]]

---

## 1. Masks and RET (Lec09)

- Fracture polygons → rectangles/trapezoids; add RET (OPC serifs/hammerheads) to mitigate diffraction
- Multi-patterning (double+): split closely spaced features across masks/exposures; color assignment
- Mask writing: laser/e-beam on resist → develop → etch chromium → clean; QA + pellicle protection

---

## 2. Wafer Fabrication

- FEOL: devices (photolithography, oxidation, diffusion, ion implantation, etching)
- BEOL: interconnects (dual-damascene metal stack)
- Hundreds of sequential steps; layer-by-layer

---

## 3. Test and Packaging

- Wafer probe: identify good dies; slice wafer; discard bad dies
- Packaging: encapsulate die, provide I/O, manage thermals; DIP, BGA, others
- Packaging affects signal integrity and thermal behavior

---

## 4. Final Test, Burn-in, Binning

- Final test post-package to catch assembly issues
- Burn-in: high voltage/temp to expose latent defects
- Binning: categorize chips by performance for pricing

---

## 5. Key Takeaways

1. RET (OPC, multi-patterning) is essential for sub-wavelength lithography.
2. Wafer fab spans FEOL devices and BEOL interconnects in many steps.
3. Packaging is a design dimension (electrical, thermal, mechanical).
4. Final test and binning ensure quality and market segmentation.

---

## Tools

- OPC engines, mask writers, inspection systems

---

## Common Pitfalls

- Skipping OPC → distorted wafer features
- Poor thermal design in packaging → overheating
- Inadequate pin planning → SI issues

---

## Further Reading

- [[14-Physical-Design-Basics]]: Interconnect and BEOL context
- [[19-Physical-Verification-and-Signoff]]: Pre-fab verification steps
