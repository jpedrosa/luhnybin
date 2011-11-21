
Success! Tweaked the main Ruby version, the one without the RegExp, to use arrays of chars. It became fast enough as a result:

    $ time ./luhny.rb 100 < sample.txt > /dev/null 

    real	0m4.644s
    user	0m4.632s
    sys 	0m0.008s

Credit goes to some other guy who had first used the "unpack" and "pack" methods.

=========

I've always wanted to keep the other Ruby implementation based on RegExp around even though its code wasn't as pretty. It did work though. After the recent change I had to take a look at it again, so I resurrected it and made a file for it (luhn_regex.rb). It performs like this:

    $ time ./luhny.rb 100 < sample.txt > /dev/null 

    real	0m7.036s
    user	0m6.976s
    sys 	0m0.012s

While still passing the newest tests.

=========

After a recent update of the tests, a failure in the algorithm was revealed so I had to remove the code that was saving some work during the masking. The Ruby version has suffered the most with it, while the Dart version has kept its superb performance:

    $ time ./luhny.dart 100 < sample.txt > /dev/null 

    real	0m1.975s
    user	0m1.940s
    sys 	0m0.024s

    $ time ./luhny.rb 100 < sample.txt > /dev/null 

    real	0m12.502s
    user	0m12.493s
    sys 	0m0.008s

Now to think of ways to improve the Ruby version. :-)

===========

Turns out those numbers weren't realistic as a bug prevented the algorithm from doing all of its work. Then again, the current numbers still help both Ruby and Dart.

    $ time ./luhny.dart 100 < sample.txt > /dev/null 

    real	0m1.779s
    user	0m1.736s
    sys 	0m0.044s

    $ time ./luhny.rb 100 < sample.txt > /dev/null 

    real	0m3.915s
    user	0m3.904s
    sys 	0m0.008s

===========

**These numbers without the RegExp dependency may have failed to a bug.** Let's keep them around as "what if?" :-)

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

