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

slicehost_api_key = '23b5c1a6628f0aab479c5b48b5b06ca3e3c1c8044f80b7344ea932914bfb50b6'
slicehost_dns_record_id = 599906

my_slicehost = SliceHost::API.create_interface(slicehost_api_key)
dns_record = my_slicehost::DNS::Record.find(slicehost_dns_record_id)
current_ip = open('http://checkip.dyndns.org/').read.scan(/[\.0-9]+/)[0]

if dns_record.data == current_ip
    dns_record.data = current_ip
    dns_record.save
end
