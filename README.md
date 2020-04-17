# pulumi-test

Experimenting with Pulumi for managing AWS infrastructure.


## Usage

Requirements and gotchas:

-  POSIX.
-  Docker.
-  Assumes AWS credentials will be gotten from the environment
   (e.g. https://github.com/otm/limes).
-  Assumes that a role called `Admin` exits in the current AWS account.
-  Assumes that you have enough AWS privileges to provision lots of stuff.
-  Defaults to AWS region `eu-west-1`.


First, create a CloudFormation stack that sets up a state bucket and a KMS key
for Pulumi:

```
make provision-pulumi-state-stack
```

Then use the scripts in `bin` to manage Pulumi stacks:

```
bin/pulumi-ts
bin/pulumi-ts projects/my-cool-project new
bin/pulumi-ts projects/my-cool-project up prod
bin/pulumi-ts projects/my-cool-project destroy prod
```


## Todo

-  Restrict stacks to specific accounts?
