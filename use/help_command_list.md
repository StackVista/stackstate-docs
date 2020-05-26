---
name: Unix - useful command list
type: documentation
---

# help\_command\_list

StackState requires some actions on the OS side when it comes to set up and configuration processes. Below there is a list of the most useful of these commands.

* `sudo -u stackstate-agent -- stackstate-agent status` -- outputs agent's status as well as status of all checks for that agent.
* `sudo service stackstate-agent restart` -- restarts the agent service
* `sudo /etc/init.d/stackstate-agent info` -- outputs information and logs for checks running with that agent
* `systemctl stop stackstate` -- stops StackState nodes
* `systemctl stop stackgraph` -- stops StackGraph nodes
* `systemctl start stackstate` -- starts StackState nodes
* `systemctl start stackgraph` -- starts StackGraph nodes
* `rpm -i <stackstate>.rpm` -- starts installation process that uses `.rpm` files
* `dpkg -i <stackstate>.deb` -- starts installation process that uses `.deb` files

