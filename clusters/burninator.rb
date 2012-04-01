#
# Burninator cluster -- populate an AMI with installed software, but no
# services, users or other preconceptions.
#
# The script /tmp/burn_ami_prep.sh will help finalize the machine -- then, just
# stop it and invoke 'Create Image (EBS AMI)'.
#
Ironfan.cluster 'burninator' do
  cloud(:ec2) do
    defaults
    availability_zones ['eu-west-1a']
    # use a c1.xlarge so the AMI knows about all ephemeral drives
    flavor              'c1.xlarge'
    backing             'ebs'
    # image_name is per-facet here
    bootstrap_distro    'ubuntu12.04-ironfan'
    chef_client_script  'client.rb'
    mount_ephemerals
  end

  environment           :development

  role                  :chef_client
  role                  :ssh

  # It's handy to have the root volumes not go away with the machine.
  # It also means you can find yourself with a whole ton of stray 8GB
  # images once you're done burninatin' so make sure to go back and
  # clear them out
  volume(:root).keep    true

  #
  # A throwaway facet for AMI generation
  #
  facet :trogdor do
    instances           1

    cloud.image_name    'precise'  # Leave set at vanilla natty

    recipe              'cloud_utils::burn_ami_prep'

    #role                :org_base
    #role                :org_users
    #role                :org_final, :last
    role                :package_set, :last

    recipe              'apt'
    recipe              'build-essential'
    recipe              'git'
    recipe              'nodejs'
    recipe              'ntp'
    recipe              'openssl'
    recipe              'runit'
    recipe              'xfs'
    recipe              'vim'
    recipe              'ubuntu'
    recipe              'xml'
    recipe              'zlib'

    facet_role.override_attributes({
        :package_set => { :install => %w[ base dev sysadmin text ] },
      })
  end

  #
  # Used to test the generated AMI.
  #
  facet :village do
    instances     1
    # Once the AMI is burned, add a new entry in your knife configuration -- see
    # knife/example-credentials/knife-org.rb. Fill in its name here:
    cloud.image_name    'ironfan-precise'
  end

end
