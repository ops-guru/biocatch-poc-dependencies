from airflow import DAG
from airflow.providers.cncf.kubernetes.operators.kubernetes_pod import KubernetesPodOperator
from airflow.providers.cncf.kubernetes.sensors.spark_kubernetes import SparkKubernetesSensor
from datetime import datetime, timedelta
from airflow.utils.dates import days_ago
from airflow.models import Variable
now = datetime.now()

default_args = {
    "owner": "crossplane-spark",
    "depends_on_past": False,
    "start_date": days_ago(1),
    "email": ["airflow@airflow.com"],
    "email_on_failure": False,
    "email_on_retry": False,
    'max_active_runs': 1,
    'retries': 0
}
dag = DAG(
    dag_id='crossplane_spark_app_1',
    default_args=default_args,
    schedule_interval=timedelta(days=1),
    tags=['pod','spark','crossplane']
)

gcp_project="artur-bolt-development"
Variable.set("gcp_project", gcp_project)

crossplane_app_name="crs-airflow"
Variable.set("crossplane_app_name", crossplane_app_name)

crossplane_app_namespace="crs-airflow"
Variable.set("crossplane_app_namespace", crossplane_app_namespace)

start_crossplane_pod = KubernetesPodOperator(
    task_id="deploy_helm_crossplane_pod",
    namespace="crossplane-system",
    image="alpine/helm",
    cmds=['/bin/sh', '-c', 'helm repo add poc https://raw.githubusercontent.com/ops-guru/biocatch-poc-dependencies/main/helm/packages/ && helm repo update && helm upgrade -i {{ var.value.crossplane_app_name }}-crs poc/crossplane-service-account --atomic --debug -f https://raw.githubusercontent.com/ops-guru/biocatch-poc-dependencies/main/airflow/values-crossplane.yaml --set-string fullnameOverride={{ var.value.crossplane_app_name }} --set-string workloadIdentity.project={{ var.value.gcp_project }} --set-string workloadIdentity.namespace={{ var.value.crossplane_app_namespace }} --set-string workloadIdentity.serviceAccount={{ var.value.crossplane_app_name }}'],
    service_account_name="helm-crossplane-system",
    do_xcom_push=False,
    is_delete_operator_pod=True,
    get_logs=True,
    log_events_on_failure=True,
    random_name_suffix=crossplane_app_name,
    kubernetes_conn_id="kubernetes_default",
    dag=dag
)
start_spark_pod = KubernetesPodOperator(
    task_id="deploy_helm_spark_pod",
    namespace="spark-operator",
    image="alpine/helm",
    cmds=['/bin/sh', '-c', 'helm repo add poc https://raw.githubusercontent.com/ops-guru/biocatch-poc-dependencies/main/helm/packages/ && helm repo update && helm upgrade -i {{ var.value.crossplane_app_name }}-spark poc/spark-application -n {{ var.value.crossplane_app_namespace }} --atomic --debug -f https://raw.githubusercontent.com/ops-guru/biocatch-poc-dependencies/main/airflow/values-spark-app.yaml --set-string driver.serviceAccount={{ var.value.crossplane_app_name }} --set-string executor.serviceAccount={{ var.value.crossplane_app_name }} --set-string fullnameOverride={{ var.value.crossplane_app_name }}'],
    service_account_name="helm-spark-operator",
    do_xcom_push=False,
    is_delete_operator_pod=True,
    get_logs=True,
    log_events_on_failure=True,
    random_name_suffix=crossplane_app_name,
    kubernetes_conn_id="kubernetes_default",
    dag=dag
)
sensor = SparkKubernetesSensor(
    task_id='sensor_helm_app',
    namespace=crossplane_app_namespace,
    application_name=crossplane_app_name,
    kubernetes_conn_id="kubernetes_default",
    dag=dag,
    api_group="sparkoperator.k8s.io",
    attach_log=True
)
start_crossplane_pod >> start_spark_pod >> sensor
