
# CertGetter

A set of scripts to automate the delivery of Let's Encrypt wildcard certificates issued through pfSense's Automated Certificate Management Environment (ACME).

### Dependencies and requirements

- pfSense¹
- ACME package for pfSense¹
- A valid public DNS domain

¹ It is likely to work with opnSense as well.

### Usage with pfSense

1. Install pfSense and configure its basic settings

2. Go to **System\Package Manager\Available Packages** and install the ACME package (in case of virtual machines, also install the package **Open-VM-Tools**)

3. Go to **System\Advanced\Admin Access**, in the **Secure Shell** section, check the **Enable Secure Shell** option, set the **SSHd Key Only** option to **Public Key Only** or **Password or Public Key** and **Save**.

4. Go to **System\User Manager\Add**, create the user **certgetter** - in lowercase, with a strong password - and **Save**

5. Edit the newly created user, assign the **Effective Privileges**  **"User - System: Shell account access"**, **"User - System: Copy files (scp)"** and **Save**

6. Go to **Diagnostics\Command Prompt** and copy, paste and run each of the blocks below one at a time in the **Run Shell Command** section

	```sh
	mkdir -p /root/certgetter && touch /root/certgetter/certgetter.sh
	```

	```sh
	curl -s https://raw.githubusercontent.com/ezlage/CertGetter/main/pfsense/certgetter.sh > /root/certgetter/certgetter.sh
	```

	```sh
	chown -R root:wheel /root/certgetter && chmod 755 /root/certgetter/certgetter.sh
	```

7. Under **Services\ACME Certificates\General settings**, make sure **Cron Entry** and **Write Certificates** are checked

8. Under **Services\ACME Certificates\Account keys**, create a test or production account and remember its name, click in **Create new account key**, **Register ACME account key** and **Save**

9. Under **Services\ACME Certificates\Certificates**, create a certificate with the same name as the account created in the previous step

	9.1. Select the corresponding **ACME Account**

	9.2. In **Domain SAN list** enter your domain or subdomain prefixed with *. (e.g.: **\*.domain.tld**) and choose **DNS-Manual** as **Method**

	9.3. In **Enable DNS alias mode** enter your domain or subdomain exactly as it is (e.g.: **domain.tld**)

	9.4. In **Actions list**, **Add** an item informing as method **Shell Command** and as **Command** the following block, but replacing **acme_account_name** with the value from step 8, **domain_primary_name** with the value from step 9.2 and **destination_name** with the value from step 9.3

	```sh
	/root/certgetter/certgetter.sh "acme_account_name"  "domain_primary_name"  "destination_name"
	```

	9.5. **Save**!

	Note: **domain.tld** and **\*.domain.tld** are not valid as they are just examples; Be sure to use other names.

10. The page will return to the **Services\ACME Certificates\Certificates** section, where you must click on **Issue** for the newly created certificate and pay attention to the informative text that will be displayed

11. As shown in the image below, copy the value and name of the record (usually **_acme-challenge** as name and some random alphanumeric as value)

![ACME Issuance](./docs/issue-screenshot.png?raw=true  "ACME Issuance")

12. Change the DNS zone to be certified by creating a TXT-type record with the name and value obtained (in some cases it may be necessary to increment the zone's serial manually)

13. Wait for the change to propagate between DNS services, it usually takes a few minutes and you can follow along as shown below (it is enough that some of the commands return the registered value)

	Microsoft Windows
	```bat
	REM Replace "recordname.domain.tld" by the correct FQDN

	nslookup -q=TXT recordname.domain.ltd 8.8.8.8
	```

	Linux, FreeBSD, macOS and similar
	```sh
	# Replace "recordname.domain.tld" by the correct FQDN

	dig @8.8.8.8 -t TXT recordname.domain.tld +short
	```

14. Get back to **Services\ACME Certificates\Certificates** and click in **Renew** for the newly created certificate; If you receive the certificate data in Base64, as in the image below, it worked!

![ACME Renewal](./docs/renew-screenshot.png?raw=true  "ACME Renewal")

Steps and scripts for importing and applying certificates on Linux and Windows servers will be added here soon.

### Roadmap and changelog

#### Under development or planned to be developed

- Scripts to import and apply certificates on Linux Servers
- Scripts to import and apply certificates on Windows Servers

#### v0.0.0.0: First public incomplete pre-release

- Step-by-step for configuring ACME in pfSense
- Step-by-step to install CertGetter in pfSense
- Script to convert and export certificates within pfSense

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