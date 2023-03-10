# Changes to spark-operator

**Known issues:**
- If port 443 for webhook is used, GKE would not mount volumes and configmaps to pods (https://github.com/GoogleCloudPlatform/spark-on-k8s-operator/issues/1103)
- Issue with leader election and helm upgrade (https://github.com/GoogleCloudPlatform/spark-on-k8s-operator/issues/1554 , https://github.com/GoogleCloudPlatform/spark-on-k8s-operator/pull/1624/files). Possible fix for now, remove pre-upgrade on service account

## New files: `statefulset.yaml`, `hpa.yaml`

### statefulset.yaml

Copied from deployment yaml, changed:

1. `kind: StatefulSet`
2. Condition to enable `{{- if eq .Values.kind "statefulset" }}`
3. Removed leader election condition
```
- -leader-election=true
- -leader-election-lock-namespace={{ default .Release.Namespace .Values.leaderElection.lockNamespace }}
- -leader-election-lock-name={{ .Values.leaderElection.lockName }}
- -leader-election-lease-duration={{ .Values.leaderElection.leaseDuration }}
- -leader-election-renew-deadline={{ .Values.leaderElection.renewDeadline }}
- -leader-election-retry-period={{ .Values.leaderElection.retryPeriod }}
```

### hpa.yaml

1. `apiVersion: autoscaling/v2`
2. Can be applied to Deployment or StatefulSet
3. Tracks memory and cpu

## deployment.yaml

### Added condition that allow choosing StatefulSet over Deployment (new file: `statefulset.yaml`)
```
{{- if eq .Values.kind "deployment" }}
...
{{- end }}
```

### Added additional leader election parameters
```
- -leader-election-lease-duration={{ .Values.leaderElection.leaseDuration }}
- -leader-election-renew-deadline={{ .Values.leaderElection.renewDeadline }}
- -leader-election-retry-period={{ .Values.leaderElection.retryPeriod }}
```

### Added additional argument
```
args:
...
- -webhook-fail-on-error={{ .Values.webhook.failOnError }}
```

### Added condition to leader election for HPA
```
{{- if or (gt (int .Values.replicaCount) 1) .Values.autoscaling.enabled  }}
- -leader-election=true
- -leader-election-lock-namespace={{ default .Release.Namespace .Values.leaderElection.lockNamespace }}
- -leader-election-lock-name={{ .Values.leaderElection.lockName }}
{{- end }}
```

### Added liveness/readiness probes
```
{{- with .Values.livenessProbe }}
livenessProbe:
  {{- toYaml . | nindent 10 }}
{{- end }}
{{- with .Values.readinessProbe }}
readinessProbe:
  {{- toYaml . | nindent 10 }}
{{- end }}
```

### Added topologySpreadConstraints
```
{{- with .Values.topologySpreadConstraints }}
topologySpreadConstraints:
  {{- toYaml . | nindent 8 }}
{{- end }}
```

## rbac.yaml

### Added access for leader election and modified to work with HPA
```
  {{- if or (gt (int .Values.replicaCount) 1) .Values.autoscaling.enabled  }}
- apiGroups:
  - coordination.k8s.io
  resources:
  - leases
  resourceNames:
  - {{ .Values.leaderElection.lockName }}
  verbs:
  - "*"
- apiGroups:
  - coordination.k8s.io
  resources:
  - leases
  verbs:
  - "*"
  {{- end }}
```

## serviceaccount.yaml

### Removed pre-upgrade helm.sh/hook as a temporary fix for leader election error when Service Account is not refreshed and helm uprgade is made
#### - https://github.com/GoogleCloudPlatform/spark-on-k8s-operator/issues/1554
#### - https://github.com/GoogleCloudPlatform/spark-on-k8s-operator/pull/1624/files
```
  annotations:
    "helm.sh/hook": pre-install
    "helm.sh/hook-delete-policy": hook-failed, before-hook-creation
    "helm.sh/hook-weight": "-10"
```

## webhook-cleanup-job.yaml / webhook-init-job.yaml

### Fixed condition closing on line 48
```
          https://kubernetes.default.svc/apis/batch/v1/namespaces/{{ .Release.Namespace }}/jobs/{{ include "spark-operator.fullname" . }}-webhook-init"
{{ end }}
      {{- with .Values.tolerations }}
```

### Added separate affinities, selectors, tolerations and topology to webhook (added .Values.**webhook**.) and missing affinity and topologySpreadConstraints
```
{{- with .Values.webhook.affinity }}
affinity:
  {{- toYaml . | nindent 8 }}
{{- end }}
{{- with .Values.webhook.topologySpreadConstraints }}
topologySpreadConstraints:
  {{- toYaml . | nindent 8 }}
{{- end }}
```

## values.yaml

### Added condition that allow choosing StatefulSet over Deployment
```
# -- Deployment type, 'deployment' or 'statefulset'
kind: deployment
```

### Added liveness/readiness probes
```
# livenessProbe -- set configurable livenessProbe for operator
livenessProbe: {}

# readinessProbe -- set configurable readinessProbe for operator
readinessProbe: {}
```

### Added new leader election parameters
```
leaderElection:
  ...
  # -- Leader election lease duration.
  leaseDuration: 15s
  # -- Leader election renew deadline.
  renewDeadline: 14s
  # -- Leader election retry period.
  retryPeriod: 4s
```

### Added autoscaling
```
autoscaling:
  enabled: false
  minReplicas: 1
  maxReplicas: 5
  targetCPU: 50
  targetMemory: 50
```

### Added separate affinities, selectors, tolerations and topology to webhook
```
webhook:
  ...
  # nodeSelector -- Node labels for pod assignment
  nodeSelector: {}
  # tolerations -- List of node taints to tolerate
  tolerations: []
  # affinity -- Affinity for pod assignment
  affinity: {}
  # topologySpreadConstraints -- topologySpreadConstraints for pod assignment
  topologySpreadConstraints: {}
```

### Added condition for webhook
```
webhook:
  ...
  # -- Policy of failure handling. If it's set to true the namespaceSelector must be defined
  failOnError: false
```