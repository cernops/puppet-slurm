module Puppet::Parser::Functions
	newfunction(:base64_decode, :type => :rvalue) do |args|
		require "base64"
		input = args[0]
		$output = Base64.decode64(input)
	end
end
