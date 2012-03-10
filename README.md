## DESCRIPTION:

Cookbook for installing [Eucalyptus](http://open.eucalyptus.com/) 2.0.3 cloud controller, node controllers, walrus, and storage controllers.  Still very much a work in progress, but also very much worth releasing imo, since the Eucalyptus install is such a huge and tedious undertaking and this cookbook zaps the most tedious parts.  Hopefully this helps.  I've only tested this on Debian 6.0.4, with a setup of One machine as a CC/CLC, one machine as a Walrus and Storage Controller, and serveral machines as compute nodes.

This is more or less a step by step conversion of the Eucalyptus setup documentation into a cookbook.  It uses the Eucalyptus "managed" networking feature, which is the most full featured of the networking options.

### Things that have to be done manually

#### Before running this cookbook:

  * Setting up a network bridge on compute nodes.  (TODO)

#### After running this cookbook successfully:

  * You *might* need to manually register Eucalyptus components on CLC.  I've set these up as LWRPs which will run after setup is complete (but they all ignore failure), but I haven't seen it work consistently.  Seems like you've got to go to https://your-cloud-controller.example.com:8443/, register thru the web interface (default login/password is admin/admin), and then on the cloud controller use the `euca_conf` tool to register your nodes, storage controller, and walrus(es).  You may be able to just register these thru the web interface as well.
  * Getting your Eucalyptus credentials.  (Get get the zip file thru the web interface)
  * Check if everything is good.  As root on the CC, run:  `euca_conf --get-credentials euca.zip && unzip euca.zip && source eucarc && euca-describe-availability-zones verbose`.  You should see numbers that are not "0" under "free / max" in the output.
  * To run instances, you'll need to register some EMIs. [Registering and uploading EMIs](http://open.eucalyptus.com/wiki/EucalyptusImageManagement_v2.0)

## REQUIREMENTS:
  
  * The only requirements that aren't specific depends in the metadata are a setup of either kvm or xen on the compute nodes.  I have a kvm cookbook at http://github.com/natlownes/kvm-cookbook , which should be run before `recipe[eucalyptus::node_controller_install]`
  * Debian 6 on all machines.  May very well work on Ubuntu, but I've only tested and used this on Debian.
  * All physical machines on the same ethernet.

## USAGE:
    
Please note the "eucalyptus" role, which should contain your specific config  ([see this example](https://gist.github.com/2012056)).    

*  Example of a run list on a cloud controller:  
   `role[eucalyptus],
    recipe[eucalyptus::cloud_controller_install]
       `
*  Example of a run list on a compute node:
   `role[eucalyptus],
    recipe[kvm],
    recipe[eucalyptus::node_controller_install]
   `

**Warning:** root's private and public keys get clobbered on all machines involved.

## ATTRIBUTES:
  
  Default attributes are in `attributes/default.rb` - you'll need to change these to be relevant to your setup.  I use a "eucalyptus" role to hold my config.  [see this example](https://gist.github.com/2012056)

## TODO: 

* More LWRPs for euca specific tasks
* **On nodes**
  * load/reload loop module to have max_loop >= 32
  * add /etc/network/interfaces and kick interface
  * ntp sync with cc - this is important.  if this gets out of sync with the cc the cc will drop the node
* **On cloud controller**
  * automatically register all components
    * I don't know what the fuck is up with this, can't get this to happen in the recipe, but can get it setup manually after logging into the web interface.
    * leaving them as they are in `cloud_controller_registration` recipe since they ignore failure right now anyway, but may work for someone
  * also seeing some weird shit wwhere sometimes the `/var/run/eucalyptus/jsp` and `/var/run/eucalyptus/webapp` directories need to be `rm -rf'd` and /etc/init.d/eucalyptus-cloud restarted.  This condition seems to manifest itself as seeing a directory listing at  https://your-cloud-controller.example.com:8443/
  * run ntp server for components

* **Uncategorized**
  * download and register some example images?  This is tedious as fuck as well.

## CONTRIBUTING:

Yes please, especially in the LWRP since I don't know what I'm doing.

## NOTES:
  
* Haven't gotten the CLC/CC managed networking setup to work on a VirtualBox VM for testing.  Everything appears to work on the VM but the public IPs don't actually allow traffic to the instances.  Works fine on real machine.
* Can use Vagrant to bring up test nodes if using kvm as a hypervisor.  Useful for testing.
  
