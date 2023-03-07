# spark-application

![Version: 0.0.1](https://img.shields.io/badge/Version-0.0.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0.0](https://img.shields.io/badge/AppVersion-1.0.0-informational?style=flat-square)

A Helm chart for Kubernetes templates

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| artur-bolt | <artur@opsguru.io> |  |

## Source Code

* <https://github.com/GoogleCloudPlatform/spark-on-k8s-operator/blob/master/docs/api-docs.md>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| annotations | object | `{}` | Add annotations to application |
| arguments | Optional | `[]` | Arguments is a list of arguments to be passed to the application. |
| batchScheduler | Optional | `""` | BatchScheduler configures which batch scheduler will be used for scheduling |
| batchSchedulerOptions | Optional | `{}` | BatchSchedulerOptions provides fine-grained control on how to batch scheduling. https://github.com/GoogleCloudPlatform/spark-on-k8s-operator/blob/master/docs/api-docs.md#sparkoperator.k8s.io/v1beta2.BatchSchedulerConfiguration |
| commonAnnotations | object | `{}` | Add annotations to all the deployed resources |
| commonLabels | object | `{}` | Add labels to all the deployed resources |
| concurrencyPolicy | string | `""` | ConcurrencyPolicy is the policy governing concurrent SparkApplication runs. https://github.com/GoogleCloudPlatform/spark-on-k8s-operator/blob/master/docs/api-docs.md#sparkoperator.k8s.io/v1beta2.ConcurrencyPolicy |
| deps | Optional | `{}` | Deps captures all possible types of dependencies of a Spark application. https://github.com/GoogleCloudPlatform/spark-on-k8s-operator/blob/master/docs/api-docs.md#sparkoperator.k8s.io/v1beta2.Dependencies |
| driver | object | `{}` | Driver is the driver specification. https://github.com/GoogleCloudPlatform/spark-on-k8s-operator/blob/master/docs/api-docs.md#sparkoperator.k8s.io/v1beta2.DriverSpec |
| dynamicAllocation | Optional | `{}` | DynamicAllocation configures dynamic allocation that becomes available for the Kubernetes scheduler backend since Spark 3.0. https://github.com/GoogleCloudPlatform/spark-on-k8s-operator/blob/master/docs/api-docs.md#sparkoperator.k8s.io/v1beta2.DynamicAllocation |
| executor | object | `{}` | Executor is the executor specification. https://github.com/GoogleCloudPlatform/spark-on-k8s-operator/blob/master/docs/api-docs.md#sparkoperator.k8s.io/v1beta2.ExecutorSpec |
| failedRunHistoryLimit | int | `1` | FailedRunHistoryLimit is the number of past failed runs of the application to keep. Defaults to 1. |
| failureRetries | Optional | `""` | FailureRetries is the number of times to retry a failed application before giving up. This is best effort and actual retry attempts can be >= the value specified. |
| fullnameOverride | string | `""` | String to override release name |
| hadoopConf | Optional | `{}` | HadoopConf carries user-specified Hadoop configuration properties as they would use the the “–conf” option in spark-submit. The SparkApplication controller automatically adds prefix “spark.hadoop.” to Hadoop configuration properties. |
| hadoopConfigMap | Optional | `""` | HadoopConfigMap carries the name of the ConfigMap containing Hadoop configuration files such as core-site.xml. The controller will add environment variable HADOOP_CONF_DIR to the path where the ConfigMap is mounted to. |
| image | Optional | `""` | Image is the container image for the driver, executor, and init-container. Any custom container images for the driver, executor, or init-container takes precedence over this. |
| imagePullPolicy | Optional | `""` | ImagePullPolicy is the image pull policy for the driver, executor, and init-container. |
| imagePullSecrets | Optional | `[]` | ImagePullSecrets is the list of image-pull secrets. |
| labels | object | `{}` | Add labels to application |
| mainApplicationFile | Optional | `""` | MainFile is the path to a bundled JAR, Python, or R file of the application. |
| mainClass | Optional | `""` | MainClass is the fully-qualified main class of the Spark application. This only applies to Java/Scala Spark applications. |
| memoryOverheadFactor | Optional | `""` | This sets the Memory Overhead Factor that will allocate memory to non-JVM memory. For JVM-based jobs this value will default to 0.10, for non-JVM jobs 0.40. Value of this field will be overridden by Spec.Driver.MemoryOverhead and Spec.Executor.MemoryOverhead if they are set. |
| mode | string | `"cluster"` | Mode is the deployment mode of the Spark application. https://github.com/GoogleCloudPlatform/spark-on-k8s-operator/blob/master/docs/api-docs.md#sparkoperator.k8s.io/v1beta2.DeployMode |
| monitoring | Optional | `{}` | Monitoring configures how monitoring is handled. https://github.com/GoogleCloudPlatform/spark-on-k8s-operator/blob/master/docs/api-docs.md#sparkoperator.k8s.io/v1beta2.MonitoringSpec |
| name | string | `""` | Define application name |
| nameOverride | string | `""` | String to partially override template (will maintain the release name) |
| nodeSelector | Optional | `{}` | NodeSelector is the Kubernetes node selector to be added to the driver and executor pods. This field is mutually exclusive with nodeSelector at podSpec level (driver or executor). This field will be deprecated in future versions (at SparkApplicationSpec level). |
| proxyUser | Optional | `""` | ProxyUser specifies the user to impersonate when submitting the application. It maps to the command-line flag “–proxy-user” in spark-submit. |
| pythonVersion | Optional | `""` | This sets the major Python version of the docker image used to run the driver and executor containers. Can either be 2 or 3, default 2. |
| rbac | object | `{"clusterWideAccess":true,"create":false,"rules":[]}` | Role Based Access Ref: https://kubernetes.io/docs/admin/authorization/rbac/ |
| rbac.clusterWideAccess | bool | `true` | Create Role or RoleBinding |
| rbac.rules | list | `[]` | Additional rbac rules |
| restartPolicy | object | `{}` | RestartPolicy defines the policy on if and in which conditions the controller should restart an application. https://github.com/GoogleCloudPlatform/spark-on-k8s-operator/blob/master/docs/api-docs.md#sparkoperator.k8s.io/v1beta2.RestartPolicy |
| retryInterval | Optional | `""` | RetryInterval is the unit of intervals in seconds between submission retries. |
| schedule | string | `""` | Schedule is a cron schedule on which the application should run. |
| serviceAccount | object | `{"annotations":{},"automountServiceAccountToken":true,"create":false,"name":""}` | Service account for pods to use ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/ |
| serviceAccount.annotations | object | `{}` | Additional custom annotations for the ServiceAccount |
| serviceAccount.automountServiceAccountToken | bool | `true` | Can be set to false if pods using this serviceAccount do not need to use K8s API |
| serviceAccount.create | bool | `false` | Enable creation of ServiceAccount for pods |
| serviceAccount.name | string | `""` | If not set and create is true, a driver.serviceAccount is used. If not set as well, a chart name is used |
| sparkConf | Optional | `{}` | SparkConf carries user-specified Spark configuration properties as they would use the “–conf” option in spark-submit. |
| sparkConfigMap | Optional | `""` | SparkConfigMap carries the name of the ConfigMap containing Spark configuration files such as log4j.properties. The controller will add environment variable SPARK_CONF_DIR to the path where the ConfigMap is mounted to. |
| sparkUIOptions | Optional | `{}` | SparkUIOptions allows configuring the Service and the Ingress to expose the sparkUI https://github.com/GoogleCloudPlatform/spark-on-k8s-operator/blob/master/docs/api-docs.md#sparkoperator.k8s.io/v1beta2.SparkUIConfiguration |
| sparkVersion | string | `""` | SparkVersion is the version of Spark the application uses. |
| successfulRunHistoryLimit | int | `1` | SuccessfulRunHistoryLimit is the number of past successful runs of the application to keep. Defaults to 1. |
| suspend | Optional | `false` | Suspend is a flag telling the controller to suspend subsequent runs of the application if set to true. Defaults to false. |
| template | object | `{}` | Template is a template from which SparkApplication instances can be created. https://github.com/GoogleCloudPlatform/spark-on-k8s-operator/blob/master/docs/api-docs.md#sparkoperator.k8s.io/v1beta2.SparkApplicationSpec |
| templateType | string | `"application"` | Define type, application / scheduled |
| timeToLiveSeconds | Optional | `""` | TimeToLiveSeconds defines the Time-To-Live (TTL) duration in seconds for this SparkApplication after its termination. The SparkApplication object will be garbage collected if the current time is more than the TimeToLiveSeconds since its termination. |
| type | string | `"Scala"` | Type tells the type of the Spark application. https://github.com/GoogleCloudPlatform/spark-on-k8s-operator/blob/master/docs/api-docs.md#sparkoperator.k8s.io/v1beta2.SparkApplicationType |
| volumes | Optional | `[]` | Volumes is the list of Kubernetes volumes that can be mounted by the driver and/or executors. https://v1-18.docs.kubernetes.io/docs/reference/generated/kubernetes-api/v1.18/#volume-v1-core |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
