{{- define "spark-templates.application" -}}
{{- if eq .Values.templateType "application" -}}
apiVersion: sparkoperator.k8s.io/v1beta2
kind: SparkApplication
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
  type: {{ .Values.type }}
  sparkVersion: {{ .Values.sparkVersion | quote }}
  mode: {{ .Values.mode }}
  {{- if .Values.proxyUser }}
  proxyUser: {{ .Values.proxyUser }}
  {{- end }}
  {{- if .Values.image }}
  image: {{ .Values.image }}
  {{- end }}
  {{- if .Values.imagePullPolicy }}
  imagePullPolicy: {{ .Values.imagePullPolicy }}
  {{- end }}
  {{- if .Values.imagePullSecrets }}
  imagePullSecrets:
  {{- range $secretName := .Values.imagePullSecrets }}
    - name: {{ $secretName }}
  {{- end }}
  {{- end }}
  {{- if .Values.mainClass }}
  mainClass: {{ .Values.mainClass }}
  {{- end }}
  {{- if .Values.mainApplicationFile }}
  mainApplicationFile: {{ .Values.mainApplicationFile }}
  {{- end }}
  {{- if .Values.arguments }}
  arguments:
  {{- range $k := .Values.arguments }}
    - {{ . | quote }}
  {{- end }}
  {{- end }}
  {{- if .Values.sparkConf }}
  sparkConf: {{- toYaml .Values.sparkConf | nindent 4 }}
  {{- end }}
  {{- if .Values.hadoopConf }}
  hadoopConf: {{- toYaml .Values.hadoopConf | nindent 4 }}
  {{- end }}
  {{- if .Values.sparkConfigMap }}
  sparkConfigMap: {{ .Values.sparkConfigMap }}
  {{- end }}
  {{- if .Values.hadoopConfigMap }}
  hadoopConfigMap: {{ .Values.hadoopConfigMap }}
  {{- end }}
  {{- if .Values.volumes }}
  volumes: {{- toYaml .Values.volumes | nindent 4 }}
  {{- end }}
  driver: {{- toYaml .Values.driver | nindent 4 }}
  executor: {{- toYaml .Values.executor | nindent 4 }}
  {{- if .Values.deps }}
  deps: {{- toYaml .Values.deps | nindent 4 }}
  {{- end }}
  restartPolicy: {{- toYaml .Values.restartPolicy | nindent 4 }}
  {{- if .Values.nodeSelector }}
  nodeSelector:
  {{- range $k := .Values.nodeSelector }}
  - {{ . }}
  {{- end }}
  {{- end }}
  {{- if .Values.failureRetries }}
  failureRetries: {{ .Values.failureRetries }}
  {{- end }}
  {{- if .Values.retryInterval }}
  retryInterval: {{ .Values.retryInterval }}
  {{- end }}
  {{- if .Values.pythonVersion }}
  pythonVersion: {{ .Values.pythonVersion | quote }}
  {{- end }}
  {{- if .Values.memoryOverheadFactor }}
  memoryOverheadFactor: {{ .Values.memoryOverheadFactor | quote }}
  {{- end }}
  {{- if .Values.monitoring }}
  monitoring: {{- toYaml .Values.monitoring | nindent 4 }}
  {{- end }}
  {{- if .Values.batchScheduler }}
  batchScheduler: {{ .Values.batchScheduler }}
  {{- end }}
  {{- if .Values.timeToLiveSeconds }}
  timeToLiveSeconds: {{ .Values.timeToLiveSeconds }}
  {{- end }}
  {{- if .Values.batchSchedulerOptions }}
  batchSchedulerOptions: {{- toYaml .Values.batchSchedulerOptions | nindent 4 }}
  {{- end }}
  {{- if .Values.sparkUIOptions }}
  sparkUIOptions: {{- toYaml .Values.sparkUIOptions | nindent 4 }}
  {{- end }}
  {{- if .Values.dynamicAllocation }}
  dynamicAllocation: {{- toYaml .Values.dynamicAllocation | nindent 4 }}
  {{- end }}
{{- end }}
{{- end }}