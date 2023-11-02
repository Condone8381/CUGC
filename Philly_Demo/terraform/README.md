## Simple load balancing set up


## Topology

<pre>
                         +
                         |
                         |
                         |
                         |   <publicip>:80
                   +-----v--------+
                   |ProductionLB  |
                   |Lb vserver    |
                   |              |
                   +-----+--------+
                         |
                   +-----v--------+
                   |Backend       |
                   |Service group |
                   |              |
                   +-----+--------+
                         |
            +------------v-+
            |              |
            |              |
            |              |
    10.0.1.8|80         10.|0.1.7:80
       +----v--+       +--------+
       |member |       |member  |
       |       |       |        |
       +-------+       +--------+

</pre>