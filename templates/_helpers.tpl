{{/* =========================
   Chart / Common
========================= */}}

{{- define "task-management.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "task-management.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" }}
{{- end }}

{{- define "task-management.labels" -}}
helm.sh/chart: {{ include "task-management.chart" . }}
app.kubernetes.io/name: {{ include "task-management.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "task-management.namespace" -}}
{{ .Values.namespace.name }}
{{- end }}


{{/* =========================
   Application
========================= */}}

{{- define "task-management.appName" -}}
{{ .Values.app.name }}
{{- end }}

{{- define "task-management.appServiceName" -}}
{{ .Values.app.serviceName }}
{{- end }}

{{- define "task-management.appConfigName" -}}
{{ printf "%s-config" .Values.app.name }}
{{- end }}

{{- define "task-management.appSecretName" -}}
{{ printf "%s-secret" .Values.app.name }}
{{- end }}

{{- define "task-management.appSelectorLabels" -}}
app.kubernetes.io/name: {{ .Values.app.name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: application
{{- end }}

{{- define "task-management.appLabels" -}}
{{ include "task-management.labels" . }}
app.kubernetes.io/component: application
{{- end }}


{{/* =========================
   MongoDB
========================= */}}

{{- define "task-management.mongodbName" -}}
{{ .Values.mongodb.name }}
{{- end }}

{{- define "task-management.mongodbServiceName" -}}
{{ .Values.mongodb.serviceName }}
{{- end }}

{{- define "task-management.mongodbHeadlessServiceName" -}}
{{ .Values.mongodb.headlessServiceName }}
{{- end }}

{{- define "task-management.mongodbSecretName" -}}
mongodb-secret
{{- end }}

{{- define "task-management.mongodbInitConfigName" -}}
mongodb-init-script
{{- end }}

{{- define "task-management.mongodbSelectorLabels" -}}
app.kubernetes.io/name: {{ .Values.mongodb.name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: mongodb
{{- end }}

{{- define "task-management.mongodbLabels" -}}
{{ include "task-management.labels" . }}
app.kubernetes.io/component: mongodb
{{- end }}


{{/* =========================
   Redis
========================= */}}

{{- define "task-management.redisName" -}}
{{ .Values.redis.name }}
{{- end }}

{{- define "task-management.redisServiceName" -}}
{{ .Values.redis.serviceName }}
{{- end }}

{{- define "task-management.redisSecretName" -}}
redis-auth
{{- end }}

{{- define "task-management.redisSelectorLabels" -}}
app.kubernetes.io/name: {{ .Values.redis.name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: redis
{{- end }}

{{- define "task-management.redisLabels" -}}
{{ include "task-management.labels" . }}
app.kubernetes.io/component: redis
{{- end }}


{{/* =========================
   Ingress / Istio
========================= */}}

{{- define "task-management.host" -}}
{{ .Values.ingress.host }}
{{- end }}

{{- define "task-management.gatewayName" -}}
{{ .Values.ingress.gatewayName }}
{{- end }}

{{- define "task-management.gatewayNamespace" -}}
{{ .Values.ingress.gatewayNamespace }}
{{- end }}

{{- define "task-management.gatewayReference" -}}
{{ printf "%s/%s" .Values.ingress.gatewayNamespace .Values.ingress.gatewayName }}
{{- end }}

{{- define "task-management.virtualServiceName" -}}
{{ .Values.ingress.virtualServiceName }}
{{- end }}

{{- define "task-management.certificateName" -}}
{{ .Values.ingress.certificateName }}
{{- end }}

{{- define "task-management.certificateSecretName" -}}
{{ .Values.ingress.secretName }}
{{- end }}

{{- define "task-management.clusterIssuer" -}}
{{ .Values.ingress.clusterIssuer }}
{{- end }}
