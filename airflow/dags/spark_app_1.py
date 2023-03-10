from airflow import DAG
from airflow.providers.cncf.kubernetes.operators.kubernetes_pod import KubernetesPodOperator
from airflow.providers.cncf.kubernetes.sensors.spark_kubernetes import SparkKubernetesSensor
from datetime import datetime, timedelta
from airflow.utils.dates import days_ago
from airflow.models import Variable
now = datetime.now()

default_args = {
    "owner": "spark",
    "depends_on_past": False,
    "start_date": days_ago(1),
    "email": ["airflow@airflow.com"],
    "email_on_failure": False,
    "email_on_retry": False,
    'max_active_runs': 1,
    'retries': 0
}
dag = DAG(
    dag_id='spark_app_1',
    default_args=default_args,
    schedule_interval=timedelta(days=1),
    tags=['pod','spark']
)

spark_app_name="airflow-pod-poc-01"
Variable.set("spark_app_name", spark_app_name)

spark_app_sa="spark-operator-spark"
Variable.set("spark_app_sa", spark_app_sa)

start_pod = KubernetesPodOperator(
    task_id="deploy_helm_pod",
    namespace="spark-operator",
    image="alpine/helm",
    cmds=['/bin/sh', '-c', 'helm repo add poc https://raw.githubusercontent.com/ops-guru/biocatch-poc-dependencies/main/helm/packages/ && helm repo update && helm upgrade -i {{ var.value.spark_app_name }} poc/spark-application --atomic --debug -f https://raw.githubusercontent.com/ops-guru/biocatch-poc-dependencies/main/airflow/values-spark-app.yaml --set-string driver.serviceAccount={{ var.value.spark_app_sa }} --set-string executor.serviceAccount={{ var.value.spark_app_sa }} --set-string fullnameOverride={{ var.value.spark_app_name }}'],
    service_account_name="helm-spark-operator",
    do_xcom_push=False,
    is_delete_operator_pod=True,
    get_logs=True,
    log_events_on_failure=True,
    random_name_suffix=spark_app_name,
    kubernetes_conn_id="kubernetes_default",
    dag=dag
)
sensor = SparkKubernetesSensor(
    task_id='sensor_helm_app',
    namespace="spark-operator",
    application_name=spark_app_name,
    kubernetes_conn_id="kubernetes_default",
    dag=dag,
    api_group="sparkoperator.k8s.io",
    attach_log=True
)
start_pod >> sensor
