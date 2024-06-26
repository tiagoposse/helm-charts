{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "secrets-beam.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "secrets-beam.fullname" -}}
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
{{- define "secrets-beam.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "secrets-beam.labels" -}}
helm.sh/chart: {{ include "secrets-beam.chart" . }}
{{ include "secrets-beam.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Common selector labels
*/}}
{{- define "secrets-beam.selectorLabels" -}}
app.kubernetes.io/name: {{ include "secrets-beam.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}


{{- define "webhook.fullname" -}}
{{- printf "%s-webhook" (include "secrets-beam.fullname" .) }}
{{- end }}

{{/*
webhook labels
*/}}
{{- define "webhook.labels" -}}
{{- include "secrets-beam.labels" . }}
component.orbitops.dev: webhook
{{- end }}

{{/*
webhook selector labels
*/}}
{{- define "webhook.selectorLabels" -}}
{{- include "secrets-beam.selectorLabels" . }}
component.orbitops.dev: webhook
{{- end }}


{{/*
Create the name of the webhook service account to use
*/}}
{{- define "webhook.serviceAccountName" -}}
{{- if .Values.webhook.serviceAccount.create }}
{{- default (printf "%s-webhook" (include "secrets-beam.fullname" .)) .Values.webhook.serviceAccount.name }}
{{- else }}
{{- default .Values.webhook.serviceAccount.name }}
{{- end }}
{{- end }}


{{- define "operator.fullname" -}}
{{- printf "%s-operator" (include "secrets-beam.fullname" .) }}
{{- end }}

{{/*
operator labels
*/}}
{{- define "operator.labels" -}}
{{- include "secrets-beam.labels" . }}
component.orbitops.dev: operator
{{- end }}

{{/*
operator selector labels
*/}}
{{- define "operator.selectorLabels" -}}
{{- include "secrets-beam.selectorLabels" . }}
component.orbitops.dev: operator
{{- end }}

{{/*
Create the name of the operator service account to use
*/}}
{{- define "operator.serviceAccountName" -}}
{{- if .Values.operator.serviceAccount.create }}
{{- default (printf "%s-operator" (include "secrets-beam.fullname" .)) .Values.operator.serviceAccount.name }}
{{- else }}
{{- default .Values.operator.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Certificate generator labels
*/}}
{{- define "certificateGenerator.labels" -}}
{{- include "secrets-beam.labels" . }}
component.orbitops.dev: cert-gen
{{- end }}

{{- define "certificateGenerator.fullname" -}}
{{- printf "%s-certificate-generator" (include "secrets-beam.fullname" .) }}
{{- end }}

{{/*
Create the name of the cert-gen service account to use
*/}}
{{- define "certificateGenerator.serviceAccountName" -}}
{{- if .Values.certificateGenerator.serviceAccount.create }}
{{- default (printf "%s-cert-gen" (include "secrets-beam.fullname" .)) .Values.certificateGenerator.serviceAccount.name }}
{{- else }}
{{- default .Values.certificateGenerator.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the webhook to use
*/}}
{{- define "secrets-beam.webhookName" -}}
{{- if .Values.certificateGenerator.enabled }}
{{- (index .Values "webhook-cert-gen").webhook.name }}
{{- else }}
{{- printf "002-secrets.orbitops.dev" }}
{{- end }}
{{- end }}

{{- define "secrets-beam.serviceName" -}}
{{- if .Values.certificateGenerator.enabled }}
{{- (index .Values "webhook-cert-gen").webhook.service }}
{{- else }}
{{- include "secrets-beam.fullname" . }}
{{- end }}
{{- end }}