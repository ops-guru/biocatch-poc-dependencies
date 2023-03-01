# Chart release

To create a versioned package of a chart, run
```
helm package chart
```

To update index.yaml, run
```
helm repo index .
```

If charts are multipartial, like `spark-application` (consists `spark-templates`), first run `helm dependency update` in the chart to download latest sub-chart and only after that package and index them.
