# Building Web Interfaces for Effective Model Communication, Exploration and Debugging

This repository holds the materials required to be used in a training to be held on **April 18** during the AMMnet Kigali meeting. The session guides participants through creating a web interface using the Shiny package. The session will be conducted using the R programming language but participants who are familiar with Python will also find the session helpful given the nearly identical syntax between the R and Python Shiny packages. Moreover, a Python implementation of the final app will be made available as well. Materials are also available in either English or French.

## Set-up

Please join the workshop with a computer that has the following installed (all available for free):

-   A recent version of R, available at <https://cran.r-project.org>
-   A recent version of RStudio Desktop available at <https://posit.co/download/rstudio-desktop>
-   The following R packages, which you can install from the R console:

```         
pkgs <- c("tidyverse", "shiny", "bslib", "deSolve", "plotly")

install.packages(pkgs)
```

> **Note** If you’re a Windows user and encounter an error message during installation noting a missing Rtools installation, install Rtools using the installer linked [here](https://cran.r-project.org/bin/windows/Rtools).
