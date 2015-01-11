#!/bin/bash

# Default control groups

DOMAIN_LOGIN='SKYNET Linux LOGIN'
DOMAIN_REMOTE='SKYNET Linux REMOTE'

DOMAIN_ADMIN='SKYNET\x20Linux\x20ADMIN'

####################################################################################################
# PAM login SETUP

echo "### DOMAIN AUTH FOR [login] ###

## COMMON AUTH
@include common-auth

# CHECK IF USER IS LOCAL
auth	[success=2 default=ignore]	pam_localuser.so

# CHECK IF USER IN SPECIFIC DOMAN GROUP
auth	[success=1 default=ignore]	pam_succeed_if.so quiet user ingroup [$DOMAIN_LOGIN]

## Fallback DENY
auth	requisite			pam_deny.so" > /etc/pam.d/DOMAIN-login

sed 's/\#\ Standard\ Un\*x\ authentication./\#\ Domain\ authentication./g;s/@include\ common-auth/@include\ DOMAIN-login/g' -i /etc/pam.d/login

####################################################################################################
# PAM ssh SETUP

echo "### DOMAIN AUTH FOR [sshd] ###

## COMMON AUTH
@include common-auth

# CHECK IF USER IS LOCAL
auth	[success=2 default=ignore]	pam_localuser.so

# CHECK IF USER IN SPECIFIC DOMAN GROUP
auth	[success=1 default=ignore]	pam_succeed_if.so quiet user ingroup [$DOMAIN_REMOTE]

## Fallback DENY
auth	requisite			pam_deny.so" > /etc/pam.d/DOMAIN-sshd

sed 's/\#\ Standard\ Un\*x\ authentication./\#\ Domain\ authentication./g;s/@include\ common-auth/@include\ DOMAIN-sshd/g' -i /etc/pam.d/sshd 

####################################################################################################
# SUDOERS 
echo "# Grant linux admins all rights
%$DOMAIN_ADMIN ALL=(ALL) ALL" > /etc/sudoers.d/linux-admins

####################################################################################################
echo "Done!"
