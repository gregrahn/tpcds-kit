## Download and install Snowflake Client
  * Visit the docs https://docs.snowflake.com/en/user-guide/snowsql.html

```bash
curl -O https://sfc-repo.snowflakecomputing.com/snowsql/bootstrap/1.2/linux_x86_64/snowsql-1.2.5-linux_x86_64.bash
chmod +x snowsql-1.2.5-linux_x86_64.bash
./snowsql-1.2.5-linux_x86_64.bash
```
  * snowsql-1.2.5-linux_x86_64.bash

## Configure the Snowflake Client
  * refer to the included file snowsql.cfg

## Example Script configuration
  * NOTE: the Snowflake example, also uses similar values from config.sh.
  * BOTH config.sh and snowsql.cfg must be edited and align
  * The Database and Schema provided in snowsql.cfg and config.sh is assumed to have already been created
  
## Other resources
  * https://docs.snowflake.net/manuals/user-guide/data-load-internal-tutorial.html
  * https://docs.snowflake.net/manuals/user-guide/data-load-considerations-prepare.html 
 