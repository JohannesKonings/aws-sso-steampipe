select
  account_id,
  _ctx ->> 'connection_name' as connection_name,
  runtime,
  count(*),
  SUM(COUNT(*)) OVER() AS total_count
from
  aws_all.aws_lambda_function
where runtime not in ('nodejs18.x', 'nodejs16.x', 'python3.9')
group by
  account_id,
  _ctx,
  runtime
order by
  connection_name,
  runtime,
  count;
  