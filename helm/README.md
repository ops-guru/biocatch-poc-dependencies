# Chart release

## templates

Folder for custom Helm library charts, that might be used in charts or separately.
Order is important, because `templates` can be `dependencies` for charts and before building final chart, dependency must be updated

## charts

Folder for custom Helm charts

## packages

Folder where github workflow stores index.yaml and *.tgz charts for future downloads
