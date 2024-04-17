# this script defines a basic malaria model 

library(deSolve)
library(tidyverse)


rates <- function(t, y, parms) {
  with(as.list(c(y, parms)), {
    poph <- Sh + Ih + Rh
    popm <- Sm + Im

    lambda_h <- beta_h * Im / poph 
    lambda_m <- beta_m * Ih / poph

    dSh <- mub_h * poph - (lambda_h + mud_h) * Sh
    dIh <- lambda_h * Sh - (gamma_h + mud_h) * Ih
    dRh <- gamma_h * Ih - mud_h * Rh

    dSm <- mub_m * popm - (lambda_m + mud_m) * Sm
    dIm <- lambda_m * Sm - mud_m * Im

    return(list(c(dSh, dIh, dRh, dSm, dIm)))
  })
}

timesteps <- seq(2015, 2025, 1 / 365)


make_parameters <- function(mub_h = 0.02,
                           mud_h = 0.02,
                           beta_h = 1,
                           gamma_h = 365.25 / 180,
                           mub_m = 2,
                           mud_m = 2,
                           beta_m = 1) {
  c(
    mu_h = mub_h + mud_h, mub_h = mub_h, mud_h = mud_h, beta_h = beta_h, gamma_h = gamma_h,
    mu_m = mub_m + mud_m, mub_m = mub_m, mud_m = mud_m, beta_m = beta_m
  )
}

makeinitial_conditions <- function(Sh = 10000,
                                  Ih = 1000,
                                  Rh = 0,
                                  Sm = 10000,
                                  Im = 1000,
                                  Ch = 0) {
  c(Sh = Sh, Ih = Ih, Rh = Rh, Sm = Sm, Im = Im)
}

run_model <- function(timesteps, initial_conditions, parameters) {
  compartment_names <- names(initial_conditions)
  mod <- ode(y = initial_conditions, times = timesteps, func = rates, parms = parameters) |>
    as.data.frame() %>% 
    pivot_longer(
      cols = !time, names_to = "compartment", values_to = "population",
      names_transform = ~ factor(.x, levels = compartment_names)
    )
  return(mod)
}