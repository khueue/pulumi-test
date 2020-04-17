package helpers

import (
	"fmt"

	// Just to test imports.
	_ "github.com/pulumi/pulumi-aws/sdk/go/aws/alb"
)

func PrintStuff(x interface{}) {
	fmt.Println(x)
}
