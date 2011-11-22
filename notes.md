
Using even more char codes now in the Dart version has resulted in bigger performance gains:

    $ time ./luhny.dart 100 < sample.txt > /dev/null 

    real	0m0.617s
    user	0m0.604s
    sys 	0m0.008s

    $ time ./luhny.dart < mega_sample.txt > /dev/null 

    real	0m0.659s
    user	0m0.648s
    sys 	0m0.008s

==========

Having found I/O performance degradation when using the default StringInputStream for the Dart version, I've managed to skip using it in favor of a custom method. The numbers when using the mega_sample.txt file are these:

    $ time ./luhny.dart < mega_sample.txt > /dev/null 

    real	0m0.950s
    user	0m0.928s
    sys 	0m0.020s

Less than the 2.1s of before.

==========

Enabled some mask offset again. I had disabled it to deal with a bug revealed by a test that had been recently added. I couldn't enable it again after fixing the bug because the bug was related to the mask offset. I had a new idea of making use of it only when the max length of 16 had been found for a legal number which happens to be the most common situation in the tests anyways. The numbers look good:

    $ time ./luhny.dart 100 < sample.txt > /dev/null 

    real	0m0.912s
    user	0m0.884s
    sys 	0m0.024s

    $ time ./luhny.rb 100 < sample.txt > /dev/null 

    real	0m3.134s
    user	0m3.108s
    sys 	0m0.008s

    $ time ./goluhny 100 < sample.txt > /dev/null 

    real	0m0.240s
    user	0m0.240s
    sys 	0m0.000s

I had been using the looping with 100 repetitions by reusing the input lines as they had been saved to a list from the stdin. Earlier today when I was checking other people's Luhnybin implementations I noticed that I could make a bigger sample.txt file to use with their implementations as they don't save the input for repeats. I called it mega_sample.txt which has 100 times the number of default tests found in the sample.txt file. That proved interesting in a number of ways.

First, I noticed a slow down for the Dart version when using the mega_sample.txt due to some less optimized I/O I guess. Whereas when the Dart version can use what it already has in memory it becomes more impressive as the numbers above show. I didn't notice the same slow downs for the Ruby or Go versions. Seeing is believing:

    $ time ./luhny.dart < mega_sample.txt > /dev/null 

    real	0m2.156s
    user	0m2.088s
    sys 	0m0.052s

    $ time ./luhny.rb < mega_sample.txt > /dev/null 

    real	0m3.129s
    user	0m3.100s
    sys 	0m0.012s

    $ time ./goluhny < mega_sample.txt > /dev/null 

    real	0m0.246s
    user	0m0.240s
    sys 	0m0.004s

Second, I had fun pitching somebody else's Java implementation against my Go implementation. When I made the mega_sample.txt file 500 times the size of the sample.txt file, his Java implementation became noticeably faster by about 0.2s. That gave me extra incentive to try to optimize my Go version. Without clear gains I couldn't change the Go code just for the heck of it. I could approach his numbers with tweaks but I didn't commit all of that. Check it out:

    $ time ./goluhny < mega_sample.txt > /dev/null 

    real	0m1.206s
    user	0m1.196s
    sys 	0m0.008s

    $ time java -server Luhn < ~/t_/luhnybin/mega_sample.txt > /dev/null 

    real	0m1.103s
    user	0m1.220s
    sys 	0m0.004s


==========

Felt enticed to create a version based on the Go programming language. As this is my first Go program it certainly hasn't been optimized enough yet, for one thing. :-) 

    $ time ./goluhny 100 < sample.txt > /dev/null 

    real	0m0.250s
    user	0m0.244s
    sys 	0m0.004s

It's interesting that even though the Go program starts instantaneously, when we make the benchmark to last longer than a very brief moment the slower to start languages have time to catch up, as is the case of the Dart implementation.

=========

Who would have guessed it? After taking the lead of the Ruby version and using more char codes, the Dart version is even faster now:

    $ time ./luhny.dart 100 < sample.txt > /dev/null 

    real	0m1.037s
    user	0m1.020s
    sys 	0m0.016s

=========

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

