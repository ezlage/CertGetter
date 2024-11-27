## Tutorial: pfSense-based ACME with CertGetter

This step-by-step guide teaches you how to generate wildcard certificates with manual DNS challenge and prepare them for automatic delivery to other systems.

If your DNS zone is hosted by a provider for which ACME has a plugin, you can also automate the issuance and renewal of the certificate. 

By following this tutorial you will need to issue and renew the certificate manually every 90 days.

1. Install pfSense, do the basic settings, set the timezone to UTC and make sure there is internet access 

2. Go to **"System\Package Manager\Available Packages"** and install the **ACME** package (in case of virtual machines, also install the package **Open-VM-Tools**)

3. Go to **"System\Advanced\Admin Access"**, in the **"Secure Shell"** section, check the **"Enable Secure Shell"** option, set the **"SSHd Key Only"** option to **"Public Key Only"** or **"Password or Public Key"** and click **Save**

4. Go to **"System\User Manager\Add"**, create the user **certgetter** - in lowercase, with a strong password -, check the **"Keep shell command history between login sessions"** option and click **Save**

5. Edit the newly created user, assign the **"Effective Privileges"** described as **"User - System: Shell account access"** and **"User - System: Copy files (scp)"**, then click **Save**

6. Go to **"Diagnostics\Command Prompt"** then copy, paste and run each of the blocks below, one at a time, in the **"Run Shell Command"** section

	```sh
	mkdir -p /root/certgetter && touch /root/certgetter/certgetter.sh
	```

	```sh
	curl -s https://raw.githubusercontent.com/ezlage/CertGetter/main/pfsense/certgetter.sh > /root/certgetter/certgetter.sh
	```

	```sh
	chown -R root:wheel /root/certgetter && chmod 755 /root/certgetter/certgetter.sh
	```

7. Under **"Services\ACME Certificates\General settings"**, make sure **"Cron Entry"** and **"Write Certificates"** are checked and click **Save**

8. Under **"Services\ACME Certificates\Account keys"**, click on **Add** to create a test or production account, set and remember its name, click on **"Create new account key"**, then **"Register ACME account key"** and click **Save**

9. Under **"Services\ACME Certificates\Certificates"**, create a certificate with the same name as the account created in the previous step

	9.1. Select the corresponding **"ACME Account"**

	9.2. In **"Domain SAN list"** enter your domain or subdomain prefixed with *. (e.g.: **\*.domain.tld**) and choose **DNS-Manual** as **Method**

	9.3. In **"Enable DNS alias mode"** enter your domain or subdomain exactly as it is (e.g.: **domain.tld**)

	9.4. In **"Actions list"**, **Add** an item informing as **Method** **"Shell Command"** and as **Command** the following block, but replacing **"acme-account-name"** with the value from step 8, **"domain-primary-name"** with the value from step 9.2 and **"local-destination-name"** with the value from step 9.3, keeping the quotation marks

	```sh
	/root/certgetter/certgetter.sh "acme-account-name" "domain-primary-name" "local-destination-name"
	```

	9.5. Click **Save**!

	Note: **domain.tld** and **\*.domain.tld** are not valid as they are just examples; Be sure to use other names.

10. The page will return to the **"Services\ACME Certificates\Certificates"** section, where you must click on **Issue** for the newly created certificate and pay attention to the informative text that will be displayed

11. As shown in the image below, copy the value and name of the record (the name is usually prefixed with **_acme-challenge** and the value is some random alphanumeric)

![ACME Issuance](https://media.githubusercontent.com/media/ezlage/CertGetter/main/docs/pfsense-acme-issue.png?raw=true)

12. Change the DNS zone to be certified by creating a TXT-type record with the name and value obtained (in some cases it may be necessary to manually increment the zone serial)

13. Wait for the change to propagate, it usually takes a few minutes and you can follow along as shown below (it is enough that some of the commands return the exact registered value)

	Microsoft Windows
	```bat
	REM Replace "_acme-challenge.domain.tld" by the correct FQDN

	nslookup -q=TXT _acme-challenge.domain.tld 8.8.8.8
	```

	Linux, FreeBSD, macOS and similar
	```sh
	# Replace "_acme-challenge.domain.tld" by the correct FQDN

	dig @8.8.8.8 -t TXT _acme-challenge.domain.tld +short
	```

	Again: **domain.tld** and **\*.domain.tld** are not valid as they are just examples; Be sure to use other names.

14. Get back to **"Services\ACME Certificates\Certificates"** and click on **Renew** for the newly created certificate; If you receive the certificate data in Base64, as in the image below, it worked!

![ACME Renewal](https://media.githubusercontent.com/media/ezlage/CertGetter/main/docs/pfsense-acme-renew.png?raw=true)

15. Please review the **"Login Protection"** section under **"System\Advanced\Admin Access"** as the settings there may block consecutive sync attempts and also cause some failures in the future

16. Done, but keep an eye on **/root/certgetter/certgetter.log** file! Also, remember to contribute by reporting problems or suggesting improvements.

	Note: If you restart pfSense, you will lose the files in **/tmp/acme** and you may need to issue and renew the certificate again. A workaround is underway!