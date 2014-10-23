def verify_exact_file_contents(subject, title, expected_lines)
  content = subject.resource('file', title).send(:parameters)[:content]
  content.split("\n").reject { |line| line =~ /(^$|^#)/ }.should == expected_lines
end

#def verify_fragment_contents(subject, title, expected_lines)
#  content = subject.resource('concat::fragment', title).send(:parameters)[:content]
#  (content.split("\n") & expected_lines).should == expected_lines
#end
