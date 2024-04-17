import numpy as np
import pandas as pd
from scipy.integrate import odeint
import matplotlib.pyplot as plt
import plotly.graph_objects as go

def rates(y, t, mub_h, mud_h, beta_h, gamma_h, mub_m, mud_m, beta_m):
    Sh, Ih, Rh, Sm, Im = y
    poph = Sh + Ih + Rh
    popm = Sm + Im
    lambda_h = beta_h * Im / poph
    lambda_m = beta_m * Ih / poph

    dSh = mub_h * poph - (lambda_h + mud_h) * Sh
    dIh = lambda_h * Sh - (gamma_h + mud_h) * Ih
    dRh = gamma_h * Ih - mud_h * Rh
    dSm = mub_m * popm - (lambda_m + mud_m) * Sm
    dIm = lambda_m * Sm - mud_m * Im

    return [dSh, dIh, dRh, dSm, dIm]

def make_parameters(mub_h = 0.02, mud_h = 0.02, beta_h = 18.0, gamma_h = 365.25 / 180.0, mub_m = 2.0, mud_m = 2.0, beta_m = 1.0):
    mu_h = mub_h + mud_h
    mu_m = mub_m + mud_m
    return mub_h, mud_h, beta_h, gamma_h, mub_m, mud_m, beta_m, mu_h, mu_m

def make_initial_conditions(Sh=10000, Ih=1000, Rh=0, Sm=10000, Im=1000):
    return [Sh, Ih, Rh, Sm, Im]

def run_model(initial_conditions, parameters, timesteps):
    Sh0, Ih0, Rh0, Sm0, Im0 = initial_conditions
    mub_h, mud_h, beta_h, gamma_h, mub_m, mud_m, beta_m, mu_h, mu_m = parameters
    y0 = np.array(initial_conditions)
    sol = odeint(rates, y0, timesteps, args=(mub_h, mud_h, beta_h, gamma_h, mub_m, mud_m, beta_m))
    df = pd.DataFrame(sol)
    df.columns = ["Sh", "Ih", "Rh", "Sm", "Im"]
    return df

# Example usage
# timesteps = np.linspace(2015, 2025, int((2025 - 2015) * 365))
# Run the model
# initial_conditions = make_initial_conditions()
# parameters = make_parameters()
# results = run_model(initial_conditions, parameters, timesteps)


