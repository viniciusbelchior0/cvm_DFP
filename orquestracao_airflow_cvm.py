from airflow import DAG 
from airflow.operators.bash_operator import BashOperator
import pendulum

with DAG(
    "demonstracoes_financeiras_cvm",
    start_date=pendulum.datetime(2024, 5, 1, tz="UTC"),
    schedule_interval='0 15 1 * *', # executas as 15:00 todo dia 1 de todos os meses
) as dag:

    obter_cias = BashOperator(
        task_id = 'obter_cias',
        bash_command = 'Rscript C:/Users/NOTEBOOK CASA/Desktop/cvm_DFPs/obter_cias.R'
    )

    obter_dfp = BashOperator(
        task_id = 'obter_dfp',
        bash_command = 'Rscript C:/Users/NOTEBOOK CASA/Desktop/cvm_DFPs/obter_dfp.R'
    )

    obter_cias >> obter_dfp
