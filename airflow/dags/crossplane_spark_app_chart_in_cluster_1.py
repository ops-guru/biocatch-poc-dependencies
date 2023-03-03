from airflow import DAG
from airflow.providers.cncf.kubernetes.operators.kubernetes_pod import KubernetesPodOperator
from airflow.providers.cncf.kubernetes.sensors.spark_kubernetes import SparkKubernetesSensor
from datetime import datetime, timedelta
from airflow.utils.dates import days_ago
from airflow.models import Variable
now = datetime.now()

default_args = {
    "owner": "k8s-kubectl",
    "depends_on_past": False,
    "start_date": days_ago(1),
    "email": ["airflow@airflow.com"],
    "email_on_failure": False,
    "email_on_retry": False,
    'max_active_runs': 1,
    'retries': 0
}
dag = DAG(
    dag_id='crossplane_spark_app_chart_in_cluster_1',
    default_args=default_args,
    schedule_interval=timedelta(days=1),
    tags=['pod','inside','bitnami','crossplane']
)

spark_app_name="crossplane-airflow-pod-poc"
Variable.set("spark_app_name", spark_app_name)

spark_app_namespace="spark-operator"
Variable.set("spark_app_namespace", spark_app_namespace)

start_crossplane_pod = KubernetesPodOperator(
    task_id="deploy_helm_crossplane_pod",
    namespace=spark_app_namespace,
    image="alpine/helm",
    cmds=['/bin/sh', '-c', 'helm repo add poc https://raw.githubusercontent.com/ops-guru/biocatch-poc-dependencies/main/helm/packages/ && helm repo update && helm upgrade -i {{ var.value.spark_app_name }} poc/crossplane-service-account --atomic --debug -f https://raw.githubusercontent.com/ops-guru/biocatch-poc-dependencies/main/airflow/crossplane-sa-values.yaml --set-string fullnameOverride={{ var.value.spark_app_name }}'],
    service_account_name="helm-identity",
    do_xcom_push=False,
    is_delete_operator_pod=True,
    get_logs=True,
    log_events_on_failure=True,
    random_name_suffix=spark_app_name,
    kubernetes_conn_id="kubernetes_default",
    dag=dag
)

start_spark_pod = KubernetesPodOperator(
    task_id="deploy_helm_spark_pod",
    namespace=spark_app_namespace,
    image="alpine/helm",
    cmds=['/bin/sh', '-c', 'helm repo add poc https://raw.githubusercontent.com/ops-guru/biocatch-poc-dependencies/main/helm/packages/ && helm repo update && helm upgrade -i {{ var.value.spark_app_name }} poc/spark-application --atomic --debug -f https://raw.githubusercontent.com/ops-guru/biocatch-poc-dependencies/main/airflow/spark-app-values.yaml --set-string name={{ var.value.spark_app_name }} --set-string driver.serviceAccount={{ var.value.spark_app_name }} --set-string executor.serviceAccount={{ var.value.spark_app_name }} --set-string fullnameOverride={{ var.value.spark_app_name }}'],
    service_account_name="helm-identity",
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
    namespace=spark_app_namespace,
    application_name=spark_app_name,
    kubernetes_conn_id="kubernetes_default",
    dag=dag,
    api_group="sparkoperator.k8s.io",
    attach_log=True
)
start_crossplane_pod >> start_spark_pod >> sensor
