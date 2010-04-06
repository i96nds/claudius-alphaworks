package br.com.claudius.threads;

import java.io.*;
import java.util.*;
import java.util.concurrent.CyclicBarrier;

/**
 * Class used to test the scalability of threads per java process. 
 * In a real system, it will scale a little larger than this, if the -Xmx and -Xss parameters 
 * can be properly tuned.
 * 
 *  @author Claudio Miranda <claudio@claudius.com.br>
 */
public class NumThreads {
    
    public static String CR = System.getProperty("line.separator");
    public static int multiple;
    public static PrintStream psout = System.out;
    public static ResourceBundle bundle = ResourceBundle.getBundle("br/com/claudius/threads/messages", Locale.getDefault());
    public static int repeat = 100;
    // pause (seconds) before the test begin
    // this is to let the user connect some sort of tool before the test.
    public static int pause_before = 1;
    
    public static void main(String[] a) throws Exception {
        // default number of threads to create if none is specified at command line
        int n = 15000;
        multiple = 1;
        if (a.length > 0) {
            n = Integer.parseInt(a[0]);
        }
        if (a.length == 3) {
            repeat = Integer.parseInt(a[1]);
            pause_before = Integer.parseInt(a[2]);
        }
        
        StringBuffer sb = new StringBuffer(CR);
        sb.append(bundle.getString("msg.01")).append(n).append(CR);
        sb.append(bundle.getString("msg.02")).append(CR).append(CR);
        sb.append(bundle.getString("msg.instruction")).append(CR).append(CR);
        sb.append(bundle.getString("msg.instruction2")).append(CR);
        sb.append(bundle.getString("msg.instruction3")).append(CR);
        sb.append(bundle.getString("msg.instruction4")).append(CR);
        print(sb.toString());
        
        // factor used to print the number of threads created and processed
        if (n > 99) {
            multiple = n / 10;
        } else {
            multiple = n / 5;
        }
        sb = new StringBuffer(bundle.getString("msg.04"));
        sb.append(CR).append(bundle.getString("msg.05")).append(CR);
        print(sb.toString());
        
        if (pause_before > 0) {
        	Thread.sleep(1000 * pause_before);
        }
        
        // all threads must start to work when all threads objects is ready to run
        CyclicBarrier barrier = new CyclicBarrier(n);
        Thread[] allthreads = new Thread[n];
        String warm = bundle.getString("warm");
        String alloc = bundle.getString("alloc");
        for (int i = 0; i < n; i++) {
            String name = "CapacityThread__" + i;
            Thread t1 = new Thread(new ThreadTest(name, barrier), name);
            if (i % multiple == 0 || i + 1 == n) {
                print(warm + (i + 1) + alloc);
            }
            allthreads[i] = t1;
        }
        print((new StringBuffer(CR).append(bundle.getString("msg.06")).append(CR)
            .append(bundle.getString("msg.07")).append(CR)).toString());
        
        int created = 0;
        String threadmessage = bundle.getString("threads_concurrent");
        try {
            for (int i = 0; i < n; i++) {
                Thread t = (Thread) allthreads[i];
                t.start();
                created++;
//                System.out.print(i + " ");
                if (i % multiple == 0 || i + 1 == n) {
                    print((i + 1) + threadmessage);
                }
            }
            
            print((new StringBuffer(CR).append(bundle.getString("msg.08")).append(CR)).toString());
            
            for (int i = 0; i < n; i++) {
                Thread t = (Thread) allthreads[i];
                t.join();
            }
            
            print((new StringBuffer(CR).append(bundle.getString("msg.08")).append(CR).append(bundle.getString("msg.09"))
                .append(n).append(bundle.getString("msg.10")).append(CR)).toString());
            
            ThreadTest.cont = 0;
        } catch (OutOfMemoryError oome) {
            allthreads = null;
            System.gc();
            printStackTrace(oome);
            print((new StringBuffer(CR).append(bundle.getString("err01")).append(CR)
                .append(bundle.getString("err02")).append(created).append(" threads").append(CR)).toString());
        }
        
    }
    
    public static void print(String m) {
        // if this class is run from a web container, change the carriage return to a HTML carriage return
        if ("<br>".equals(CR)) {
            m+=CR;
        }
        psout.println(m);
    }
    
    public static void printStackTrace(Error e) {
        ByteArrayOutputStream byteOut = new ByteArrayOutputStream();
        PrintStream ps = new PrintStream(byteOut);
        e.printStackTrace(ps);
        print(byteOut.toString());
    }
    
}

class ThreadTest implements Runnable {
    
    String threadName;
    public static int cont = 0;
    CyclicBarrier barrier;
    int number = -1;
    
    public ThreadTest(String name, CyclicBarrier barrier) {
        this.threadName = name;
        this.barrier = barrier;
        number = barrier.getParties();
    }
    
    public void run() {
        boolean whichOne = false;
        try {
            barrier.await();
            for (int i = 1; i < NumThreads.repeat; i++) {
                Random r1 = new Random();
                Random r2 = new Random();
                Random r3 = new Random();
                Random r4 = new Random();
                Random r5 = new Random();
                Math.abs(r1.nextGaussian());
                Math.abs(r2.nextGaussian());
                Math.abs(r3.nextGaussian());
                Math.abs(r4.nextGaussian());
                Math.abs(r5.nextGaussian());
                Math.abs(r1.nextGaussian());
                Math.asin(r1.nextDouble());
                Math.asin(r2.nextDouble());
                Math.asin(r3.nextDouble());
                Math.asin(r4.nextDouble());
                Math.asin(r5.nextDouble());
                Math.ceil(r1.nextDouble());
                Math.ceil(r2.nextDouble());
                Math.ceil(r3.nextDouble());
                Math.ceil(r4.nextDouble());
                Math.ceil(r5.nextDouble());
                Math.cos(r1.nextGaussian());
                Math.cos(r2.nextGaussian());
                Math.cos(r3.nextGaussian());
                Math.cos(r4.nextGaussian());
                Math.cos(r5.nextGaussian());
            }
            int l = ++cont;
            if (l % NumThreads.multiple == 0 || l + 1 == number) {
                NumThreads.print((new StringBuffer().append(l + 1).append(NumThreads.bundle.getString("success"))).toString());
            }
        } catch (Exception e) {
            e.printStackTrace();
        } catch (OutOfMemoryError oome) {
            oome.printStackTrace();
        }
        
    }
    
}
