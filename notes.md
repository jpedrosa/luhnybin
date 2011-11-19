Working on these programs has been rather fun. 

While Dart is pretty new, I've grown fond of it as well.

Running the Dart and Ruby versions side by side on my machine provides these numbers:

  $ time ./luhny.dart 100 < sample.txt > /dev/null 

  real	0m6.118s
  user	0m6.016s
  sys	0m0.064s

  $ time ./luhny.rb 100 < sample.txt > /dev/null 

  real	0m6.994s
  user	0m6.920s
  sys	0m0.028s

Until the latest changes, Ruby was ahead in performance.

Somehow, the Dart version made it easier to think of improvements. While by and large I ignore the Ruby syntax as "just works!" I was thinking of ways to improve the Dart version which also helped with improving the Ruby one. They both now enjoy much better algorithms.

