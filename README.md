# pulumi-test

Experimenting with Pulumi for managing AWS infrastructure.


## Usage

Requirements:

-  POSIX.
-  Docker.
-  Assumes AWS credentials will be gotten from the environment
   (e.g. https://github.com/otm/limes).


First, create a CloudFormation stack that sets up a state bucket and a KMS key
for Pulumi (assumes that a role called `Admin` exits in the account):

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

-  Restrict stacks to specific accounts.
