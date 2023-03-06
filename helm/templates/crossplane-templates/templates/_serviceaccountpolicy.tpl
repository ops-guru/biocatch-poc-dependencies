{{- define "crossplane-templates.iamGcpServiceAccountPolicy" -}}
apiVersion: iam.gcp.crossplane.io/v1alpha1
kind: ServiceAccountPolicy
metadata:
  name: {{ include "crossplane-templates.fullname" . }}
spec:
  forProvider:
    serviceAccountRef:
      name: {{ include "crossplane-templates.fullname" . }}
    policy:
      {{- with .Values.bindings }}
      bindings:
        {{- if .Values.workloadIdentity }}
        - role: roles/iam.workloadIdentityUser
          members:
            - serviceAccount:{{ .Values.workloadIdentity.project }}.svc.id.goog[{{ .Values.workloadIdentity.namespace }}/{{ .Values.workloadIdentity.serviceAccount }}]
        {{- end }}
        {{- toYaml . | nindent 8 }}
      {{- end }}
  providerConfigRef:
    name: {{ .Values.providerConfigName }}
---
{{- end }}