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
{{- end }}