{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "kscp.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kscp.fullname" -}}
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
{{- define "kscp.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "webhook.fullname" -}}
{{- printf "%s-webhook" (include "kscp.fullname" .) }}
{{- end }}

{{- define "certificateGenerator.fullname" -}}
{{- printf "%s-certificate-generator" (include "kscp.fullname" .) }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "kscp.labels" -}}
helm.sh/chart: {{ include "kscp.chart" . }}
{{ include "kscp.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Common selector labels
*/}}
{{- define "kscp.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kscp.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}


{{/*
webhook labels
*/}}
{{- define "webhook.labels" -}}
{{- include "kscp.labels" . }}
component.kscp.io: webhook
{{- end }}

{{/*
Certificate generator labels
*/}}
{{- define "certificateGenerator.labels" -}}
{{- include "kscp.labels" . }}
component.kscp.io: cert-gen
{{- end }}

{{/*
webhook selector labels
*/}}
{{- define "webhook.selectorLabels" -}}
{{- include "kscp.selectorLabels" . }}
component.kscp.io: webhook
{{- end }}


{{/*
Create the name of the webhook service account to use
*/}}
{{- define "webhook.serviceAccountName" -}}
{{- if .Values.webhook.serviceAccount.create }}
{{- default (printf "%s-webhook" (include "kscp.fullname" .)) .Values.webhook.serviceAccount.name }}
{{- else }}
{{- default (printf "%s-webhook" (include "kscp.fullname" .)) .Values.webhook.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the cert-gen service account to use
*/}}
{{- define "certificateGenerator.serviceAccountName" -}}
{{- if .Values.certificateGenerator.serviceAccount.create }}
{{- default (printf "%s-cert-gen" (include "kscp.fullname" .)) .Values.certificateGenerator.serviceAccount.name }}
{{- else }}
{{- default (printf "%s-cert-gen" (include "kscp.fullname" .)) .Values.certificateGenerator.serviceAccount.name }}
{{- end }}
{{- end }}
