This project hosts diverse small java projects I develop to help me at my day to day work. There are small alpha software that I want to use, bash scripts, and other softwares



the script top\_threads.sh shows the top java threads, see an example
```
$ top_threads.sh 9772 5
  PID USER      VIRT  RES  SHR CODE DATA S %CPU %MEM   TIME COMMAND                                                                                                                                       
 9814 claudio  1452m  55m 7316    4 1.4g S  5.9  0.9   0:00 /opt/jdk/jdk1.7.0_02/bin/java -Xss128k -Xmx1300m -classpath build/web/ br.com.claudius.threads.NumThreads 40 99999 1                          
 9801 claudio  1452m  55m 7316    4 1.4g S  5.9  0.9   0:00 /opt/jdk/jdk1.7.0_02/bin/java -Xss128k -Xmx1300m -classpath build/web/ br.com.claudius.threads.NumThreads 40 99999 1                          
 9787 claudio  1452m  55m 7316    4 1.4g R  5.9  0.9   0:00 /opt/jdk/jdk1.7.0_02/bin/java -Xss128k -Xmx1300m -classpath build/web/ br.com.claudius.threads.NumThreads 40 99999 1                          
 9823 claudio  1452m  55m 7316    4 1.4g S  4.0  0.9   0:00 /opt/jdk/jdk1.7.0_02/bin/java -Xss128k -Xmx1300m -classpath build/web/ br.com.claudius.threads.NumThreads 40 99999 1                          
 9821 claudio  1452m  55m 7316    4 1.4g S  4.0  0.9   0:00 /opt/jdk/jdk1.7.0_02/bin/java -Xss128k -Xmx1300m -classpath build/web/ br.com.claudius.threads.NumThreads 40 99999 1                          
========> Java LWP: 9814 - Native Thread ID=2656
"CapacityThread__30" prio=10 tid=0x5e239c00 nid=0x2656 waiting for monitor entry [0x5df07000]
   java.lang.Thread.State: BLOCKED (on object monitor)
        at java.security.SecureRandom.nextBytes(SecureRandom.java:455)
        - waiting to lock <0x632406b0> (a java.security.SecureRandom)
        at java.util.UUID.randomUUID(UUID.java:146)
        at br.com.claudius.threads.ThreadTest.run(NumThreads.java:146)
        at java.lang.Thread.run(Thread.java:722)

========> Java LWP: 9801 - Native Thread ID=2649
"CapacityThread__17" prio=10 tid=0x5e225800 nid=0x2649 waiting for monitor entry [0x5e0b4000]
   java.lang.Thread.State: BLOCKED (on object monitor)
        at java.security.SecureRandom.nextBytes(SecureRandom.java:455)
        - waiting to lock <0x632406b0> (a java.security.SecureRandom)
        at java.util.UUID.randomUUID(UUID.java:146)
        at br.com.claudius.threads.ThreadTest.run(NumThreads.java:146)
        at java.lang.Thread.run(Thread.java:722)

========> Java LWP: 9787 - Native Thread ID=263b
"CapacityThread__3" prio=10 tid=0x5e20f800 nid=0x263b waiting for monitor entry [0x5e396000]
   java.lang.Thread.State: BLOCKED (on object monitor)
        at java.security.SecureRandom.nextBytes(SecureRandom.java:455)
        - waiting to lock <0x632406b0> (a java.security.SecureRandom)
        at java.util.UUID.randomUUID(UUID.java:146)
        at br.com.claudius.threads.ThreadTest.run(NumThreads.java:146)
        at java.lang.Thread.run(Thread.java:722)

========> Java LWP: 9823 - Native Thread ID=265f
"CapacityThread__39" prio=10 tid=0x5e248000 nid=0x265f waiting for monitor entry [0x5ddde000]
   java.lang.Thread.State: BLOCKED (on object monitor)
        at java.security.SecureRandom.nextBytes(SecureRandom.java:455)
        - waiting to lock <0x632406b0> (a java.security.SecureRandom)
        at java.util.UUID.randomUUID(UUID.java:146)
        at br.com.claudius.threads.ThreadTest.run(NumThreads.java:146)
        at java.lang.Thread.run(Thread.java:722)

========> Java LWP: 9821 - Native Thread ID=265d
"CapacityThread__37" prio=10 tid=0x5e244c00 nid=0x265d waiting for monitor entry [0x5de20000]
   java.lang.Thread.State: BLOCKED (on object monitor)
        at java.security.SecureRandom.nextBytes(SecureRandom.java:455)
        - waiting to lock <0x632406b0> (a java.security.SecureRandom)
        at java.util.UUID.randomUUID(UUID.java:146)
        at br.com.claudius.threads.ThreadTest.run(NumThreads.java:146)
        at java.lang.Thread.run(Thread.java:722)
```