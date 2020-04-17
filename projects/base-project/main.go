package main

import (
	"github.com/pulumi/pulumi-aws/sdk/go/aws/s3"
	"github.com/pulumi/pulumi/sdk/go/pulumi"
	"github.com/pulumi/pulumi/sdk/go/pulumi/config"
)

func main() {
	pulumi.Run(func(ctx *pulumi.Context) error {
		conf := config.New(ctx, "")

		bucket, err := s3.NewBucket(ctx, conf.Require("bucket_name"), nil)
		if err != nil {
			return err
		}

		ctx.Export("baseBucketName", bucket.ID())

		return nil
	})
}
