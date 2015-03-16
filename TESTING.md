# Testing end development

## Requirements
The testing environment requires Vagrant to be installed.

## Architecture
The testing environment contains:
  * A log server (10.0.0.100)
  * 3 log clients (10.0.0.21|22|23)

To support the the environment there is a additional puppet module named `syslog_ng_testing`. It provides a script called `loggen.py` that can generate random log messages.
See `puppet/manifests/site.pp` for the setup of the machines.

## Setup
To use the testing environment you have to bring up the virtual machines. Typically 
 ```bash
    vagrant up
 ```
should be enough.
NOTE: Currently it seems that the `syslog-ng` package is broken on Ubuntu 14.04 and you will receive some errors from puppet. You may want to run `vagrant privision` on each machine again.

Howenver, you may want to start and provision the virtual machines one-by-one
 ```bash
    vagrant up -no-provision logclient_1
    vagrant provision logclient_1
    vagrant up -no-provision logclient_2
    vagrant provision logclient_2
    vagrant up -no-provision logclient_3
    vagrant provision logclient_3
    vagrant up -no-provision logserver
    vagrant provision logserver
 ```
Now log into one of the log clients and run the log generator
 ```bash
    vagrant ssh logclient_1
    loggen.py
 ```
This will create some logs that are transported to the log server. You may check this by logging into the log server.
 ```bash
    vagrant ssh logserver
    cd /var/log/myapp
    sudo tail -f myapp.log
 ```
All 3 log clients come with a different configuration for the loggen.py script.
