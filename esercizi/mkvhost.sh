#!/bin/bash

# Your company provides web hosting service to customers, and you have been tasked with writing 
# a Bash shell script called /usr/local/sbin/mkvhost to automate the many steps involved in 
# setting up an Apache name-based virtual host for your customers. The script will be used for 
# virtual host creation on all servers going forward, so it needs to also be able to accommodate 
# the one-time tasks that are executed the first time a new server is configured for name-based 
# virtual hosting.
#
# The script will take two arguments. The first argument will be the fully qualified domain name of the 
# new virtual host. The second argument will be a number between 1 and 3, which represents the support tier 
# that the customer purchased. The support tier determines the support email address, which will be set with 
# the Apache ServerAdmin directive for the virtual host.

# The script will create a configuration file under /etc/httpd/conf.vhosts.d with the name 
# <VIRTUALHOSTNAME>.conf for each virtual host. It will also create a document root directory for the virtual 
# host at /srv/<VIRTUALHOSTNAME>/www. Prior to creating the virtual host configuration file and document root 
# directory, the script will check to make sure they do not already exist to ensure there will not be a conflict.

# echo "127.0.0.1 www.pippo.com" >> /etc/hosts
# curl www.pippo.com

# Variables
VHOSTNAME=$1
TIER=$2

HTTPDCONF=/etc/httpd/conf/httpd.conf
VHOSTCONFDIR=/etc/httpd/conf.vhosts.d
DEFVHOSTCONFFILE=$VHOSTCONFDIR/00-default-vhost.conf
VHOSTCONFFILE=$VHOSTCONFDIR/$VHOSTNAME.conf
WWWROOT=/srv
DEFVHOSTDOCROOT=$WWWROOT/default/www
VHOSTDOCROOT=$WWWROOT/$VHOSTNAME/www

# Check arguments
if [ "$VHOSTNAME"  = '' ] || [ "$TIER" = '' ]; then
	echo "Usage: $0 VHOSTNAME TIER"
	exit 1
else
	# Set support email address
	case $TIER in

	1)      VHOSTADMIN='basic_support@example.com'
        ;;
	2)      VHOSTADMIN='business_support@example.com'
        ;;
	3)      VHOSTADMIN='enterprise_support@example.com'
        ;;
	*)      echo "Invalid tier specified."
        exit 1
	;;
	esac
fi

# Verify if the default virtual host document root directory already exists
if [ ! -d $DEFVHOSTDOCROOT ]; then
        mkdir -p $DEFVHOSTDOCROOT
        restorecon -Rv $WWWROOT
fi
# Verify if the default virtual host config  directory already exists
if [ ! -d $VHOSTCONFDIR ]; then
        mkdir -p $VHOSTCONFDIR
        restorecon -Rv $VHOSTCONFDIR
fi

# Add include one time if missing
grep -q '^IncludeOptional conf\.vhosts\.d/\*\.conf$' $HTTPDCONF

if [ $? -ne 0 ]; then
        # Backup before modifying
	cp -a $HTTPDCONF $HTTPDCONF.orig
        echo "IncludeOptional conf.vhosts.d/*.conf" >> $HTTPDCONF

        if [ $? -ne 0 ]; then
                echo "ERROR: Failed adding include directive."
                exit 1
	fi
fi

# Check for default virtual host

if [ ! -f $DEFVHOSTCONFFILE ]; then
	cat <<DEFCONFEOF > $DEFVHOSTCONFFILE
<VirtualHost _default_:80>
   DocumentRoot $DEFVHOSTDOCROOT
   CustomLog "logs/default-vhost.log" combined
</VirtualHost>

<Directory $DEFVHOSTDOCROOT>
   Require all granted
</Directory>
DEFCONFEOF

fi


# Check for virtual host conflict
if [ -f $VHOSTCONFFILE ]; then
        echo "ERROR: $VHOSTCONFFILE already exists."
        exit 1
elif [ -d $VHOSTDOCROOT ]; then
        echo "ERROR: $VHOSTDOCROOT already exists."
	exit 1
else
	cat <<CONFEOF > $VHOSTCONFFILE
<Directory $VHOSTDOCROOT>
  Require all granted
  AllowOverride None
</Directory>
<VirtualHost *:80>
  DocumentRoot $VHOSTDOCROOT
  ServerName $VHOSTNAME
  ServerAdmin $VHOSTADMIN
  ErrorLog "logs/${VHOSTNAME}_error_log"
  CustomLog "logs/${VHOSTNAME}_access_log" common
</VirtualHost>
CONFEOF
	mkdir -p $VHOSTDOCROOT
	restorecon -Rv $WWWROOT
	cat <<INDEXHTMLEOF > $VHOSTDOCROOT/index.html
<H1>LAB - ENHANCING BASH SHELL SCRIPTS WITH CONDITIONALS AND CONTROL STRUCTURES</H1>
INDEXHTMLEOF
	chown -R apache $WWWROOT
fi

# Check config and reload
apachectl configtest &> /dev/null

if [ $? -eq 0 ]; then
        systemctl reload httpd &> /dev/null
else
        echo "ERROR: Config error."
	exit 1
fi