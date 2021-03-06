#!/bin/bash
# Copyright (C) 2018, Raffaello Bonghi <raffaello@rnext.it>
# All rights reserved
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the above copyright 
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. Neither the name of the copyright holder nor the names of its 
#    contributors may be used to endorse or promote products derived 
#    from this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND 
# CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, 
# BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; 
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
# EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# Set default configuration of git

MODULE_NAME="Set default configuration of git"
MODULE_DESCRIPTION="Set GIT global configuration equal to user.name and user.email"
MODULE_DEFAULT="STOP"
MODULE_OPTIONS=("RUN" "STOP")
MODULE_SUBMENU=("Set user name:set_user_name" "Set email:set_email")

script_run()
{
    echo "Run git configuration"
    # Initialize rosdep
    tput setaf 6
    echo "Install git"
    tput sgr0
    sudo apt install git -y
    
    if [ ! -z ${NEW_GIT_USERNAME+x} ] ; then
        tput setaf 6
        echo "git config --global user.name \"$NEW_GIT_USERNAME\""
        tput sgr0
        git config --global user.name "$NEW_GIT_USERNAME"
    fi
    if [ ! -z ${NEW_GIT_EMAIL+x} ] ; then
        tput setaf 6
        echo "git config --global user.email $NEW_GIT_EMAIL"
        tput sgr0
        git config --global user.email $NEW_GIT_EMAIL
    fi
}

script_load_user()
{
    if dpkg-query -l git > /dev/null; then
		#tput setaf 1
		#echo "Git not installed"
		#tput sgr0
		NEW_GIT_USERNAME=""
    else
        # If is available GIT get name and email
        if [ -z ${NEW_GIT_USERNAME+x} ] ; then
            git --version 2>&1 >/dev/null # improvement by tripleee
            local GIT_IS_AVAILABLE=$?
            if [ $GIT_IS_AVAILABLE -eq 0 ]; then 
                # Default git user name
                NEW_GIT_USERNAME="$(git config user.name)"
            else
                NEW_GIT_USERNAME=""
            fi
        fi
    fi
}

script_load_email()
{
    if dpkg-query -l git > /dev/null; then
		#tput setaf 1
		#echo "Git not installed"
		#tput sgr0
		NEW_GIT_EMAIL=""
    else
        # If is available GIT get name and email
        if [ -z ${NEW_GIT_EMAIL+x} ] ; then
            git --version 2>&1 >/dev/null # improvement by tripleee
            local GIT_IS_AVAILABLE=$?
            if [ $GIT_IS_AVAILABLE -eq 0 ]; then 
                # Default git user name
                NEW_GIT_EMAIL="$(git config user.email)"
            else
                NEW_GIT_EMAIL=""
            fi
        fi
    fi
}

script_load_default()
{
    script_load_user 
    script_load_email
}

script_save()
{
    if [ ! -z ${NEW_GIT_USERNAME+x} ] && [ ! -z $NEW_GIT_USERNAME ] ; then
        # if [ NEW_GIT_USERNAME != $(git config user.name) ] ; then
        echo "NEW_GIT_USERNAME=\"$NEW_GIT_USERNAME\"" >> $1
        # fi
    fi
    if [ ! -z ${NEW_GIT_EMAIL+x} ] && [ ! -z $NEW_GIT_EMAIL ] ; then
        echo "NEW_GIT_EMAIL=\"$NEW_GIT_EMAIL\"" >> $1
    fi
}

script_info()
{
    if [ ! -z ${NEW_GIT_USERNAME+x} ] ; then
        if [ $NEW_GIT_USERNAME != "$(git config user.name)" ] ; then
            echo " - Git user.name=\"$NEW_GIT_USERNAME\""
        fi
    fi
    if [ ! -z ${NEW_GIT_EMAIL+x} ] ; then
        if [ $NEW_GIT_EMAIL != "$(git config user.email)" ] ; then
            echo " - Git user.email=\"$NEW_GIT_EMAIL\""
        fi
    fi
}

set_user_name()
{
    local NEW_GIT_USERNAME_TMP_VALUE
    NEW_GIT_USERNAME_TMP_VALUE=$(whiptail --inputbox "$MODULE_NAME - Set user name" 8 78 $NEW_GIT_USERNAME --title "Set user.name" 3>&1 1>&2 2>&3)
    local exitstatus=$?
    if [ $exitstatus = 0 ] ; then
        # Write the new workspace
        NEW_GIT_USERNAME=$NEW_GIT_USERNAME_TMP_VALUE
    fi
}

set_email()
{
    local NEW_GIT_EMAIL_TMP_VALUE
    NEW_GIT_EMAIL_TMP_VALUE=$(whiptail --inputbox "$MODULE_NAME - Set user email" 8 78 $NEW_GIT_EMAIL --title "Set user.email" 3>&1 1>&2 2>&3)
    local exitstatus=$?
    if [ $exitstatus = 0 ]; then
        # Write the new workspace
        NEW_GIT_EMAIL=$NEW_GIT_EMAIL_TMP_VALUE
    fi
}


