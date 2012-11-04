require "libusb"

begin
usb = LIBUSB::Context.new
device = usb.devices(:idVendor => 0x045e, :idProduct => 0x0038).first
config = device.configurations.first
interface = config.interfaces.first
endpoint = interface.endpoints.first
handle = device.open
handle.detach_kernel_driver(0)
handle.claim_interface(0)

while true do
  data = handle.interrupt_transfer(endpoint: endpoint.bEndpointAddress, 
                                       dataIn: 6,
                                       timeout: 0)
  data.bytes {|c| print c, ' '}
  puts
end

rescue Interrupt => i
  puts "done"
  handle.release_interface(0)
  handle.attach_kernel_driver(0)
  handle.close
rescue Exception => e
  puts e.inspect
end


