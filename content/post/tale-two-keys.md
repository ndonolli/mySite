+++
title = "A Tale of Two Keys"
date = "2017-06-19T12:12:11-05:00"

+++

My math research teacher Mrs. K would usually explain mathematical concepts to me using stories and riddles.  On the subject of encryption, she proposed this thought problem:

> _A man and a woman are lovers who have become separated from one another.  They can communicate through the mail, but there's a problem - The post office can open and read all of the mail that comes through the system.  The couple wants to exchange secrets, so they decide to send their mail locked in a box, which can be opened with a key.  This still poses a problem, since the post office can still open the box if they can obtain the key in transit.  How can the lovers exchange secret messages with each other so that the post office cannot open the box?_

My first thought was that the couple should meet outside the postal system and create two copies of the key for both of them to have.  In the early days of pre-digital cryptography, this was the common technique for exchanging encrypted messages.  However, this is only effective if you have a prior, secure avenue of communication to establish the keys.  If we assume that the couple (server and client) have not yet established a key, and can now only communicate through the post office (the internet), the problem merits a new solution.

Mrs. K's answer to the problem is this: 

> _The man puts the message in the box, locks it with his own lock, and keeps its key in his drawer.  He sends the box to his lover, who then puts her own lock on the box and stores away its key. She sends the box back to the man who unlocks his lock with his key, to which he sends the box back to his lover who can now unlock the box with her key._

This technique is the basis of **public key cryptography**, or asymmetric encryption, which is used to authenticate secure tunnels in both SSH and SSL protocols.  Since this is accomplished through ciphers, the metaphor of the key and the lock is a little off.  With public key cryptography, a **public** and a **private** key are mathematically derived from a random large integer.  The public "key", in this case, is the lock - because the public key can be used to encrypt information but cannot be used to decrypt afterwards.  The only way to decrypt the package is to use the private key, which is held by one person and never shared.  For a great example that sticks closer to the key/lock mechanism, I found [this article](https://medium.com/@vrypan/explaining-public-key-cryptography-to-non-geeks-f0994b3c2d5) by Panayotis Vryonis to be very helpful.

This is a great oversimplification of the techniques involved in this process, but the abstract concept is not too difficult to grasp.  Public key cryptography provides other authentication benefits as well.  If we go back to our post office example, anybody can send a package to someone under the guise that it was sent from somewhere else (i.e. an intentionally false return address).  The same is true for an inherently unsecure network like the internet.  In public key cryptography, a woman's public key can be distributed and used to decrypt information that was encrypted with her private key.  This ensures that your package came from the source from which it claims to arrive from.

The benefits from this technique of encryption, coupled with the ease of computing power at our fingertips<sup id="a1">[1](#f1)</sup>, have allowed us to operate more effectively with distributed systems.  As I mentioned before, an SSH handshake is initialized through asymmetric encryption, after which it becomes a private channel with one agreed upon secret key (symmetric encryption!).  Going back to our original thought problem, this is like the lovers exchanging the private key though their locked box, so that they can afterwards use it to open packages rather than sending it back and forth each time.  In real life, system engineers can use the SSH protocol to remotely gain access to servers without the fear of an unauthorized breach.

As our personal information becomes more distributed and more devices join our network, this type of authentication becomes much more crucial in the realm of personal computers.  Where before, encryption was commonplace within business networks subject to attacks, it is now (sometimes) standard for communication between personal devices.  The SSL protocol, which uses digital certificates to authenticate secure HTTP connections, is rapidly becoming the new standard of the web with giants like Google [enforcing SSL encryption through their chrome browser](https://security.googleblog.com/2016/09/moving-towards-more-secure-web.html).  And though encryption has been around for a while, it will continue to become more prevalent in our increasingly digital lives. 

---

<b id="f1">1:</b> The technique of public crypto keys was [suggested in the 1970's](https://en.wikipedia.org/wiki/Public-key_cryptography#Classified_discovery) but was not developed to fruition due to the infancy of the current networks and lack of computing power necessary. [↩](#a1)







