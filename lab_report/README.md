# Instructions for the lab report

The lab report is an opportunity to demonstrate that you know not just how to use molecular dynamics or quantum mechanics simulation tools, but also that you understand the physical meaning behind the input parameters that you choose and the validity of the results which you present (as opposed to using the simulation tool as a black box). A suggested lab report structure and topics to discuss (similar to that provided in the examples) could be as follows:
- Abstract
- Introduction
- Computational details
- Results
- Conclusion

We provide this outline as a suggestion, it is up to you how much information you include and how you want to structure your report, as long as you include the minimum expected results. For additional notes on how to generate images/plots for your report, see the comment at the end of this email.

Please note, the oral exam is assessing both your simulations and understanding of the theory, which includes any of the lecture material presented during the semester. According to the lecture syllabus, as written on the KOS page for BE0M35EAS (https://www.kos.cvut.cz/course-syllabus/BE0M35EAS/B242), the examinable topics are lectures 1-5 and 7-11. There are additional topics listed in the lecture syllabus on KOS, but if the topic was not presented during the course (some things we did not have time for) then we will not examine you on it.

You will receive a single final grade considering both the lab report and the oral exam (there is not a separate grade for each component).

The current tentative dates for the oral exams (and corresponding deadlines for the lab report) are as follows:
- Exam: 12/6, Lab report: 05/6
- Exam: 17/6, Lab report: 10/6
- Exam: 24/6, Lab report: 17/6
Antonio will write via KOS to confirm the exam dates/times once we have room reservation approved.

When submitting your lab report, send a pdf via email to Antonio and myself (no printing necessary).

If you encounter problems whilst performing your investigations that you cannot solve, and equally if you have questions about the lecture material, you are welcome to write to myself or Antonio (preferably not one day before the exam).

Comment: Generating images for the lab report

You may wish to provide 1) a snapshot of atomic structure or 2) plots of data in your report. We did not discuss how to generate publication-style images during the lab sessions, but I can provide brief instructions for the three main visualisation tools that we used:
1. VMD - click "File" -> "Render..." and select desired format from the drop down menu in "Render the current scene using:". A suggested format is to select "Taychon" from the drop-down - this produces a .tga file which can be read by common image readers (e.g. ImageMagick or GIMP on Linux, GIMP or Photoshop on Windows) and subsequently exported in a format (e.g. png, pdf, eps...) that can be used in your report. For further detail please refer to the relevant page from the VMD documentation:
https://www.ks.uiuc.edu/Research/vmd/current/ug/node18.html
Also remember, if you wish to view the boundaries of the simulation box in your image, you should open "Extensions" -> "Tk Console" and write the following command in the terminal window: "pbc box".
2. VESTA - click "File" -> "Export Raster Image" or "Export Vector Image" (recommended to use vector format e.g. save as .pdf or .eps). Be aware, the exact position of your camera and how big the crystal appears in the VESTA window determines the size of the crystal in the image that you produce. For further customisation of the visualisation in VESTA, check the settings under "Objects" -> "Properties" and "Objects" -> "Boundaries".
3. Gnuplot - (after opening a plot window) click "Export" -> "Export to PNG" or "Export to SVG" or "Export to image". For further formatting, see the gnuplot documentation e.g. the plot command:
http://gnuplot.info/docs_6.0/loc7969.html

You might want to use other visualisation tools for your report (e.g. Ovito, Matplotlib etc.), but we cannot promise to be able to fix problems with tools which we did not demonstrate in the labs, and with which we may not be familiar.
