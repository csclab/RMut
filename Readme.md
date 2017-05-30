Setup guide
===========

To run and utilize all functions of *RMut* package, three following installations should be conducted in sequence:

Java SE Development Kit
-----------------------

Core algorithms of *RMut* package were written in Java, thus a Java SE Development Kit (JDK) is required to run the package. The JDK is available at:

<http://www.oracle.com/technetwork/java/javase/downloads/index.html>.

The version of JDK should be greater than or equal to 8.

RMut package
------------

The *RMut* package should be properly installed into the R environment by typing the following commands into the R console:

*&gt; install.packages("rJava")*

*&gt; devtools::install\_github("csclab/RMut", args="--no-multiarch")*

Though all of core algorithms written in Java, the *rJava* package must be firstly installed in the R environment as well. Normally, the dependent package would be also installed by the above command. Otherwise, we should install it manually in a similar way to RMut. After installation, the RMut package can be loaded via

*&gt; library(RMut)*

In addition, we could set the *Maximum Java heap size* to a large value, for ex., 8GB (in case of large-scale networks analysis) via

*&gt; .jinit(parameters="-Xmx8000m")*

OpenCL library
--------------

In order to utilize the full computing power of multi-core central processing units (CPUs) and graphics processing units (GPUs), OpenCL drivers should be installed into your system. Here are necessary steps for a system with:

-   NVIDIA graphics cards

    OpenCL support is included in the latest drivers, in the driver CD or available at

    [www.nvidia.com/drivers](www.nvidia.com/drivers).

-   AMD graphics cards

    The OpenCL GPU runtime library is included in the AMD Catalyst drivers of your AMD cards. We should install the latest version of the Catalyst drivers to take advantage of the AMD GPU's capabilities with OpenCL. The drivers could be in the driver CD or available at

    <http://support.amd.com/en-us/download>

-   CPU devices only (No graphics cards)

    The "AMD APP SDK" tool is provided to the developer community to accelerate the programming in a heterogeneous environment. It contains the OpenCL runtime library for CPU hardware. Install the latest SDK from:

    <http://developer.amd.com/tools-and-sdks/opencl-zone/amd-accelerated-parallel-processing-app-sdk/>

    Figure 1 shows some important setup steps (SDK version v3.0). As shown in the figure, we could install the SDK from Internet connection directly and select *Complete* setup type.

    ![AMD APP SDK installation guide](https://github.com/csclab/RMut/blob/master/vignettes/amd_sdk.png)

After installation, OpenCL information can be outputed via the function *showOpencl*. Then we can enable OpenCL computation on a CPU/GPU device via the function *setOpencl*:

``` r
library(RMut)
```

    ## Loading required package: rJava

    ## Warning: package 'rJava' was built under R version 3.3.2

``` r
showOpencl()
```

    ## Your system has 2 installed OpenCL platform(s):
    ## 1. NVIDIA CUDA
    ##   PROFILE = FULL_PROFILE
    ##   VERSION = OpenCL 1.1 CUDA 4.1.1
    ##   VENDOR = NVIDIA Corporation
    ##   EXTENSIONS = cl_khr_byte_addressable_store cl_khr_icd cl_khr_gl_sharing cl_nv_d3d9_sharing cl_nv_d3d10_sharing cl_khr_d3d10_sharing cl_nv_d3d11_sharing cl_nv_compiler_options cl_nv_device_attribute_query cl_nv_pragma_unroll 
    ##  1 GPU device(s) found on the platform:
    ##  1. GeForce GTX 680
    ##  DEVICE_VENDOR = NVIDIA Corporation
    ##  DEVICE_VERSION = OpenCL 1.1 CUDA
    ##  CL_DEVICE_MAX_COMPUTE_UNITS: 8
    ## 2. AMD Accelerated Parallel Processing
    ##   PROFILE = FULL_PROFILE
    ##   VERSION = OpenCL 2.0 AMD-APP (1800.8)
    ##   VENDOR = Advanced Micro Devices, Inc.
    ##   EXTENSIONS = cl_khr_icd cl_khr_d3d10_sharing cl_khr_d3d11_sharing cl_khr_dx9_media_sharing cl_amd_event_callback cl_amd_offline_devices 
    ##  1 CPU device(s) found on the platform:
    ##  1.         Intel(R) Core(TM) i7-3770 CPU @ 3.40GHz
    ##  DEVICE_VENDOR = GenuineIntel
    ##  DEVICE_VERSION = OpenCL 1.2 AMD-APP (1800.8)
    ##  CL_DEVICE_MAX_COMPUTE_UNITS: 8

``` r
setOpencl("gpu")
```

    ## Enabled OpenCL computation based on the device: GeForce GTX 680.

The above functions show installed OpenCL platforms with their corresponding CPU/GPU devices, and try to select an graphics card for OpenCL computing.

Loading networks
================

Networks can be loaded in two ways using RMut:

*loadNetwork* function
----------------------

The *loadNetwork* function creates a network from a Tab-separated values text file. The file format contains three columns:

-   *source* and *target*: are gene/protein identifiers that are used to define nodes
-   *interaction type*: labels the edges connecting each pair of nodes

The function returned a network object which contains:

-   The network name
-   Three data frames used for storing attributes of the nodes/edges and the network itself, respectively

Here is an example:

Finally, the loaded network object *amrn* has five components:

-   *name*: a string variable represents the network identifier, *AMRN.sif* in this case.
-   *nodes*: a data frame which initially contains one column for node identifiers.

    In this example network, there exists 10 nodes. Additional columns for other node-based attributes would be inserted later.

-   *edges*: a data frame which initially contains one column for edge identifiers.

    In this example, there exists 22 edges. Additional columns for other edge-based attributes would be inserted later.

-   *network*: a data frame which initially contains one column for the network identifier (*AMRN.sif* in this case).

    Additional columns for other network-based attributes would be inserted later, such as total number of feedback/feed-forward loops.

-   *transitionNetwork*: a Boolean variable denotes whether the network is a transition network or not, in this case the value is *FALSE*.

    The *findAttractors* function returns a transition network object in which the *transitionNetwork* variable has a value *TRUE*. For all other cases, the variable has a value *FALSE*.

*data* function
---------------

In addition, the package provides some example networks that could be simply loaded by *data* command. For ex.,

``` r
library(RMut)
data(amrn)
```

The package supplied four example datasets from small-scale to large-scale real biological networks:

-   *amrn*

    The Arabidopsis morphogenesis regulatory network (AMRN) with 10 nodes and 22 links.
-   *cdrn*

    The cell differentiation regulatory network (CDRN) with 9 nodes and 15 links.
-   *ccsn*

    The canonical cell signaling network (CCSN) with 771 nodes and 1633 links.
-   *hsn*

    The large-scale human signaling network (HSN) with 1192 nodes and 3102 links.

Dynamics analyses
=================

The package utilizes a Boolean network model with synchronous updating scheme, and provides two types of useful analyses of Boolean dynamics in real biological networks or random networks:

Sensitivity analyses
--------------------

Via *calSensitivity* function, this package computes nodal/edgetic sensitivity against many types of mutations in terms of Boolean dynamics. We classified ten well-known mutations into two types (refer to RMut paper for more details):

-   *Node-based* mutations: state-flip, rule-flip, outcome-shuffle, knockout and overexpression

-   *Edgetic* mutations: edge-removal, edge-attenuation, edge-addition, edge-sign-switch, and edge-reverse

In addition, we note that multiple sets of random Nested Canalyzing rules could be specified, and thus resulted in multiple sensitivity values for each node/edge. Here, we show an example of some sensitivity types:

``` r
library(RMut)
data(amrn)

# generate all possible initial-states each containing 10 Boolean nodes
set1 <- generateStates(10, "all")

# generate all possible groups each containing a single node in the AMRN network
amrn <- generateGroups(amrn, "all", 1, 0)
```

    ## [1] "Number of possibly mutated groups:10"

``` r
amrn <- calSensitivity(amrn, set1, "rule flip", numRuleSets = 2)
print(amrn$Group_1)
```

    ##    GroupID ruleflip_t1000_r1 ruleflip_t1000_r2
    ## 1      SUP         0.0000000         0.0000000
    ## 2     TFL1         0.4687500         0.4687500
    ## 3      UFO         0.0000000         0.0000000
    ## 4       AG         1.0000000         1.0000000
    ## 5      LUG         0.0000000         0.0000000
    ## 6      AP1         0.9687500         0.9687500
    ## 7       PI         0.7988281         0.9707031
    ## 8      AP3         0.7617188         0.9707031
    ## 9      LFY         0.9062500         0.9062500
    ## 10    EMF1         0.0000000         0.0000000

``` r
# generate all possible groups each containing a single edge in the AMRN network
amrn <- generateGroups(amrn, "all", 0, 1)
```

    ## [1] "Number of possibly mutated groups:22"

``` r
amrn <- calSensitivity(amrn, set1, "edge removal")
print(amrn$Group_2)
```

    ##          GroupID edgeremoval_t1000_r1
    ## 1  EMF1 (-1) AP1           0.00000000
    ## 2    LFY (1) AP1           0.42187500
    ## 3    SUP (-1) PI           0.01757812
    ## 4     PI (1) AP3           0.18945312
    ## 5    AP3 (1) AP3           0.00000000
    ## 6  LFY (-1) TFL1           0.00000000
    ## 7     LFY (1) PI           0.18164062
    ## 8    AP1 (-1) AG           0.03125000
    ## 9  EMF1 (-1) LFY           0.00000000
    ## 10  TFL1 (-1) AG           0.01269531
    ## 11   LUG (-1) AG           0.09375000
    ## 12 TFL1 (-1) LFY           0.12500000
    ## 13     PI (1) PI           0.00390625
    ## 14  SUP (-1) AP3           0.01562500
    ## 15   AG (-1) AP1           0.12500000
    ## 16   AP1 (1) LFY           0.46875000
    ## 17    AP3 (1) PI           0.02539062
    ## 18    UFO (1) PI           0.01757812
    ## 19   LFY (1) AP3           0.00390625
    ## 20    LFY (1) AG           0.14062500
    ## 21   UFO (1) AP3           0.01562500
    ## 22 EMF1 (1) TFL1           0.46875000

``` r
# generate all possible groups each containing a new edge (not exist in the AMRN network)
amrn <- generateGroups(amrn, "all", 0, 1, TRUE)
```

    ## [1] "Number of possibly mutated groups:178"

``` r
amrn <- calSensitivity(amrn, set1, "edge addition")
print(amrn$Group_3)
```

    ##            GroupID edgeaddition_t1000_r1
    ## 1      PI (-1) AP3           0.987304688
    ## 2   EMF1 (-1) TFL1           0.500000000
    ## 3       PI (1) AP1           0.212890625
    ## 4     SUP (1) TFL1           0.250000000
    ## 5    SUP (-1) TFL1           0.250000000
    ## 6     SUP (-1) LFY           0.109375000
    ## 7      LUG (1) LFY           0.109375000
    ## 8      EMF1 (1) AG           0.500000000
    ## 9     TFL1 (1) LFY           0.000000000
    ## 10    UFO (-1) LUG           0.500000000
    ## 11   TFL1 (-1) SUP           0.515625000
    ## 12      AG (-1) AG           0.578125000
    ## 13   LUG (-1) TFL1           0.250000000
    ## 14    PI (-1) TFL1           0.500000000
    ## 15     UFO (-1) PI           1.000000000
    ## 16      AG (1) UFO           0.562500000
    ## 17    AP1 (1) EMF1           0.718750000
    ## 18    PI (-1) EMF1           0.496093750
    ## 19     PI (-1) UFO           0.535156250
    ## 20     LUG (-1) PI           1.000000000
    ## 21     TFL1 (1) PI           1.000000000
    ## 22     AG (-1) LUG           0.593750000
    ## 23    SUP (-1) LUG           0.500000000
    ## 24     AP3 (1) SUP           0.539062500
    ## 25     SUP (1) UFO           0.500000000
    ## 26    SUP (1) EMF1           0.500000000
    ## 27     AG (1) EMF1           0.500000000
    ## 28     AP1 (1) AP3           0.987304688
    ## 29   TFL1 (-1) AP1           0.687500000
    ## 30    AP3 (-1) UFO           0.537109375
    ## 31     PI (-1) LUG           0.517578125
    ## 32     LFY (1) LFY           0.531250000
    ## 33   EMF1 (-1) AP3           0.987304688
    ## 34     AP3 (1) AP1           0.216796875
    ## 35    LFY (-1) LUG           0.593750000
    ## 36     LFY (-1) AG           0.093750000
    ## 37    SUP (-1) AP1           0.484375000
    ## 38     LUG (1) AP3           0.987304688
    ## 39      PI (-1) PI           1.000000000
    ## 40     SUP (1) LUG           0.500000000
    ## 41    EMF1 (1) LUG           0.500000000
    ## 42   TFL1 (1) EMF1           1.000000000
    ## 43      AG (1) AP3           0.987304688
    ## 44     UFO (1) UFO           1.000000000
    ## 45    AP3 (-1) LUG           0.505859375
    ## 46      PI (1) SUP           0.535156250
    ## 47   UFO (-1) EMF1           0.500000000
    ## 48    AP3 (-1) LFY           0.078125000
    ## 49      PI (-1) AG           0.093750000
    ## 50     EMF1 (1) PI           1.000000000
    ## 51    TFL1 (1) AP3           0.987304688
    ## 52     LFY (1) LUG           0.593750000
    ## 53     PI (1) EMF1           0.619140625
    ## 54     AG (-1) AP3           0.987304688
    ## 55     AP3 (-1) PI           1.000000000
    ## 56    AP1 (1) TFL1           0.000000000
    ## 57     TFL1 (1) AG           0.093750000
    ## 58      AP1 (1) PI           1.000000000
    ## 59   EMF1 (-1) UFO           0.500000000
    ## 60    UFO (1) TFL1           0.250000000
    ## 61    EMF1 (1) AP1           0.218750000
    ## 62     AP1 (-1) PI           1.000000000
    ## 63     AP1 (1) LUG           0.593750000
    ## 64      AP1 (1) AG           0.218750000
    ## 65     LUG (1) SUP           0.500000000
    ## 66   TFL1 (-1) AP3           0.987304688
    ## 67      PI (1) UFO           0.552734375
    ## 68   TFL1 (-1) UFO           0.515625000
    ## 69     AG (-1) SUP           0.562500000
    ## 70   TFL1 (-1) LUG           0.500000000
    ## 71    LUG (-1) LUG           1.000000000
    ## 72      AG (1) SUP           0.562500000
    ## 73      PI (1) LFY           0.214843750
    ## 74   AP3 (-1) EMF1           0.498046875
    ## 75     UFO (1) LFY           0.484375000
    ## 76   LUG (-1) EMF1           0.500000000
    ## 77    UFO (-1) SUP           0.500000000
    ## 78     AP1 (1) AP1           0.187500000
    ## 79     AP3 (1) UFO           0.537109375
    ## 80     SUP (1) AP3           0.987304688
    ## 81      UFO (1) AG           0.500000000
    ## 82    LFY (-1) AP3           0.987304688
    ## 83      SUP (1) PI           1.000000000
    ## 84       AG (1) PI           0.992187500
    ## 85    UFO (-1) AP3           0.987304688
    ## 86    EMF1 (1) AP3           0.987304688
    ## 87    LFY (1) EMF1           0.718750000
    ## 88     AP3 (1) LFY           0.216796875
    ## 89     AG (1) TFL1           0.500000000
    ## 90    LFY (-1) SUP           0.593750000
    ## 91   LFY (-1) EMF1           0.468750000
    ## 92    TFL1 (-1) PI           1.000000000
    ## 93    AP1 (-1) SUP           0.593750000
    ## 94     PI (-1) LFY           0.083984375
    ## 95     LFY (-1) PI           1.000000000
    ## 96     PI (1) TFL1           0.000000000
    ## 97      LUG (1) PI           1.000000000
    ## 98    AG (-1) EMF1           0.500000000
    ## 99      AG (1) LFY           0.171875000
    ## 100    PI (-1) SUP           0.552734375
    ## 101     AP3 (1) AG           0.107421875
    ## 102    LUG (1) AP1           0.484375000
    ## 103   TFL1 (1) SUP           0.509765625
    ## 104   AP3 (-1) AP1           0.968750000
    ## 105  UFO (-1) TFL1           0.250000000
    ## 106    PI (-1) AP1           0.212890625
    ## 107    LFY (1) SUP           0.593750000
    ## 108      AG (1) AG           0.093750000
    ## 109   UFO (1) EMF1           0.500000000
    ## 110     PI (1) LUG           0.505859375
    ## 111   UFO (-1) UFO           0.000000000
    ## 112    LFY (1) UFO           0.593750000
    ## 113    SUP (1) SUP           1.000000000
    ## 114   SUP (-1) SUP           1.000000000
    ## 115    SUP (-1) AG           0.500000000
    ## 116   AP3 (-1) AP3           0.987304688
    ## 117     SUP (1) AG           0.046875000
    ## 118   LUG (-1) AP1           0.484375000
    ## 119   LUG (-1) UFO           0.500000000
    ## 120    AG (-1) LFY           0.203125000
    ## 121  EMF1 (-1) SUP           0.500000000
    ## 122  EMF1 (-1) LUG           0.500000000
    ## 123   AP1 (-1) AP3           0.987304688
    ## 124   LFY (-1) AP1           0.218750000
    ## 125   UFO (-1) LFY           0.109375000
    ## 126   EMF1 (1) SUP           0.500000000
    ## 127 EMF1 (-1) EMF1           0.000000000
    ## 128   AP1 (-1) LFY           0.218750000
    ## 129   AP1 (-1) AP1           0.187500000
    ## 130   LUG (1) EMF1           0.500000000
    ## 131   AP3 (-1) SUP           0.537109375
    ## 132   AP3 (1) TFL1           0.099609375
    ## 133   EMF1 (1) UFO           0.500000000
    ## 134     AG (-1) PI           0.992187500
    ## 135   AP1 (-1) UFO           0.593750000
    ## 136   EMF1 (-1) AG           0.093750000
    ## 137   LUG (1) TFL1           0.250000000
    ## 138  SUP (-1) EMF1           0.500000000
    ## 139   UFO (-1) AP1           0.484375000
    ## 140 TFL1 (-1) TFL1           0.375000000
    ## 141  TFL1 (1) TFL1           0.250000000
    ## 142   TFL1 (1) LUG           0.500000000
    ## 143    SUP (1) AP1           0.484375000
    ## 144    SUP (1) LFY           0.109375000
    ## 145    AP3 (-1) AG           0.005859375
    ## 146  AP3 (-1) TFL1           0.099609375
    ## 147   EMF1 (-1) PI           1.000000000
    ## 148     AG (1) LUG           0.531250000
    ## 149    UFO (1) LUG           0.500000000
    ## 150 TFL1 (-1) EMF1           1.000000000
    ## 151    AP1 (1) UFO           0.593750000
    ## 152   LFY (1) TFL1           0.500000000
    ## 153   LUG (-1) SUP           0.500000000
    ## 154    AP3 (1) LUG           0.505859375
    ## 155    LUG (1) UFO           0.500000000
    ## 156   LFY (-1) UFO           0.593750000
    ## 157    AP1 (1) SUP           0.593750000
    ## 158  AP1 (-1) TFL1           0.000000000
    ## 159  AP1 (-1) EMF1           0.468750000
    ## 160   LFY (-1) LFY           0.062500000
    ## 161   TFL1 (1) UFO           0.509765625
    ## 162   EMF1 (1) LFY           0.218750000
    ## 163    LUG (1) LUG           1.000000000
    ## 164  EMF1 (1) EMF1           1.000000000
    ## 165   LUG (-1) AP3           0.987304688
    ## 166      PI (1) AG           0.005859375
    ## 167   SUP (-1) UFO           0.500000000
    ## 168   AP1 (-1) LUG           0.593750000
    ## 169     AG (1) AP1           0.921875000
    ## 170   AP3 (1) EMF1           0.498046875
    ## 171     LUG (1) AG           0.500000000
    ## 172    UFO (1) SUP           0.500000000
    ## 173   TFL1 (1) AP1           0.062500000
    ## 174    AG (-1) UFO           0.562500000
    ## 175   LUG (-1) LFY           0.109375000
    ## 176   AG (-1) TFL1           0.500000000
    ## 177    UFO (-1) AG           0.046875000
    ## 178    UFO (1) AP1           0.484375000

As shown above, we firstly need to generate a set of initial-states by the function *generateStates*. Then by the function *generateGroups*, we continue to generate three sets of node/edge groups whose their sensitivity would be calculated. Finally, the sensitivity values are stored in the same data frame of node/edge groups. The data frame has one column for group identifiers (lists of nodes/edges), and some next columns containing their sensitivity values according to each set of random update-rules. For example, the mutation *rule-flip* used two sets of Nested Canalyzing rules, thus resulted in two corresponding sets of sensitivity values.

Attractor cycles identification
-------------------------------

Via *findAttractors* function, the landscape of the network state transitions along with attractor cycles would be identified. The returned transition network object has same structures with the normal network object resulted from *loadNetwork* function (see section "*loadNetwork* function"). An example is demonstrated as follows:

``` r
library(RMut)
data(amrn)

# generate all possible initial-states each containing 10 Boolean nodes
set1 <- generateStates(10, "all")

# generate a set of only conjunction rules
generateRule(amrn)
```

    ## [1] "Generate a default set of update-rules successfully!"

    ## [1] "ok"

``` r
transNet <- findAttractors(amrn, set1)
```

    ## [1] "Number of found attractors:34"
    ## [1] "Number of transition nodes:1024"
    ## [1] "Number of transition edges:1024"

``` r
# print some first network states
head(transNet$nodes)
```

    ##   NodeID Attractor NetworkState
    ## 1     N1         1   0000000000
    ## 2     N2         1   0000000001
    ## 3     N3         0   0000000010
    ## 4     N4         0   0000000011
    ## 5     N5         1   0000000100
    ## 6     N6         1   0000000101

``` r
# print some first transition links between network states
head(transNet$edges)
```

    ##      EdgeID Attractor
    ## 1 N1 (1) N1         1
    ## 2 N2 (1) N2         1
    ## 3 N3 (1) N1         0
    ## 4 N4 (1) N2         0
    ## 5 N5 (1) N5         1
    ## 6 N6 (1) N6         1

``` r
output(transNet)
```

    ## [1] "All output files get created in the working directory:"
    ## [1] "D:/HCStore/R_Projects/RMut/vignettes"

As shown in the example, there exists some different points inside two nodes/edges's data frames of the *transNet* object compared to those of normal network objects:

-   *nodes*:

    The first column is also used for node identifiers, but in this case they represent *states* of the analyzed network *amrn*. There exists 1024 nodes which are equivalent to 1024 network states of *amrn*.

    Additional columns are described as follows:
    -   *Attractor*: value *1* denotes the network state belongs to an attractor, otherwises *0*.
    -   *NetworkState*: specifies the network state of the node.
-   *edges*:

    The first column is also used for edge identifiers, but in this case they represent *transition links* of the analyzed network *amrn*. Each edge identifier has a string *(1)* which denotes a directed link between two node identifiers. There exists 1024 edges which are equivalent to 1024 transition links of *amrn*.

    Additional columns are described as follows:
    -   *Attractor*: value *1* means that the transition link connects two network states of an attractor, otherwises *0*.

We take the node *N6* as an example. Its corresponding network state is *0000000101* which represents Boolean values of all nodes in alphabetical order of the analyzed network *amrn*:

    ## [1] "Number of found FBLs:4"
    ## [1] "Number of found positive FBLs:4"
    ## [1] "Number of found negative FBLs:0"

    ## AG      AP1     AP3     EMF1    LFY     LUG     PI      SUP     TFL1    UFO

    ## 0       0       0       0       0       0       0       1       0       1

Moreover, the *Attractor* value *1* means that *N6* belongs to an attractor. And the data frame *edges* also shows a transition link *N6 (1) N6* with *Attractor* value 1. It means that *N6 (1) N6* is a fixed point attractor.

Finally, the resulted transition network could be exported by the function *output* (see section "*Export results*"). Three CSV files were outputed for the transition network itself and nodes/edges attributes with the following names: *AMRN\_trans.sif*, *AMRN\_trans\_out\_nodes.csv* and *AMRN\_trans\_out\_edges.csv*, respectively. Then, those resulted files could be further loaded and analyzed by other softwares with powerful visualization functions like Cytoscape. For more information on Cytoscape, please refer to <http://www.cytoscape.org/>. In this tutorial, we used Cytoscape version 3.4.0.

The transition network is written as a SIF file (\*.**sif**). The SIF file could be loaded to Cytoscape with the following menu:

*File | Import | Network | File...* or using the shortcut keys *Ctrl/Cmd + L* (*Figure 2(a)*)

![Import network (a) and nodes/edges attributes (b) in Cytoscape software](https://github.com/csclab/RMut/blob/master/vignettes/transition_menu.png)

In next steps, we import two CSV files of nodes/edges attributes via *File | Import | Table | File...* menu (*Figure 2(b)*). For the nodes attributes file, we should select *String* data type for the column *NetworkState* (*Figure 3*). For the edges attributes file, we must select *Edge Table Columns* in the drop-down list beside the text *Import Data as:* (*Figure 4*).

![Nodes attributes importing dialog](https://github.com/csclab/RMut/blob/master/vignettes/transition_menu_attr_node.png)

![Edges attributes importing dialog](https://github.com/csclab/RMut/blob/master/vignettes/transition_menu_attr_edge.png)

After importing, we select *Style* panel and modify the node and edge styles a little to highlight all attractor cycles. For node style, select *Red* color in *Fill Color* property for the nodes that belong to an attractor (*Figure 5(a)*). Regards to edge style, select *Red* color in *Stroke Color* property and change *Width* property to a larger value (optional) for the edges that connect two states of an attractor (*Figure 5(b)*).

![Nodes (a) and edges (b) style modification](https://github.com/csclab/RMut/blob/master/vignettes/style_node_edge.png)

As a result, *Figure 6* shows the modified transition network with clearer indication of attractor cycles.

![The transition network of AMRN](https://github.com/csclab/RMut/blob/master/vignettes/amrn_attractors.png)

Structural characteristics computation
======================================

Feedback/Feed-forward loops search
----------------------------------

Via *findFBLs* and *findFFLs*, the package supports methods of searching feedback/feed-forward loops (FBLs/FFLs), respectively, for all nodes/edges in a network. The following is an example R code for the search:

``` r
library(RMut)
data(amrn)

# search feedback/feed-forward loops
amrn <- findFBLs(amrn, maxLength = 10)
```

    ## [1] "Number of found FBLs:6"
    ## [1] "Number of found positive FBLs:4"
    ## [1] "Number of found negative FBLs:2"

``` r
amrn <- findFFLs(amrn)
```

    ## [1] "Number of found FFLs:15"
    ## [1] "Number of found coherent FFLs:10"
    ## [1] "Number of found incoherent FFLs:5"

``` r
print(amrn$nodes)
```

    ##    NodeID NuFBL NuPosFBL NuNegFBL NuFFL NuFFL_A NuFFL_B NuFFL_C
    ## 1      AG     3        1        2     5       0       1       4
    ## 2     AP1     4        2        2     5       1       2       2
    ## 3     AP3     1        1        0     6       0       3       3
    ## 4    EMF1     0        0        0     4       4       0       0
    ## 5     LFY     4        2        2    11       5       4       2
    ## 6     LUG     0        0        0     0       0       0       0
    ## 7      PI     1        1        0     6       0       3       3
    ## 8     SUP     0        0        0     2       2       0       0
    ## 9    TFL1     2        1        1     4       1       2       1
    ## 10    UFO     0        0        0     2       2       0       0

``` r
print(amrn$edges)
```

    ##           EdgeID NuFBL NuPosFBL NuNegFBL NuFFL NuFFL_AB NuFFL_BC NuFFL_AC
    ## 1    AG (-1) AP1     3        1        2     1        0        1        0
    ## 2    AP1 (-1) AG     1        1        0     2        0        1        1
    ## 3    AP1 (1) LFY     3        1        2     2        1        1        0
    ## 4    AP3 (1) AP3     0        0        0     0        0        0        0
    ## 5     AP3 (1) PI     1        1        0     3        0        3        0
    ## 6  EMF1 (-1) AP1     0        0        0     2        1        0        1
    ## 7  EMF1 (-1) LFY     0        0        0     3        2        0        1
    ## 8  EMF1 (1) TFL1     0        0        0     2        1        0        1
    ## 9  LFY (-1) TFL1     2        1        1     2        1        1        0
    ## 10    LFY (1) AG     1        0        1     4        1        2        1
    ## 11   LFY (1) AP1     1        1        0     3        1        1        1
    ## 12   LFY (1) AP3     0        0        0     2        1        0        1
    ## 13    LFY (1) PI     0        0        0     2        1        0        1
    ## 14   LUG (-1) AG     0        0        0     0        0        0        0
    ## 15    PI (1) AP3     1        1        0     3        0        3        0
    ## 16     PI (1) PI     0        0        0     0        0        0        0
    ## 17  SUP (-1) AP3     0        0        0     2        1        0        1
    ## 18   SUP (-1) PI     0        0        0     2        1        0        1
    ## 19  TFL1 (-1) AG     1        0        1     2        0        1        1
    ## 20 TFL1 (-1) LFY     1        1        0     2        1        1        0
    ## 21   UFO (1) AP3     0        0        0     2        1        0        1
    ## 22    UFO (1) PI     0        0        0     2        1        0        1

``` r
print(amrn$network)
```

    ##   NetworkID NuFBL NuPosFBL NuNegFBL NuFFL NuCoFFL NuInCoFFL
    ## 1      AMRN     6        4        2    15      10         5

In the above output, some abbreviations in the two nodes/edges data frames are explained as follows (refer to the literature \[3-4\] in the References section for more details):

-   *NuFBL*: number of feedback loops involving the node/edge

-   *NuPosFBL*, *NuNegFBL*: number of positive and negative feedback loops, respectively, involving the node/edge

-   *NuFFL*: number of feed-forward loops involving the node/edge

-   *NuFFL\_A*, *NuFFL\_B* and *NuFFL\_C*: number of feed-forward loops with role A, B and C, respectively, involving the node

-   *NuFFL\_AB*, *NuFFL\_BC* and *NuFFL\_AC*: number of feed-forward loops with role AB, BC and AC, respectively, involving the edge

In the *network* data frame, *NuFBL*, *NuPosFBL*, *NuNegFBL*, *NuFFL*, *NuCoFFL* and *NuInCoFFL* denote total numbers of FBLs, positive/negative FBLs, FFLs and coherent/incoherent FFLs in the network, respectively.

Centrality measures computation
-------------------------------

The *calCentrality* function calculates node-/edge-based centralities of a network such as Degree, In-/Out-Degree, Closeness, Betweenness, Stress, Eigenvector, Edge Degree and Edge Betweenness. An example is demonstrated as follows:

``` r
library(RMut)
data(amrn)

# calculate node-/edge-based centralities
amrn <- calCentrality(amrn)
print(amrn$nodes)
```

    ##    NodeID Degree In_Degree Out_Degree  Closeness Betweenness Stress
    ## 1      AG      5         4          1 0.01923077   5.5000000      6
    ## 2     AP1      5         3          2 0.02083333   8.3333333      9
    ## 3     AP3      7         5          2 0.01234568   0.0000000      0
    ## 4    EMF1      3         0          3 0.02564103   0.0000000      0
    ## 5     LFY      8         3          5 0.02222222  13.8333333     15
    ## 6     LUG      1         0          1 0.02083333   0.0000000      0
    ## 7      PI      7         5          2 0.01234568   0.0000000      0
    ## 8     SUP      2         0          2 0.01388889   0.0000000      0
    ## 9    TFL1      4         2          2 0.02083333   0.3333333      1
    ## 10    UFO      2         0          2 0.01388889   0.0000000      0
    ##     Eigenvector
    ## 1  1.962552e-01
    ## 2  3.688391e-01
    ## 3  8.780781e-49
    ## 4  6.569244e-01
    ## 5  4.969356e-01
    ## 6  1.044252e-01
    ## 7  8.780781e-49
    ## 8  1.756156e-48
    ## 9  3.688391e-01
    ## 10 1.756156e-48

``` r
print(amrn$edges)
```

    ##           EdgeID Degree Betweenness
    ## 1    AG (-1) AP1     10   10.500000
    ## 2    AP1 (-1) AG     10    1.333333
    ## 3    AP1 (1) LFY     13   12.000000
    ## 4    AP3 (1) AP3     14    0.000000
    ## 5     AP3 (1) PI     14    1.000000
    ## 6  EMF1 (-1) AP1      8    1.333333
    ## 7  EMF1 (-1) LFY     11    3.333333
    ## 8  EMF1 (1) TFL1      7    1.333333
    ## 9  LFY (-1) TFL1     12    4.000000
    ## 10    LFY (1) AG     13    1.333333
    ## 11   LFY (1) AP1     13    1.500000
    ## 12   LFY (1) AP3     15    6.000000
    ## 13    LFY (1) PI     15    6.000000
    ## 14   LUG (-1) AG      6    6.000000
    ## 15    PI (1) AP3     14    1.000000
    ## 16     PI (1) PI     14    0.000000
    ## 17  SUP (-1) AP3      9    1.000000
    ## 18   SUP (-1) PI      9    1.000000
    ## 19  TFL1 (-1) AG      9    1.833333
    ## 20 TFL1 (-1) LFY     12    3.500000
    ## 21   UFO (1) AP3      9    1.000000
    ## 22    UFO (1) PI      9    1.000000

Export results
==============

Via *output* function, all examined attributes of the networks and their nodes/edges will be exported to CSV files. The structure of these networks are also exported as Tab-separated values text files (.SIF extension). The following is an example R code for the output:

``` r
library(RMut)
data(amrn)

# generate all possible initial-states each containing 10 Boolean nodes
set1 <- generateStates(10, "all")

# generate all possible groups each containing a single node in the AMRN network
amrn <- generateGroups(amrn, "all", 1, 0)
```

    ## [1] "Number of possibly mutated groups:10"

``` r
amrn <- calSensitivity(amrn, set1, "knockout")

# search feedback/feed-forward loops
amrn <- findFBLs(amrn, maxLength = 10)
```

    ## [1] "Number of found FBLs:6"
    ## [1] "Number of found positive FBLs:4"
    ## [1] "Number of found negative FBLs:2"

``` r
amrn <- findFFLs(amrn)
```

    ## [1] "Number of found FFLs:15"
    ## [1] "Number of found coherent FFLs:10"
    ## [1] "Number of found incoherent FFLs:5"

``` r
# calculate node-/edge-based centralities
amrn <- calCentrality(amrn)

# export all results to CSV files
output(amrn)
```

    ## [1] "All output files get created in the working directory:"
    ## [1] "D:/HCStore/R_Projects/RMut/vignettes"

Batch-mode analysis
===================

The methods of dynamics and structure analysis described in the above sections (except the *findAttractors* function due to memory limitation) could also be applied to a set of networks, not limited to a single network. The RMut package provides the *createRBNs* function to generate a set of random networks using a generation model from among four models (refer to the literature in the References section for more details):

-   Barabasi-Albert (BA) model \[1\]

-   Erdos-Renyi (ER) variant model \[2\]

-   Two shuffling models (Shuffle 1 and Shuffle 2) \[3\]

Here, we show two examples of generating a set of random networks and analyzing dynamics-related sensitivity and structural characteristic of those networks:

*Example 1*

``` r
# Example 1: generate random networks based on BA model #
#########################################################

library(RMut)
# generate all possible initial-states each containing 10 Boolean nodes
set1 <- generateStates(10, "all")

# generate two random networks based on BA model
ba_rbns <- createRBNs("BA_RBN_", 2, "BA", 10, 17)

# for each random network, generate all possible groups each containing a single node
ba_rbns <- generateGroups(ba_rbns, "all", 1, 0)
```

    ## [1] "Number of possibly mutated groups:10"
    ## [1] "Number of possibly mutated groups:10"

``` r
# for each random network, calculate the sensitivity values of all nodes against "knockout" mutation
ba_rbns <- calSensitivity(ba_rbns, set1, "knockout")

# for each random network, calculate structural measures of all nodes/edges
ba_rbns <- findFBLs(ba_rbns, maxLength = 10)
```

    ## [1] "Number of found FBLs:8"
    ## [1] "Number of found positive FBLs:3"
    ## [1] "Number of found negative FBLs:5"
    ## [1] "Number of found FBLs:4"
    ## [1] "Number of found positive FBLs:2"
    ## [1] "Number of found negative FBLs:2"

``` r
ba_rbns <- findFFLs(ba_rbns)
```

    ## [1] "Number of found FFLs:3"
    ## [1] "Number of found coherent FFLs:1"
    ## [1] "Number of found incoherent FFLs:2"
    ## [1] "Number of found FFLs:3"
    ## [1] "Number of found coherent FFLs:1"
    ## [1] "Number of found incoherent FFLs:2"

``` r
ba_rbns <- calCentrality(ba_rbns)

print(ba_rbns)
```

    ## [[1]]
    ## $name
    ## [1] "BA_RBN_1"
    ## 
    ## $nodes
    ##    NodeID NuFBL NuPosFBL NuNegFBL NuFFL NuFFL_A NuFFL_B NuFFL_C Degree
    ## 1       0     5        2        3     1       0       1       0      6
    ## 2       1     4        1        3     1       1       0       0      4
    ## 3       2     7        3        4     0       0       0       0      5
    ## 4       3     3        1        2     1       0       0       1      4
    ## 5       4     3        2        1     0       0       0       0      3
    ## 6       5     4        2        2     0       0       0       0      3
    ## 7       6     1        0        1     0       0       0       0      2
    ## 8       7     1        0        1     0       0       0       0      3
    ## 9       8     4        2        2     0       0       0       0      2
    ## 10      9     0        0        0     0       0       0       0      2
    ##    In_Degree Out_Degree  Closeness Betweenness Stress Eigenvector
    ## 1          3          3 0.04000000          23     29  0.45320318
    ## 2          1          3 0.04000000          17     22  0.45320318
    ## 3          3          2 0.03846154          37     46  0.45320318
    ## 4          3          1 0.02500000           8      8  0.08385953
    ## 5          1          2 0.03703704          10     15  0.34211296
    ## 6          2          1 0.02777778          14     16  0.14716321
    ## 7          1          1 0.03125000           1      2  0.25825343
    ## 8          2          1 0.03125000           5      5  0.25825343
    ## 9          1          1 0.03225806          13     17  0.25825343
    ## 10         0          2 0.04000000           0      0  0.19494975
    ## 
    ## $edges
    ##      EdgeID NuFBL NuPosFBL NuNegFBL NuFFL NuFFL_AB NuFFL_BC NuFFL_AC
    ## 1  0 (-1) 2     2        1        1     0        0        0        0
    ## 2   0 (1) 3     2        1        1     1        0        1        0
    ## 3   0 (1) 7     1        0        1     0        0        0        0
    ## 4  1 (-1) 3     1        0        1     1        0        0        1
    ## 5  1 (-1) 6     1        0        1     0        0        0        0
    ## 6   1 (1) 0     2        1        1     1        1        0        0
    ## 7   2 (1) 1     4        1        3     0        0        0        0
    ## 8   2 (1) 4     3        2        1     0        0        0        0
    ## 9   3 (1) 5     3        1        2     0        0        0        0
    ## 10 4 (-1) 0     2        1        1     0        0        0        0
    ## 11  4 (1) 5     1        1        0     0        0        0        0
    ## 12  5 (1) 8     4        2        2     0        0        0        0
    ## 13  6 (1) 2     1        0        1     0        0        0        0
    ## 14 7 (-1) 0     1        0        1     0        0        0        0
    ## 15  8 (1) 2     4        2        2     0        0        0        0
    ## 16 9 (-1) 3     0        0        0     0        0        0        0
    ## 17 9 (-1) 7     0        0        0     0        0        0        0
    ##    Degree Betweenness
    ## 1      11          16
    ## 2      10           7
    ## 3       9           8
    ## 4       8           7
    ## 5       6          10
    ## 6      10           8
    ## 7       9          26
    ## 8       8          19
    ## 9       7          16
    ## 10      9          11
    ## 11      6           7
    ## 12      5          22
    ## 13      7           9
    ## 14      9          13
    ## 15      7          21
    ## 16      6           3
    ## 17      5           6
    ## 
    ## $network
    ##   NetworkID NuFBL NuPosFBL NuNegFBL NuFFL NuCoFFL NuInCoFFL
    ## 1  BA_RBN_1     8        3        5     3       1         2
    ## 
    ## $transitionNetwork
    ## [1] FALSE
    ## 
    ## $Group_1
    ##    GroupID knockout_t1000_r1
    ## 1        5               0.0
    ## 2        9               0.5
    ## 3        6               1.0
    ## 4        8               0.0
    ## 5        4               0.0
    ## 6        1               0.0
    ## 7        0               0.0
    ## 8        2               0.0
    ## 9        7               0.0
    ## 10       3               0.0
    ## 
    ## attr(,"class")
    ## [1] "list"    "NetInfo"
    ## 
    ## [[2]]
    ## $name
    ## [1] "BA_RBN_2"
    ## 
    ## $nodes
    ##    NodeID NuFBL NuPosFBL NuNegFBL NuFFL NuFFL_A NuFFL_B NuFFL_C Degree
    ## 1       0     2        1        1     2       0       0       2      4
    ## 2       1     0        0        0     1       1       0       0      3
    ## 3       2     3        1        2     2       1       1       0      6
    ## 4       3     1        1        0     1       0       1       0      3
    ## 5       4     2        1        1     0       0       0       0      4
    ## 6       5     0        0        0     0       0       0       0      2
    ## 7       6     1        1        0     0       0       0       0      4
    ## 8       7     1        0        1     0       0       0       0      3
    ## 9       8     1        1        0     0       0       0       0      3
    ## 10      9     0        0        0     0       0       0       0      2
    ##    In_Degree Out_Degree  Closeness Betweenness Stress Eigenvector
    ## 1          3          1 0.01960784    7.500000      8  0.12342209
    ## 2          1          2 0.02439024    4.000000      7  0.26509820
    ## 3          3          3 0.02127660   19.166667     24  0.26509820
    ## 4          1          2 0.01960784    3.500000      4  0.08421433
    ## 5          2          2 0.02083333   10.500000     14  0.18088387
    ## 6          2          0 0.01111111    0.000000      0  0.00000000
    ## 7          1          3 0.05882353    5.333333      8  0.67692415
    ## 8          2          1 0.01960784    5.666667      7  0.18088387
    ## 9          1          2 0.04761905    1.333333      2  0.54609849
    ## 10         1          1 0.02127660    2.000000      4  0.12342209
    ## 
    ## $edges
    ##      EdgeID NuFBL NuPosFBL NuNegFBL NuFFL NuFFL_AB NuFFL_BC NuFFL_AC
    ## 1   0 (1) 4     2        1        1     0        0        0        0
    ## 2  1 (-1) 0     0        0        0     1        0        0        1
    ## 3   1 (1) 2     0        0        0     1        1        0        0
    ## 4  2 (-1) 0     1        0        1     2        0        1        1
    ## 5  2 (-1) 3     1        1        0     1        1        0        0
    ## 6   2 (1) 7     1        0        1     0        0        0        0
    ## 7  3 (-1) 0     1        1        0     1        0        1        0
    ## 8  3 (-1) 5     0        0        0     0        0        0        0
    ## 9  4 (-1) 5     0        0        0     0        0        0        0
    ## 10  4 (1) 2     2        1        1     0        0        0        0
    ## 11 6 (-1) 1     0        0        0     0        0        0        0
    ## 12 6 (-1) 8     1        1        0     0        0        0        0
    ## 13  6 (1) 4     0        0        0     0        0        0        0
    ## 14 7 (-1) 2     1        0        1     0        0        0        0
    ## 15 8 (-1) 6     1        1        0     0        0        0        0
    ## 16 8 (-1) 9     0        0        0     0        0        0        0
    ## 17 9 (-1) 7     0        0        0     0        0        0        0
    ##    Degree Betweenness
    ## 1       8   12.500000
    ## 2       7    4.500000
    ## 3       9    5.500000
    ## 4      10    7.000000
    ## 5       9   11.500000
    ## 6       9    5.666667
    ## 7       7    4.000000
    ## 8       5    4.500000
    ## 9       6    4.500000
    ## 10     10   11.000000
    ## 11      7    6.000000
    ## 12      7    2.333333
    ## 13      8    6.000000
    ## 14      9   10.666667
    ## 15      7    6.333333
    ## 16      5    4.000000
    ## 17      5    8.000000
    ## 
    ## $network
    ##   NetworkID NuFBL NuPosFBL NuNegFBL NuFFL NuCoFFL NuInCoFFL
    ## 1  BA_RBN_2     4        2        2     3       1         2
    ## 
    ## $transitionNetwork
    ## [1] FALSE
    ## 
    ## $Group_1
    ##    GroupID knockout_t1000_r1
    ## 1        7         0.0000000
    ## 2        0         0.1093750
    ## 3        5         0.1640625
    ## 4        3         1.0000000
    ## 5        1         0.7500000
    ## 6        9         0.7500000
    ## 7        2         0.0078125
    ## 8        8         0.7500000
    ## 9        4         0.2031250
    ## 10       6         0.7500000
    ## 
    ## attr(,"class")
    ## [1] "list"    "NetInfo"

``` r
output(ba_rbns)
```

    ## [1] "All output files get created in the working directory:"
    ## [1] "D:/HCStore/R_Projects/RMut/vignettes"

*Example 2*

``` r
# Example 2: generate random networks based on "Shuffle 2" model #
##################################################################

library(RMut)
data(amrn)

# generate all possible initial-states each containing 10 Boolean nodes
set1 <- generateStates(10, "all")

# generate two random networks based on "Shuffle 2" model
amrn_rbns <- createRBNs("AMRN_RBN_", 2, "shuffle 2", referedNetwork = amrn)

# for each random network, generate all possible groups each containing a single edge
amrn_rbns <- generateGroups(amrn_rbns, "all", 0, 1)
```

    ## [1] "Number of possibly mutated groups:22"
    ## [1] "Number of possibly mutated groups:22"

``` r
# for each random network, calculate the sensitivity values of all edges against "remove" mutation
amrn_rbns <- calSensitivity(amrn_rbns, set1, "edge removal")

# for each random network, calculate structural measures of all nodes/edges
amrn_rbns <- findFBLs(amrn_rbns, maxLength = 10)
```

    ## [1] "Number of found FBLs:9"
    ## [1] "Number of found positive FBLs:4"
    ## [1] "Number of found negative FBLs:5"
    ## [1] "Number of found FBLs:13"
    ## [1] "Number of found positive FBLs:8"
    ## [1] "Number of found negative FBLs:5"

``` r
amrn_rbns <- findFFLs(amrn_rbns)
```

    ## [1] "Number of found FFLs:16"
    ## [1] "Number of found coherent FFLs:12"
    ## [1] "Number of found incoherent FFLs:4"
    ## [1] "Number of found FFLs:18"
    ## [1] "Number of found coherent FFLs:8"
    ## [1] "Number of found incoherent FFLs:10"

``` r
amrn_rbns <- calCentrality(amrn_rbns)

print(amrn_rbns)
```

    ## [[1]]
    ## $name
    ## [1] "AMRN_RBN_1"
    ## 
    ## $nodes
    ##    NodeID NuFBL NuPosFBL NuNegFBL NuFFL NuFFL_A NuFFL_B NuFFL_C Degree
    ## 1      AG     3        2        1     6       0       2       4      5
    ## 2     AP1     7        3        4     5       0       2       3      5
    ## 3     AP3     7        3        4     5       1       2       2      7
    ## 4    EMF1     0        0        0     1       1       0       0      3
    ## 5     LFY     6        3        3    12       8       3       1      8
    ## 6     LUG     0        0        0     0       0       0       0      1
    ## 7      PI     6        3        3     8       0       3       5      7
    ## 8     SUP     0        0        0     1       1       0       0      2
    ## 9    TFL1     2        1        1     5       2       3       0      4
    ## 10    UFO     0        0        0     2       2       0       0      2
    ##    In_Degree Out_Degree  Closeness Betweenness Stress Eigenvector
    ## 1          4          1 0.01818182         0.5      1  0.08748462
    ## 2          3          2 0.02040816         9.0     10  0.27862356
    ## 3          5          2 0.02083333        14.5     16  0.39101014
    ## 4          0          3 0.02564103         0.0      0  0.29757499
    ## 5          3          5 0.02222222        14.5     17  0.52126019
    ## 6          0          1 0.02272727         0.0      0  0.19113894
    ## 7          5          2 0.01960784         9.0     10  0.17896602
    ## 8          0          2 0.02500000         0.0      0  0.34229418
    ## 9          2          2 0.01960784         0.5      1  0.13025005
    ## 10         0          2 0.02500000         0.0      0  0.44594849
    ## 
    ## $edges
    ##           EdgeID NuFBL NuPosFBL NuNegFBL NuFFL NuFFL_AB NuFFL_BC NuFFL_AC
    ## 1     AG (-1) PI     3        2        1     2        0        2        0
    ## 2   AP1 (-1) AP3     6        2        4     1        0        1        0
    ## 3     AP1 (1) PI     1        1        0     1        0        1        0
    ## 4    AP3 (1) AP1     1        0        1     2        0        1        1
    ## 5    AP3 (1) LFY     6        3        3     2        1        1        0
    ## 6   EMF1 (-1) AG     0        0        0     1        0        0        1
    ## 7  EMF1 (-1) AP3     0        0        0     0        0        0        0
    ## 8  EMF1 (1) TFL1     0        0        0     1        1        0        0
    ## 9  LFY (-1) TFL1     2        1        1     2        2        0        0
    ## 10    LFY (1) AG     1        1        0     2        1        0        1
    ## 11   LFY (1) AP1     1        0        1     4        2        1        1
    ## 12   LFY (1) AP3     1        1        0     3        1        1        1
    ## 13    LFY (1) PI     1        0        1     4        2        1        1
    ## 14  LUG (-1) AP3     0        0        0     0        0        0        0
    ## 15     PI (1) AG     1        0        1     2        0        2        0
    ## 16    PI (1) AP1     5        3        2     1        0        1        0
    ## 17  SUP (-1) LFY     0        0        0     1        1        0        0
    ## 18   SUP (-1) PI     0        0        0     1        0        0        1
    ## 19  TFL1 (-1) AG     1        1        0     4        1        2        1
    ## 20  TFL1 (-1) PI     1        0        1     3        1        1        1
    ## 21   UFO (1) AP3     0        0        0     2        1        0        1
    ## 22   UFO (1) LFY     0        0        0     2        1        0        1
    ##    Degree Betweenness
    ## 1      12         5.5
    ## 2      12        11.0
    ## 3      12         3.0
    ## 4      12         4.5
    ## 5      15        15.0
    ## 6       8         1.5
    ## 7      10         3.0
    ## 8       7         1.5
    ## 9      12         8.0
    ## 10     13         4.5
    ## 11     13         2.0
    ## 12     15         2.0
    ## 13     15         3.0
    ## 14      8         6.0
    ## 15     12         2.5
    ## 16     12        11.5
    ## 17     10         4.0
    ## 18      9         2.0
    ## 19      9         1.0
    ## 20     11         4.5
    ## 21      9         1.5
    ## 22     10         4.5
    ## 
    ## $network
    ##    NetworkID NuFBL NuPosFBL NuNegFBL NuFFL NuCoFFL NuInCoFFL
    ## 1 AMRN_RBN_1     9        4        5    16      12         4
    ## 
    ## $transitionNetwork
    ## [1] FALSE
    ## 
    ## $Group_1
    ##          GroupID edgeremoval_t1000_r1
    ## 1    UFO (1) LFY          0.070312500
    ## 2    SUP (-1) PI          0.004882812
    ## 3   EMF1 (-1) AG          0.000000000
    ## 4    UFO (1) AP3          0.000000000
    ## 5   AP1 (-1) AP3          0.035156250
    ## 6  EMF1 (-1) AP3          0.082031250
    ## 7   TFL1 (-1) AG          0.019531250
    ## 8  LFY (-1) TFL1          0.000000000
    ## 9    AP3 (1) LFY          0.230468750
    ## 10   LFY (1) AP3          0.480468750
    ## 11  LUG (-1) AP3          0.019531250
    ## 12   LFY (1) AP1          0.023437500
    ## 13    AG (-1) PI          0.000000000
    ## 14    LFY (1) PI          0.011718750
    ## 15     PI (1) AG          0.015625000
    ## 16   AP3 (1) AP1          0.011718750
    ## 17    PI (1) AP1          0.023437500
    ## 18    AP1 (1) PI          0.078125000
    ## 19 EMF1 (1) TFL1          0.480468750
    ## 20  SUP (-1) LFY          0.082031250
    ## 21    LFY (1) AG          0.480468750
    ## 22  TFL1 (-1) PI          0.000000000
    ## 
    ## attr(,"class")
    ## [1] "list"    "NetInfo"
    ## 
    ## [[2]]
    ## $name
    ## [1] "AMRN_RBN_2"
    ## 
    ## $nodes
    ##    NodeID NuFBL NuPosFBL NuNegFBL NuFFL NuFFL_A NuFFL_B NuFFL_C Degree
    ## 1      AG     4        2        2     2       0       1       1      5
    ## 2     AP1     3        2        1     2       1       1       0      5
    ## 3     AP3    10        5        5    11       1       3       7      7
    ## 4    EMF1     0        0        0     5       5       0       0      3
    ## 5     LFY    10        6        4    12       7       4       1      8
    ## 6     LUG     0        0        0     0       0       0       0      1
    ## 7      PI    11        6        5     9       1       3       5      7
    ## 8     SUP     0        0        0     0       0       0       0      2
    ## 9    TFL1     7        4        3     4       0       3       1      4
    ## 10    UFO     0        0        0     0       0       0       0      2
    ##    In_Degree Out_Degree  Closeness Betweenness Stress Eigenvector
    ## 1          4          1 0.01923077    6.666667      9  0.10435924
    ## 2          3          2 0.02083333    4.833333     11  0.34120574
    ## 3          5          2 0.02040816   11.833333     18  0.23684651
    ## 4          0          3 0.02564103    0.000000      0  0.49154771
    ## 5          3          5 0.02222222   13.166667     19  0.53753045
    ## 6          0          1 0.02083333    0.000000      0  0.04598274
    ## 7          5          2 0.02083333   10.500000     14  0.34120574
    ## 8          0          2 0.02380952    0.000000      0  0.19632471
    ## 9          2          2 0.02040816    1.000000      1  0.19632471
    ## 10         0          2 0.02380952    0.000000      0  0.30068394
    ## 
    ## $edges
    ##           EdgeID NuFBL NuPosFBL NuNegFBL NuFFL NuFFL_AB NuFFL_BC NuFFL_AC
    ## 1    AG (-1) AP3     4        2        2     1        0        1        0
    ## 2   AP1 (-1) AP3     2        1        1     2        0        1        1
    ## 3    AP1 (1) LFY     1        1        0     1        1        0        0
    ## 4     AP3 (1) PI     5        2        3     3        0        2        1
    ## 5   AP3 (1) TFL1     5        3        2     2        1        1        0
    ## 6  EMF1 (-1) LFY     0        0        0     3        2        0        1
    ## 7   EMF1 (-1) PI     0        0        0     3        2        0        1
    ## 8   EMF1 (1) AP3     0        0        0     2        1        0        1
    ## 9  LFY (-1) TFL1     2        1        1     3        2        0        1
    ## 10    LFY (1) AG     2        1        1     2        1        0        1
    ## 11   LFY (1) AP1     3        2        1     1        1        0        0
    ## 12   LFY (1) AP3     2        1        1     6        2        3        1
    ## 13    LFY (1) PI     1        1        0     3        1        1        1
    ## 14   LUG (-1) AG     0        0        0     0        0        0        0
    ## 15    PI (1) AP3     2        1        1     3        0        2        1
    ## 16    PI (1) LFY     9        5        4     2        1        1        0
    ## 17   SUP (-1) AG     0        0        0     0        0        0        0
    ## 18  SUP (-1) AP1     0        0        0     0        0        0        0
    ## 19  TFL1 (-1) AG     2        1        1     1        0        1        0
    ## 20  TFL1 (-1) PI     5        3        2     2        0        2        0
    ## 21   UFO (1) AP1     0        0        0     0        0        0        0
    ## 22    UFO (1) PI     0        0        0     0        0        0        0
    ##    Degree Betweenness
    ## 1      12   11.666667
    ## 2      12    3.916667
    ## 3      13    5.916667
    ## 4      14   10.166667
    ## 5      11    6.666667
    ## 6      11    3.500000
    ## 7      10    1.000000
    ## 8      10    1.500000
    ## 9      12    3.333333
    ## 10     13    5.000000
    ## 11     13    7.000000
    ## 12     15    1.000000
    ## 13     15    1.833333
    ## 14      6    6.000000
    ## 15     14    2.750000
    ## 16     15   12.750000
    ## 17      7    2.166667
    ## 18      7    3.833333
    ## 19      9    2.500000
    ## 20     11    3.500000
    ## 21      7    3.000000
    ## 22      9    3.000000
    ## 
    ## $network
    ##    NetworkID NuFBL NuPosFBL NuNegFBL NuFFL NuCoFFL NuInCoFFL
    ## 1 AMRN_RBN_2    13        8        5    18       8        10
    ## 
    ## $transitionNetwork
    ## [1] FALSE
    ## 
    ## $Group_1
    ##          GroupID edgeremoval_t1000_r1
    ## 1   AP1 (-1) AP3         0.0000000000
    ## 2    UFO (1) AP1         0.1093750000
    ## 3    LFY (1) AP1         0.2031250000
    ## 4    AG (-1) AP3         0.0000000000
    ## 5     PI (1) AP3         0.0000000000
    ## 6     PI (1) LFY         0.0312500000
    ## 7    LUG (-1) AG         0.0000000000
    ## 8   SUP (-1) AP1         0.1093750000
    ## 9     LFY (1) PI         0.0156250000
    ## 10    LFY (1) AG         0.7031250000
    ## 11    AP3 (1) PI         0.1875000000
    ## 12  EMF1 (1) AP3         0.0009765625
    ## 13   SUP (-1) AG         0.0546875000
    ## 14  AP3 (1) TFL1         0.9531250000
    ## 15 EMF1 (-1) LFY         0.1093750000
    ## 16   AP1 (1) LFY         0.1093750000
    ## 17  TFL1 (-1) PI         0.0000000000
    ## 18  TFL1 (-1) AG         0.0312500000
    ## 19  EMF1 (-1) PI         0.0000000000
    ## 20   LFY (1) AP3         0.0000000000
    ## 21    UFO (1) PI         0.0000000000
    ## 22 LFY (-1) TFL1         0.0000000000
    ## 
    ## attr(,"class")
    ## [1] "list"    "NetInfo"

``` r
output(amrn_rbns)
```

    ## [1] "All output files get created in the working directory:"
    ## [1] "D:/HCStore/R_Projects/RMut/vignettes"

References
==========

1.  Barabasi A-L, Albert R (1999) Emergence of Scaling in Random Networks. Science 286: 509-512. doi: 10.1126/science.286.5439.509

2.  Le D-H, Kwon Y-K (2011) NetDS: A Cytoscape plugin to analyze the robustness of dynamics and feedforward/feedback loop structures of biological networks. Bioinformatics.

3.  Trinh H-C, Le D-H, Kwon Y-K (2014) PANET: A GPU-Based Tool for Fast Parallel Analysis of Robustness Dynamics and Feed-Forward/Feedback Loop Structures in Large-Scale Biological Networks. PLoS ONE 9: e103010.

4.  Koschutzki D, Schwobbermeyer H, Schreiber F (2007) Ranking of network elements based on functional substructures. Journal of Theoretical Biology 248: 471-479.
