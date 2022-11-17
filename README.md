# eth2move

EVM to Move static bytecode translator.

# e2m

Converts **solidity file** to **binary move** code. You can convert from **abi + bin** files or a **sol** file

> **! IMPORTANT**\
> To convert from a **sol** file, **solc** must be installed on the computer and accessible from the terminal using the
> short command **solc**.\

## Install solc

How to install **solc**, [see the documentation](https://docs.soliditylang.org/en/develop/installing-solidity.html)

## Checking solc

The **solc** version must be at least **0.8.15**

```bash
solc --version
```

> **! IMPORTANT**\
> If this command is not available for execution from the terminal, e2m will not work.

## Install aptos

How to install **aptos**, [see the documentation](https://aptos.dev/cli-tools/aptos-cli-tool/install-aptos-cli)

## Checking aptos

The **aptos** version must be at least **1.0.0**

```bash
aptos --version
```

## Download e2m

[Download link for the latest version of e2m](https://github.com/pontem-network/eth2move-samples/releases) \
Unpack the archive and place the executable file in a place convenient for you. For convenience, create an alias **e2m**
in the system for this file.
> **! IMPORTANT**
> In all examples, e2m will be called via an alias


> **! IMPORTANT**
>
> **Creating an account "default" and "demo"**
> Before running the examples, you will need to create a private key.
> It will be used both for the module address and for publishing on the node.
>
> Default profile:
> ```bash
> aptos init
> ```
> Demo profile:
> ```bash
> aptos init --profile demo
> ```
> See more: [aptos init](https://aptos.dev/cli-tools/aptos-cli-tool/use-aptos-cli/#step-1-run-aptos-init)
>
>
> **Replenishment of the balance in "devnet"**
>
> Default profile:
> ```bash
> aptos account fund-with-faucet --amount 10000000
> ```
> Demo profile:
> ```bash
> aptos account fund-with-faucet --account demo --amount 10000000 --profile demo
> ```
>
> See more: [aptos account](https://aptos.dev/cli-tools/aptos-cli-tool/use-aptos-cli/#fund-an-account-with-the-faucet)

### See help:

```bash
e2m --help
```

#### Subcommands

* `convert`    Converting a sol script to move binary code
* `call`       Run a Move function
* `resources`  Command to list resources, modules, or other items owned by an address

## Convert

```bash
e2m convert --help
```

### Input parameters

* `<PATH>`              Path to the file. Specify the path to sol file or abi | bin
* `-o`, `--output`      Where to save the converted Move binary file
* `--module`            The name of the move module. If not specified, the name will be taken from the abi path
* `-p`, `--profile`     Profile name or address. The address must start with "0x". [default: default]
* `-a`, `--args`        Parameters for initialization
* `--native-input`      Input params of native type
* `--native-output`     Output value of native type
* `--u128_io`           Use u128 instead of u256
* `-d`, `--deploy`      Deploying the module in aptos node
* `--max-gas`           Maximum amount of gas units to be used to send this transaction

### Example

You can find the files from the examples in
the ./examples folder

#### Required parameters

Required parameters are the paths to sol file (`<PATH>`).\
The file can be extensions:

* `sol` - The file will be compiled using the solc utility. The resulting **abi** and **bin** will be translated into **
  move binarycode**
* `bin` - It is expected that there is an `abi` file with the same name in the same folder. These **abi** and **bin**
  will be translated into **move binarycode**
* `abi` - It is expected that there is an `bin` file with the same name in the same folder. These **abi** and **bin**
  will be translated into **move binarycode**

The name from the passed **solidity library** will be used as the filename and the name of the **move module**.\
After executing the command, you will see the path to the created directory (Example: "./NameSolModule/").
The directory will contain the **interface** for interacting with the module, the **abi** and the **move binarycode**
file.
By default, the directory is saved to the current directory.

#### examples/a_plus_b.sol

```bash
e2m convert examples/a_plus_b.sol
```

##### Result:

> Saved in the "./APlusB"

Move module address: **Address from the "default" profile**\
Move module name: **APlusB**

#### examples/APlusB.abi

```bash
e2m convert examples/APlusB.abi
```

##### Result:

> Saved in "./APlusB.mv"

Move module address: **Address from the "default" profile**\
Move module name: **APlusB**

#### examples/APlusB.bin

```bash
e2m convert examples/APlusB.bin
```

##### Result:

> Saved in "./APlusB.mv"

Move module address: **Address from the "default" profile**\
Move module name: **APlusB**

#### ! Fail: examples/BinNotFound.abi

```bash
e2m convert examples/BinNotFound.abi
```

##### Result:

> Error: Couldn't find bin.
> Path:"examples/BinNotFound.bin"

> **! IMPORTANT**\
> A successful broadcast always requires a **bin** and an **abi** **solidity library**

### Path to save

The `-o`, `--output` parameter is responsible for specifying the location of the directory where the result will be
saved.

#### examples/const_fn.sol

```bash
e2m convert examples/const_fn.sol -o ./Test
```

##### Result:

> Saved in "./Test"

The move binary file will be created in the directory named **./Test/ConstFn.mv**\
Move module address: **Address from the "default" profile** \
Move module name: **ConstFn**

#### examples/APlusB.bin

```bash
e2m convert examples/APlusB.bin -o ./AB
```

##### Result:

> Saved in "./AB"

Move module address: **Address from the "default" profile** \
Move module name: **APlusB**

#### Explicit indication of the module name in the received move bytecode

The `--module` argument is responsible for explicitly specifying the move module name.

##### examples/APlusB.abi

```bash
e2m convert examples/APlusB.abi --module ApB
```

##### Result:

> Saved in "./ApB"

Move module address: **Address from the "default" profile** \
Move module name: **ApB**

#### examples/two_functions.sol

```bash
e2m convert examples/two_functions.sol --module TF
```

##### Result:

> Saved in "./TF"

Move module address: **Address from the "default" profile** \
Move module name: **TF**

### Explicit indication of the module address in the received move bytecode

The argument `-p`, `--profile` is responsible for explicitly specifying the address of the transfer module or the name
of the profile from which the address will be taken.
If the parameter value starts with **"0x"**, then it will be taken as an address, everything else will be considered
the **profile name**.\
Profile data will be taken from **.aptos/config.yaml**

#### examples/const_fn.sol

```bash
e2m convert examples/const_fn.sol -p 0x3
```

##### Result:

> Saved in "./ConstFn"

Move module address: **0x3** \
Move module name: **ConstFn**

#### examples/two_functions.sol

```bash
e2m convert examples/two_functions.sol --profile demo
```

##### Result:

> Saved in "./TwoFunctions"

Move module address: **Address from the "demo" profile** \
Move module name: **TwoFunctions**

#### Combined arguments

```bash
 e2m convert examples/const_fn.sol -o ./MyMove --module DemoName --profile 0x3 
```

###### Result:

> Saved in "./MyMove"

Move module address: **0x3** \
Move module name: **DemoName**

### Convert and publish the module

In order for the module to be published on the aptos node after conversion, use the `-d`, `--deploy` flag.\
After successful publication, you will receive complete information in json format about the completed process.

> **! IMPORTANT**\
> When you try to re-publish the module, you will see the message "DUPLICATE_MODULE_NAME"

#### examples/two_functions.sol

```bash
e2m convert examples/two_functions.sol -d --max-gas 20000 
```

#### examples/APlusB.abi

```bash
e2m convert examples/APlusB.abi -o ./module --profile demo --deploy --max-gas 20000
```

### Generate an interface project

#### examples/APlusB.abi

```bash
e2m convert examples/a_plus_b.sol \
    -o ./aplusb
```

A "move" project will be created in the current directory. This interface is necessary for accessing the published
module.

### Native types. examples/APlusB.abi

By default, the module uses "Ethereum" types for data input and output.
`--native-input`, `--native-output` - by setting these flags, the functions in the module will use the "move" types as
input and output parameters.
`--u128-io` - Use u128 instead of u256

#### U256

```bash
e2m convert examples/a_plus_b.sol \
    --native-input \
    --native-output
```

#### U128

```bash
e2m convert examples/a_plus_b.sol \
    --native-input \
    --native-output \
    --u128-io
```

## Call.

See help:

```bash
e2m call --help
```

### Input parameters

* `-f`, `--function-id` Function name as `<ADDRESS>::<MODULE_ID>::<FUNCTION_NAME>` \
* `-a`, `--args`        Arguments combined with their type separated by spaces. Supported types \
  **[u8, u64, u128, bool, hex, string, address, raw]** \
  Example: \
  address:0x1 bool:true u8:0
  Example: \
  0x02::message::set_message \
  default::message::set_message
* `--init-args`         Parameters for initialization. Required if a sol file is specified in the path

* `--native-type`       Use native "move" types for input and output values
* `--how`               Default: node

  `node` - Call a remote contract on a node

  `local` - Call a remote contract locally and display the return value

  `local-source` - Call a local contract with remote resources and display the return value

  `vm` - Call a local contract and display the return value
* `--path`              Path to converted project or sol file
* `-p`, `--profile`     Profile name or address. The address must start with "0x". [default: default]
* `--max-gas`           Maximum amount of gas units to be used to send this transaction

## Resources.

See help:

```bash
e2m resources --help
```

### Input parameters

* `--query`                Type of items to list: [balance, resources, modules, resource, events]
  [default: resources]
* `--decode-types`         Types for decoding. Used for decoding EVENTS
* `-r`, `--resource-path`  Query `<ADDRESS>::<MODULE_ID>::<FUNCTION_NAME>(::<FIELD_NAME>)?`

  Example:
  Resource: `default::ModuleName::StuctureName` \
  List of Events: `default::ModuleName::StuctureName::field_name`
* `--abi`                  Path to abi for decoding events
* `--limit`                Max number of events to retrieve [default: 10]
* `--start`                Starting sequence number of events [default: 0]
* `--url`                  URL to a fullnode on the network
* `--connection-timeout-s` Connection timeout in seconds, used for the REST endpoint of the fullnode [default: 30]
* `--account`              Address of the account you want to list resources/modules for
* `--profile`              Profile to use from the CLI config
  This will be used to override associated settings such as the REST URL, the Faucet URL,
  and the private key arguments.

  Defaults to "default"

  Defaults to <https://fullnode.devnet.aptoslabs.com/v1>

### Example with Native types

#### Module transformation and publication

This command we will make

* Converting a ./examples/users.sol file
  to "mv"
* Generate an interface to use in source. The `./examples/i_users_native/` folder will appear in the current directory
* Module will support "move" types
* We will publish the generated module from the "default" profile

```bash
e2m convert ./examples/users.sol \
   -o ./examples/i_users_native \
   --module UsersNative \
   -a self \
   --native-input \
   --native-output \
   --max-gas 25000 \
   -d
```

#### Publishing a script

Publishing a ./examples/sc_users_native for interacting with the
module

> **Important** don't forget to replace the address

```bash
aptos move publish \
  --package-dir ./examples/sc_users_native \
  --max-gas 10000 \
  --assume-yes
```

#### Calling the module constructor.

Calling the module constructor to assign the current account as the owner

```bash
aptos move run \
   --function-id default::ScUsersNative::constructor \
   --max-gas 5000 \
   --assume-yes
```

Or

```bash
e2m call \
   --function-id default::ScUsersNative::constructor \
   --max-gas 5000 \
   --native
```

#### Adding a "demo" account

```bash
aptos move run \
   --function-id default::ScUsersNative::create_user \
   --max-gas 25000 \
   --assume-yes \
   --profile demo
```

Or

```bash
e2m call \
   --function-id default::ScUsersNative::create_user \
   --max-gas 25000 \
   --native \
   --profile demo
```

#### ID verification

account "default": id = 1

```bash
aptos move run \
  --function-id default::ScUsersNative::is_id \
  --args u128:1 \
  --max-gas 10000 \
  --assume-yes
```

or

```bash
e2m call \
  --function-id default::ScUsersNative::is_id \
  --args u128:1 \
  --max-gas 10000 \
  --native
```

account "demo": id = 2

```bash
aptos move run \
  --function-id default::ScUsersNative::is_id \
  --args u128:2 \
  --max-gas 10000 \
  --profile demo \
  --assume-yes
```

Or

```bash
e2m call \
  --function-id default::ScUsersNative::is_id \
  --args u128:2 \
  --max-gas 10000 \
  --profile demo \
  --native
```

#### Checking whether this account is the owner:

```bash
aptos move run \
   --function-id default::ScUsersNative::is_owner \
   --max-gas 10000 \
   --assume-yes
```

or

```bash
e2m call \
   --function-id default::ScUsersNative::is_owner \
   --max-gas 10000
   --native
```

An **error** will occur when checking from another account

```bash
aptos move run \
   --function-id default::ScUsersNative::is_owner \
   --max-gas 10000 \
   --profile demo \
   --assume-yes
```

#### Checking the balance

account "default": 10000000000000000000000000000

```bash
aptos move run \
  --function-id default::ScUsersNative::check_balance \
  --args u128:10000000000000000000000000000 \
  --max-gas 10000 \
  --assume-yes
```

Or

```bash
e2m call \
  --function-id default::ScUsersNative::check_balance \
  --args u128:10000000000000000000000000000 \
  --max-gas 10000 \
  --native
```

account "demo": 0

```bash
aptos move run \
  --function-id default::ScUsersNative::is_empty_balance \
  --max-gas 10000 \
  --profile demo \
  --assume-yes
```

or

```bash
e2m call \
  --function-id default::ScUsersNative::is_empty_balance \
  --max-gas 10000 \
  --profile demo \
  --native
```

#### Transfer

Sending 200 coins from "default" to "demo"

```bash
aptos move run \
  --function-id default::ScUsersNative::transfer \
  --args address:demo u128:200 \
  --max-gas 25000 \
  --assume-yes
```

Or

```bash
e2m call \
  --function-id default::ScUsersNative::transfer \
  --args address:demo u128:200 \
  --max-gas 25000 \
  --native
```

#### Checking the transfer

Account **default**

```bash
aptos move run \
  --function-id default::ScUsersNative::check_balance \
  --args u128:9999999999999999999999999800 \
  --max-gas 10000 \
  --assume-yes
```

Or

```bash
e2m call \
  --function-id default::ScUsersNative::check_balance \
  --args u128:9999999999999999999999999800 \
  --max-gas 10000 \
  --native
```

Account **demo**

```bash
aptos move run \
  --function-id default::ScUsersNative::check_balance \
  --args u128:200 \
  --max-gas 10000 \
  --profile demo \
  --assume-yes
```

Or

```bash
e2m call \
  --function-id default::ScUsersNative::check_balance \
  --args u128:200 \
  --max-gas 10000 \
  --native \
  --profile demo
```

### Example with Ethereum Type

#### Module transformation and publication

This command we will make

* Converting a ./examples/users.sol
  file to "mv"
* Generate an interface to use in source. The `./i_users_ethtypes/` folder will appear in the current directory
* We will publish the generated module from the "default" profile

```bash
e2m convert ./examples/users.sol \
   --module UsersEth \
   -o ./examples/i_users_ethtypes \
   -a self \
   --max-gas 30000 \
   -d
```

#### Publishing a script

Publishing a ./examples/sc_users_ethtypes for interacting
with the module

> **Important** don't forget to replace the address

```bash
aptos move publish \
  --package-dir ./examples/sc_users_ethtypes \
  --max-gas 20000 \
  --assume-yes
```

#### Calling the module constructor.

Calling the module constructor to assign the current account as the owner

```bash
e2m call \
   --function-id default::ScUsersEth::constructor \
   --max-gas 5000
```

#### Adding a "demo" account

```bash
e2m call \
   --function-id default::ScUsersEth::create_user \
   --max-gas 25000 \
   --profile demo
```

#### ID verification

account "default": id = 1

```bash
e2m call \
  --function-id default::ScUsersEth::is_id \
  --args u128:1 \
  --max-gas 10000
```

account "demo": id = 2

```bash
e2m call \
  --function-id default::ScUsersEth::is_id \
  --args u128:2 \
  --max-gas 10000 \
  --profile demo 
```

#### Checking whether this account is the owner:

```bash
e2m call \
   --function-id default::ScUsersEth::is_owner \
   --max-gas 10000
```

An **error** will occur when checking from another account

```bash
e2m call \
   --function-id default::ScUsersEth::is_owner \
   --max-gas 10000 \
   --profile demo
```

#### Checking the balance

account "default": 10000000000000000000000000000

```bash
e2m call \
  --function-id default::ScUsersEth::check_balance \
  --args u128:10000000000000000000000000000 \
  --max-gas 10000
```

account "demo": 0

```bash
e2m call \
  --function-id default::ScUsersEth::is_empty_balance \
  --max-gas 10000 \
  --profile demo
```

#### Transfer

Sending 200 coins from "default" to "demo"

```bash
e2m call \
  --function-id default::ScUsersEth::transfer \
  --args address:demo u128:200 \
  --max-gas 25000
```

##### Checking the transfer

Account **default**

```bash
e2m call \
  --function-id default::ScUsersEth::check_balance \
  --args u128:9999999999999999999999999800 \
  --max-gas 10000
```

Account **demo**

```bash
e2m call \
  --function-id default::ScUsersEth::check_balance \
  --args u128:200 \
  --max-gas 10000 \
  --profile demo
```

## Local call

> **! IMPORTANT**\
> When starting contacts locally, you cannot access other resources.
> For this reason, the data may be incorrect or will not work: `msg.sender.balance`, `block.number`, `block.timestamp`,
> etc.

### Call a remote contract locally

`--how local` - Call a remote contract locally and display the return value


```bash
e2m call \
  --function-id default::UsersEth::get_id \
  --path ./examples/i_users_ethtypes \
  --how local
```

###### Result:

> Uint(1)

#### Call a local contract with remote resources and display the return value

`--how local-source` - Call a local contract with remote resources and display the return value

```bash
e2m call \
  --function-id default::ConstFn::const_fn_10 \
  --how local-source \
  --path ./examples/const_fn.sol
```

###### Result:

> Uint(10)

#### Calling a local contract without loading a remote resource

`--how vm` Call a local contract and display the return value

```bash
e2m call \
  --function-id default::APlusB::plus \
  --how vm \
  --path ./examples/a_plus_b.sol
```

###### Result:

> Uint(27)

## Resource

### View resource

```bash
e2m resources --query resource \
  --resource-path default::UsersEth::Persist
```

### View the list of events

```bash
e2m resources --query events \
  --resource-path default::UsersEth::Persist::events
```

### Decoding the list of events using abi

```bash
e2m resources --query events \
  --resource-path default::UsersEth::Persist::events \
  --abi ./examples/i_users_ethtypes/UsersEth.abi
```

### Decoding by the specified types

```bash
e2m resources --query events \
  --resource-path default::UsersEth::Persist::events \
  --decode-types data:address,address,u256 topics:bytes
```

