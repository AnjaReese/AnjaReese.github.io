waiting time 从 arrival time 开始计算

#### 算法 | First-Come, First-Serve (FCFS)[¶](https://note.isshikih.top/cour_note/D3QD_OperatingSystem/Unit1/#%E7%AE%97%E6%B3%95--first-come-first-serve-fcfs "Permanent link")

FCFS 是最基本的**非抢占式**调度方法就是按照进程先来后到的顺序进行调度，可以很简单地通过一个 FIFO 的队列实现。FCFS 最大的优点就是实现简单。

#### 算法 | Shortest-Job-First (SJF) / Shortest-Remaining-Time-First (SRTF)[¶](https://note.isshikih.top/cour_note/D3QD_OperatingSystem/Unit1/#%E7%AE%97%E6%B3%95--shortest-job-first-sjf--shortest-remaining-time-first-srtf "Permanent link")

SJF 的思路是，当有多个进程处于就绪态时，选择需要**运行时间最短**的进程先运行。这种算法的优点是，能够保证平均等待时间最小；但是缺点是，如果有一个进程需要运行时间很长，那么它可能会一直被推迟，从而导致“**饥饿**”现象，此外，我们并不知道进程运行时间有多久。

这种做法又被称为 Shortest-Next-CPU-Burst，它是一种 **非抢占式** 调度算法，但假设我们在执行一个进程的过程中，有一个新的进程加入了 ready queue，而且这个进程的执行时间比正在运行的进程的剩余时间还要短，我们仍然需要继续执行完当前的进程才行——因为它是非抢占式的。而显然这个过程是可以通过 **抢占式** 调度来优化的，于是我们引入了 Shortest-Remaining-Time-First (SRTF)，其表述是：总是执行 **剩余** 运行时间最短的进程。其优缺点与 SJF 一致。

#### 算法 | Round-Robin (RR)[¶](https://note.isshikih.top/cour_note/D3QD_OperatingSystem/Unit1/#%E7%AE%97%E6%B3%95--round-robin-rr "Permanent link")

RR 调度就是使用 [分时技术](https://note.isshikih.top/cour_note/D3QD_OperatingSystem/Unit1/Unit0.md/time-sharing) 后的 FCFS 调度，因此它也是**非抢占式**的。每一个进程最多连续执行一个时间片的长度，完成后被插入到 FIFO ready queue 的末尾，并取出 FIFO ready queue 的队首进行执行。

我们之前提到[分时](https://note.isshikih.top/cour_note/D3QD_OperatingSystem/Unit1/Unit0.md/time-sharing)的时候也说过，分时技术通过优化响应时间解决了用户交互问题，RR 调度虽然相比 SJF 有了更长的等待时间，但是有了更短的响应时间，而实际直接影响用户交互问题的应该是响应时间。

一个需要注意的是，RR 调度有一个“超参数”，即时间片的长度。理论上，时间片约短，响应时间越短；但更短的时间片将带来更频繁的进程切换，从而带来更多的 dispatch latency。

#### 算法 | Priority Scheduling[¶](https://note.isshikih.top/cour_note/D3QD_OperatingSystem/Unit1/#%E7%AE%97%E6%B3%95--priority-scheduling "Permanent link")

优先级调度的思路是，每个进程都有一个优先级，当有多个进程处于就绪态时，选择优先级最高的进程先运行。这种算法的优点是，能够保证优先级高的进程优先运行；但是缺点是，如果有一个进程的优先级很高，那么它可能会一直被推迟，从而导致“**饥饿**”现象。

你可能发现了，如果把上面这句话的“优先级最高”改成“运行时间最短”/“剩余运行时间最短”，那就和 [SJF/SRTF](https://note.isshikih.top/cour_note/D3QD_OperatingSystem/Unit1/#shortest-job-first-sjf--shortest-remaining-time-first-srtf) 一模一样了，SJF/SRTF 实际上就是优先级调度的一个特例，因而优先级调度当然是可以实现**抢占式**和**非抢占式**两种的。

此外，优先级的分配可以根据使用需求进行设计，它可能是一些测量数据，也可能具有一些被赋予的意义，甚至可以是一些复合的值；优先级也并不一定是静态的，先前我们提到过的饥饿问题，就可以通过动态的优先级来解决：优先级随着等待时间增加不断增长，等待过久的任务就会被赋予较高的优先级，以此避免饥饿的发生，这种策略叫 priority aging。

#### 设计 | Multilevel Queue Scheduling[¶](https://note.isshikih.top/cour_note/D3QD_OperatingSystem/Unit1/#%E8%AE%BE%E8%AE%A1--multilevel-queue-scheduling "Permanent link")

既然调度算法多种多样，他们适配不同的需求，那能否只在特定情况下使用特定算法呢？答案是肯定的，我们可以将 ready queue 分成多个队列，每个队列使用不同的调度算法，然后再进行队列间调度，这种方法被称为**多级队列调度(multilevel queue scheduling)**。

