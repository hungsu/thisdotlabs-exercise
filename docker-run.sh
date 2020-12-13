docker run -d \
    --name=thisdotlabs  \
    --restart=always \
    -v '/opt/nginx/thisdotlabs:/usr/share/nginx/html:ro'  \
    --label com.github.cloudbox.cloudbox_managed=true \
    --network=cloudbox  \
    --network-alias=thisdotlabs  \
    -e 'VIRTUAL_HOST=thisdotlabs.hung.su'  \
    -e 'VIRTUAL_PORT=80'  \
    -e 'LETSENCRYPT_HOST=thisdotlabs.hung.su'  \
    -e 'LETSENCRYPT_EMAIL=hungsu.nguyen@gmail.com'  \
    nginx
