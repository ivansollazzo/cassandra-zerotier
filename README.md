# Setup a cassandra distributed storage over zerotier VPN

Get the repository

`git clone https://gitlab.com/ciminoV/cassandra-docker.git`

Change directory to repository

`cd cassandra-docker `

Build a custom immage of cassandra with some net utils installed

`docker build -t my-cassandra-build . `

Now you can run the containers via docker-composer

`docker-compose up`

Once everything is up and running, you have to install and configure zerotier inside **zerotier-vpn** container

`docker exec -it zerotier-vpn bash`

From the container download zerotier

`curl https://install.zerotier.com/ | bash`

Run the zerotier daemon

`/usr/sbin/zerotier-one -d`

Join your vpn of choice using zerotier-cli

`/usr/sbin/zerotier-cli join [id]`

You can check wheter you're connected or not listing the networks

`/usr/sbin/zerotier-cli listnetworks`

In order to connect your cassandra nodes with other nodes in the vpn, the zerotier-vpn container has to do the NAT and the port forwarding

`
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
`

`
iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 7000 -j DNAT --to 172.30.0.2:7000
`

`
iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 7000 -j DNAT --to 172.30.0.3:7000
`

`
iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 7000 -j DNAT --to 172.30.0.4:7000
`

Finally, add the the route inside cassandra containers, so that they use zerotier-vpn container as gateway to vpn network 

`ip route add 192.168.195.0/24 via 172.30.0.5`

(in this example my vpn ip addresses are 192.168.195.0/24)
