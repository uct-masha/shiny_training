import numpy as np
import pandas as pd
import plotly.express as px
import great_tables.shiny as gts

from shiny import App, Inputs, Outputs, Session, render, ui, reactive
from faicons import icon_svg
from shinywidgets import output_widget, render_widget
from great_tables import GT

# import the model
import model

# define the ui
app_ui = ui.page_sidebar(
    ui.sidebar(
        ui.accordion(
            ui.accordion_panel(
                "Human Parameters",
                ui.input_slider("birth_rate_human", "Human birth rate", min=0, max=1, value=0.02),
                ui.input_slider("death_rate_human", "Human death rate", min=0, max=1, value=0.02),
                ui.input_numeric("beta_human", "Human transmission parameter", value=18),
                ui.input_numeric("gamma_human", "Human recovery rate", value=round(365.25 / 180)),
                icon=icon_svg("person")
            ),
            ui.accordion_panel(
                "Mosquito Parameters",
                ui.input_slider("birth_rate_mosquito", "Mosquito birth rate", min=1, max=5, value=2),
                ui.input_slider("death_rate_mosquito", "Mosquito death rate", min=1, max=5, value=2),
                ui.input_numeric("beta_mosquito", "Mosquito transmission parameter", value=1),
                icon=icon_svg("mosquito")
            ),
            ui.accordion_panel(
                "Initial Conditions",
                ui.input_numeric("susceptible_humans", "Susceptible humans", value=10000),
                ui.input_numeric("infectious_humans", "Infectious humans", value=100),
                ui.input_numeric("recovered_humans", "Recovered humans", value=0),
                ui.input_numeric("susceptible_mosquitoes", "Susceptible Mosquitoes", value=10000),
                ui.input_numeric("infectious_mosquitoes", "Infectious Mosquitoes", value=100),
                icon=icon_svg("network-wired")
            ),
            open=False
        ),
        ui.input_action_button("run_model", "Run model"),
        title="Model Inputs",
        width=300
    ),
    ui.navset_card_underline(
        ui.nav_panel("Plots", output_widget("model_plot")),
        ui.nav_panel("Raw results", gts.output_gt("results_table")),
        ui.nav_panel(
            "Downloads", 
            ui.p("You can download the raw model results in a CSV file."), 
            ui.br(),
            ui.layout_columns(ui.download_button("raw_model_results", "Download results"))
        ),
        title="Model Results"
    ),
    title="Basic Malaria App",
    fillable=True
)

# define the server function
def server(input: Inputs, output: Outputs, session: Session):

    # reactive value to store model results
    model_results = reactive.value()

    # run the model when the run button is clicked
    @reactive.effect
    @reactive.event(input.run_model,  ignore_none=False)
    def _():
        # Run the model
        timesteps = np.linspace(2015, 2025, int((2025 - 2015) * 365))
        initial_conditions = model.make_initial_conditions(
            Sh = input.susceptible_humans(),
            Ih = input.infectious_humans(),
            Rh = input.recovered_humans(),
            Sm = input.susceptible_mosquitoes(),
            Im = input.infectious_mosquitoes()
        )
        parameters = model.make_parameters(
            mub_h = input.birth_rate_human(),
            mud_h = input.death_rate_human(),
            beta_h = input.beta_human(),
            gamma_h = input.gamma_human(),
            mub_m = input.birth_rate_mosquito(),
            mud_m = input.death_rate_mosquito(),
            beta_m = input.beta_mosquito()
        )

        results = model.run_model(initial_conditions, parameters, timesteps)
        results['Time'] = timesteps
        model_results.set(results) # store the model results in a model_results reactive


    # render the model plot
    @render_widget
    def model_plot():

        # Create the DataFrame for plotting
        df = model_results.get()
        
        # Melt the DataFrame for Plotly Express
        melted_df = df.melt(
            id_vars=['Time'], 
            value_vars=['Sh', 'Ih', 'Rh', 'Sm', 'Im'], 
            var_name='Compartment', 
            value_name='Population'
        )

        # Create the plotly interactive plot
        fig = px.line(melted_df, x='Time', y='Population', color='Compartment')
        fig.update_layout(
            xaxis_title='Time (days)', 
            yaxis_title='Population', 
            legend_title='Compartments',  
            plot_bgcolor='white'
        )
        fig.update_xaxes({'gridcolor': '#d3d3d3'})
        fig.update_yaxes({'gridcolor': '#d3d3d3'})
        
        return fig

    # render the table of raw results
    @gts.render_gt
    def results_table():
        tbl =  (
            GT(model_results.get().head(n = 15))
            .tab_options(table_width="100%")
            .fmt_number(columns =["Sh", "Ih", "Rh", "Sm", "Im"], decimals=0, use_seps=True)
            .fmt_number(columns = "Time", decimals=2, use_seps=False)
        )
        return tbl
    
    # download the model results to a csv
    @session.download(filename="model_results.csv")
    def raw_model_results():
        yield model_results.get().to_csv()

app = App(app_ui, server)



