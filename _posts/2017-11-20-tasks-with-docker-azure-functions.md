---
layout: post
title: "Running tasks with Docker and Azure Functions"
tags:
- azure
- docker
---

Months ago Microsoft announced [Azure Container
Instances](https://docs.microsoft.com/en-us/azure/container-instances/) (ACI), which
allow for rapidly provisioning containers "in the cloud." When they were first
announced, I played around with them for a bit, before realizing that the
pricing for running a container "full-time" was almost 3x what it would cost to
deploy that container on an equitable Standard A0 virtual machine. Since then
however, Azure has added support for a "Never" restart policy, which opens the
door for using Azure Container Instances for [arbitrary task
execution](https://docs.microsoft.com/en-us/azure/container-instances/container-instances-restart-policy).


The ability to quickly run arbitrary containerized tasks is a really exciting
feature. Any Ruby, Python, JavaScript, script that I can package into a Docker
container I can kick out to Azure Container Instances in seconds, and pay by
the second of runtime. **Very** exciting, but it's not practical for me to
always have the Azure CLI at the ready to execute something akin to:

```
az container create \
    --resource-group myResourceGroup \
    --name mycontainer \
    --image rtyler/my-silly-container:latest \
    --restart-policy Never
```

Fortunately, Microsoft publishes a number of client libraries for Azure,
including a Node.js one.  This is where introducing [Azure
Functions](https://docs.microsoft.com/en-us/azure/azure-functions/) can help
make Azure Container Instances really _shine_.  Similar to AWS Lambda, or
Google Cloud Functions, Azure Functions provide a light-weight computing
environment for running teeny-tiny little bits of code, typically JavaScript,
"in the cloud."


This past weekend I had an arguably good argument for combining the two in a
novel fashion: launching a (containerized) script every ten minutes.

The expensive and old fashioned way to handle this would be to just deploy a
small VM, add a crontab entry, and spend the money to keep that machine online
for what equates to approximately 6 hours of work throughout the month.

* Standard A0 virtual machine monthly cost: $14.64
* Azure Container Instance, for 6 hours a month, cost: $0.56

In this blog post I won't go too deeply into the creation of an Azure Function,
but I will focus on the code which actually provisions an Azure Container
Instance from Node.js.

### Prerequisites

In order to provision resources in Azure, we must first create the Azure
credentials objects necessary. For better or worse, Azure builds on top of
Azure Active Directory which offers an absurd amount of role-based access
controls and options. The downside of that flexibility is that it's supremely
awkward to get simple API tokens set up for what seem like otherwise mundane
tasks.

To provision resources, we will need an "Application", "Service Principal", and
"Secret". The instructions below will use the Azure CLI:

* `openssl rand -base64 24` will generate a good "client secret" to use.
* `az ad app create --display-name MyAppName --homepage http://example.com/my-app --identifier-uris http://example.com/my-app --password $CLIENT_SECRET` creates the Azure Active Directory Application, mind the "App ID" (aka client ID).
* `az ad sp create --id $CLIENT_ID` will create a Service Principal.
* And finally, I'll assign a role to that Service Principal: `az role assignment create --assignee http://example.com/my-app --role Contributor --scope /subscriptions/$SUBSCRIPTION)_ID/resourceGroups/my-apps-resource-group`.

In these steps, I've isolated the Service Principal to a specific Resource
Group (`my-apps-resource-group`) to keep it away from other resources, but also
to make it easier to monitor costs.

A number of these variables will be set in the Azure Function "Application
Settings" to enable my JavaScript function to authenticate against the Azure
APIs.


### Accessing Azure from Azure

Writing the JavaScript to actually launch a container instance was a little
tricky, as I couldn't find a single example in the [azure-arm-containerinstance
package](https://github.com/Azure/azure-sdk-for-node/tree/master/lib/services/containerinstanceManagement).

In the "Codes" section below is the entire Azure Function, but the only major
caveat is that in my example I've "hacked" the `apiVersion` which is used when
accessing the Azure REST APIs, as the current package hits an API which doesn't
support the "Never" restart policy for the container.

With the Azure SDK for Node, authenticating properly, it's feasible to do all
kinds of interesting operations in Azure, creating, updating, or deleting
resources based on specific triggers from Azure Functions.

### Future Possibilities

The code below is among the most simplistic use-cases imaginable for
combining Azure Functions and Azure Container Instances. Thinking more broadly,
one could conceivably trigger short-lived containers 'on-demand" in response to
messages coming from Event Hub, or even inbound HTTP requests from another user
or system. Imagine, for example, if you wanted to provide a quick demo of some
application to new users on your website. One Azure Function provisioning
containers for specific users, and another periodically reaping any containers
which have been running past their timeout, would be both cheap and easily
deployed.

I still wouldn't use Azure Container Instances for any "full-time" workload,
their pricing model is fundamentally flawed for those kinds of tasks. If you
have workloads which are run for only seconds, minutes, or hours at a time,
they make a *lot* more sense, and with Azure Functions, are cheaply and easily
orchestrated.


### Codes

---

**2017-12-05 update**: corrected the following code to delete any previously
existing container group, to more effectively emulate a "cron."

---

**index.js**

```
module.exports = function (context) {
    const ACI   = require('azure-arm-containerinstance');
    const AZ    = require('ms-rest-azure');

    context.log('Starting a container');

    AZ.loginWithServicePrincipalSecret(
        process.env.AZURE_CLIENT_ID,
        process.env.AZURE_CLIENT_SECRET,
        process.env.AZURE_TENANT_ID,
        (err, credentials) => {
            if (err) {
                throw err;
            }
            let client = new ACI(credentials, process.env.AZURE_SUBSCRIPTION_ID);

            /* First delete the previous existing container group if it exists */
            client.containerGroups.deleteMethod(group, containerGroup).then((r) => {
                context.log('Delete completed', r);
                let container = new client.models.Container();
                context.log('Launching a container for client', client);

                container.name = 'twitter-processing';
                container.environmentVariables = [
                    {
                        name: 'SOME_ENV_VAR',
                        value: process.env.SOME_ENV_VAR
                    }
                ];
                container.image = 'my-fancy-image-name:latest';
                container.ports = [{port: 80}];
                container.resources = {
                    requests: {
                        cpu: 1,
                        memoryInGB: 1
                    }
                };

                context.log('Provisioning a container', container);
                client.containerGroups.createOrUpdate(group, containerGroup,
                    {
                        containers: [container],
                        osType: osType,
                        location: region,
                        restartPolicy: 'never'
                    }
                ).then((r) => {
                    context.log('Launched:', r);
                    context.done();
                }).catch((r) => {
                    context.log('Finished up with error', r);
                    context.done();
                });
        });
    });
};
```

**package.json**

```
{
  "name": "foobar-processing",
  "version": "0.0.1",
  "description": "Timer-triggered function for running an Azure Container Instance",
  "main": "index.js",
  "author": "R Tyler Croy",
  "dependencies": {
    "azure-arm-containerinstance": "^1.0.0-preview"
  }
}
```
**function.json**

```
{
  "disabled": false,
  "bindings": [
    {
        "direction": "in",
        "schedule": "0 */10 * * * *",
        "name": "tenMinuteTimer",
        "type": "timerTrigger"
    }
  ]
}
```
