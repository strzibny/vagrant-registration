# vagrant-registration

The vagrant-registration plugin supports new capabilities "register" and "unregister." The "register" event occurs during the "up" process, immediately after startup but before any provisioning (including built-in like rsync). The "unregister" event occurs during the "halt" process (which also is called during the "destroy" process) immediately before the instances goes down.

Essentially, this supports developers wanting to use linuxes that have a subscription model for updates, like RHEL.

To use, make sure you have the capabilities registered and your subscription-manager credentials properly configured in your Vagrant file.

## Using

The plugin is still very early alpha, so YMMV. If you try it out, and have problems, please feel free to file an issue. 

* vagrant plugin install vagrant-registration
* configure subscription-manager credentials in your Vagrantfile
* that should be it

### subscription-manager Configuration

vagrant-registration supports all the options of subscription-manager's register command.
You can set any option easily by setting `config.registration.OPTION_NAME = 'OPTION_VALUE'
in your Vagrantfile (please see the subscription-manager's documentation for option
description).

Setting up the credentials can be done as follows:

```ruby
    config.registration.username = 'foo'
    config.registration.password = 'bar'
```

This should go, preferably, into the Vagrantfile in your Vagrant home directory
(defaults to ~/.vagrant.d), to make it available for every project. It can be
later overriden in an individual project's Vagrantfile, if needed.

If you prefer not to store your username and/or password on your filesystem,
you can optionally configure vagrant-registration plugin to use environment
variables, such as:

    config.registration.username = ENV['SUB_USERNAME']
    config.registration.password = ENV['SUB_PASSWORD']

If you do not provide credentials, you will be prompted for them in the "up process." However, this is a tentative feature because if you are launching more than one VM from one Vagrantfile, the feature acts unexepectedly (appearing to hang because the prompt for creds gets lost in the scrollback). 

You can also skip the registration process altogether by setting a `skip` options
to `true`:

    config.registration.skip = true

RHEL Subscription Manager will fail if you attempt to register a registered machine (see the man page for why). In order to not slow boot time, we now, by default, pass the "--force" flag when we try to subscribe. If you want to disable this feature:

    config.registration.force = false 

## Support

Currently, "capabilities" are only provided for Red Hat's Subscription Manager. To add others, one just needs to add a new guest plugin, then a cap directory with register.rb and unregister.rb. See the redhat guest for an example. 
