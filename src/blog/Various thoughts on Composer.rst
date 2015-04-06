.. post::
   :author: Clicky
   :category: php
   :tags: composer
   :language: en
   :excerpt: 2

############################
Various thoughts on Composer
############################

Before you read on, let me make this clear: I love Composer, I really do!
It has brought a lot of improvements to the PHP ecosystem by providing
a common package manager that all developers can use [#fn_composer]_.

However, I sometimes feel it doesn't quite deliver some
of its early promises or that it still lacks some important features.

The features I'm going to write about:

*   `Virtual packages`_
*   `Security`_


Virtual packages
================

Virtual packages are an essential part of any package management system.
They allow application and library developers to require a specific feature
while keeping a certain level of abstraction, which in turn provides
flexibility.

This feature has always been available in Composer. In fact, it was one of the
first few features from Composer and Packagist to be `highlighted on nelm.io`_.
Still, this feature is very underused in my opinion.

Take logging for example. Almost every piece of code I've come across recently
makes use of some logging library at one point or another to provide feedback
about what it's doing to its users. This is A Good Thing (and definitely
something most PHP applications didn't do just over a decade ago).

Now, there are literally `tens of logging libraries for PHP`_ out there,
like my very own `Plop`_. To help interoperability, the |PHP-FIG|_ created the 
|PSR-3|, a logging interface that logging libraries must implement.
Once the interface has been implemented, the package for the logging library
should declare that it ``provides`` the ``psr/log-implementation``
virtual package.
Applications that want to use the interoperable interface only need to add
a ``require`` dependency on ``psr/log``.
They can then use the ``Psr\\Log\\LoggerInterface`` interface as a typehint
wherever a logger is needed.

The problem is that you must **already** have a virtual package for all of this
to work properly. That also means that you have come to an agreement with other
parties as to what is considered interoperable.

If you are interested in using virtual packages, check out the following
articles:

*   `Composer and virtual packages`_ by Peter Petermanns Devedge which gives
    nice examples of how to create and use virtual packages with Composer.

*   `Composer provide and dependency inversion`_ by Matthias Noback which
    is a reply to the previous article and gives insight into the principles
    of dependency inversion.

..  _`highlighted on nelm.io`:
    http://nelm.io/blog/2011/12/composer-part-2-impact/
..  _`tens of logging libraries for PHP`:
    https://packagist.org/providers/psr/log-implementation
..  _`Plop`:
    https://plop.readthedocs.org/en/latest/
..  |PHP-FIG| replace:: :abbr:`PHP-FIG (PHP Framework Interop Group)`
..  _`PHP-FIG`:
    http://www.php-fig.org/
..  |PSR-3| replace:: :abbr:`PSR-3 (PHP Standards Recommendation #3)`
..  _`PSR-3`:
    http://www.php-fig.org/psr/psr-3/
..  _`Composer and virtual packages`:
    https://devedge.wordpress.com/2014/09/27/composer-and-virtual-packages/
..  _`Composer provide and dependency inversion`:
    http://php-and-symfony.matthiasnoback.nl/2014/10/composer-provide-and-dependency-inversion/


Security
========

I work for a company that specializes in IT security among other things.
As a result of that, I often apply the same technics I learned at work
for my own usage. I also get frustrated whenever I hit a wall from a security
standpoint due to some software that doesn't apply basic security principles.
Composer is one such software because it offers very little guarantees over
what it installs.

That last sentence may seem counter-intuitive since Composer is a package
manager, so of course you'd expect it to install whatever it was told to
install. But the thing is, Composer itself can easily be compromised.
Heck, the installation instructions amount to:

*   Download remote PHP code from the Internet
*   Execute said code on your computer

Okay, so I hear you screaming "but the code is downloaded using HTTPS,
so this is secure!" There are two problems however that still make
Composer vulnerable:

1.  First, it's quite easy to obtain a **valid** certificate for
    https://getcomposer.org/. Also, you could just create your own
    self-signed certificate. Then you can just use DNS cache poisoning
    or other technics to impersonate the website.

    I doubt PHP beginners would reject such a certificate,
    even when their tools (eg. :program:`curl`) give out warnings
    about the certificate being invalid.

2.  Secondly, and more importantly, the way the :file:`composer.phar` archive
    is fetched can still be insecure because the installation instructions
    say:

    ..  note::
    
        If the above fails for some reason, you can download the installer
        with :file:`php` instead:

    ..  sourcecode:: console

        php -r "readfile('https://getcomposer.org/installer');" | php

    Therefore, any PHP beginners that gets an error related to certificate
    validation would probably just run that command on their machine.

    Alas, PHP does not properly validate certificates by default.
    So this command effectively downloads and executes arbitrary PHP code
    off the Internet.

Think about it for a second, this is very similar to remote code inclusion,
a security flaw that can do great damages to any system.
This vulnerability is even more scary when you consider that Composer is then
used to install dozens of other pieces of code (so-called "packages").
If the installer itself can be compromised, how sure can you be that the code
it later installed is the one you intended?

All is not lost though. There has been `rising concern`_ about this
and `other security issues`_ in Composer. I hope these issues will be fixed
in the future. Meanwhile, it's a risk I am (reluctantly) willing to take
because the gain outweights it.

..  _`rising concern`:
    https://www.adayinthelifeof.nl/2012/10/15/installing-composer-russian-roulette/
..  _`other security issues`:
    https://github.com/composer/composer/issues/1074

----

What about you? Are there aspects of Composer you're dissatisfied with?
Please share your thoughts and experiences in the comments below.

----

..  [#fn_composer]
    Technically, Composer is language neutral and is thus not limited
    to managing PHP packages. A lot of efforts from the Composer folks
    are actually directed towards promoting Composer to handle
    JavaScript libraries, Ruby software, Python software, etc.

