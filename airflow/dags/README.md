# Airflow DAGs

`spark_operator_in_cluster_1.py` - shows the usage of SparkKubernetesOperator Airflow provider which constructs SparkApplication CRD.

`spark_app_chart_in_cluster_1.py` - shows the usage of KubernetesPodOperator Airflow provider which uses `spark-application` helm chart installed from a K8s pod.