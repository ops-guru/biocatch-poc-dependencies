{{- define "crossplane-templates.iamGcpServiceAccount" -}}
apiVersion: iam.gcp.crossplane.io/v1alpha1
kind: ServiceAccount
metadata:
  name: {{ include "crossplane-templates.fullname" . }}
spec:
  forProvider:
    displayName: {{ include "crossplane-templates.fullname" . }}
    description: {{ include "crossplane-templates.fullname" . }}
  deletionPolicy: {{ .Values.deletionPolicy }}
  providerConfigRef:
    name: {{ .Values.providerConfigName }}
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ include "crossplane-templates.fullname" . }}
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
automountServiceAccountToken: {{ .Values.serviceAccount.automountServiceAccountToken | default true }}
{{- end }}