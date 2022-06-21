## The StackState API-Integration Agent StackPack is installed

### Install API-Integration StackPacks
To install specific API-Integrations have a look at our [StackPacks](/#/stackpacks).

If you want to create your own Topology/ Telemetry checks please read [the docs](https://l.stackstate.com/CJWUEn).

To install more API-Integration Agents follow the instructions below.

### Installation

1. Install the API-Integration Agent using the following sequence of steps:

    **Debian, Ubuntu**
    
    - Download the [Agent Debian package](https://l.stackstate.com/stackstate-agent-1-deb-latest) or run this command on the machine where you wish to install the Agent:
        ```
        wget 'https://l.stackstate.com/stackstate-agent-1-deb-latest'
        ```
    - Install the downloaded package:
        ```
        dpkg -i stackstate-agent_1.3.0-1_amd64.deb
        ```
    
    **Amazon Linux, CentOS, Fedora, Red Hat**
    
    - Download the [Agent RPM package](https://l.stackstate.com/stackstate-agent-1-rpm-latest) or run this command on the machine where you wish to install the Agent:
        ```
        wget 'https://l.stackstate.com/stackstate-agent-1-rpm-latest'
        ```
    - Install the downloaded package:
        ```
        rpm -i stackstate-agent_1.3.0-1.x86_64.rpm
        ```
2. Set the following keys in the stackstate.conf.example file:

    ```
    api_key: {{config.apiKey}}
    dd_url: {{config.baseUrl}}/stsAgent/
    ```

3. Copy the example configuration to use as configuration:

    ```
    cp /etc/sts-agent/stackstate.conf.example /etc/sts-agent/stackstate.conf
    ```

### Uninstall

To uninstall this API-Integration StackPack click **UNINSTALL**. This will remove all configuration to work with API-Integration Agents. The historical data will be preserved.
