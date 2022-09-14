
# CertGetter

A set of scripts to automate the delivery of Let's Encrypt wildcard certificates issued through pfSense's Automated Certificate Management Environment (ACME).

### Dependencies and requirements

- pfSense¹
- ACME package for pfSense¹
- A valid public DNS domain

¹ It is likely to work with opnSense as well.

### Usage

- First of all, prepare your pfSense and ACME server as shown [here](./docs/pfsense-acme-tutorial.md)
- Second, prepare the server that will use the certificate and automatically download it whenever renewed (Linux tutorial comming very soon; Windows tutorial coming soon)
- Done! The certificate, even if wildcard, was issued manually, but will be renewed and applied automatically wherever it is needed

### Roadmap and changelog

#### Under development or planned to be developed

- Script to import and apply certificates in Windows
- Tutorial to import and apply certificates automatically in Linux-like systems
- Tutorial to import and apply certificates automatically in Windows
- Scripts to facilitate reloading of services that use the certificates

#### v0.0.0.2: Added script for Linux and similar

- Script to import and apply certificates in Linux and similar ([linux/certgetter.sh](./linux/certgetter.sh))
- Many underscores (_) in the full chain file, CA public key file and a few other places have been replaced by a dash (-)

#### v0.0.0.1: Script for pfSense now logs messages

- **certgetter.sh** for pfSense-based ACME server has been modified to save logs

#### v0.0.0.0: First public incomplete pre-release

- Script to convert and prepare ACME certificates for export from pfSense ([pfsense/certgetter.sh](./pfsense/certgetter.sh))
- Tutorial to configure ACME, its certificates and install CertGetter inside pfSense

### License, credits, feedback and donation

[BSD 3-Clause "New" or "Revised" License](./LICENSE.md)  
Developed by [Ezequiel Lage](https://twitter.com/ezlage), Sponsored by [Lageteck](https://lageteck.com)  
Any and all suggestions, criticisms and contributions are welcome!  
Get in touch via Issues, Discussions and Pull Requests  

#### Support this initiative!

BTC: 1Nw2fzDgtXM5X219Q9VtJ7WaSTDPua3oe8  
DASH: XeEuQk3za87DTtNZGkriRXMAJPoMbXNjUA  
LTC: LgMYNhUREb2kgXpBXoybgjtJM7QSNZKs14  
ZEC: t1dtNs9nNphKdLrro3JPzvE2r5E48doboM1  
ERC20*: 0xbc024170e10e097140d4be5c30fd4ed6220cfb57  
\* Any ERC20 token supported by Binance (ETH, USDC, USDT, etc)  