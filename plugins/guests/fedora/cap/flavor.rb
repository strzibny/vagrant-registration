module VagrantPlugins
  module GuestFedora
    module Cap
      class Flavor
        def self.flavor(machine)
          # Read the version file
          machine.communicate.sudo("grep VERSION_ID /etc/os-release") do |type, data|
            version = data.split("=")[1].chomp.to_i if type == :stdout
          end

          # Detect various flavors we care about
          if version >= 20
            return :"fedora_#{version}"
          else
            return :fedora
          end
        end
      end
    end
  end
end
