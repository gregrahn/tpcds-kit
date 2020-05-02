## NOTE
  * Query fixes for Redshift remain incomplete
  * Some queries will fail where it cotains, 'group by rollup'

## AWS Pre-Requisites 
  
  * AWS CLI
       https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html
  
  * AWS CLI Configuration
       https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html
  
  * IAM Role to access S3 (add to config.sh 'iamrole')
       https://docs.aws.amazon.com/redshift/latest/mgmt/authorizing-redshift-service.html
       
  * Trust relationship with IAM role and the redshift cluster & dbuser
       https://docs.aws.amazon.com/IAM/latest/UserGuide/roles-managingrole-editing-console.html
  * S3 Bucket (add to config.sh 'S3Landing')
  
## Additional resources

  * S3 cp 
     https://docs.aws.amazon.com/cli/latest/reference/s3/cp.html

