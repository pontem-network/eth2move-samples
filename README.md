# eth2move

EVM to Move static bytecode translator.

# e2m

Converts **solidity file** to **binary move** code. You can convert from **abi + bin** files or a **sol** file

> **! IMPORTANT**\
> To convert from a **sol** file, **solc** must be installed on the computer and accessible from the terminal using the
> short command **solc**.\
> To publish, you need the installed **aptos** utility and **e2m** build with the flag `--features=deploy`

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

The **aptos** version must be at least **0.3.8**

```bash
aptos --version
```

## Download e2m

[Download link for the latest version of e2m](https://github.com/pontem-network/eth2move-samples/releases) \
Unpack the archive and place the executable file in a place convenient for you. For convenience, create an alias **e2m**
in the system for this file.
> **! IMPORTANT**
> In all examples, e2m will be called via an alias


> **! IMPORTANT**\
> Before running the examples, you will need to create a private key.
> It will be used both for the module address and for publishing on the node.
> Default profile:
> ```bash
> aptos init
> ```
> Demo profile:
> ```bash
> aptos init --profile demo
> ```
> See more: [aptos init](https://aptos.dev/cli-tools/aptos-cli-tool/use-aptos-cli/#step-1-run-aptos-init)

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
* `-i`, `--interface_package`   Generate an interface project
* `--native-input`      Input params of native type
* `--native-output`     Output value of native type
* `--u128_io`           Use u128 instead of u256
* `-d`, `--deploy`      Deploying the module in aptos node
* `--max-gas`           Maximum amount of gas units to be used to send this transaction
* `--save-abi`          Save solidity abi

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
After completing the command, you will see the path to the created file (Example: "./NameSolModule.mv").
By default, the file is saved to the current directory.

#### examples/a_plus_b.sol

```bash
e2m convert examples/a_plus_b.sol 
```

##### Result:

> Saved in "./APlusB.mv

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

The `-o`, `--output` parameter is responsible for specifying the location where the converted file will be saved.

#### examples/const_fn.sol

```bash
e2m convert examples/const_fn.sol -o ./Test.mv
```

##### Result:

> Saved in "./Test.mv"

The move binary file will be created in the current directory named **Test.vm**\
Move module address: **Address from the "default" profile** \
Move module name: **Cons**

#### examples/APlusB.bin

```bash
e2m convert examples/APlusB.bin -o ./AB.mv
```

##### Result:

> Saved in "./AB.mv"

Move module address: **Address from the "default" profile** \
Move module name: **APlusB**

#### Explicit indication of the module name in the received move bytecode

The `--module` argument is responsible for explicitly specifying the move module name.

##### examples/APlusB.abi

```bash
e2m convert examples/APlusB.abi --module ApB
```

##### Result:

> Saved in "./APlusB.mv"

Move module address: **Address from the "default" profile** \
Move module name: **ApB**

#### examples/two_functions.sol

```bash
e2m convert examples/two_functions.sol --module TF
```

##### Result:

> Saved in "./TwoFunctions.mv"

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

> Saved in "./ConstFn.mv"

Move module address: **0x3** \
Move module name: **ConstFn**

#### examples/two_functions.sol

```bash
e2m convert examples/two_functions.sol --profile demo
```

##### Result:

> Saved in "./TwoFunctions.mv"

Move module address: **Address from the "demo" profile** \
Move module name: **TwoFunctions**

#### Combined arguments

```bash
 e2m convert examples/const_fn.sol -o ./MyMove.mv --module DemoName --profile 0x3 
```

###### Result:

> Saved in "./MyMove.mv"

Move module address: **0x3** \
Move module name: **DemoName**

### Convert and publish the module

In order for the module to be published on the aptos node after conversion, use the `-d`, `--deploy` flag.\
After successful publication, you will receive complete information in json format about the completed process.

> **! IMPORTANT**\
> When you try to re-publish the module, you will see the message "DUPLICATE_MODULE_NAME"

#### examples/two_functions.sol

```bash
e2m convert examples/two_functions.sol -d
```

#### examples/APlusB.abi

```bash
e2m convert examples/APlusB.abi -o ./module.mv --profile demo --deploy
```

### Generate an interface project

#### examples/APlusB.abi

```bash
e2m convert examples/a_plus_b.sol \
    -o ./aplusb.mv \
    -i
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
    --native-output \
    -i
```

#### U128

```bash
e2m convert examples/a_plus_b.sol \
    --native-input \
    --native-output \
    --u128-io \
    -i
```

## Call.

See help:

```bash
e2m call --help
```

### Input parameters

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
* Generate an interface to use in source. The `./examples/i_users/` folder will appear in the current directory
* Module will support "move" types
* We will publish the generated module from the "default" profile

```bash
e2m convert ./examples/users.sol \
   -o ./examples/i_users \
   -a self \
   --native-input \
   --native-output \
   -i \
   --max-gas 10000 \
   --save-abi \
   -d
```

#### Publishing a script

Publishing a ./examples/sc_users for interacting with the
module

> **Important** don't forget to replace the address

```bash
aptos move publish \
  --package-dir ./examples/sc_users \
  --max-gas 2000 \
  --assume-yes
```

#### Calling the module constructor.

Calling the module constructor to assign the current account as the owner

```bash
aptos move run \
   --function-id default::ScUser::constructor \
   --max-gas 2000 \
   --assume-yes
```

#### Adding a "demo" account

```bash
aptos move run \
   --function-id default::ScUser::create_user \
   --max-gas 2000 \
   --profile demo \
   --assume-yes
```

#### ID verification

account "default": id = 1

```bash
aptos move run \
  --function-id default::ScUser::is_id \
  --args u128:1 \
  --max-gas 1000 \
  --assume-yes
```

account "demo": id = 2

```bash
aptos move run \
  --function-id default::ScUser::is_id \
  --args u128:2 \
  --max-gas 1000 \
  --profile demo \
  --assume-yes
```

#### Checking whether this account is the owner:

```bash
aptos move run \
   --function-id default::ScUser::is_owner \
   --max-gas 1000 \
   --assume-yes
```

An **error** will occur when checking from another account

```bash
aptos move run \
   --function-id default::ScUser::is_owner \
   --max-gas 1000 \
   --profile demo \
   --assume-yes
```

#### Checking the balance

account "default": 10000000000000000000000000000

```bash
aptos move run \
  --function-id default::ScUser::check_balance \
  --args u128:10000000000000000000000000000 \
  --max-gas 1000 \
  --assume-yes
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
  --max-gas 2000 \
  --assume-yes
```

#### Checking the transfer

Account **default**

```bash
aptos move run \
  --function-id default::ScUser::check_balance \
  --args u128:9999999999999999999999999800 \
  --max-gas 1000\
  --assume-yes
```

Account **demo**

```bash
aptos move run \
  --function-id default::ScUser::check_balance \
  --args u128:200 \
  --max-gas 1000 \
  --profile demo\
  --assume-yes
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
   --module EthUsers \
   -o ./examples/i_users_ethtypes \
   -a self \
   -i \
   --max-gas 10000 \
   -d
```

#### Publishing a script

Publishing a ./examples/sc_users for interacting
with the module

> **Important** don't forget to replace the address

```bash
aptos move publish \
  --package-dir ./examples/sc_users_ethtypes \
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

## Resource

### View resource

```bash
e2m resources --query resource --resource-path default::Users::Persist
```

### View the list of events

```bash
e2m resources --query events --resource-path default::Users::Persist::events
```

### Decoding the list of events using abi

```bash
e2m resources --query events \
  --resource-path default::Users::Persist::events \
  --abi ./examples/i_users.abi
```

### Decoding by the specified types

```bash
e2m resources --query events \
  --resource-path default::Users::Persist::events \
  --decode-types data:address,address,u256 topics:bytes
```
