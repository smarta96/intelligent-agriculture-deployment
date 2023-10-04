# Intelligent Agriculture Workshop Deployment


## Deploying the demo only

### 1. Create an OpenShift Cluster in RHPDS or use your own cluster

### 2. Deploy RHODS with the operator

- Look for a RHODS Operator in OperatorHub
- Install RHODS Operator

### 3. If on RHPDS, remove the LimitRanges of the rhods-notebooks project. You will have to do this again for any project created

- In Administrator view go to Administration -> LimitRanges

### 4. Deploy minio (from the minio folder), this will create the Deployment, Service and Route. Admin user and pass will be iademo123 / iademo123

- Copy login command
- Login to the Openshift cluster via the CLI
- Create a local folder called for example “intelligent agriculture”
- Set intelligent agriculture as a working directory
- Git clone https://github.com/guimou/intelligent-agriculture-deployment.git
- Navigate to minio folder
- List files inside the minio folder and vim minio.yaml
  Edit the value for MINIO_ROOT_USER and change it to iademo123 and edit the value for the MINIO_ROOT_PASSWORD to iademo123 (iademo123 is just an example)
- Check if services, deployments, and routes were created in the right project and namespace
  Go to Administrator view
  Click on Workloads, check Deployments, and look for minio with rhodes-notebooks namespace
  Click on Networking navigate to Routes and look for 
  Click on Storage and navigate to PersistentVolumeClaims to check if minio was created. 
- Go to Networking -> Routes -> s3 -> click on the Location link that will redirect you to minio
  Use the values defined above (user: iademo123 and password: iademo123) to log in to minio

### 5. In Minio, create access and secret keys (you can keep them simple), and a bucket called models. Apply the policy policy.json to this bucket.

- Go to Access Keys -> 
- Set the credentials:	
  Access Key -  iamdemo1234
  Secret Key - iademo_1234
- Navigate to Buckets and click “Create Bucket”
  Set the Bucket name as "models"
  In terminal cat policy.json copy the content of the file. 
  Click on the bucket and edit the Access Policy 
  Paste the policy.json content
  
### 6. In the bucket models create a new Path crops and upload the ONNX model from the model folder.

- Click “Browse Bucket” 
- Click Upload -> Upload a file -> Look for crops.nnx file. It takes a few min for the file to be uploaded.
  Import the Optapy custom image: quay.io/opendatahub-contrib/workbench-images:jupyter-optapy-ubi9-py39_2023b_latest

### 7. Go to RHODS

- Go to Settings -> Notebooks images
- Import an Optapy image: quay.io/opendatahub-contrib/workbench-images:jupyter-optapy-ubi9-py39_2023b_latest
  
### 8. In RHODS, create a Data Science Project

- Navigate to RHODS
- Go to Data Science Projects
- Create a new project with name: data-science-project
  
### 9. Create a Workbench using the OptaPy image

- In my case, the workbench was not starting, so I launched Jupiter app on Optapy image 
- In the Workbench, git clone the repo: https://github.com/rh-aiservices-bu/intelligent-agriculture-demo.git
- Within the workbench, in the workshop folder, you can show the different notebooks used to create this demo
  
### 10. In the DSP, create a Data Connection to the bucket created above. Access and Secret key should be what you create, the address should be http://s3.redhat-ods-applications.svc.cluster.local:9000/, and the bucket should be models. Adapt if you change anything.

- Name of the Data Connection: agriculture-connection
- Access Key -  iamdemo123, Secret Key - iademo_123
- http://s3.rhods-notebooks.svc.cluster.local:9000/
- AWS_S3_BUCKET: models
- Connected workbench: agriculture

### 11. Deploy a Model Server (small), and deploy the Model using the Data Connection. If you followed the instructions, the model should be in the crops folder.

- Model server name: crops
- Model name: crops
- Model servers: crops
- Model framework: onnx-1
- Folder path: /crops/crops.onnx
  
### 12. From the app-deployment folder, edit lines 33 and 35 of intelligent-agriculture-deployment.yaml, to set the pathservice and the classification endpoints. They should look like https://ia-pathservice-name_of_your_project.apps.cluster_address and https://ia-classification-name_of_your_project.apps.cluster_address. So what you have to modify here are the part name_of_your_project and cluster_address.

- Go to your terminal. Make sure you are logged in to your openshift cluster. If not, go to the openshift console and copy the login command.  
- Navigate to home/intelligent-agriculture-deployment/app-deployment/
- vim intelligent-agriculture-deployment.yaml
- Change lines 33 and 35 of the yaml.
  ‘Replace-me’ in the 33rd line - example - https://ia-pathservice-agriculture.apps.cluster-l6qgt.l6qgt.sandbox772.opentlc.com/
  ‘Replace-me’ in the 33rd line - example - https://ia-classification-agriculture.apps.cluster-l6qgt.l6qgt.sandbox772.opentlc.com/
- oc project agriculture - you need to be in the same namespace as your data science project
- oc apply -f intelligent-agriculture-deployment.yaml
  
### 13. The application will be accessible at https://ia-classification-name_of_your_project.apps.cluster_addres

- Go to this link and you should see your application running: https://ia-classification-agriculture.apps.cluster-l6qgt.l6qgt.sandbox772.opentlc.com/


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
