#!/bin/bash
add-apt-repository ppa:niklas-andersson/dcpromo
apt-get update
debconf-set-selections /vagrant/dcpromo.debconf
apt-get install dcpromo
dcpromo
shutdown -r now
