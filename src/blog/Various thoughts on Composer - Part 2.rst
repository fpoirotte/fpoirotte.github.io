.. post::
   :author: Clicky
   :category: php
   :tags: composer, security
   :language: en
   :excerpt: 2

..  _`Various thoughts on Composer: Part 2`:

####################################
Various thoughts on Composer: Part 2
####################################

This is the second and final post of a series of articles about what I find
to be defective in Composer itself or in the way it is usually employed.

So, :ref:`last time <Various thoughts on Composer: Part 1>`,
I wrote about my concerns on the way security is handled by Composer.
This time, I'll be writing about the use of virtual packages
by the PHP community.


Virtual packages and Composer
=============================

Virtual packages are an essential part of any package management system.
They allow application and library developers to require a specific feature
while keeping a certain level of abstraction, which in turn provides
flexibility.

Virtual packages have always been available in Composer.
In fact, they were one of the first few features from Composer and Packagist
to be `highlighted on nelm.io`_. Still, this feature is very underused
in my opinion.

Take logging for example. Almost every piece of code I've come across recently
makes use of some logging library at one point or another to provide feedback
about what it's doing. This is A Good Thing (and definitely something
most PHP applications didn't do just over a decade ago).

Now, there are literally tens of logging libraries for PHP out there,
like my very own `Plop`_. To help interoperability, the |PHP-FIG|_ created the 
|PSR-3|, a logging interface that logging libraries must implement.
Once the interface has been implemented, the package for the logging library
should declare that it ``provides`` the :packagist:`psr/log-implementation`
virtual package.

Applications that want to use the interoperable interface thus only need to add
a ``require`` dependency on ``psr/log``.
They can then use the ``Psr\\Log\\LoggerInterface`` interface as a typehint
wherever a logger is needed.

The problem is that you must **already** have a virtual package for all of this
to work properly. That also means that you come to an agreement with other
parties beforehand as to what is considered interoperable.


More info about virtual packages
================================

If you are interested in using virtual packages, check out the following
articles:

*   `Composer and virtual packages`_ by Peter Petermanns Devedge which gives
    nice examples of how to create and use virtual packages with Composer.

*   `Composer provide and dependency inversion`_ by Matthias Noback which
    is a reply to the previous article and gives insight into the principles
    of dependency inversion.


..  _`highlighted on nelm.io`:
    http://nelm.io/blog/2011/12/composer-part-2-impact/
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

----

What about you? Are there aspects of Composer you're dissatisfied with?
Please share your thoughts and experiences in the comments below.

