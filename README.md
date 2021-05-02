### Simple Frontend deployment using S3 and Cloudformation
### `ci.sh` as a CI/CD mimic with two stages: build and deploy
- build phase creates **dist** directory and puts static contents there.
- Deploy stage copies files to s3, updates cloudfront distribution to point to latest copies of static contents
### Make sure you have proper `CF_DEV_ID` (Cloudfront ID)
### Cloudfront takes some time to distribute your files
