{{- define "spark-templates.scheduledApplication" -}}
{{- if eq .Values.templateType "scheduled" -}}
apiVersion: sparkoperator.k8s.io/v1beta2
kind: ScheduledSparkApplication
metadata:
  name: {{ include "spark-templates.fullname" . }}
  {{- if or .Values.commonLabels .Values.labels }}
  labels:
    {{- if .Values.commonLabels }}
    {{- toYaml .Values.commonLabels | nindent 4 }}
    {{- end }}
    {{- if .Values.labels }}
    {{- toYaml .Values.labels | nindent 4 }}
    {{- end }}
  {{- end }}
  {{- if or .Values.commonAnnotations .Values.annotations }}
  annotations:
    {{- if .Values.commonAnnotations }}
    {{- toYaml .Values.commonAnnotations | nindent 4 }}
    {{- end }}
    {{- if .Values.annotations }}
    {{- toYaml .Values.annotations | nindent 4 }}
    {{- end }}
  {{- end }}
spec:
  suspend: {{ .Values.suspend | default false }}
  concurrencyPolicy: {{ .Values.concurrencyPolicy }}
  schedule: {{ .Values.schedule | quote }}
  successfulRunHistoryLimit: {{ .Values.successfulRunHistoryLimit | default 1 }}
  failedRunHistoryLimit: {{ .Values.failedRunHistoryLimit | default 1 }}
  template: {{- toYaml .Values.template | nindent 4 }}
{{- end }}
{{- end }}