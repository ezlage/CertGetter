## Tutorial: CertGetter for Linux-like systems

This step-by-step guide teaches you how to automate the delivery of certificates and how to reload the necessary services on Linux or similar operating systems.

1. Access the server via SSH, make sure name resolution is working and there is network connectivity, then install SCP, RSYNC and cUR

2. In the terminal, copy and run each of the command blocks below, one at a time

	```sh
	sudo mkdir -p /root/certgetter && sudo touch /root/certgetter/certgetter.sh
	```

	```sh
	sudo curl -s https://raw.githubusercontent.com/ezlage/CertGetter/main/linux/certgetter.sh > /root/certgetter/certgetter.sh
	```

	```sh
	sudo chown -R root:root /root/certgetter && sudo chmod 755 /root/certgetter/certgetter.sh
	```

	```sh
	sudo test -f /root/.ssh/id_rsa || sudo ssh-keygen -t rsa -b 2048 -f /root/.ssh/id_rsa -q -P ""
	```

3. Copy the root user's RSA public key and register it as **"Authorized SSH Keys"** for the CertGetter user on the ACME server (**"System\User Manager\Edit"**)

	```sh
	sudo cat /root/.ssh/id_rsa.pub
	```

4. Run CertGetter for the first time by replacing **"acme-server"** with the FQDN or IP of the ACME server and **"remote-source-name"** with the certificate set name

	```sh
	sudo /root/certgetter/certgetter.sh "acme-server" "remote-source-name"
	```

5. If everything went well, add a scheduled task in crontab with the same replacements as in the previous step; By default, ACME runs its scheduled task at 03:16 (AM), so all other servers should run their tasks after that (it is recommended that they are all set to UTC)

	```sh
	sudo crontab -e
	```

	```sh
	# This will cause the certificates to be synced every day at 04:00 (AM)
	0 4 * * * /root/certgetter/certgetter.sh "acme-server" "remote-source-name"
	```

	```sh
	# This will do the same as the previous command and still reload Nginx
	0 4 * * * /root/certgetter/certgetter.sh "acme-server" "remote-source-name"; nginx -t && nginx -s reload
	```	

	```sh
	# This will do the same as the previous command, but reloading Apache
	0 4 * * * /root/certgetter/certgetter.sh "acme-server" "remote-source-name"; apachectl -t && apachectl graceful
	```	

	In some cases it may be necessary to invoke **nginx** or **apachectl** using the full path.	

7. Done, but keep an eye on **/root/certgetter/certgetter.log** file! Also, remember to contribute by reporting problems or suggesting improvements.

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