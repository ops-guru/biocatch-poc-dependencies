{{- define "spark-templates.clusterRole" -}}
{{- if and .Values.rbac.create .Values.rbac.clusterWideAccess }}
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: {{ (.Values.rbac).name | default .Chart.Name }}
  {{- if or .Values.commonLabels .Values.rbac.labels }}
  labels:
    {{- if .Values.commonLabels }}
    {{- toYaml .Values.commonLabels | nindent 4 }}
    {{- end }}
    {{- if .Values.rbac.labels }}
    {{- toYaml .Values.rbac.labels | nindent 4 }}
    {{- end }}
  {{- end }}
  {{- if or .Values.commonAnnotations .Values.rbac.annotations }}
  annotations:
    {{- if .Values.commonAnnotations }}
    {{- toYaml .Values.commonAnnotations | nindent 4 }}
    {{- end }}
    {{- if .Values.rbac.annotations }}
    {{- toYaml .Values.rbac.annotations | nindent 4 }}
    {{- end }}
  {{- end }}
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "watch", "list", "create", "delete", "patch"]
- apiGroups: [""]
  resources: ["services"]
  verbs: ["get", "create", "delete"]
- apiGroups: [""]
  resources: ["configmaps"]
  verbs: ["get", "create", "list", "delete"]
{{- if .Values.rbac.rules }}
{{- toYaml .Values.rbac.rules | nindent 4 }}
{{- end }}
{{- end -}}
{{- end -}}
