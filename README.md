# eth2move

EVM to Move static bytecode translator.

## e2m
Converts **solidity file** to **binary move** code. You can convert from **abi + bin** files or a **sol** file

> **! IMPORTANT**\
> To convert from a **sol** file, **solc** must be installed on the computer and accessible from the terminal using the short command **solc**.\
> To publish, you need the installed **aptos** utility and **e2m** build with the flag `--features=deploy`

### Install solc

How to install **solc**, [see the documentation](https://docs.soliditylang.org/en/develop/installing-solidity.html)

#### Checking solc

The **solc** version must be at least **0.8.15**

```bash
solc --version
```
> **! IMPORTANT**\
> If this command is not available for execution from the terminal, e2m will not work.

### Install aptos

How to install **aptos**, [see the documentation](https://aptos.dev/cli-tools/aptos-cli-tool/install-aptos-cli)

#### Checking aptos

The **aptos** version must be at least **0.2.3**

```bash
aptos --version
```

### Installation e2m
Cloning the repository and installing e2m:

```bash
git clone https://github.com/pontem-network/eth2move
cargo +nightly install --path cli/e2m --features=deploy
```

### See help:
```bash
e2m --help
```

#### Input parameters
* `<PATH>`              Path to the file. Specify the path to sol file or abi | bin
* `-o`, `--output`      Where to save the converted Move binary file
* `--module`            The name of the move module. If not specified, the name will be taken from the abi path
* `-p`, `--profile`     Profile name or address. The address must start with "0x". [default: default]
* `-m`, `--math`        Math backend u128 or u256 [default: u128]
* `-d`, `--deploy`      Deploying the module in aptos node

### Example
You can find the files from the examples in the [eth2move/examples](https://github.com/pontem-network/eth2move/tree/master/examples) folder

> **! IMPORTANT**\
> Before running the examples, you will need to create a private key.
It will be used both for the module address and for publishing on the node.
> Default profile:
> ```bash
> aptos init
> ```
> Demo profile:
> ```bash
> aptos init --profile demo
> ```
> See more: [aptos init](https://aptos.dev/cli-tools/aptos-cli-tool/use-aptos-cli/#step-1-run-aptos-init)

#### Required parameters
Required parameters are the paths to sol file (`<PATH>`).\
The file can be extensions:
* `sol` - The file will be compiled using the solc utility. The resulting **abi** and **bin** will be translated into **move binarycode**
* `bin` - It is expected that there is an `abi` file with the same name in the same folder. These **abi** and **bin** will be translated into **move binarycode**
* `abi` - It is expected that there is an `bin` file with the same name in the same folder. These **abi** and **bin** will be translated into **move binarycode**

The name from the passed **solidity library** will be used as the filename and the name of the **move module**.\
After completing the command, you will see the path to the created file (Example: "./NameSolModule.mv"). 
By default, the file is saved to the current directory.

##### examples/a_plus_b.sol
```bash
e2m examples/a_plus_b.sol 
```

###### Result:
> Saved in "./APlusB.mv

Move module address: **Address from the "default" profile**\
Move module name: **APlusB**

##### examples/APlusB.abi
```bash
e2m examples/APlusB.abi
```

##### Result:
> Saved in "./APlusB.mv"

Move module address: **Address from the "default" profile**\
Move module name: **APlusB**


##### examples/APlusB.bin
```bash
e2m examples/APlusB.bin
```

###### Result:
> Saved in "./APlusB.mv"

Move module address: **Address from the "default" profile**\
Move module name: **APlusB**


##### ! Fail: examples/BinNotFound.abi
```bash
e2m examples/BinNotFound.abi
```

###### Result:
> Error: Couldn't find bin.
Path:"examples/BinNotFound.bin"

> **! IMPORTANT**\
> A successful broadcast always requires a **bin** and an **abi** **solidity library**

#### Path to save
The `-o`, `--output` parameter is responsible for specifying the location where the converted file will be saved.

##### examples/const_fn.sol

```bash
e2m examples/const_fn.sol -o ./Test.mv
```

###### Result:
> Saved in "./Test.mv"

The move binary file will be created in the current directory named **Test.vm**\
Move module address: **Address from the "default" profile** \
Move module name: **Cons**

##### examples/APlusB.bin

```bash
e2m examples/APlusB.bin -o ./AB.mv
```

###### Result:
> Saved in "./AB.mv"

Move module address: **Address from the "default" profile** \
Move module name: **APlusB**

#### Explicit indication of the module name in the received move bytecode
The `--module` argument is responsible for explicitly specifying the move module name.

##### examples/APlusB.abi

```bash
e2m examples/APlusB.abi --module ApB
```

###### Result:
> Saved in "./APlusB.mv"

Move module address: **Address from the "default" profile** \
Move module name: **ApB**

##### examples/two_functions.sol

```bash
e2m examples/two_functions.sol --module TF
```

###### Result:
> Saved in "./TwoFunctions.mv"

Move module address: **Address from the "default" profile** \
Move module name: **TF**

#### Explicit indication of the module address in the received move bytecode
The argument `-p`, `--profile` is responsible for explicitly specifying the address of the transfer module or the name of the profile from which the address will be taken.
If the parameter value starts with **"0x"**, then it will be taken as an address, everything else will be considered the **profile name**.\
Profile data will be taken from **.aptos/config.yaml**

##### examples/const_fn.sol

```bash
e2m examples/const_fn.sol -p 0x3
```

###### Result:
> Saved in "./ConstFn.mv"

Move module address: **0x3** \
Move module name: **ConstFn**

##### examples/two_functions.sol

```bash
e2m examples/two_functions.sol --profile demo
```

###### Result:
> Saved in "./TwoFunctions.mv"

Move module address: **Address from the "demo" profile** \
Move module name: **TwoFunctions**

#### Combined arguments

```bash
 e2m examples/const_fn.sol -o ./MyMove.mv --module DemoName --profile 0x3 
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
e2m examples/two_functions.sol -d
```

#### examples/APlusB.abi
```bash
e2m examples/APlusB.abi -o ./module.mv --profile demo --deploy
```

## What the converter can already do.

See the [folder](https://github.com/pontem-network/eth2move/tree/master/translator/test_infra/sol)