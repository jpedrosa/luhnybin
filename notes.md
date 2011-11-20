
Even more goodness! After just 3 lines of code change by adding a mask_offset barrier to avoid some repetition, the Ruby version improved 3 fold in performance to join the Dart version at the top of the hill:

    $ time ./luhny.dart 100 < sample.txt > /dev/null 

    real	0m1.497s
    user	0m1.472s
    sys 	0m0.028s

    $ time ./luhny.rb 100 < sample.txt > /dev/null 

    real	0m1.725s
    user	0m1.720s
    sys 	0m0.004s


Woot! After removing the dependency on RegExp, both Ruby and Dart enjoyed further speedups. Only Dart is way ahead now:

    $ time ./luhny.dart 100 < sample.txt > /dev/null 

    real	0m1.575s
    user	0m1.564s
    sys 	0m0.012s

    $ time ./luhny.rb 100 < sample.txt > /dev/null 

    real	0m5.926s
    user	0m5.920s
    sys 	0m0.004s

On the plus side, removing the dependency on RegExp helped to alleviate the complexity of the code. The code is more conventional now, making it prettier? :-)

====

**Outdated** 

Kept for reference.

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

After more tweaks, the Dart version has jumped further ahead:

    $ time ./luhny.dart 100 < sample.txt > /dev/null 

    real	0m3.885s
    user	0m3.844s
    sys 	0m0.036s

    $ time ./luhny.rb 100 < sample.txt > /dev/null 

    real	0m6.904s
    user	0m6.892s
    sys 	0m0.008s

Using the char codes in Dart made a huge difference.

