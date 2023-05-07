# Intelligent Agriculture Workshop Deployment

- Create OpenShift Cluster from RHPDS
- From OpenShift tweak folder, replace htpasswd-secret to create users
- Deploy ODF
- Set default storage class to ocs-storagecluster-ceph-rbd
- Deploy RHODS
- Patch RHODS configuration
- Import Optapy custom image: quay.io/opendatahub-contrib/workbench-images:jupyter-optapy-ubi9-py39_2023b_latest
- Deploy minio, and create double service name
- Upload ONNX model to S3, create access and secret keys
- Deploy guide
- Deploy username-distribution/redis
- In username-distribution/usertool, modify LAB_EXTRA_URLS (OpenShift Console) and LAB_MODULE_URLS (Guide) addresses
- Deploy username-distribution/usertool
- Modify Optapy custom image address in pre-puller and deploy pre-puller
