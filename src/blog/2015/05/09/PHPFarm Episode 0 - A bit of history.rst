.. post:: May 09, 2015
   :author: Clicky
   :category: php, phpfarm
   :tags: phpfarm
   :language: en
   :excerpt: 3


#######################################
PHPFarm Episode 0: A bit of history
#######################################

Alright! In this new series of articles, we're not going to collect vegetables.
Instead, I'll be focusing on phpfarm, a tool that allows several versions
of PHP to co-exist.

In this first article, I'll reminisce about the early days of PHP 5
and the reason projects like phpfarm were born in the first place.

Aside from that, I know the series on Composer isn't finished yet.
I have another entry in preparation but I can't quite find the words
to express my ideas on that topic right now.
So, expect some interleaving between the two series in coming entries.


A bit of history
================

Back in the days when PHP 4 was still the most widely deployed version of PHP
and PHP 5 was slowly starting to emerge, lots of developers were faced with
a single problem: what version should they support?

Sure enough, PHP 5 was largely backwards compatible, allowing *most* scripts
to run pretty much identically on both versions.
However, some corner cases were not handled exactly the same and so the need
arose for a way to run PHP 4 and PHP 5 side-by-side to test them both.

The solution at the time was... well, hard. Most PHP developers are beginners
and do not know much about setting up a webserver with PHP running on it.
Hence the success of PHP stacks like WAMP, LAMP and so on.

To give a more thorough answer to our question, we need to introduce SAPIs.


Enter Server APIs
=================

As you may know, PHP can be integrated with a webserver in several ways.
Take Apache 2.x for example, there are many different ways to run PHP there:

*   As an Apache module (using :file:`libphp5.so`)

*   As a (Fast)CGI server:

    *   Either using the :file:`php-cgi` binary directly
    *   Or through a FastCGI Process Manager like :file:`php-fpm`

*   Starting with PHP 5.4, you may even run PHP's internal webserver
    and have Apache serve as a reverse proxy for it (though this is
    highly deprecated for any production site).

Each of these methods relies on a different :abbr:`SAPI (Server API)`
to handle PHP scripts. A SAPI is what allows the webserver (eg. Apache)
to trigger the execution of the PHP engine and to communicate with it.
It can be either specific to a particular webserver (like the Apache module,
which relies on the Apache2 SAPI), or it can be generic and use an
interoperable protocol (like the FastCGI and internal webserver approaches).

Only the first two methods (Apache module and :file:`php-cgi` binary)
were available when PHP 5.0.0 was first realeased.


Back to square one
==================

What if you wanted to run several versions of PHP simultaneously?
Well, most people will say you can either:

*   Run one version as an Apache module (eg. PHP 4) and the other one (PHP 5)
    as a FastCGI server. Yep, that works.

*   Or, run both as separate FastCGI servers (for consistency).
    Yep, that works too!

What most people don't know however is that you could also load both versions
as Apache modules [#fn_apache2]_. Eg.

..  sourcecode:: Apache

    LoadModule php_module        libphp.so
    LoadModule php5_module       libphp5.so

So, basically, all you need is to either use different SAPIs for each version,
or create different instances of the same SAPI (one instance per version).

In any case, you must build each PHP version for its target SAPI.
So the only problem left now is, how do you do that?


Building PHP and phpfarm's significance
=======================================

Since most (if not all) Linux distributions can only be used to install
a single version of PHP, getting several versions together usually means
that you have to build them from sources [#fn_distro]_.

This can be tedious, especially if you upgrade your PHP versions frequently
(due to security fixes, to test against new alpha/beta/RC versions, etc.).
You need a repeatable process that can also keep your compilation options
and configuration between upgrades.

phpfarm automates that process and provides easy ways to customize
your installation. In the next entries, I'll explain how to use phpfarm
for basic usage and how to accomplish certain advanced tasks with it.

----

What about you? Have you ever used phpfarm to install multiple side-by-side
versions of PHP? Did you use some other tool? Are there topics related to
phpfarm that you'd like me to explore?

Please share your thoughts and experiences in the comments below.

----

..  [#fn_apache2]
    In reality, loading both PHP 4 and PHP 5 as Apache modules only worked
    for a brief period of time until the two modules started exporting
    the same symbols, which led to clashes and ultimately, crashes.

..  [#fn_distro]
    Actually, you could also install one version using your distribution's
    packages and only build additional versions from sources.

