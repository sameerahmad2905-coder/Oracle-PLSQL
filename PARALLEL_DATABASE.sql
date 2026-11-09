---------------BY Satish Sir-------------

Throughput - No of tasks that can be completed in a given interval of TIME

Response Time - The amount of time it takes to complete a single task from the time it is submitted

Higher Respoonse time & Good Response Time ----> Parallel Database..using Multple processor & disks in Parallel

Types of Parallel machine

1) Coarse Grain Parallel machine - Having 2 or 4 Praallel machine
2) Fine Grain Paralle Machine - having 100 number of Parallel machine with higer dgerre of Parallelism

How to measure the Performance of Parallel DB 
Two factors

i) Speed Up ii) Scale Up

Speed Up =  Time taken on the smaller machine having single Machine with on processor (Ts)
			------------------------------------------------------------------------
			Time taken on the Larger machine having multiple Machine with Processor (Tl)
			
			=60 SECOND
			-----------  = 3,  Hence Speed up increases with increse in No. of Processor
			20 SECOND
			
ii) Scaleup - Its factor that expresses how much more work can b done  in the same time period by a system n times larger.

			Here the Time is constant & we have to chceck how much data is processed by a small machine & Large Machine
			
			No of Transaction been processed by the Large machine in constant time (30second) = 300
			----------------------------------------------------------------------------------------	300
			No of Transaction been processed by the smaller machine in constant time (30second) = 100	--- = 3
																										100

Parallism - Sharing the Memory
            Sharing disks
				Parallel one w/o any sharing except the Network is best.