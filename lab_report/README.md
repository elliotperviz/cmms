# Instructions for the lab report and final exam

## Lab report

The lab report is an opportunity to demonstrate that you know not just how to use molecular dynamics or quantum mechanics simulation tools, but also that you understand the physical meaning behind the input parameters that you choose and the validity of the results which you present (as opposed to using the simulation tool as a black box). 

Thus, your task is to perform your own classical and quantum simulations, and investigate **at least** one property in each case. Note that you should not choose an overly complicated system, as you want the simulations to be able to run locally on the machines in the laboratory within reasonable time.

Afterwards, you are required to write-up a lab report detailing the results of your investigation. The lab report must contain a **minimum** of two sections, one for each type of simulation (quantum/classical). A recommended lab report structure is to follow the style of a scientific paper, that is:
- Abstract
- Introduction
- Computational details
- Results
- Conclusion

We provide this outline as a suggestion, it is up to you how much information you include and how you want to structure your report, as long as you include the minimum expected results. Some example lab reports are provided in the [examples](examples/) folder. For additional notes on how to generate high quality images/plots for your report, see the next section.

There is no individual mark for your lab report, rather it is considered together with your performance in the final exam when awarding you a final grade.

## Final exam

The final exam is an oral assessment of both your simulations and understanding of the theory, which includes any of the lecture material presented during the semester. If the topic was not presented during the course (some things we may not have time for) then we will not examine you on it.

You will receive a single final grade considering both the lab report and the oral exam (there is not a separate grade for each component).

The current tentative dates for the oral exams (and corresponding deadlines for the lab report) are as follows:
- Exam Date 1: TBA, Lab report: TBA
- Exam Date 2: TBA, Lab report: TBA
- Exam Date 3: TBA, Lab report: TBA

Antonio will write via KOS to confirm the exam dates/times once we have room reservation approved.

When submitting your lab report, send a pdf via email to Antonio and myself (no printing necessary).

If you encounter problems whilst performing your investigations that you cannot solve, and equally if you have questions about the lecture material, you are welcome to write to myself or Antonio (preferably not one day before the exam).

# Generating images for the lab report

You may wish to provide 1) a snapshot of atomic structure or 2) plots of data in your report. We did not discuss how to generate publication-style images during the lab sessions, but I can provide brief instructions for the three main visualisation tools that we used:
1. VMD - click "File" -> "Render..." and select desired format from the drop down menu in "Render the current scene using:". A suggested format is to select "Taychon" from the drop-down - this produces a .tga file which can be read by common image readers (e.g. ImageMagick or GIMP on Linux, GIMP or Photoshop on Windows) and subsequently exported in a format (e.g. png, pdf, eps...) that can be used in your report. For further detail please refer to the relevant page from the VMD documentation:
https://www.ks.uiuc.edu/Research/vmd/current/ug/node18.html
Also remember, if you wish to view the boundaries of the simulation box in your image, you should open "Extensions" -> "Tk Console" and write the following command in the terminal window: "pbc box".
2. VESTA - click "File" -> "Export Raster Image" or "Export Vector Image" (recommended to use vector format e.g. save as .pdf or .eps). Be aware, the exact position of your camera and how big the crystal appears in the VESTA window determines the size of the crystal in the image that you produce. For further customisation of the visualisation in VESTA, check the settings under "Objects" -> "Properties" and "Objects" -> "Boundaries".
3. Gnuplot - (after opening a plot window) click "Export" -> "Export to PNG" or "Export to SVG" or "Export to image". For further formatting, see the gnuplot documentation e.g. the plot command:
http://gnuplot.info/docs_6.0/loc7969.html

You might want to use other visualisation tools for your report (e.g. Ovito, Matplotlib etc.), but we cannot promise to be able to fix problems with tools which we did not demonstrate in the labs, and with which we may not be familiar.
