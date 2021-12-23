---
description: StackState Self-hosted v4.5.x
---

# Prepare a multi-instance provisioning script


A multi-instance StackPack requires a provisioning script that is able to provision multiple StackPack instances. To achieve that, you need to provide a separate template file in the context for both `stackPack` and `instance`; `stackPack` needs to be provided with the `shared-template.stj`, and `instance` requires the `instance-template.stj` as in the example below:

Note that `instance-template.stj` has some instance specific information, like `topicName`, `instanceId` and anything else defined in `templateArguments`, while `shared-template` passes without any specifics \(`[:]`\).

```text
import com.stackstate.stackpack.ProvisioningScript
import com.stackstate.stackpack.ProvisioningContext
import com.stackstate.stackpack.ProvisioningIO
import com.stackstate.stackpack.Version

class Provision extends ProvisioningScript {

  Provision(ProvisioningContext context) {
      super(context)
  }

  @Override
  ProvisioningIO<scala.Unit> install(Map<String, Object> config) {
    def instance_url = instanceURL(config)
    def templateArguments = [
                'topicName': topicName(config),
                'instance_url': instance_url,
                'instanceId': context().instance().id()
                ]
    templateArguments.putAll(config)

    return context().stackPack().importSnapshot("templates/shared-template.stj", [:]) >>
           context().instance().importSnapshot("templates/instance-template.stj", templateArguments)
  }

  @Override
  ProvisioningIO<scala.Unit> upgrade(Map<String, Object> config, Version current) {
    return install(config)
  }

  @Override
  void waitingForData(Map<String, Object> config) {
    context().sts().onDataReceived(topicName(config), {
      context().sts().provisioningComplete()
    })
  }

  private def topicName(Map<String, Object> exampleConfig) {
    def instance_url = exampleConfig.test_instance_url
    def topic = instance_url.replace("/", "_").replace(":", "_")
    return context().sts().createTopologyTopicName("example", topic)
  }

  private def instanceURL(Map<String, Object> exampleConfig) {
      def url = exampleConfig.test_instance_url
      def instance_url = ''
      if (url.startsWith('http') || url.startsWith('https')){
        instance_url = url.split("//")[1].split("/")[0]
      }
      else{
        instance_url = url.split("/")[0]
      }
      return instance_url
  }

}
```

The last step is to [prepare a StackPack `.sts` package and upload it to StackState.](prepare_multi-instance_provisioning_script.md)

