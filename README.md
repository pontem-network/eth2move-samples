# e2m
Converts **solidity file** to **binary move** code. You can convert from **abi + bin** files or a **sol** file

> **! IMPORTANT**\
> To convert from a **sol** file, **solc** must be installed on the computer and accessible from the terminal using the short command **solc**.\
> To publish, you need the installed **aptos** utility and **e2m** build with the flag `--features=deploy`

## Install solc

How to install **solc**, [see the documentation](https://docs.soliditylang.org/en/develop/installing-solidity.html)

### Checking solc

The **solc** version must be at least **0.8.15**

```bash
solc --version
```
> **! IMPORTANT**\
> If this command is not available for execution from the terminal, e2m will not work.

## Install aptos

How to install **aptos**, [see the documentation](https://aptos.dev/cli-tools/aptos-cli-tool/install-aptos-cli)

### Checking aptos

The **aptos** version must be at least **0.3.3**

```bash
aptos --version
```

## Installation e2m
@todo

### See help:
```bash
e2m --help
```

#### Input parameters
* `<PATH>`              Path to the file. Specify the path to sol file or abi | bin
* `-o`, `--output`      Where to save the converted Move binary file
* `--module`            The name of the move module. If not specified, the name will be taken from the abi path
* `-p`, `--profile`     Profile name or address. The address must start with "0x". [default: default]
* `-d`, `--deploy`      Deploying the module in aptos node
* `-a`, `--args`        Parameters for initialization
* `-i`, `--interface_package`   Generate an interface project
* `--native_input`      Input params of native type
* `--native_output`     Output value of native type

## Example

> **! IMPORTANT**
> 
> Before running the examples, you will need to create a private key.
> It will be used both for the module address and for publishing on the node.
> 
> **Default profile:**
> 
> ```bash
> aptos init
> ```
> 
> Paste the received address into the file [**samples/sc_users/Move.toml**](https://github.com/pontem-network/eth2move-samples/blob/main/samples/sc_users/Move.toml)\
> `sc = "_"` replace the `_` character with the received address
> 
> **Demo profile:**
> ```bash
> aptos init --profile demo
> ```
> See more: [aptos init](https://aptos.dev/cli-tools/aptos-cli-tool/use-aptos-cli/#step-1-run-aptos-init)



### Module transformation and publication
This command we will make
* Converting a "sol" file to "mv"
* Generate an interface to use in source. The `./i_users/` folder will appear in the current directory 
* Module will support "move" types
* We will publish the generated module from the "default" profile

```bash
e2m ./samples/users.sol \
   -o ./i_users \
   -a self \
   --native_input \
   --native_output \
   -i \
   -d
```

### Publishing a script
Publishing a script for interacting with the module

> **Important** don't forget to replace the address

```bash
aptos move publish \
  --package-dir ./samples/sc_users \
  --max-gas 1000
```

### Calling the module constructor. 
Calling the module constructor to assign the current account as the owner

```bash
aptos move run \
   --function-id default::ScUser::constructor \
   --max-gas 1000
```

### Adding a "demo" account
```bash
aptos move run \
   --function-id default::ScUser::create_user \
   --max-gas 1000 \
   --profile demo
```

### ID verification
account "default": id = 1
```bash
aptos move run \
  --function-id default::ScUser::is_id \
  --args u128:1 \ 
  --max-gas 1000
```

account "demo": id = 2
```bash
aptos move run \
  --function-id default::ScUser::is_id \
  --args u128:2 \
  --max-gas 1000 \
  --profile demo
```

### Checking whether this account is the owner:
```bash
aptos move run \
   --function-id default::ScUser::is_owner \
   --max-gas 1000
```
An **error** will occur when checking from another account
```bash
aptos move run \
   --function-id default::ScUser::is_owner \
   --max-gas 1000 \
   --profile demo
```

### Checking the balance
account "default": 10000000000000000000000000000
```bash
aptos move run \
  --function-id default::ScUser::is_balance \
  --args u128:10000000000000000000000000000 \
  --max-gas 1000
```

account "demo": 0
```bash
aptos move run \
  --function-id default::ScUser::is_empty_balance \
  --max-gas 1000 \
  --profile demo
```

### Transfer
Sending 200 coins from "default" to "demo"
```bash
aptos move run \
  --function-id default::ScUser::transfer \
  --args address:demo u128:200 \
  --max-gas 1000
```

#### Checking the transfer
Account **default**
```bash
aptos move run \
  --function-id default::ScUser::is_balance \
  --args u128:9999999999999999999999999800 \
  --max-gas 1000
```

Account **demo**
```bash
aptos move run \
  --function-id default::ScUser::is_balance \
  --args u128:200 \
  --max-gas 1000 \
  --profile demo
```

