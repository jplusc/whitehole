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
cat "${PIHOLE_LOCATION}"/whitelist.tmp | sort -f -u >> "${PIHOLE_LOCATION}"/whitelist.txt
rm "${PIHOLE_LOCATION}"/whitelist.tmp 2> /dev/null

echo -e "  [ ] Pi-hole gravity rebuilding lists. This may take a while... "
${GRAVITY_UPDATE_COMMAND} 
 
echo -e "  [ ] Pi-hole's gravity updated. "
echo -e "  [✓] Done. "





