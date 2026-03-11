# Kubernetes User Creation using CSR

This guide explains how to create a **new Kubernetes user using a Certificate Signing Request (CSR)** and configure access using `kubectl`.

---

# 1. Generate a Private Key

Create a private key for the user.

```bash
openssl genrsa -out abdelhamed.key 2048
```

---

# 2. Generate the CSR (Certificate Signing Request)

The **Common Name (CN)** will be used as the Kubernetes username.

```bash
openssl req -new -key abdelhamed.key -out abdelhamed.csr -subj "/CN=abdelhamed"
```

Verify the CSR file:

```bash
ls
cat abdelhamed.csr
```

---

# 3. Encode CSR to Base64

Kubernetes requires the CSR to be **base64 encoded without newlines**.

```bash
cat abdelhamed.csr | base64 | tr -d "\n"
```

Copy the output because it will be used inside the CSR YAML file.

---

# 4. Create the CSR YAML File

Create a file named `csr.yaml`.

```bash
vim csr.yaml
```

Example content:

```yaml
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: abdelhamed
spec:
  request: <BASE64_CSR>
  signerName: kubernetes.io/kube-apiserver-client
  usages:
  - client auth
```

Replace `<BASE64_CSR>` with the encoded CSR from the previous step.

---

# 5. Create the CSR in Kubernetes

```bash
kubectl create -f csr.yaml
```

Check CSR status:

```bash
kubectl get csr
```

View details:

```bash
kubectl get csr -o yaml
```

---

# 6. Approve the CSR

Approve the certificate request.

```bash
kubectl certificate approve abdelhamed
```

Verify approval:

```bash
kubectl get csr
```

---

# 7. Retrieve the Signed Certificate

Extract the signed certificate from the CSR resource.

```bash
kubectl get csr abdelhamed -o jsonpath='{.status.certificate}' > cert
```

Decode it:

```bash
cat cert | base64 --decode > abdelhamed.crt
```

Verify the certificate:

```bash
cat abdelhamed.crt
```

---

# 8. Configure Credentials in kubeconfig

Add the user credentials to kubeconfig.

```bash
kubectl config set-credentials abdelhamed \
--client-key=/root/abdelhamed.key \
--client-certificate=/root/abdelhamed.crt \
--embed-certs=true
```

---

# 9. Create a Context for the User

Associate the user with the cluster.

```bash
kubectl config set-context abdelhamed \
--cluster=kubernetes \
--user=abdelhamed
```

Check kubeconfig:

```bash
kubectl config view
```

List contexts:

```bash
kubectl config get-contexts
```

---

# 10. Test Access

Test the user access:

```bash
kubectl get pods --context abdelhamed
```

Other examples:

```bash
kubectl get pods --context dolfiend
kubectl get pods --context kubernetes-admin@kubernetes
```

---

# 11. Optional: Grant RBAC Permissions

The user will not have permissions unless RBAC is configured.

Example:

```bash
kubectl create rolebinding abdelhamed-view \
--clusterrole=view \
--user=abdelhamed \
--namespace=default
```

---

# Summary

This process:

1. Generates a private key
2. Creates a CSR
3. Sends CSR to Kubernetes
4. Approves the request
5. Retrieves the signed certificate
6. Configures kubeconfig credentials
7. Creates a context for the user

The user can now authenticate to the cluster.

---
