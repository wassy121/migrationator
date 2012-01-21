# Fact: packages
#
# Purpose: enumerate package managers, and installed packages
#
# Caveats: Not all inclusive of all packages manager types
#

require 'facter'

Facter.add(:package_manager) do
  confine :kernel => [ :linux ]
  setcode do
    ['rpm', 'dpkg' ].each do |manager|
      [ '/usr/bin', '/bin' ].collect {|dir| File.join(dir,manager)}.each do |file|
        if FileTest.file?(file)
          puts file
          value = file
        end
      end
    end
  end
end
