
# CertGetter

A set of scripts to automate the delivery of Let's Encrypt certificates issued through pfSense's Automated Certificate Management Environment (ACME).

## Dependencies and requirements

- pfSense¹
- ACME package for pfSense¹
- A valid public DNS domain

¹ It is likely to work with OPNsense as well.

## Usage

- First of all, prepare your pfSense and ACME server as shown [here](./docs/pfsense-acme-tutorial.md)
- Second, prepare the server that will use the certificate and automatically download it whenever renewed (Linux tutorial [here](./docs/linux-like-tutorial.md); Windows tutorial coming soon!)
- Done! The certificate, even if wildcard, will applied automatically wherever it is needed

## Roadmap and Changelog

This repository is based on and inspired by - but not limited to - [Keep a Changelog](https://keepachangelog.com/), [Semantic Versioning](https://semver.org/) and the [ezGTR](https://github.com/ezlage/ezGTR) template. Therefore, any changes made, expected or intended will be documented in the [Roadmap and Changelog](./RMAP_CLOG.md) file.  

## Credits, Sponsorship and Licensing

Developed by [Ezequiel Lage](https://github.com/ezlage), Sponsored by [Lageteck](https://lageteck.com) and Published under the [MIT License](./LICENSE.txt).  
All suggestions, criticisms and contributions are welcome!  

### Support this initiative!

BTC: 1Nw2fzDgtXM5X219Q9VtJ7WaSTDPua3oe8  
ERC20*: 0x089499f57ee20fd2c19f57612d9af69d645dff0d  
\* Any ERC20 token supported by Binance (ETH, USDC, USDT, etc.)  