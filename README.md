# aws-sso-steampipe

`docker build -t steampipe-query .`

```bash
docker run --entrypoint /bin/bash -it \
--mount type=bind,source="${PWD}/queries",target=/workspace/queries \
--mount type=bind,source="${PWD}/scripts",target=/workspace/scripts \
--mount type=bind,source="${PWD}/.env",target=/workspace/.env \
--name steampipe-query \
steampipe-query 
```

`docker start -a steampipe-query`

`docker exec -it steampipe-query /bin/bash`

`aws configure sso`

`aws sso login --sso-session $SSO_SESSION_NAME`