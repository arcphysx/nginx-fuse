
# NGINX FUSE

A NGINX and Google Cloud Storage adapter using Docker and GCSFuse



## Usage/Examples

1. Create `credentials.json` file containing Service Account Credentials in JSON format

2. Build docker image from the Dockerfile
```bash
# You can replace "gcsfuse" below with any prefered tag name

docker build -t gcsfuse .
```

3. Run the Docker image
```bash
docker run -it --rm --privileged -p 8080:8080 -e BUCKET_NAME="some-bucket-name" gcsfuse
```

4. Access http://localhost:8080 and it should show the directory and file from your GCS bucket


## Authors

- [@arcphysx](https://github.com/arcphysx)


## FAQ

#### How to get Service Account Credentials?

[read here](https://cloud.google.com/storage/docs/gcsfuse-mount#authenticate_by_using_a_service_account)


#### Why we need `--privileged` attribute?
Read the discussion [here](https://github.com/docker/for-linux/issues/321#issuecomment-468659916)


#### Can we run GCS Fuse without privileges in K8s/GKE?
Found the possible solution [here](https://github.com/samos123/gke-gcs-fuse-unprivileged), but not tested yet