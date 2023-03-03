# Airflow DAGs

`spark_operator_in_cluster_1.py` - shows the usage of SparkKubernetesOperator Airflow provider which constructs SparkApplication CRD.
- Make sure that service account for the application exists in the target namespace.

`spark_app_chart_in_cluster_1.py` - shows the usage of KubernetesPodOperator Airflow provider which uses `spark-application` helm chart installed from a K8s pod.
- Make sure that app is being deployed in the same namespace where `service_account_name` specified in DAG is located.