# Intelligent Agriculture Workshop Deployment

## Deploying the demo only

- Create an OpenShift Cluster in RHPDS or use your own cluster
- Deploy RHODS with the operator
- If on RHPDS, remove the LimitRanges of the rhods-notebooks project. You will have to do this again for any project created
- Import the Optapy custom image: quay.io/opendatahub-contrib/workbench-images:jupyter-optapy-ubi9-py39_2023b_latest
- Deploy minio (from the minio folder), this will create the Deployment, Service and Route. Admin user and pass will be iademo / iademo
- In Minio, create access and secret keys (you can keep them simple), and a bucket called `models`. Apply the policy `policy.json` to this bucket.
- In the bucket `models` create a new Path `crops` and upload the ONNX model from the `model` folder.
- In RHODS, create a Data Science Project
- Create a Workbench using the OptaPy image
- In the Workbench, git clone the repo: https://github.com/rh-aiservices-bu/intelligent-agriculture-demo.git
- Within the workbench, in the `workshop` folder, you can show the different notebooks used to create this demo
- In the DSP, create a Data Connection to the bucket created above. Access and Secret key should be what you creates, address should be `http://s3.redhat-ods-applications.svc.cluster.local:9000/`, and the bucket should be `models`. Adapt if you changed anything.
- Deploy a Model Server (small), and deploy the Model using the Data Connection. If you followed the instructions, the model should be in the `crops` folder.
- From the `app-deployment` folder, edit lines 33 and 35 of `intelligent-agriculture-deployment.yaml`, to set the pathservice and the classification endpoints. They should look like `https://ia-pathservice-name_of_your_project.apps.cluster_address` and `https://ia-classification-name_of_your_project.apps.cluster_address`. So what you have to modify here are the part `name_of_your_project` and `cluster_address`.
- The application will be accessible at `https://ia-classification-name_of_your_project.apps.cluster_address`

## Deploying as a workshop

The process is mostly the same (deploy RHODS, Minio, upload model), except for some tweaks and further configuration.

After OpenShift deployment (RHPDS):

- From the `openshift-tweak` folder, replace the relevant parts of the Secret named `htpasswd-secret` that you find in the project `openshift-config` to create users. The password will be the same for everyone, `openshift`.
- Modify project templates (`oc edit-n openshift-config template/project-request`) to fully remove or set limit ranges properly

Other configuration:

- Deploy OpenShift Data Foundation and set default storage class to ocs-storagecluster-ceph-rbd. This will allow to create many PVCs for users without consuming much storage (thin provisioning).

After deploying RHODS

- Patch RHODS configuration with `odh-dashboard-config.yaml` from `rhopds-config` to set right TShirt sizes for Notebooks and Model Server.
- Import Optapy custom image: quay.io/opendatahub-contrib/workbench-images:jupyter-optapy-ubi9-py39_2023b_latest

Guide and user assignments:

- Deploy the Workshop Guide with the files in the folder `guide`
- Deploy files from the `username-distribution/redis` folder.
- In `username-distribution/usertool`, modify LAB_EXTRA_URLS (OpenShift Console) and LAB_MODULE_URLS (Guide) addresses. Adapt depending of your cluster name.
- Deploy `username-distribution/usertool`

Pre-Puller:

- Optionally, modify the different image names in the pre-puller and deploy it.
