from airflow import DAG
from airflow.providers.cncf.kubernetes.operators.kubernetes_pod import KubernetesPodOperator
from airflow.providers.cncf.kubernetes.sensors.spark_kubernetes import SparkKubernetesSensor
from datetime import datetime, timedelta
from airflow.utils.dates import days_ago
from airflow.models import Variable
now = datetime.now()

default_args = {
    "owner": "crossplane",
    "depends_on_past": False,
    "start_date": days_ago(1),
    "email": ["airflow@airflow.com"],
    "email_on_failure": False,
    "email_on_retry": False,
    'max_active_runs': 1,
    'retries': 0
}
dag = DAG(
    dag_id='crossplane_sa_1',
    default_args=default_args,
    schedule_interval=timedelta(days=1),
    tags=['pod','crossplane']
)

gcp_project_name="artur-bolt-development"
Variable.set("gcp_project_name", gcp_project_name)

crossplane_sa_name="crossplane-example-sa"
Variable.set("crossplane_sa_name", crossplane_sa_name)

crossplane_sa_namespace="crossplane-example-ns"
Variable.set("crossplane_sa_namespace", crossplane_sa_namespace)

start_crossplane_pod = KubernetesPodOperator(
    task_id="deploy_helm_crossplane_pod",
    namespace="crossplane-system",
    image="alpine/helm",
    cmds=['/bin/sh', '-c', 'helm repo add poc https://raw.githubusercontent.com/ops-guru/biocatch-poc-dependencies/main/helm/packages/ && helm repo update && helm upgrade -i {{ var.value.crossplane_sa_namespace }}-crs poc/crossplane-service-account --atomic --debug -f https://raw.githubusercontent.com/ops-guru/biocatch-poc-dependencies/main/airflow/values-crossplane.yaml --set-string fullnameOverride={{ var.value.crossplane_sa_name }} --set-string workloadIdentity.project={{ var.value.gcp_project_name }} --set-string workloadIdentity.namespace={{ var.value.crossplane_sa_namespace }} --set-string workloadIdentity.serviceAccount={{ var.value.crossplane_sa_name }}'],
    service_account_name="helm-crossplane-system",
    do_xcom_push=False,
    is_delete_operator_pod=True,
    get_logs=True,
    log_events_on_failure=True,
    random_name_suffix=crossplane_sa_name,
    kubernetes_conn_id="kubernetes_default",
    dag=dag
)
start_crossplane_pod
