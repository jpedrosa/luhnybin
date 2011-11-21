s = IO.read('sample.txt')
File.open('mega_sample.txt', 'w'){|f| 100.times{ f.puts s }}

