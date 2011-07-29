#--
# Copyleft shura. [ shura1991@gmail.com ]
#
# This file is part of em-udev.
#
# em-udev is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# em-udev is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with em-udev. If not, see <http://www.gnu.org/licenses/>.
#++

require 'eventmachine'
require 'rubdev'

module EM
  class Udev
    def self.new (handler)
      context = RubDev::Context.new
      monitor = RubDev::Monitor.from_netlink(context, 'udev')

      mod = Module.new {
        include handler if handler

        define_method(:device_added) {|dev|
          puts "added #{dev.devnode}"
        } unless instance_methods.include?(:device_added)

        define_method(:device_removed) {|dev|
          puts "removed #{dev.devnode}"
        } unless instance_methods.include?(:device_removed)

        define_method(:notify_readable) {
          dev = monitor.receive_device
          self.send((dev.action == 'add' ? :device_added : :device_removed), dev)
        } unless instance_methods.include?(:notify_readable)
      }

      EM.watch(monitor.to_io, mod).tap {|c|
        [[:@context, context], [:@monitor, monitor]].each {|args|
          c.instance_variable_set(*args)
        }

        c.notify_readable = true
        monitor.enable_receiving
      }
    end
  end

  def self.udev (handler)
    return unless handler.is_a?(Module)
    Udev.new(handler)
  end
end
