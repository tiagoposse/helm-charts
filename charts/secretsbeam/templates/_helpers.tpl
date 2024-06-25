{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "secretsbeam.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "secretsbeam.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "secretsbeam.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "secretsbeam.labels" -}}
helm.sh/chart: {{ include "secretsbeam.chart" . }}
{{ include "secretsbeam.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Common selector labels
*/}}
{{- define "secretsbeam.selectorLabels" -}}
app.kubernetes.io/name: {{ include "secretsbeam.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}


{{- define "webhook.fullname" -}}
{{- printf "%s-webhook" (include "secretsbeam.fullname" .) }}
{{- end }}

{{/*
webhook labels
*/}}
{{- define "webhook.labels" -}}
{{- include "secretsbeam.labels" . }}
component.orbitops.dev: webhook
{{- end }}

{{/*
webhook selector labels
*/}}
{{- define "webhook.selectorLabels" -}}
{{- include "secretsbeam.selectorLabels" . }}
component.orbitops.dev: webhook
{{- end }}


{{/*
Create the name of the webhook service account to use
*/}}
{{- define "webhook.serviceAccountName" -}}
{{- if .Values.webhook.serviceAccount.create }}
{{- default (printf "%s-webhook" (include "secretsbeam.fullname" .)) .Values.webhook.serviceAccount.name }}
{{- else }}
{{- default .Values.webhook.serviceAccount.name }}
{{- end }}
{{- end }}


{{- define "operator.fullname" -}}
{{- printf "%s-operator" (include "secretsbeam.fullname" .) }}
{{- end }}

{{/*
operator labels
*/}}
{{- define "operator.labels" -}}
{{- include "secretsbeam.labels" . }}
component.orbitops.dev: operator
{{- end }}

{{/*
operator selector labels
*/}}
{{- define "operator.selectorLabels" -}}
{{- include "secretsbeam.selectorLabels" . }}
component.orbitops.dev: operator
{{- end }}

{{/*
Create the name of the operator service account to use
*/}}
{{- define "operator.serviceAccountName" -}}
{{- if .Values.operator.serviceAccount.create }}
{{- default (printf "%s-operator" (include "secretsbeam.fullname" .)) .Values.operator.serviceAccount.name }}
{{- else }}
{{- default .Values.operator.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Certificate generator labels
*/}}
{{- define "certificateGenerator.labels" -}}
{{- include "secretsbeam.labels" . }}
component.orbitops.dev: cert-gen
{{- end }}

{{- define "certificateGenerator.fullname" -}}
{{- printf "%s-certificate-generator" (include "secretsbeam.fullname" .) }}
{{- end }}

{{/*
Create the name of the cert-gen service account to use
*/}}
{{- define "certificateGenerator.serviceAccountName" -}}
{{- if .Values.certificateGenerator.serviceAccount.create }}
{{- default (printf "%s-cert-gen" (include "secretsbeam.fullname" .)) .Values.certificateGenerator.serviceAccount.name }}
{{- else }}
{{- default .Values.certificateGenerator.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the webhook to use
*/}}
{{- define "secretsbeam.webhookName" -}}
{{- if .Values.certificateGenerator.enabled }}
{{- (index .Values "webhook-cert-gen").webhook.name }}
{{- else }}
{{- printf "002-secrets.orbitops.dev" }}
{{- end }}
{{- end }}

{{- define "secretsbeam.serviceName" -}}
{{- if .Values.certificateGenerator.enabled }}
{{- (index .Values "webhook-cert-gen").webhook.service }}
{{- else }}
{{- include "secretsbeam.fullname" . }}
{{- end }}
{{- end }}