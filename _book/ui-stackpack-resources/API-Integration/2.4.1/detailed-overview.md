#### Starting and Stopping the API-Integration Agent
To manually start the API-Integration Agent:

```
sudo /etc/init.d/stackstate-agent start
```

To stop the Agent:

```
sudo /etc/init.d/stackstate-agent stop
```

To restart the Agent and to reload the configuration files:

```
sudo /etc/init.d/stackstate-agent restart
```

#### Status and Information

To check if the API-Integration Agent is running:

```
sudo /etc/init.d/stackstate-agent status
```

To receive information about the API-Integration Agent's state:

```
sudo /etc/init.d/stackstate-agent info
```

Tracebacks for errors can be retrieved by setting the -v flag:

```
sudo /etc/init.d/stackstate-agent info -v
```

[comment]: # (split)

#### Configuration

The configuration file for the API-Integration Agent is located in `/etc/sts-agent/stackstate.conf`

Configuration files for integrations are located in `/etc/sts-agent/conf.d/`

#### Troubleshooting

Try running the info command to see the state of the API-Integration Agent.

Logs for the subsystems are in the following files:

```
/var/log/stackstate/supervisord.log
/var/log/stackstate/collector.log
/var/log/stackstate/stsstatsd.log
/var/log/stackstate/forwarder.log
```

If you're still having trouble, our [support team](https://support.stackstate.com/hc/en-us) will be glad to provide further assistance.
