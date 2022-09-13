# eth2move

EVM to Move static bytecode translator.

[Feature list](feature-list.md)

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

#### Samples

```bash
 e2m samples/users.sol -o ./Users.mv  --profile 0x3 
```

###### Result:
> Saved in "./Users.mv"

Move module address: **0x3** \


### Convert and publish the module
In order for the module to be published on the aptos node after conversion, use the `-d`, `--deploy` flag.\
After successful publication, you will receive complete information in json format about the completed process.

> **! IMPORTANT**\
> When you try to re-publish the module, you will see the message "DUPLICATE_MODULE_NAME"


#### examples/two_functions.sol
```bash
e2m samples/users.sol -d
```


## What the converter can already do.

See the [folder](https://github.com/pontem-network/eth2move-samples/tree/main/samples)