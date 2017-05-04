+++
date = "2017-05-04T23:04:33-05:00"
title = "To vim or not to vim"
+++

![](https://ucarecdn.com/18f71672-5e94-4f74-9cf4-b840507509b0/)

---
I am not good with vim.  I use it for git commits and for when my *bash-fu* is not strong enough to make file changes with one command.  I like it better than nano.

For a while now, I've been trying to change my ways.  vim is everywhere.  It's on Linux.  Linux is everywhere.  To achieve at least some level of proficiency with the vim text editor could give one a tremendous advantage working within a shell.  I grew tired of my walking-on-eggshells workflow of *press i -> press keys -> press ESC + :wq and pray* to touch files, and decided enough was enough - **I was going to actually learn vim.**

But it hasn't happened yet.  I still switch to the arrow keys when my stream of *hjkls* spaz out the cursor.  The other day I accidentally recorded a macro and didn't know how to stop it (my current solution: quit vim). Yes, I could be devoting more time to it.  No, I haven't set my IDE to vim mode.  Somewhere along the journey, possibly before it even started, I stopped caring.  And so the conflict remains: should I care?  Will learning vim make me a more effective software engineer?

I believe the answer is a soft *maybe*.  vim is old, but it withstood the test of time and won the hearts and minds of many a developer.  The fact that vim is more alive than ever is actually pretty amazing.  vim is older than I am - the first computer I recall using was an IBM Aptiva running Windows 95, which was released four years after vim and even longer after its precursor vi was a POSIX standard.  Modern computers can run newer, heavier IDEs with little difference in speed, and yet vim remains the IDE of choice for many veteran and even junior software developers.

As I understand it, vim's appeal is on two fronts: accessibility and speed. The speed aspect is due its specific set of bindings which, when learned, can allow you to quickly traverse and edit text without the need for a mouse or touchpad.  On top of that, vim's bindings are organized by different modes, allowing modularity and a larger set of binding options.  Unfortunately, this is one of the primary hurdles of learning vim.  There are many key bindings, and they are not intuitive to users of modern text editors which utilize a different of shortcuts.  Those who master the bindings, however, can blaze through a document with the ability to select specific patterns, move whole lines, and other specific features all without touching the mouse.

![](http://www.terminally-incoherent.com/blog/wp-content/uploads/2012/03/vimcheat-640x272.png)

*Lesson 1: Hit your head against the keyboard repeatedly*

The accessibility aspect is due to the fact that vim exists on most UNIX and Linux flavored operating systems, and it runs in the terminal.  If you need to SSH into a remote server and edit a text file, you can bet you can do it with vim.  Existing as a command line application, vim has easy access to the rest of the system through its extensibility.  It is written in C but ships with its own scripting language used for plugins and extensions. If your vim looks underfeatured compared to your beefed up atom IDE, it's probably because you never beefed up your vim.  Any modern vim user probably extends it with syntax highlighting, version control integration, directory trees - really anything you find in any new IDE.  And when you encounter vanilla vim on another machine?  Hey, you already know the bindings.

I should retract my previous statement. *I do care about learning vim*.  It's just work, and I can't get over the irony that I'm doing work in order to become faster at, well, doing work.  What really intrigues me to learn is the accessibility advantage.  Like bash, vim is a program that lives on because *other people use it*, and what other indication of quality software do you need? 

For the record, I hate writing bash scripts too.  Or rather, I used to hate it.  Once you get past the old-school, memory-saving syntax of this weird, geeky language - good god is it useful.  It's the glue of Linux, and no higher-level python script can come close to taking its place.  The same applies to vim, probably for the next twenty years.