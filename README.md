# any-monic
Bring whatever kind of mnemonic you want, leave with an address and a PK

## What can I use this for?
1. Input your mnemonic
2. Get your Ethereum (or any other chain) address and private key

## What's so special?
Not much, just that:
- It's a very simple script that runs locally in your machine
- There are no validations on the mnemonic, so you can use whatever string
- It's interesting for recovering crooked mnemonics and so on...

## How to use
The script is written on _dart_, so you essencially only need to install it.

### 1. Install Dart
Visit (the official page)[https://dart.dev/get-dart#install] and follow the short instructions.

### 2. Clone this repo
Go to your console, and type `git clone git@github.com:brunocalmels/any-monic.git`

### 3. Run the script
- Go into the directory where you just cloned the repo (most probably `cd any-monic`)
- Run the script: `dart run bin/any_monic.dart 'my mnemonic'`
- You will get your address (in standard hex format) and the private key (in hex format also, without the initial '0x'). You can import the private key in wallets such as Metamask, Defiant, and more. 

### Customizing the derivation path
- You can tap into the script code and change the derivation path. See [final derivationPath = "m/44'/60'/0'/0/0"; // Ethereum](https://github.com/brunocalmels/any-monic/blob/55d753567875e544f99dfeb7e9ebb7ceba5c658c/bin/any_monic.dart#L49-L50). There we're using Ethereum derivation path, and RSK's is commented in the next line. Uncomment or change at will. 