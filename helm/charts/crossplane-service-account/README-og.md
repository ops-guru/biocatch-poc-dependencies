# OpsGuru Crossplane

**Known issues:**
Issue with CRDs and cluster freeze (https://github.com/crossplane/crossplane/issues/3754, https://github.com/crossplane/docs/issues/336, https://github.com/crossplane/crossplane/issues/2869). To resovle this issue, use provider-gcp from crossplane-contrib and use a workaround with K8s Job iam binding.

Current version of Helm Chart allows provider choice with the parameter `provider: ""` (upbound / crossplane)