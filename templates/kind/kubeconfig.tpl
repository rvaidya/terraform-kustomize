apiVersion: v1
clusters:
- cluster:
    server: https://${cluster_endpoint}
    certificate-authority-data: ${cluster_ca}
  name: ${cluster_name}
contexts:
- context:
    cluster: ${cluster_name}
    user: admin@${cluster_name}
  name: ${cluster_name}
current-context: ${cluster_name}
kind: Config
preferences: {}
users:
- name: admin@${cluster_name}
  user:
    client-certificate-data: ${client-certificate-data}
    client-key-data: ${client-key-data}
