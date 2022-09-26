# e2m
Converts **solidity file** to **binary move** code. You can convert from **abi + bin** files or a **sol** file 

[Feature list](feature-list.md)

> **! IMPORTANT**\
> To convert from a **sol** file, **solc** must be installed on the computer and accessible from the terminal using the short command **solc**.\
> To publish, you need the installed **aptos** utility

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

## Download e2m
[Download link for the latest version of e2m](https://github.com/pontem-network/eth2move-samples/releases) \
Unpack the archive and place the executable file in a place convenient for you. For convenience, create an alias **e2m** in the system for this file.
> **! IMPORTANT**
> In all examples, e2m will be called via an alias


### Convert. See help:
```bash
e2m convert --help
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
* `--u128_io`           Use u128 instead of u256

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


### Native types

#### Module transformation and publication
This command we will make
* Converting a [./samples/users.sol](https://github.com/pontem-network/eth2move-samples/blob/main/samples/users.sol) file to "mv"
* Generate an interface to use in source. The `./i_users/` folder will appear in the current directory 
* Module will support "move" types
* We will publish the generated module from the "default" profile


```bash
e2m convert ./samples/users.sol \
   -o ./i_users \
   -a self \
   --native_input \
   --native_output \
   -i \
   -d
```

#### Publishing a script
Publishing a [script](https://github.com/pontem-network/eth2move-samples/tree/main/samples/sc_users) for interacting with the module

> **Important** don't forget to replace the address

```bash
aptos move publish \
  --package-dir ./samples/sc_users \
  --max-gas 1000
```

#### Calling the module constructor. 
Calling the module constructor to assign the current account as the owner

```bash
aptos move run \
   --function-id default::ScUser::constructor \
   --max-gas 1000
```

#### Adding a "demo" account
```bash
aptos move run \
   --function-id default::ScUser::create_user \
   --max-gas 1000 \
   --profile demo
```

#### ID verification
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

#### Checking whether this account is the owner:
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

#### Checking the balance
account "default": 10000000000000000000000000000
```bash
aptos move run \
  --function-id default::ScUser::check_balance \
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

#### Transfer
Sending 200 coins from "default" to "demo"
```bash
aptos move run \
  --function-id default::ScUser::transfer \
  --args address:demo u128:200 \
  --max-gas 1000
```

##### Checking the transfer
Account **default**
```bash
aptos move run \
  --function-id default::ScUser::check_balance \
  --args u128:9999999999999999999999999800 \
  --max-gas 1000
```

Account **demo**
```bash
aptos move run \
  --function-id default::ScUser::check_balance \
  --args u128:200 \
  --max-gas 1000 \
  --profile demo
```

### Ethereum Type

#### Call. See help:
```bash
e2m call --help
```
##### Input parameters
* `-p`, `--profile`     Profile name or address. The address must start with "0x". [default: default]
* `-a`, `--args`        Arguments combined with their type separated by spaces. Supported types \ 
                        **[u8, u64, u128, bool, hex, string, address, raw]** \
                        Example: \
                        address:0x1 bool:true u8:0
* `-f`, `--function-id` Function name as `<ADDRESS>::<MODULE_ID>::<FUNCTION_NAME>` \
                        Example: \
                        0x02::message::set_message \
                        default::message::set_message
* `--max-gas`           Maximum amount of gas units to be used to send this transaction
* `--sandbox`           Display only. The request will not be sent to the aptos node


#### Module transformation and publication
This command we will make
* Converting a [./samples/users.sol](https://github.com/pontem-network/eth2move-samples/blob/main/samples/users.sol) file to "mv"
* Generate an interface to use in source. The `./i_users_ethtypes/` folder will appear in the current directory
* We will publish the generated module from the "default" profile


```bash
e2m convert ./samples/users.sol \
   -o ./i_users_ethtypes \
   -a self \
   -i \
   --max-gas 10000 \
   -d
```

#### Publishing a script
Publishing a [script](https://github.com/pontem-network/eth2move-samples/tree/main/samples/sc_users) for interacting with the module

> **Important** don't forget to replace the address

```bash
aptos move publish \
  --package-dir ./samples/sc_users_ethtypes \
  --max-gas 2000 \
  --assume-yes
```

#### Calling the module constructor.
Calling the module constructor to assign the current account as the owner

```bash
e2m call \
   --function-id default::ScUserEth::constructor \
   --max-gas 2000
```

#### Adding a "demo" account
```bash
e2m call \
   --function-id default::ScUserEth::create_user \
   --max-gas 2000 \
   --profile demo
```

#### ID verification
account "default": id = 1
```bash
e2m call \
  --function-id default::ScUserEth::is_id \
  --args u128:1 \
  --max-gas 2000 \
  --encode
```

account "demo": id = 2
```bash
e2m call \
  --function-id default::ScUserEth::is_id \
  --args u128:2 \
  --max-gas 1000 \
  --profile demo \
  --encode
```

#### Checking whether this account is the owner:
```bash
e2m call \
   --function-id default::ScUserEth::is_owner \
   --max-gas 1000
```
An **error** will occur when checking from another account
```bash
e2m call \
   --function-id default::ScUserEth::is_owner \
   --max-gas 1000 \
   --profile demo
```

#### Checking the balance
account "default": 10000000000000000000000000000
```bash
e2m call \
  --function-id default::ScUserEth::check_balance \
  --args u128:10000000000000000000000000000 \
  --max-gas 1000 \
  --encode
```

account "demo": 0
```bash
e2m call \
  --function-id default::ScUserEth::is_empty_balance \
  --max-gas 1000 \
  --profile demo
```

#### Transfer
Sending 200 coins from "default" to "demo"
```bash
e2m call \
  --function-id default::ScUserEth::transfer \
  --args address:demo u128:200 \
  --max-gas 2000 \
  --encode
```

##### Checking the transfer
Account **default**
```bash
e2m call \
  --function-id default::ScUserEth::check_balance \
  --args u128:9999999999999999999999999800 \
  --max-gas 1000 \
  --encode
```

Account **demo**
```bash
e2m call \
  --function-id default::ScUserEth::check_balance \
  --args u128:200 \
  --max-gas 1000 \
  --profile demo \
  --encode
```

