{{- define "base-templates.namespace" -}}
apiVersion: v1
kind: Namespace
metadata:
  name: {{ include "base-templates.fullname" . }}
  {{- if or .Values.commonLabels .Values.serviceAccount.labels }}
  labels:
    {{- if .Values.commonLabels }}
    {{- toYaml .Values.commonLabels | nindent 4 }}
    {{- end }}
    {{- if .Values.serviceAccount.labels }}
    {{- toYaml .Values.serviceAccount.labels | nindent 4 }}
    {{- end }}
  {{- end }}
  {{- if or .Values.commonAnnotations .Values.serviceAccount.annotations }}
  annotations:
    {{- if .Values.commonAnnotations }}
    {{- toYaml .Values.commonAnnotations | nindent 4 }}
    {{- end }}
    {{- if .Values.serviceAccount.annotations }}
    {{- toYaml .Values.serviceAccount.annotations | nindent 4 }}
    {{- end }}
  {{- end }}
{{- end }}