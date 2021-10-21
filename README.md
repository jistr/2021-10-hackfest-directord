Vagrant-libvirt environment for directord hackfest
==================================================

**Note: Due to permissions issues Vagrant/Libvirt can only create the
additional private network when running as root. It is recommended to
execute the Vagrant environment on some lab machine as root.**

**Note2**: If you have Vagrant installed locally, you don't have to use
the toolbox container, you can simply skip to `cd vagrant;
./vagrant-up`. However, if your lab machine is running CentOS, it
likely doesn't have Vagrant-libvirt easily installable (it doesn't
ship with the distro or with EPEL). That's when the toolbox container
comes in handy.

**Note3**: This tool was prepared in half a day by amending the Vagrant
setup we have for OS Migrate. Please adjust your expectations
accordingly. :)

**Note4**: If you are not familiar with Vagrant, you may want to look at
[Vagrant docs](https://www.vagrantup.com/docs/cli).

Starting the toolbox container
------------------------------

You need to have Libvirt up and running. After cloning the repo, cd
into it and run:

```
./vagrant-toolbox-create
```

This will start a containerized bash session with Vagrant
available.

It may be a good idea to `dnf -y install tmux` and run `tmux` within
the toolbox bash session, to get easily multiple shells within the
container.

After closing the session, the toolbox container remains running. To
start another bash session within the existing container, run:

```
./vagrant-toolbox-exec
```

Creating and removing the hackfest VMs
--------------------------------------

This is run either from the toolbox container shell, or can be run
from the host if you have Vagrant installed on the host.

```
cd vagrant
./vagrant-up
```

To destroy the VMs:

```
# cd vagrant
./vagrant-destroy
```

Snapshotting
------------

To snapshot the VMs state (snapshot name defaults to "clean"):

```
./vagrant-snapshot-create [snapshot name]
```

To revert to the snapshotted state:

```
./vagrant-snapshot-revert [snapshot name]
```

To delete snapshots:

```
./vagrant-snapshot-delete [snapshot name]
```

Some initial setup beyond Vagrant
---------------------------------

Mutual ssh between node0 and node1:

```
# cd vagrant

ssh-keygen -N '' -b 4096 -f env/hackfest_id_rsa -C hackfest_id_rsa

cat env/hackfest_id_rsa.pub | ssh -F env/ssh-config node0 'tee -a ~/.ssh/authorized_keys'
cat env/hackfest_id_rsa.pub | ssh -F env/ssh-config node1 'tee -a ~/.ssh/authorized_keys'

cat env/hackfest_id_rsa | ssh -F env/ssh-config node0 'tee ~/.ssh/id_rsa' > /dev/null
cat env/hackfest_id_rsa | ssh -F env/ssh-config node1 'tee ~/.ssh/id_rsa' > /dev/null

ssh -F env/ssh-config node0 'chmod 0600 ~/.ssh/id_rsa'
ssh -F env/ssh-config node1 'chmod 0600 ~/.ssh/id_rsa'

# populate known-hosts
ssh -F env/ssh-config node0 'ssh -o StrictHostKeyChecking=no node0 true'
ssh -F env/ssh-config node0 'ssh -o StrictHostKeyChecking=no node1 true'
ssh -F env/ssh-config node1 'ssh -o StrictHostKeyChecking=no node0 true'
ssh -F env/ssh-config node1 'ssh -o StrictHostKeyChecking=no node1 true'
```

Alternative approach that does not need generating a new key: [https://gist.github.com/philroche/546eee987105a5e0cf11e6718db918ab](https://gist.github.com/philroche/546eee987105a5e0cf11e6718db918ab).
