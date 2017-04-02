S3_BUCKET = _YOUR_S3_BUCKET_
STACK_NAME = aws-sam-plugin-dead-letter-queue-demo

package:
	@[ -d .sam ] || mkdir .sam
	@aws s3 cp src/plugins/aws-sam-plugin-dead-letter-queue/template.yml s3://$(S3_BUCKET)
	@aws cloudformation package \
		--template-file sam.yml \
		--s3-bucket $(S3_BUCKET) \
		--s3-prefix $(STACK_NAME)/`date '+%Y%m%d'` \
		--output-template-file .sam/packaged.yml

deploy:
	@aws cloudformation deploy \
		--template-file .sam/packaged.yml \
		--stack-name $(STACK_NAME) \
		--capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM \
		--parameter-overrides ArtifactBucket=$(S3_BUCKET)

all: package deploy

.PHONY: package deploy all
