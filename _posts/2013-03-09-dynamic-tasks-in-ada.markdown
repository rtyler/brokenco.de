---
layout: post
title: Safe, Dynamic Task Creation in Ada
tags:
- ada
- programming
---


A few years ago,
[Ada](https://secure.wikimedia.org/wikipedia/en/wiki/Ada_(programming_language)
became my hobby/tinker programming language of choice, for a [number of
reasons](/2010/12/06/ada-surely-you-jest-mr-pythonman.html), concurrency being
one of them. In this post I'd like to walk you through an example of dynamic
task creation in Ada, which uses `Ada.Task_Termination` handlers, a new feature
in Ada 2005.

(If you're familiar with Ada, you can skip this next section)

---

> *Note:* You can find all this code, and more in my
[ada-playground](https://github.com/rtyler/ada-playground) repository on GitHub

---

Similar to C, Ada supports stack allocated variables as well as heap allocated
variabels, it also defaults to stack allocation. For example:

{% highlight ada %}

    procedure Main is
        -- A stack allocated `Integer` object
        Enough_Memory : constant Integer := 655360;
    begin
        null;
    end Main;

{% endhighlight %}

If you wanted to allocate that `Integer` onto the heap, then you would use the
`new` keyword:

{% highlight ada %}

    procedure Main is
        -- A heap allocated `Integer` pointer
        Enough_Memory : access Integer := new Integer'(655360);
    begin
        null;
    end Main;

{% endhighlight %}


I won't dive too much into the minutia of what is going on here, if you're not
familiar with Ada already you can learn more about [access types on the Ada
Programming
Wikibook](http://en.wikibooks.org/wiki/Ada_Programming/Types/access). Basically
we're heap allocating a new Integer and using an  **access type** (aka: typed
pointer) to keep track of it. Keen readers will notice we didn't do anything
with that Integer access type, and we're _technically_ leaking the memory. To
solve this we use the generic unit `Ada.Unchecked_Deallocation`, which gives
you a facility for properly freeing memory ([more details
here](http://en.wikibooks.org/wiki/Ada_Programming/Types/access#Deleting_objects_from_a_storage_pool)).


---

### Tasking Trickiness

Concurrency is part of the language in Ada, and is handled through
[tasking](http://en.wikibooks.org/wiki/Ada_Programming/Tasking). A basic
example of might be:

{% highlight ada %}
    with Ada.Text_IO;
    procedure Main is
        task Counter;
        task body Counter is
        begin
            for Count in 1 .. 10 loop
                Ada.Text_IO.Put_Line (Count'Img);
            end loop;
        end Counter;
    begin
        null;
    end Main;
{% endhighlight %}

The way tasks in Ada work means that the `Counter` task will be created,
started and then the execution of the `Main` program will block until the
`Counter` task completes (important detail).

The trickiness starts to arrive when you talk about dynamically allocating task
objects, and combine that with something like an infinite loop, such as one
might find in a server program, e.g.:

{% highlight ada %}

    procedure Main is
    begin
        -- Socket set up omitted
        loop
            declare
                Client_Socket : Socket_Type;
                Request_Handler : Handler_Ptr := new Handler;
            begin
                -- Block until we receive a new inbound connection
                Accept_Socket (Server_Socket, Client_Socket, Server_Addr);
                -- Dereference the Handler_Ptr and call `Process` on the Handler
                -- task
                Request_Handler.all.Process (Client_Socket);
            end;
        end loop;
    end Main;

{% endhighlight %}

(The code above is an abbreviated version of `echomultitask_main.adb` which [can
be found
here](https://github.com/rtyler/ada-playground/blob/master/echomultitask_main.adb)).

The issue with this code is that we're allocating a new `Handler` task for
every in-bound connection, and we have no means of ever cleaning them up
properly. If we were to create an Array of `Handler_Ptr`, we still would have
to find some mechanism (which exists) to check the status of each `Handler` to
determine if we should clean it up. Problem being, we'd have to loop through
all the active tasks, checking for a "terminated" status, in order to
deallocate them. It'd be much better if a task could tell us when it's
finished, rather than us polling every one.

Fortunately in Ada 2005, a mechanism was added to make it easier to add
"clean-up" to tasks: **`Ada.Task_Termination`**. The package allows you to set
up a termination handler for the a specific task, which the runtime will call
when that task terminates. _Unfortunately_ however, the handler procedure that
can be invoked when the task terminates will **not** be passed a pointer to
the task itself, but rather the `Task_Id` (`Ada.Task_Identification.Task_Id`).

**So close** to being able to properly deallocate these dynamic tasks, but we
need one more component, a protected object with a hash map inside of it:

{% highlight ada %}

    package Server.Handlers is
        protected Coordinator is
            procedure Track (Ptr : in Handler_Ptr);
        private
            Active_Tasks : Handler_Containers.Map;
        end Coordinator;
    end Server.Handlers;

{% endhighlight %}

Then back in `main.adb`:

{% highlight ada %}

    Accept_Socket (Server_Socket, Client_Socket, Server_Addr);
    Request_Handler.all.Process (Client_Socket);
    -- Make sure the we keep track of the Request_Handler in order to properly
    -- deallocate it later
    Server.Handlers.Coordinator.Track (Request_Handler);

{% endhighlight %}

(The code above is an abbreviated version of `echomultitask-worker.ads` which
[can be found
here](https://github.com/rtyler/ada-playground/blob/master/echomultitask-worker.ads))

The singleton protected object `Coordinator` not only will give us protected
(aka thread safe) access to the `Active_Tasks` map, but also gives us a
protected object to hang our `Ada.Task_Termination.Termination_Handler`
protected procedure off of:


{% highlight ada %}

    protected body Server.Handlers is
        protected body Coordinator is
            procedure Last_Wish (C : Ada.Task_Termination.Cause_Of_Termination;
                                T : Ada.Task_Identification.Task_Id;
                                X : Ada.Exceptions.Exception_Occurrence) is
            begin
                -- Deallocate our task identified by `T`
                -- and make sure we remove it from `Active_Tasks`
            end Last_Wish;
            procedure Track (Ptr : in Handler_Ptr) is
                -- Dereference our `Handler` task, and fish out its Task_Id
                Handler_Id : Ada.Task_Idenfitication.Task_Id := Ptr.all'Identity
            begin
                -- Add `Handler_Id` to our `Active_Tasks` map
                Active_Tasks.Insert (Handler_Id, Ptr);
                -- Set up the Last_Wish procedure to be executed after our task has
                -- terminated
                Ada.Task_Termination.Set_Specific_Handler (Handler_Id, Last_Wish'Access);
            end Track;
        end Coordinator;
    end Server.Handlers;

{% endhighlight %}

(The code above is an abbreviated version of `echomultitask-worker.adb` which
[can be found here](https://github.com/rtyler/ada-playground/blob/master/echomultitask-worker.adb))


This approach will allow us to safely create new dynamic tasks to handle the
incoming requests, but will also make sure that the tasks are cleanly
deallocated when they terminate.

If you're interested in concurrency in Ada, I
highly recommend purchasing [Concurrent and Real-Time Programming in
Ada](http://www.amazon.com/gp/product/0521866979?ie=UTF8&tag=unethicalblog-20&linkCode=as2&camp=1789&creative=390957&creativeASIN=0521866979)
by Alan Burns and Andy Wellings, it's been tremendously helpful for my own
concurrency exploration in Ada.
