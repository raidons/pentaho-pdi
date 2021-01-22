#!/bin/bash

# Sets script to fail if any command fails.
set -e

set_xauth() {
	echo xauth add $DISPLAY . $XAUTH
	touch /.Xauthority
	xauth add $DISPLAY . $XAUTH
}

custom_properties() {
	if [ -f /jobs/kettle.properties ] ; then
		cp /jobs/kettle.properties $KETTLE_HOME/.kettle
	fi
	if [ -f /jobs/jdbc.properties ] ; then
		cp /jobs/jdbc.properties $KETTLE_HOME/simple-jndi/jdbc.properties
	fi
}

run_pan() {
	custom_properties
	echo ./pan.sh -file $@
	pan.sh -file /jobs/$@
}

run_kitchen() {
	./mountgs.sh
	custom_properties
	echo ./kitchen.sh -file $@
	kitchen.sh -file /jobs/$@
}

run_spoon() {
	custom_properties
	set_xauth
	echo /data-integration/spoon.sh
	/data-integration/spoon.sh
}

print_usage() {

echo "
Usage:	$0 COMMAND
Pentaho Data Integration (PDI)
Options:
  runj filename		Run job file
  runt filename		Run transformation file
  spoon				Run spoon (GUI)
  help		        Print this help
"
}

case "$1" in
    help)
        print_usage
        ;;
    runt)
	shift 1
        run_pan "$@"
        ;;
    runj)
	shift 1
        run_kitchen "$@"
        ;;
    spoon)
	    run_spoon
        ;;
    *)
        exec "$@"
esac