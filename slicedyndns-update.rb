#!/usr/bin/ruby

require 'rubygems'
require 'activeresource'
require 'open-uri'

module SliceHost
    class API
        def self.create_interface(api_key)
			@module_name = "SliceHostAPI#{api_key}"
			class_eval <<-"end_eval",__FILE__, __LINE__
			module #{@module_name}
			    module DNS
			        class Record < ActiveResource::Base
                        self.site = "https://#{api_key}@api.slicehost.com/"
                    end
		        end
				self # return the module
			end
			end_eval
		end
    end
end

slicehost_api_key = '<API KEy Goes here>'
slicehost_dns_record_id = <DNS Record ID>

my_slicehost = SliceHost::API.create_interface(slicehost_api_key)
dns_record = my_slicehost::DNS::Record.find(slicehost_dns_record_id)
current_ip = open('http://checkip.dyndns.org/').read.scan(/[\.0-9]+/)[0]

if dns_record.data != current_ip
    dns_record.data = current_ip
    dns_record.save
    system("syslog -s -l n 'SliceHost DNS - Record data updated to: #{dns_record.data}'")
else
    system("syslog -s -l n 'SliceHost DNS - Record data unchanged: #{dns_record.data}'")
end
