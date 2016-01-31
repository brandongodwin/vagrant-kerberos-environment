# About
This simple test environment will emulate an Active Directory environment and allow you to easily test your Kerberos + SPNEGO enabled applications. The domain controller is setup on Ubuntu using Samba 4 and the client machine is running a modified [Modern.IE](http://modern.ie) Windows 7 image with WinRM enabled for Vagrant provisioning.

# Requirements
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Vagrant 1.6+](https://www.vagrantup.com/downloads.html)

# Getting Started
1. Clone or download the repo and CD into the directory.
2. Run `vagrant up`. This will launch and provision the Domain Controller first, then the Windows client. This step will take a while.
3. Using the VirtualBox GUI showing the Windows client, restart the Windows machine. The logon screen will complain about an incorrect password. Click Ok, then Switch User, and then Other User. You can now login with the domain user `TESTDOMAIN\Administrator` and the password `Password1`.

# Setup a Sample Application
You can setup a sample Spring application to test the environment.

1. From the command line on the host machine and in this project's directory, type `vagrant ssh dc` to connect to the Domain Controller.
2. Run the following commands:

	```
	sudo apt-get install default-jre
	wget http://repo.spring.io/libs-snapshot/org/springframework/security/kerberos/sec-server-spnego-form-auth/1.0.1.BUILD-SNAPSHOT/sec-server-spnego-form-auth-1.0.1.BUILD-20150311.142529-1.jar
	sudo samba-tool user create java-app --random-password
	sudo samba-tool spn add HTTP/dc.testdomain.lan@TESTDOMAIN.LAN java-app
	sudo samba-tool domain exportkeytab spring-sample.keytab --principal HTTP/dc.testdomain.lan@TESTDOMAIN.LAN
	sudo chown vagrant:vagrant spring-sample.keytab
	```
	
	If you get an error stating `Key table entry not found`, try removing the `@TESTDOMAIN.LAN` from the two commands.
	
3. Create a new `application.yml` with these contents:

	```
	server:
		port: 8080
	app:
		service-principal: HTTP/dc.testdomain.lan@TESTDOMAIN.LAN
		keytab-location: spring-sample.keytab
	```
	
4. Run the application with `java -jar sec-server-spnego-form-auth-1.0.1.BUILD-20150311.142529-1.jar`
5. On the Windows client, open the Start Menu and type "Internet Options". Go to the Security tab, click the Internet zone, then click Custom Level. Scroll to the bottom of the list and under User Authentication, select "Automatic logon with current user name and password".
6. Visit [http://dc.testdomain.lan:8080](http://dc.testdomain.lan:8080) in Internet Explorer on the Windows client and click the link. You should be greeted with your username.

#### Note
* You will need to change the Internet Options on the Windows client for each new user you create and test.
* You may need to increase the memory available to the domain controller virtual machine. I have occasionally seen the java process get sacrificed by the OOM Killer.

# Credits
This setup is derived from https://github.com/xnandersson/dcpromo-vagrant.