select
  account_id,
  _ctx ->> 'connection_name' as connection_name,
  vpc_endpoint_id,
  service_name,
  vpc_id,
  tags ->> 'delete-vpc-endpoint' as delete_vpc_endpoint_tag
from
  aws_all.aws_vpc_endpoint
where
  vpc_endpoint_type = 'Interface'
order by
  connection_name,
  vpc_endpoint_id;
