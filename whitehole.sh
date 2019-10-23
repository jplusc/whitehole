#!/bin/bash
# pi-hole whitelist updater
#
# This script will download fresh copies of the whitelist domains and add them
# to your existing whitelists and recompile gravity.
#
# existing manually added whitelisted domains will not be lost
#
# Project homepage: https://github.com/jplusc/whitehole
# Licence: MIT https://github.com/jplusc/whitehole/blob/master/LICENSE
# based on Anudeep's work (https://raw.githubusercontent.com/anudeepND/whitelist/master/scripts/whitelist.sh)
#================================================================================

# edit these to fit your needs
# these are the default for a Raspbian install of pi-hole on a pi
PIHOLE_LOCATION="/etc/pihole"
GRAVITY_UPDATE_COMMAND="pihole -g"
#✓


echo -e "  [ ] Downloading new whitelists.... "
rm "${PIHOLE_LOCATION}"/whitelist.new 2> /dev/null
cp "${PIHOLE_LOCATION}"/whitelist.txt "${PIHOLE_LOCATION}"/whitelist.txt.old 
# grep -o '^[^#]*' to remove comments and extra lines
curl -sS https://raw.githubusercontent.com/jplusc/whitehole/master/whitelist.txt | grep -o '^[^#]*' >> "${PIHOLE_LOCATION}"/whitelist.new
curl -sS https://raw.githubusercontent.com/anudeepND/whitelist/master/domains/whitelist.txt | grep -o '^[^#]*' >> "${PIHOLE_LOCATION}"/whitelist.new

echo -e "  [ ] Adding domains to whitelist... "
cat "${PIHOLE_LOCATION}"/whitelist.new >> "${PIHOLE_LOCATION}"/whitelist.txt
rm "${PIHOLE_LOCATION}"/whitelist.new 2> /dev/null

echo -e "  [ ] Removing duplicates... "
mv "${PIHOLE_LOCATION}"/whitelist.txt "${PIHOLE_LOCATION}"/whitelist.tmp 
# the "awk '{$1=$1;print}'" is to remove any leading or trailing whitespace so the will be properly de-duped.
# I don't fully understand why the tee is needed, but I can't get permission to write to whitelist.txt on output of
# sort even if I toss a sudo before it (which I don't want to do anyway)
#cat "${PIHOLE_LOCATION}"/whitelist.tmp | awk '{$1=$1;print}' | sort -f -u > "${PIHOLE_LOCATION}"/whitelist.txt
cat "${PIHOLE_LOCATION}"/whitelist.tmp | awk '{$1=$1;print}' | sort -f -u | tee -a "${PIHOLE_LOCATION}"/whitelist.txt > /dev/null
rm "${PIHOLE_LOCATION}"/whitelist.tmp 2> /dev/null

echo -e "  [ ] Pi-hole gravity rebuilding lists. This may take a while... "
${GRAVITY_UPDATE_COMMAND} 
 
echo -e "  [ ] Pi-hole's gravity updated. "
echo -e "  [✓] Done. "





