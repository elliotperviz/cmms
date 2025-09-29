# Computational Methods for Materials Science
Here you will find lecture and tutorial material for the course **Computational Methods for Materials Science**.

"Some words of an introduction to the course here"

Written and maintained by<br>
- Assoc. Prof. Antonio Cammarata (cammaant@fel.cvut.cz)<br>
- MSc. Elliot Perviz (perviell@fel.cvut.cz)<br>

## Installation (software and tutorial material)

### 0. Let's get started
In the laboratory sessions, the machines are prepared to have all relevant software pre-installed. As such, the necessary preparation steps are minimal.

It is important to be aware that we use machines with a **Linux operating system** installed. Moreover, we will almost exclusively work inside the **Linux terminal**, both for installation and to carry out the various tutorials in the laboratory.

Why?
- The majority of the software that we use does *not* have a graphical interface.
- Whilst to the new user the terminal may seem daunting, working directly in such a command line interface (CLI) allows us to directly interface with the simulation codes to perform post-processing and analysis.
- Over the duration of the course, you will learn both how to use the simulation software, and the manipulation of input and output data through the guided tutorials that we have prepared.

The aim of this course is not to teach users how to use the Linux terminal. Nevertheless, we have prepared a small "cheat sheet" **TO DO!!!** for common commands that we will use regularly.

### 1. Download the tutorial files
First, clone this github repository to download the tutorial files. In the Linux terminal copy the following command in the location where you would like to download the files (note: the files download into a single folder, you don't need to make one yourself):
```bash
git clone https://github.com/elliotperviz/cmms.git
cd cmms/
```

You should see the following files/folders, e.g.
```bash
perviell@postel cmms$ ls
README.md  exam  md  ph  qm  scripts
```

### 2. Compile scripts for post-processing and analysis
For your convenience, we have prepared scripts to simplify some aspects of post-processing and analysis. To be able to use the scripts, you should add the folder to the Linux ```$PATH``` variable and build the relevant executables from source. Enter (or copy) the following commands into your terminal (assuming you are inside the "cmms" folder):
```bash
cd scripts
chmod +x compile.sh
./compile.sh
source ~/.bashrc
```

To understand the purpose of the different scripts, more context is provided in the README file in the [scripts](scripts/) folder.

### 3. Additional information

For your reference, we provide a list of the relevant software used throughout the tutorials below:
[list here]

For installation on your home computer, please check the relevant installation guides for the different software packages. [In the future, we may provide short installation guides here for different types of machine]

## Tutorial Outline
Add to this section as the tutorial material is checked
### Subsection


