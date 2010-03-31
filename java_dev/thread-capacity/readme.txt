Introduction
============

This utility test the ability to create many threads as possible per java process, 
as the user request it by command line or http parameter.

This test can be run from command line or deployed as an war file.

The reason to test it from a servlet container is to see the thread limit per 
appserver instance, as each instance have different JVM tuning from command line.

Beware that the maximum number of threads can be different when running from 
command line and servlet container. 
* There are some JVM parameters that cannot be tuned as the command line, 
    such as -Xmx and -Xss
* At servlet container there are thread pools and thread management

Compatibility
=============

JDK 1.4, 1.5 and 6
Java EE 1.3 and 1.4

Dependencies
============

package util.concurrent (Doug Lea)

Internationalization
====================

english (en)
portuguese (pt_BR)

By default the application will use the system default. If you want to specify different locale
use the environment variable (unix) LANG before invoking the script, example:

LANG=en ./start_thread_test.sh

At the AppServer, use the java properties -Duser.language and -Duser.country

Design
======

First, all thread objects is created (new Thread)

A CyclicBarrier is used to control the exact moment, when all thread objects are 
ready to run.

All threads are started, but its run method has a barrier to wait until all 
threads have its method start() invoked.

The reasoning is to have all threads to run concurrently.

After all threads are properly running, there is a join() call on each thread, to
make the main method wait, until all threads run sucessfully or are interrupted 
by some error.

Security
========

As this is a test of resource usage, be careful because the system can be
unresponsive at all.

The war file has authentication disabled, to enable it, edit web.xml and uncomment
the security section.

Its possible to run this test on public accessible machine, for this to work, 
create any user at the file-realm and associate it with the group named "threadtest"

Usage
=====

To use this thread test, you can invoke the start_thread_test.sh script.

First, you need to unpack the war file. I recommend to create a new directory 
and unpack it there.

mkdir thread_test
cd thread_test
jar xf ../thread-capacity-web.war
chmod +x *.sh

./start_thread_test.sh [n] [thread repeat]

Options:
[n] is the desired number of threads (default = 15000)
[thread repeat] the number of interactions inside the thread (default = 100)

Monitoring
==========

The number of threads can be monitored through operating system tools, such as:

* Linux: ps -p PID -o pid,user,%cpu,rss,etime,nlwp,args
    The NLWP column display the number of threads

* Solaris: prstat -c -p PID 1 100

At the root of war file there are some better shell scripts to monitor and run
this utility

./linux_threads_per_process.sh updatecenter  300

Usage:

threads_per_process.sh PID | process name [count] "

Example:
  PID: 36434 OR
  process string: NumThreads (this script will do a ps -ef|grep NumThreads to get the PID)
  The last number is the number of times the command will run

     threads_per_process.sh 36434 20"
     threads_per_process.sh 36434 "
     threads_per_process.sh NumThreads"
     threads_per_process.sh NumThreads 20"
