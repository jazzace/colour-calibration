#!/bin/sh
#
# configure_display_profiles.sh
# Written by Tim Sutton; adapted for IAML use
#
# Very simple helper script to run the customdisplayprofiles tool to
# set profiles stored in a known folder location, with subfolders named
# by display index, like in the sample structure below. The icc file itself
# is given only by a shell wildcard, but the tool will only take the first
# argument.
#
# This would allow someone calibrating a display to configure a profile
# for all users simply by copying the profile to the correct folder
# and ensuring it's the only file in this folder.
#
# This script would typically be run at login using a LaunchAgent.
# The IAML will use Outset to run it (login-every).
#
# Sample folder hierarchy:
#
# /Library/ColorSync/Profiles/Custom
# ├── 1
# │   └── Custom Profile 1.icc
# └── 2
#     └── Custom Profile 2.icc


PROFILES_DIR=/Library/ColorSync/Profiles/Custom
TOOL_PATH=/usr/local/bin/customdisplayprofiles

for DISPLAY_INDEX in $(ls "${PROFILES_DIR}"); do
    echo "Setting profile for display $DISPLAY_INDEX..."
    $TOOL_PATH set --display $DISPLAY_INDEX "$PROFILES_DIR/$DISPLAY_INDEX"/*
done
