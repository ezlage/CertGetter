
# CertGetter

A set of scripts to automate the delivery of Let's Encrypt certificates issued through pfSense's Automated Certificate Management Environment (ACME).

### Dependencies and requirements

- pfSense¹
- ACME package for pfSense¹
- A valid public DNS domain

¹ It is likely to work with opnSense as well.

### Usage

- First of all, prepare your pfSense and ACME server as shown [here](./docs/pfsense-acme-tutorial.md)
- Second, prepare the server that will use the certificate and automatically download it whenever renewed (Linux tutorial [here](./docs/linux-like-tutorial.md); Windows tutorial coming soon!)
- Done! The certificate, even if wildcard, was issued manually, but will be renewed and applied automatically wherever it is needed

### Roadmap and changelog

#### Under development or planned to be developed

- Facilities for collecting and centralizing logs
- Script to import and apply certificates in Windows
- Scripts to generate log and facilitate reloading of services that use the certificates
- Small adaptations to enable automated delivery of non-Let's Encrypt certificates
- The entire process was done with some haste, so refactorings will still be necessary, including making the code more semantic and intelligible
- Tutorial to import and apply certificates automatically in Windows

#### v0.0.0.3: Tutorial for Linux and similar

- Documentation enhancements
- Tutorial to import and apply certificates automatically in Linux-like systems

#### v0.0.0.2: Added script for Linux and similar

- Script to import and apply certificates in Linux and similar ([linux/certgetter.sh](./linux/certgetter.sh))
- Underscores (_) have been replaced by dashes (-) in various places

#### v0.0.0.1: Script for pfSense now logs messages

- Minor documentation tweaks
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