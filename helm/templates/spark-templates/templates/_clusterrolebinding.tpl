{{- define "spark-templates.clusterRoleBinding" -}}
{{- $saName := .Values.serviceAccount.name | default (.Values.driver).serviceAccount -}}
{{- if and .Values.rbac.create .Values.rbac.clusterWideAccess }}
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: {{ (.Values.rbac).name | default .Chart.Name }}-binding
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
subjects:
- kind: ServiceAccount
  name: {{ $saName | default .Chart.Name }}
  namespace: {{ .Release.Namespace }}
roleRef:
  kind: ClusterRole
  name: {{ (.Values.rbac).name | default .Chart.Name }}
  apiGroup: rbac.authorization.k8s.io
{{- end -}}
{{- end -}}