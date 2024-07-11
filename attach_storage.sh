INSTANCE_GROUP=$(curl -fs http://metadata.google.internal/computeMetadata/v1/instance/attributes/igroup -H Metadata-Flavor:Google | cut -d . -f1)
CURRENT_BUCKET=$(curl -fs http://metadata.google.internal/computeMetadata/v1/project/attributes/PRIMARY_STORAGE_NAME -H "Metadata-Flavor: Google")

sudo tee /etc/yum.repos.d/gcsfuse.repo > /dev/null <<EOF
[gcsfuse]
name=gcsfuse (packages.cloud.google.com)
baseurl=https://packages.cloud.google.com/yum/repos/gcsfuse-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
      https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF


sudo yum -y install gcsfuse
sudo mkdir /srv/shared 2>/dev/null
sudo chmod a+w /srv/shared 2>/dev/null

# for mounting a particular directory
sudo gcsfuse --dir-mode 755 --file-mode 755  -o allow_other --implicit-dirs --only-dir $INSTANCE_GROUP  $CURRENT_BUCKET /srv/shared 2>/dev/null

# for all folders in the bucket
# sudo gcsfuse --dir-mode 755 --file-mode 755  -o allow_other   $CURRENT_BUCKET /srv/shared 2>/dev/null
