# Chart release

## charts

Folder for custom managed Helm charts

## packages

Folder where github workflow stores `index.yaml` and `*.tgz` charts for future downloads as `helm dependency update`

# Usage

You may download `spark-application` helm chart as a whole or use `spark-templates` as a dependency in your custom helm chart (as shown in charts/spark-application/Chart.yaml)