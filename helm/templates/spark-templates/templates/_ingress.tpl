{{- define "spark-templates.ingress" -}}
{{- $appName := .Values.name -}}
{{- $serviceName := printf "%s-%s" .Values.name "ui-svc" -}}
{{- $svcName := (.Values.service).name | default $serviceName -}}
{{- $svcPort := (.Values.service).port | default 4040 -}}
{{- if (eq ((.Values.ingress).enabled | default false) true) -}}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ $appName }}
  {{- if or .Values.commonLabels (.Values.ingress).labels }}
  labels:
    {{- if .Values.commonLabels }}
    {{- toYaml .Values.commonLabels | nindent 4 }}
    {{- end }}
    {{- if (.Values.ingress).labels }}
    {{- toYaml (.Values.ingress).labels | nindent 4 }}
    {{- end }}
  {{- end }}
  {{- if or .Values.commonAnnotations (.Values.ingress).annotations }}
  annotations:
    {{- if .Values.commonAnnotations }}
    {{- toYaml .Values.commonAnnotations | nindent 4 }}
    {{- end }}
    {{- if (.Values.ingress).annotations }}
    {{- toYaml (.Values.ingress).annotations | nindent 4 }}
    {{- end }}
  {{- end }}
spec:
  {{- if .Values.ingress.tls }}
  tls:
    {{- range .Values.ingress.tls }}
    - hosts:
        {{- range .hosts }}
        - {{ . | quote }}
        {{- end }}
      secretName: {{ .secretName }}
    {{- end }}
  {{- end }}
  rules:
    {{- range .Values.ingress.hosts }}
    - host: {{ .host | quote }}
      http:
        paths:
          {{- range .paths }}
          - path: {{ .path }}
            pathType: {{ .pathType | default "ImplementationSpecific" }}
            backend:
              service:
                name: {{ $svcName }}
                port:
                  number: {{ $svcPort }}
          {{- end }}
    {{- end }}
{{- end }}
{{- end }}
