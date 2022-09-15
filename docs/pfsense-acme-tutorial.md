## Tutorial: pfSense-based ACME with CertGetter

This step-by-step guide teaches you how to generate wildcard certificates with challenge via DNS and prepare them for automatic delivery to other systems.

1. Install pfSense, do the basic settings, set the timezone to UTC and make sure there is internet access 

2. Go to **"System\Package Manager\Available Packages"** and install the **ACME** package (in case of virtual machines, also install the package **Open-VM-Tools**)

3. Go to **"System\Advanced\Admin Access"**, in the **"Secure Shell"** section, check the **"Enable Secure Shell"** option, set the **"SSHd Key Only"** option to **"Public Key Only"** (recommended) or **"Password or Public Key"** and **Save**

4. Go to **"System\User Manager\Add"**, create the user **certgetter** - in lowercase, with a strong password - and **Save**

5. Edit the newly created user, assign the **"Effective Privileges"** described as **"User - System: Shell account access"** and **"User - System: Copy files (scp)"**, then **Save**

6. Go to **"Diagnostics\Command Prompt"** and copy, paste and run each of the blocks below one at a time in the **"Run Shell Command"** section

	```sh
	mkdir -p /root/certgetter && touch /root/certgetter/certgetter.sh
	```

	```sh
	curl -s https://raw.githubusercontent.com/ezlage/CertGetter/main/pfsense/certgetter.sh > /root/certgetter/certgetter.sh
	```

	```sh
	chown -R root:wheel /root/certgetter && chmod 755 /root/certgetter/certgetter.sh
	```

7. Under **"Services\ACME Certificates\General settings"**, make sure **"Cron Entry"** and **"Write Certificates"** are checked and **Save**

8. Under **"Services\ACME Certificates\Account keys"**, create a test or production account and remember its name, click in **"Create new account key"**, then **"Register ACME account key"** and **Save**

9. Under **"Services\ACME Certificates\Certificates"**, create a certificate with the same name as the account created in the previous step

	9.1. Select the corresponding **"ACME Account"**

	9.2. In **"Domain SAN list"** enter your domain or subdomain prefixed with *. (e.g.: **\*.domain.tld**) and choose **DNS-Manual** as **Method**

	9.3. In **"Enable DNS alias mode"** enter your domain or subdomain exactly as it is (e.g.: **domain.tld**)

	9.4. In **"Actions list"**, **Add** an item informing as **Method** **"Shell Command"** and as **Command** the following block, but replacing **"acme-account-name"** with the value from step 8, **"domain-primary-name"** with the value from step 9.2 and **"local-destination-name"** with the value from step 9.3, keeping the quotation marks

	```sh
	/root/certgetter/certgetter.sh "acme-account-name" "domain-primary-name" "local-destination-name"
	```

	9.5. **Save**!

	Note: **domain.tld** and **\*.domain.tld** are not valid as they are just examples; Be sure to use other names.

10. The page will return to the **"Services\ACME Certificates\Certificates"** section, where you must click on **Issue** for the newly created certificate and pay attention to the informative text that will be displayed

11. As shown in the image below, copy the value and name of the record (the name is usually prefixed with **_acme-challenge** and the value is some random alphanumeric)

![ACME Issuance](https://media.githubusercontent.com/media/ezlage/CertGetter/main/docs/pfsense-acme-issue.png?raw=true)

12. Change the DNS zone to be certified by creating a TXT-type record with the name and value obtained (in some cases it may be necessary to manually increment the zone serial); Make sure not to issue the certificate again, so that the same record remains valid, and do not delete such record from the DNS zone

13. Wait for the change to propagate, it usually takes a few minutes and you can follow along as shown below (it is enough that some of the commands return the exact registered value)

	Microsoft Windows
	```bat
	REM Replace "_acme-challenge.domain.tld" by the correct FQDN

	nslookup -q=TXT _acme-challenge.domain.ltd 8.8.8.8
	```

	Linux, FreeBSD, macOS and similar
	```sh
	# Replace "_acme-challenge.domain.tld" by the correct FQDN

	dig @8.8.8.8 -t TXT _acme-challenge.domain.tld +short
	```

	Again: **domain.tld** and **\*.domain.tld** are not valid as they are just examples; Be sure to use other names.

14. Get back to **"Services\ACME Certificates\Certificates"** and click in **Renew** for the newly created certificate; If you receive the certificate data in Base64, as in the image below, it worked!

![ACME Renewal](https://media.githubusercontent.com/media/ezlage/CertGetter/main/docs/pfsense-acme-renew.png?raw=true)

15. Please review the **"Login Protection"** section under **"System\Advanced\Admin Access"** as the settings there may block consecutive sync attempts and also cause some failures in the future

16. Done, but keep an eye on **/root/certgetter/certgetter.log** file! Also, remember to contribute by reporting problems or suggesting improvements.

### License, credits, feedback and donation

[BSD 3-Clause "New" or "Revised" License](../LICENSE.md)  
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