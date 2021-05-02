#! /usr/bin/env bash
echo "Building "
mkdir -p dist
cp -r css dist/
cp index.html dist/
echo "Deploying"
echo "Uploading to S3"
COMMIT_HASH=`git rev-parse --short=7 HEAD`
CF_DEV_ID='E22RDIT78RN1CE'
echo ${COMMIT_HASH}
aws s3 sync ./dist s3://ytamang-may-2/${COMMIT_HASH}

echo "Updating Cloudfront paths"
aws cloudfront get-distribution-config --id ${CF_DEV_ID} > dist.json
JQ_QUERY=".DistributionConfig.Origins.Items[0].OriginPath = \"/${COMMIT_HASH}\""
jq "$JQ_QUERY" < dist.json > updated.json

CFDIST_ETAG=$(jq -r '.ETag' < dist.json)
jq .DistributionConfig < updated.json > new-dist-config.json
echo $CFDIST_ETAG

aws cloudfront update-distribution --id ${CF_DEV_ID} --distribution-config file://new-dist-config.json --if-match ${CFDIST_ETAG}
rm -rf *.json
echo "All Done"
