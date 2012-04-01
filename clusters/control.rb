#
# Command and control cluster
#
Ironfan.cluster 'control' do

  cloud(:ec2) do
    defaults
    permanent           true
    availability_zones ['eu-west-1a']
    flavor              't1.micro'
    backing             'ebs'
    image_name          'ironfan-precise'
    #image_name          'basebox-1110'
    bootstrap_distro    'ubuntu12.04-ironfan'
    chef_client_script  'client.rb'
    mount_ephemerals
  end

  environment           :development

  role                  :systemwide
  role                  :chef_client
  role                  :ssh
  role                  :set_hostname

  role                  :volumes
  role                  :package_set,    :last
  role                  :minidash,       :last
  role                  :tuning,         :last

  role                  :org_base
  role                  :org_users
  role                  :org_final,      :last

  facet :nfs do
    role                :nfs_server
    facet_role do
      override_attributes({
          :nfs => { :exports => { '/home' => { :name => 'home', :nfs_options => '*.internal(rw,no_root_squash,no_subtree_check)' }}},
        })
    end

    volume(:image_data_vol) do
      defaults
      size                26
      keep                true
      device              '/dev/sdn' # note: will appear as /dev/xvdh on modern ubuntus
      mount_point         '/image_data'
      attachable          :ebs
      snapshot_name       :blank_2_xfs
     resizable           true
      create_at_launch    true
      tags( :persistent => true, :local => false, :bulk => false, :fallback => false )
    end
    volume(:home_vol) do
      defaults
      size                2
      keep                true
      device              '/dev/sdh' # note: will appear as /dev/xvdh on modern ubuntus
      mount_point         '/home'
      attachable          :ebs
      snapshot_name       :blank_home_drive
      resizable           true
      create_at_launch    true
      tags( :persistent => true, :local => false, :bulk => false, :fallback => false )
    end
  end

end
