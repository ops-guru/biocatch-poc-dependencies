{{- define "base-templates.rbac" -}}
apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ include "base-templates.fullname" . }}
  namespace: {{ include "base-templates.fullname" . }}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: {{ include "base-templates.fullname" . }}
  namespace: {{ include "base-templates.fullname" . }}
rules:
- apiGroups: ["sparkoperator.k8s.io"]
  resources: ["sparkapplications", "sparkapplications/status", "scheduledsparkapplications", "scheduledsparkapplications/status"]
  verbs: ["*"]
- apiGroups: [""]
  resources:
  - services
  - configmaps
  - ingresses
  - serviceaccounts
  verbs:
  - create
  - get
  - list
  - delete
  - patch
- apiGroups: [""]
  resources:
    - secrets
  verbs:
    - create
    - get
    - list
    - delete
    - update
    - patch
- apiGroups: [""]
  resources:
    - pods
  verbs: ["get", "watch", "list", "create", "delete", "patch"]
- apiGroups: ["rbac.authorization.k8s.io"]
  resources:
  - clusterroles
  - roles
  - rolebindings
  - clusterrolebindings
  verbs:
  - create
  - get
  - list
  - delete
  - patch
- apiGroups: ["extensions", "networking.k8s.io"]
  resources:
  - ingresses
  verbs:
  - create
  - get
  - list
  - delete
  - patch
- apiGroups: [""]
  resources: ["pods/log"]
  verbs: ["get"]
- apiGroups: [""]
  resources: ["pods/exec"]
  verbs: ["create"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: {{ include "base-templates.fullname" . }}
  namespace: {{ include "base-templates.fullname" . }}
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: {{ include "base-templates.fullname" . }}
subjects:
- kind: ServiceAccount
  name: {{ include "base-templates.fullname" . }}
  namespace: {{ include "base-templates.fullname" . }}
{{- end -}}