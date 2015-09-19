.. post::
   :author: Clicky
   :category: php, phpfarm
   :tags: phpfarm
   :language: en
   :excerpt: 3


#######################################
PHPFarm Episode 1: Getting started
#######################################

So far, I merely described the raison d'être of phpfarm.
In this new post, we'll get things rolling by actually using it
to build and install a single version of PHP.


Dos and don'ts
================

phpfarm really is a great tool. It provides for a very simple,
and yet very flexible way to get multiple versions of PHP
running side-by-side on a Linux or Mac system.

At the same time, it lacks some features that some people may want.
So, let's review what it can and cannot do.

Can do:

*   Build a stock PHP version from source on a standard Linux/Mac box.

*   Script the installation of multiple versions with shared and
    version-specific build options.

*   Isolate PHP versions from one another (separate binaries,
    separate configuration files, etc.)

*   Automate the creation of a PEAR/Pyrus installation.

*   Compile and install PECL extensions.

No, can't do:

*   Build PHP on a Microsoft Windows system.

    ...but maybe? PHPFarm uses various tools from the Linux world (eg. gcc).
    While it may be possible to use these under Windows too using specific
    environments (eg. MingW or Cygwin), the resulting binaries would not really
    be native Windows executables, which may cause issues later on.

*   Create "virtual environments".

    Unlike Python's ``virtualenv`` project which can be used to create
    separate copies (environments) of the same Python version, phpfarm
    can only be used to create exactly one copy per PHP version.

    However, this is generally not a problem unless your project uses
    function/class names that conflict with those from the PHP interpreter
    (either built-in names or through PHP extensions), or it relies on PEAR
    libraries.

*   Help diagnose misconfigurations / incorrect setups and so on.

    While PHPFarm strives to give meaningful error messages for things under
    its control (eg. "Unknown option used when building ..."),
    there are many ways which can make a particular build fail,
    involving missing libraries/packages, bugs in third-party tools,
    incorrect options (eg. attempting to build a 64 bits version of PHP
    on a 32 bits system), etc.

    PHPFarm can't detect those. In case such an error occurs,
    you have to deal with the issue yourself.

It's fairly safe to say most PHP developers will probably never hear of phpfarm,
nor will they have any need for it. It is mainly aimed at specific needs:

*   Continuous integration

    Because phpfarm offers many ways to customize the build and the installation
    process |---| akin to git hooks, it is perfect in situations where you need
    a repeatable way to build different PHP versions (eg. for testing purpose
    of a PHP extension or application.)

*   Benchmarking

    PHPFarm can be useful if you're looking for a quick way to set up
    a benchmarking platform (eg. for performance comparison of some PHP code
    across various PHP versions.)


Building a single version of PHP
=================================

Okay, now that we understand what PHPFarm can be used for, how do we actually
use it?

Provided you have a standard developer environment (compilers, development
headers, etc.), you first need to clone the project's git repository:

..  sourcecode:: console

    clicky@localhost:~/$ git clone https://github.com/fpoirotte/phpfarm.git

This will create a :dir:`phpfarm` folder in the current directory.
Now, go to that folder and into the :dir:`src` subfolder,
this is where all the good stuff is:

..  sourcecode:: console

    clicky@localhost:~$ cd phpfarm/src/

Call :file:`main.sh` with the PHP version you want to build, eg.:

..  sourcecode:: console

    clicky@localhost:~/phpfarm/src$ ./main.sh 7.0.0RC3

With that last command, we instructed PHPFarm to build and install
a version of PHP (in our case, 7.0.0RC3 which was released just a few days ago).
Depending on your machine, this may take 2-20 minutes to complete,
so now is probably a good time to take a break (and drink a cup of coffee).

Once PHPFarm is done, go into the :dir:`inst` directory at the top of PHPFarm's
sources, you should see something like this:

..  sourcecode:: console

    clicky@localhost:~/phpfarm/src$ cd ../inst
    clicky@localhost:~/phpfarm/inst$ ls -1p
    bin/
    php-7.0.0RC3/

The :dir:`bin` folder contains symbolic links to the various executables
that were built as part of the PHP build process.

To test our new installation, just call the php interpreter with a very basic
script:

..  sourcecode:: console

    clicky@localhost:~/phpfarm/inst$ bin/php-7.0.0RC3-debug -r 'echo "Hello world!" . PHP_EOL;'
    Hello world!

Now, call the :file:`switch-phpfarm` script to mark the newly-built version
as the main version of PHP.

..  sourcecode:: console

    clicky@localhost:~/phpfarm/inst$ bin/switch-phpfarm 7.0.0RC3
    Setting active PHP version to 7.0.0RC3
    PHP 7.0.0RC3 (cli) (built: Sep 19 2015 14:58:10)
    Copyright (c) 1997-2015 The PHP Group
    Zend Engine v3.0.0-dev, Copyright (c) 1998-2015 Zend Technologies

Calling :file:`switch-phpfarm` with no arguments displays a list of all installed
PHP versions and the one that is currently selected as the main version.
In my case, I have several versions installed and PHP 7.0.0RC3 is the main one
as a result of the previous commands.

..  sourcecode:: console

    clicky@localhost:~/phpfarm/inst$ bin/switch-phpfarm
    Available versions:
      5.3.29
      5.4.45
      5.5.29
      5.6.13
    * 7.0.0RC3

Setting the main version creates a symbolic link called :file:`current`
under the :dir:`inst` folder. This is useful to get version-independent
paths for the PHP executables:

..  sourcecode:: console

    clicky@localhost:~/phpfarm/inst$ current/bin/php -v
    PHP 7.0.0RC3 (cli) (built: Sep 19 2015 14:58:10)
    Copyright (c) 1997-2015 The PHP Group
    Zend Engine v3.0.0-dev, Copyright (c) 1998-2015 Zend Technologies


Down to business: customization
================================

So far, we've seen how to build a single version of PHP.
Notice that we did not specify any build options (``--enable-xxx``,
``--with-xxx`` and so on) to do so.

In fact, PHPFarm used various default options for the build.
These defaults are located in the :file:`options.sh` script under the :dir:`src`
folder. PHPFarm also create a :file:`php.ini` configuration file automatically,
based on the contents of the :file:`php.ini-development` file bundled with
the PHP sources and the :file:`default-custom-php.ini` from PHPFarm's sources.

But what if we wanted to used custom build options and custom :file:`php.ini`
settings? First, create a folder named :dir:`custom` at the root of phpfarm's
sources, and descend into it:

..  sourcecode:: console

    clicky@localhost:~/phpfarm/inst$ mkdir ../custom
    clicky@localhost:~/phpfarm/inst$ cd ../custom

Now, create a file named :file:`options.sh`.
This script should (re)define the ``$configoptions`` variable with whatever
options fit your needs:

..  sourcecode:: console

    clicky@localhost:~/phpfarm/custom$ cat options.sh
    # Build the JSON PHP extension as a dynamic library (.so)
    # in addition to extensions from the default options.sh script.
    configoptions="$configoptions --enable-json=shared"

Similarly, you can create a file named :file:`php.ini` to overwrite settings
from the :file:`default-custom-php.ini` file.

..  sourcecode:: console

    clicky@localhost:~/phpfarm/custom$ cat php.ini
    date.timezone=Europe/Paris

    # $ext_dir gets replaced with the full path
    # to the extensions' directory by phpfarm.
    extension_dir="$ext_dir"

    # Now, enable the JSON extension.
    extension=json.so

That's it for now...


Going further
==============

In the next post in this series, I'll explain how to manage multiple
PHP versions and give you some tips about advanced usage of PHPFarm.

----

Have you ever used PHPFarm on an esoteric operating system? Maybe even Windows?
Did you know about the existence of the :dir:`custom` folder and its content?

Please tell me all about it using the comments form below!

