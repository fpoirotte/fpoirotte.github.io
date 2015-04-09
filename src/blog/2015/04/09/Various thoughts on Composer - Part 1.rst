.. post:: Apr 09, 2015
   :author: Clicky
   :category: php
   :tags: composer
   :language: en
   :excerpt: 3

..  _`Various thoughts on Composer: Part 1`:

####################################
Various thoughts on Composer: Part 1
####################################

Before you read on, let me make this clear: I love Composer, I really do!
It has brought a lot of improvements to the PHP ecosystem by providing
a common package manager that all developers can use [#fn_composer]_.

However, I sometimes feel it doesn't quite deliver some
of its early promises or that it still lacks some important features.

This is the first post of a series of articles about what I find
to be defective in Composer itself or in the way it is usually employed.
It concerns security and how it is addressed in Composer.

Security in Composer (or its lack of)
=====================================

I work for a company that specializes in IT security among other things.
As a result of that, I often apply the same technics I learned at work
for my own usage. Also, I get frustrated whenever I hit a wall from a security
standpoint due to some software not applying basic security principles.
Composer is one such software because it offers very little guarantees over
what it installs.

That last sentence may seem very counter-intuitive since Composer is a package
manager, so of course you'd expect it to install whatever it was told to
install. But the thing is, Composer itself can easily be compromised.

Heck, the installation instructions basically amount to:

*   Download remote PHP code from the Internet
*   Execute said code on your computer

Okay, I hear you screaming "but the code is downloaded over HTTPS,
so this is all secure!" There are two problems however that still make
Composer vulnerable:

1.  First, it's quite easy to obtain a **valid** certificate for
    https://getcomposer.org/. Then you can just use DNS cache poisoning
    or other technics to impersonate the website.

    Also, you could just create your own self-signed certificate.
    I doubt PHP beginners would reject such a certificate,
    even when their tools (eg. :program:`curl`) give out warnings
    about the certificate being invalid. They would probably just
    bypass the warning by using whatever option the program provides
    to ignore it.

2.  Secondly, and more importantly, the way the :file:`composer.phar` archive
    is fetched can still be insecure because the installation instructions
    say:

    ..  note::
    
        If the above fails for some reason, you can download the installer
        with :file:`php` instead:

    ..  sourcecode:: console

        php -r "readfile('https://getcomposer.org/installer');" | php

    Therefore, any PHP beginner that gets an error related to certificate
    validation would probably just run that command on their machine.

    Alas, PHP does not properly validate certificates by default.
    So this command effectively downloads and executes arbitrary PHP code
    off the Internet.

Think about it for a second. This is very similar to remote code inclusion,
a security flaw that usually does great damages...

This vulnerability gets even scarier when you consider that Composer is then
used to install dozens of other pieces of code |---| so-called "packages".
If the installer itself can be compromised, how sure can you be that the code
it installed is really the one you intended?

All is not lost though. There has been `rising concern`_ about this
and `other security issues`_ in Composer. I hope these issues will be fixed
in the future. Meanwhile, it's a risk I am (reluctantly) willing to take
because I still think the gain outweights it.


..  _`rising concern`:
    https://www.adayinthelifeof.nl/2012/10/15/installing-composer-russian-roulette/
..  _`other security issues`:
    https://github.com/composer/composer/issues/1074

----

What about you? Are you concerned about Composer's security?
Please share your thoughts and experiences in the comments below.

----

..  [#fn_composer]
    Technically, Composer is language neutral and is thus not limited
    to managing PHP packages. A lot of efforts from the Composer folks
    are actually directed towards promoting Composer to handle
    JavaScript libraries, Ruby software, Python software, etc.

