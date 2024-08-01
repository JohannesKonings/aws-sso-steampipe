# aws-sso-steampipe

`docker build -t steampipe-query steampipe`

```bash
docker run --entrypoint /bin/bash -it \
--mount type=bind,source="${PWD}/steampipe/queries",target=/workspace/queries \
--mount type=bind,source="${PWD}/steampipe/scripts",target=/workspace/scripts \
--mount type=bind,source="${PWD}/.env",target=/workspace/.env \
--name steampipe-query \
steampipe-query 
```

`docker start -a steampipe-query`

`docker exec -it steampipe-query /bin/bash`

`aws sso login --sso-session $SSO_SESSION_NAME`

`steampipe query steampipe/queries/lambda-runtime.sql`
