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

The *RMut* package should be properly installed into the R environment by typing the following command into the R console:

*&gt; install.packages("RMut")*

Though all of core algorithms written in Java, the *rJava* package must be additionally installed in the R environment as well. Normally, the dependent package would be also installed by the above command. Otherwise, we should install it manually in a similar way to RMut. After installation, the RMut package can be loaded via

*&gt; library(RMut)*

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

    ![AMD APP SDK installation guide](https://github.com/csclab/RMut/tree/master/vignettes/amd_sdk.png)

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
amrn <- calSensitivity(amrn, set1, 1, "rule flip", numRuleSets = 2)
print(amrn$Group_1)
```

    ##    GroupID ruleflip_t1000_r1 ruleflip_t1000_r2
    ## 1       PI         0.7988281         0.9707031
    ## 2      LUG         0.0000000         0.0000000
    ## 3      LFY         0.9062500         0.9062500
    ## 4       AG         1.0000000         1.0000000
    ## 5      UFO         0.0000000         0.0000000
    ## 6     TFL1         0.4687500         0.4687500
    ## 7     EMF1         0.0000000         0.0000000
    ## 8      SUP         0.0000000         0.0000000
    ## 9      AP1         0.9687500         0.9687500
    ## 10     AP3         0.7617188         0.9707031

``` r
# generate all possible groups each containing a single edge in the AMRN network
amrn <- generateGroups(amrn, "all", 0, 1)
```

    ## [1] "Number of possibly mutated groups:22"

``` r
amrn <- calSensitivity(amrn, set1, 2, "edge removal")
print(amrn$Group_2)
```

    ##          GroupID edgeremoval_t1000_r1
    ## 1  EMF1 (-1) AP1           0.00000000
    ## 2    AP1 (1) LFY           0.46875000
    ## 3    AP1 (-1) AG           0.03125000
    ## 4   SUP (-1) AP3           0.01562500
    ## 5    UFO (1) AP3           0.01562500
    ## 6      PI (1) PI           0.00390625
    ## 7     AP3 (1) PI           0.02539062
    ## 8    SUP (-1) PI           0.01757812
    ## 9   TFL1 (-1) AG           0.01269531
    ## 10    LFY (1) PI           0.18164062
    ## 11    LFY (1) AG           0.14062500
    ## 12 LFY (-1) TFL1           0.00000000
    ## 13   LFY (1) AP1           0.42187500
    ## 14 EMF1 (-1) LFY           0.00000000
    ## 15 EMF1 (1) TFL1           0.46875000
    ## 16 TFL1 (-1) LFY           0.12500000
    ## 17    PI (1) AP3           0.18945312
    ## 18    UFO (1) PI           0.01757812
    ## 19   AG (-1) AP1           0.12500000
    ## 20   AP3 (1) AP3           0.00000000
    ## 21   LUG (-1) AG           0.09375000
    ## 22   LFY (1) AP3           0.00390625

``` r
# generate all possible groups each containing a new edge (not exist in the AMRN network)
amrn <- generateGroups(amrn, "all", 0, 1, TRUE)
```

    ## [1] "Number of possibly mutated groups:178"

``` r
amrn <- calSensitivity(amrn, set1, 3, "edge addition")
print(amrn$Group_3)
```

    ##            GroupID edgeaddition_t1000_r1
    ## 1     TFL1 (1) AP3           0.987304688
    ## 2       PI (1) UFO           0.535156250
    ## 3     SUP (1) TFL1           0.250000000
    ## 4       PI (1) SUP           0.535156250
    ## 5     LUG (-1) UFO           0.500000000
    ## 6      AP3 (-1) AG           0.093750000
    ## 7     AP3 (1) EMF1           0.619140625
    ## 8   TFL1 (-1) TFL1           0.500000000
    ## 9     AP1 (1) TFL1           0.000000000
    ## 10     AP3 (-1) PI           1.000000000
    ## 11      AG (1) LFY           0.125000000
    ## 12     AP3 (1) UFO           0.537109375
    ## 13     LUG (1) SUP           0.500000000
    ## 14   EMF1 (-1) LUG           0.500000000
    ## 15    AG (-1) TFL1           0.000000000
    ## 16    EMF1 (1) LFY           0.000000000
    ## 17    SUP (-1) UFO           0.500000000
    ## 18    TFL1 (1) LFY           0.000000000
    ## 19     AP3 (1) LUG           0.517578125
    ## 20    LFY (-1) AP3           0.987304688
    ## 21     SUP (1) UFO           0.500000000
    ## 22     AP1 (1) LUG           0.593750000
    ## 23    LUG (-1) SUP           0.500000000
    ## 24       AG (1) PI           0.992187500
    ## 25    AP3 (-1) AP3           0.987304688
    ## 26     SUP (1) LUG           0.500000000
    ## 27   TFL1 (-1) AP1           0.218750000
    ## 28     UFO (1) AP1           0.484375000
    ## 29      SUP (1) AG           0.046875000
    ## 30     SUP (1) LFY           0.484375000
    ## 31      AG (1) SUP           0.562500000
    ## 32    AP1 (-1) AP3           0.987304688
    ## 33     UFO (-1) AG           0.046875000
    ## 34   SUP (-1) EMF1           0.500000000
    ## 35    AP1 (-1) UFO           0.593750000
    ## 36    AP1 (-1) LUG           0.593750000
    ## 37     PI (-1) LFY           0.968750000
    ## 38     AG (-1) UFO           0.562500000
    ## 39    LUG (-1) AP1           0.109375000
    ## 40      PI (-1) AG           0.093750000
    ## 41     AP1 (1) AP1           0.062500000
    ## 42  TFL1 (-1) EMF1           1.000000000
    ## 43      AG (1) LUG           0.531250000
    ## 44   LUG (-1) EMF1           0.500000000
    ## 45   TFL1 (-1) AP3           0.987304688
    ## 46    TFL1 (1) LUG           0.500000000
    ## 47    SUP (-1) AP1           0.109375000
    ## 48     TFL1 (1) AG           0.500000000
    ## 49     LUG (-1) PI           1.000000000
    ## 50    AG (-1) EMF1           0.625000000
    ## 51      AG (1) AP3           0.987304688
    ## 52     LFY (1) LFY           0.187500000
    ## 53      AG (-1) AG           0.093750000
    ## 54    LFY (-1) UFO           0.593750000
    ## 55   EMF1 (-1) AP3           0.987304688
    ## 56      SUP (1) PI           1.000000000
    ## 57     UFO (1) LFY           0.109375000
    ## 58     LUG (1) LUG           1.000000000
    ## 59     TFL1 (1) PI           1.000000000
    ## 60   UFO (-1) TFL1           0.250000000
    ## 61    EMF1 (1) AP3           0.987304688
    ## 62    PI (-1) EMF1           0.619140625
    ## 63    PI (-1) TFL1           0.500000000
    ## 64   AP1 (-1) TFL1           0.500000000
    ## 65     LUG (1) AP3           0.987304688
    ## 66    EMF1 (1) SUP           0.500000000
    ## 67    AP3 (-1) LFY           0.265625000
    ## 68     UFO (1) UFO           1.000000000
    ## 69     EMF1 (1) AG           0.500000000
    ## 70     PI (1) EMF1           0.496093750
    ## 71     PI (-1) UFO           0.552734375
    ## 72      AP1 (1) AG           0.218750000
    ## 73       AG (1) AG           0.093750000
    ## 74   EMF1 (-1) SUP           0.500000000
    ## 75    TFL1 (1) SUP           0.515625000
    ## 76    EMF1 (-1) AG           0.093750000
    ## 77    TFL1 (1) UFO           0.509765625
    ## 78   AP3 (-1) EMF1           0.498046875
    ## 79     PI (-1) LUG           0.505859375
    ## 80    EMF1 (1) AP1           0.500000000
    ## 81     LUG (1) AP1           0.109375000
    ## 82    LUG (-1) LFY           0.109375000
    ## 83    UFO (-1) AP1           0.109375000
    ## 84    SUP (-1) LUG           0.500000000
    ## 85    LFY (-1) AP1           0.125000000
    ## 86     LUG (1) UFO           0.500000000
    ## 87     AP3 (1) LFY           0.078125000
    ## 88    EMF1 (-1) PI           1.000000000
    ## 89     AG (-1) AP3           0.987304688
    ## 90    UFO (-1) SUP           0.500000000
    ## 91   EMF1 (-1) UFO           0.500000000
    ## 92   UFO (-1) EMF1           0.500000000
    ## 93      LUG (1) AG           0.093750000
    ## 94    UFO (-1) LFY           0.484375000
    ## 95   TFL1 (-1) UFO           0.515625000
    ## 96     AG (1) EMF1           0.500000000
    ## 97    LFY (-1) LUG           0.593750000
    ## 98    AP1 (-1) AP1           0.187500000
    ## 99   TFL1 (-1) LUG           0.525390625
    ## 100   LUG (1) EMF1           0.500000000
    ## 101   AP1 (-1) SUP           0.593750000
    ## 102   AP1 (1) EMF1           0.468750000
    ## 103     UFO (1) AG           0.500000000
    ## 104    LFY (-1) PI           1.000000000
    ## 105  LUG (-1) TFL1           0.250000000
    ## 106   LFY (1) TFL1           0.468750000
    ## 107  LFY (-1) EMF1           0.468750000
    ## 108  EMF1 (1) EMF1           1.000000000
    ## 109   SUP (-1) SUP           0.000000000
    ## 110  SUP (-1) TFL1           0.250000000
    ## 111     AG (-1) PI           0.992187500
    ## 112     PI (-1) PI           1.000000000
    ## 113   EMF1 (1) LUG           0.500000000
    ## 114   TFL1 (1) AP1           0.687500000
    ## 115    SUP (1) SUP           0.000000000
    ## 116   AP3 (-1) AP1           0.080078125
    ## 117   AP3 (1) TFL1           0.500000000
    ## 118   LUG (1) TFL1           0.250000000
    ## 119    LFY (1) LUG           0.593750000
    ## 120     AP3 (1) AG           0.005859375
    ## 121    AG (-1) SUP           0.562500000
    ## 122   AP3 (-1) UFO           0.539062500
    ## 123  AP3 (-1) TFL1           0.500000000
    ## 124   AP3 (-1) SUP           0.537109375
    ## 125    AG (1) TFL1           0.000000000
    ## 126    SUP (1) AP1           0.109375000
    ## 127    LFY (1) SUP           0.593750000
    ## 128   UFO (1) TFL1           0.250000000
    ## 129   SUP (1) EMF1           0.500000000
    ## 130 EMF1 (-1) EMF1           0.000000000
    ## 131   UFO (1) EMF1           0.500000000
    ## 132    AP1 (1) AP3           0.987304688
    ## 133    PI (1) TFL1           0.000000000
    ## 134  AP1 (-1) EMF1           0.718750000
    ## 135     PI (1) LUG           0.517578125
    ## 136     AG (1) AP1           0.000000000
    ## 137      PI (1) AG           0.113281250
    ## 138   LFY (-1) SUP           0.593750000
    ## 139    LFY (1) UFO           0.593750000
    ## 140     PI (1) AP1           0.214843750
    ## 141    AP1 (-1) PI           1.000000000
    ## 142   LUG (-1) LUG           0.000000000
    ## 143   LFY (1) EMF1           0.468750000
    ## 144  TFL1 (1) TFL1           0.375000000
    ## 145    AP3 (1) SUP           0.539062500
    ## 146    PI (-1) AP3           0.987304688
    ## 147    AP1 (1) UFO           0.593750000
    ## 148   AP1 (-1) LFY           0.000000000
    ## 149    PI (-1) AP1           0.214843750
    ## 150   LUG (-1) AP3           0.987304688
    ## 151    SUP (-1) AG           0.500000000
    ## 152     AP1 (1) PI           1.000000000
    ## 153    LUG (1) LFY           0.109375000
    ## 154   TFL1 (-1) PI           1.000000000
    ## 155   UFO (-1) LUG           0.500000000
    ## 156  TFL1 (-1) SUP           0.509765625
    ## 157   SUP (-1) LFY           0.109375000
    ## 158    PI (-1) SUP           0.535156250
    ## 159     PI (1) LFY           0.214843750
    ## 160    EMF1 (1) PI           1.000000000
    ## 161   UFO (-1) AP3           0.987304688
    ## 162   EMF1 (1) UFO           0.500000000
    ## 163  TFL1 (1) EMF1           1.000000000
    ## 164   UFO (-1) UFO           1.000000000
    ## 165    AG (-1) LFY           0.125000000
    ## 166    UFO (-1) PI           1.000000000
    ## 167 EMF1 (-1) TFL1           0.000000000
    ## 168    AP3 (1) AP1           0.080078125
    ## 169    SUP (1) AP3           0.987304688
    ## 170     AG (1) UFO           0.562500000
    ## 171    LFY (-1) AG           0.166015625
    ## 172    UFO (1) SUP           0.500000000
    ## 173    AP1 (1) SUP           0.593750000
    ## 174    AG (-1) LUG           0.531250000
    ## 175    UFO (1) LUG           0.500000000
    ## 176   LFY (-1) LFY           0.187500000
    ## 177   AP3 (-1) LUG           0.505859375
    ## 178     LUG (1) PI           1.000000000

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

![Import network (a) and nodes/edges attributes (b) in Cytoscape software](transition_menu.tif)

In next steps, we import two CSV files of nodes/edges attributes via *File | Import | Table | File...* menu (*Figure 2(b)*). For the nodes attributes file, we should select *String* data type for the column *NetworkState* (*Figure 3*). For the edges attributes file, we must select *Edge Table Columns* in the drop-down list beside the text *Import Data as:* (*Figure 4*).

![Nodes attributes importing dialog](transition_menu_attr_node.bmp)

![Edges attributes importing dialog](transition_menu_attr_edge.bmp)

After importing, we select *Style* panel and modify the node and edge styles a little to highlight all attractor cycles. For node style, select *Red* color in *Fill Color* property for the nodes that belong to an attractor (*Figure 5(a)*). Regards to edge style, select *Red* color in *Stroke Color* property and change *Width* property to a larger value (optional) for the edges that connect two states of an attractor (*Figure 5(b)*).

![Nodes (a) and edges (b) style modification](style_node_edge.tif)

As a result, *Figure 6* shows the modified transition network with clearer indication of attractor cycles.

![The transition network of AMRN](amrn_attractors.tif)

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
amrn <- calSensitivity(amrn, set1, 1, "knockout")

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
ba_rbns <- calSensitivity(ba_rbns, set1, 1, "knockout")

# for each random network, calculate structural measures of all nodes/edges
ba_rbns <- findFBLs(ba_rbns, maxLength = 10)
```

    ## [1] "Number of found FBLs:9"
    ## [1] "Number of found positive FBLs:3"
    ## [1] "Number of found negative FBLs:6"
    ## [1] "Number of found FBLs:5"
    ## [1] "Number of found positive FBLs:3"
    ## [1] "Number of found negative FBLs:2"

``` r
ba_rbns <- findFFLs(ba_rbns)
```

    ## [1] "Number of found FFLs:6"
    ## [1] "Number of found coherent FFLs:5"
    ## [1] "Number of found incoherent FFLs:1"
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
    ## 1       0     9        3        6     3       0       1       2      9
    ## 2       1     0        0        0     1       0       0       1      2
    ## 3       2     8        2        6     4       2       1       1      8
    ## 4       3     1        1        0     0       0       0       0      2
    ## 5       4     4        0        4     1       1       0       0      3
    ## 6       5     2        0        2     0       0       0       0      2
    ## 7       6     4        1        3     1       0       1       0      2
    ## 8       7     2        0        2     1       0       1       0      2
    ## 9       8     2        2        0     0       0       0       0      2
    ## 10      9     0        0        0     1       1       0       0      2
    ##    In_Degree Out_Degree  Closeness Betweenness Stress Eigenvector
    ## 1          4          5 0.04545455   39.500000     46   0.5091245
    ## 2          2          0 0.01111111    0.000000      0   0.0000000
    ## 3          5          3 0.04166667   30.500000     35   0.3985130
    ## 4          1          1 0.03448276    0.000000      0   0.2628299
    ## 5          1          2 0.03703704    8.666667     12   0.3119327
    ## 6          1          1 0.03333334    1.666667      5   0.2057280
    ## 7          1          1 0.03703704    0.000000      0   0.2628299
    ## 8          1          1 0.03448276    0.000000      0   0.2057280
    ## 9          1          1 0.03333334    1.666667      5   0.2057280
    ## 10         0          2 0.05882353    0.000000      0   0.4685579
    ## 
    ## $edges
    ##      EdgeID NuFBL NuPosFBL NuNegFBL NuFFL NuFFL_AB NuFFL_BC NuFFL_AC
    ## 1  0 (-1) 1     0        0        0     1        0        1        0
    ## 2  0 (-1) 3     1        1        0     0        0        0        0
    ## 3  0 (-1) 4     4        0        4     0        0        0        0
    ## 4  0 (-1) 5     2        0        2     0        0        0        0
    ## 5  0 (-1) 8     2        2        0     0        0        0        0
    ## 6  2 (-1) 0     4        1        3     3        1        1        1
    ## 7  2 (-1) 6     4        1        3     1        1        0        0
    ## 8   2 (1) 1     0        0        0     1        0        0        1
    ## 9  3 (-1) 0     1        1        0     0        0        0        0
    ## 10 4 (-1) 2     2        0        2     1        0        0        1
    ## 11  4 (1) 7     2        0        2     1        1        0        0
    ## 12 5 (-1) 2     2        0        2     0        0        0        0
    ## 13  6 (1) 0     4        1        3     1        0        1        0
    ## 14 7 (-1) 2     2        0        2     1        0        1        0
    ## 15  8 (1) 2     2        2        0     0        0        0        0
    ## 16 9 (-1) 2     0        0        0     1        1        0        0
    ## 17  9 (1) 0     0        0        0     1        0        0        1
    ##    Degree Betweenness
    ## 1      11    3.500000
    ## 2      11    8.000000
    ## 3      12   16.666667
    ## 4      11    9.666667
    ## 5      11    9.666667
    ## 6      17   25.000000
    ## 7      10    8.000000
    ## 8      10    5.500000
    ## 9      11    8.000000
    ## 10     11    8.666667
    ## 11      5    8.000000
    ## 12     10    9.666667
    ## 13     11    8.000000
    ## 14     10    8.000000
    ## 15     10    9.666667
    ## 16     10    2.500000
    ## 17     11    6.500000
    ## 
    ## $network
    ##   NetworkID NuFBL NuPosFBL NuNegFBL NuFFL NuCoFFL NuInCoFFL
    ## 1  BA_RBN_1     9        3        6     6       5         1
    ## 
    ## $transitionNetwork
    ## [1] FALSE
    ## 
    ## $Group_1
    ##    GroupID knockout_t1000_r1
    ## 1        6       1.000000000
    ## 2        4       0.470703125
    ## 3        9       0.500000000
    ## 4        3       0.470703125
    ## 5        0       0.646484375
    ## 6        1       0.000000000
    ## 7        2       0.009765625
    ## 8        7       0.470703125
    ## 9        8       0.470703125
    ## 10       5       0.470703125
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
    ## 1       0     5        3        2     1       0       0       1     13
    ## 2       1     0        0        0     1       0       1       0      3
    ## 3       2     0        0        0     1       1       0       0      2
    ## 4       3     1        1        0     0       0       0       0      3
    ## 5       4     1        1        0     0       0       0       0      2
    ## 6       5     1        0        1     0       0       0       0      2
    ## 7       6     1        1        0     0       0       0       0      2
    ## 8       7     1        0        1     0       0       0       0      2
    ## 9       8     0        0        0     0       0       0       0      3
    ## 10      9     0        0        0     0       0       0       0      2
    ##    In_Degree Out_Degree  Closeness Betweenness Stress Eigenvector
    ## 1          8          5 0.02222222        38.5     43   0.3077287
    ## 2          2          1 0.02439024         2.5      5   0.3077287
    ## 3          0          2 0.03125000         0.0      0   0.3692745
    ## 4          2          1 0.02040816         2.5      5   0.3077287
    ## 5          1          1 0.02040816         0.0      0   0.3077287
    ## 6          1          1 0.02040816         0.0      0   0.3077287
    ## 7          1          1 0.02040816         0.0      0   0.3077287
    ## 8          1          1 0.02040816         0.0      0   0.3077287
    ## 9          1          2 0.02777778         1.5      2   0.1230915
    ## 10         0          2 0.04166667         0.0      0   0.4308202
    ## 
    ## $edges
    ##      EdgeID NuFBL NuPosFBL NuNegFBL NuFFL NuFFL_AB NuFFL_BC NuFFL_AC
    ## 1  0 (-1) 4     1        1        0     0        0        0        0
    ## 2  0 (-1) 5     1        0        1     0        0        0        0
    ## 3  0 (-1) 7     1        0        1     0        0        0        0
    ## 4   0 (1) 3     1        1        0     0        0        0        0
    ## 5   0 (1) 6     1        1        0     0        0        0        0
    ## 6  1 (-1) 0     0        0        0     1        0        1        0
    ## 7  2 (-1) 0     0        0        0     1        0        0        1
    ## 8  2 (-1) 1     0        0        0     1        1        0        0
    ## 9   3 (1) 0     1        1        0     0        0        0        0
    ## 10 4 (-1) 0     1        1        0     0        0        0        0
    ## 11  5 (1) 0     1        0        1     0        0        0        0
    ## 12  6 (1) 0     1        1        0     0        0        0        0
    ## 13  7 (1) 0     1        0        1     0        0        0        0
    ## 14 8 (-1) 1     0        0        0     0        0        0        0
    ## 15 8 (-1) 3     0        0        0     0        0        0        0
    ## 16 9 (-1) 0     0        0        0     0        0        0        0
    ## 17  9 (1) 8     0        0        0     0        0        0        0
    ##    Degree Betweenness
    ## 1      15         9.0
    ## 2      15         9.0
    ## 3      15         9.0
    ## 4      16         7.5
    ## 5      15         9.0
    ## 6      16         8.5
    ## 7      15         6.0
    ## 8       5         1.0
    ## 9      16         7.5
    ## 10     15         5.0
    ## 11     15         5.0
    ## 12     15         5.0
    ## 13     15         5.0
    ## 14      6         4.5
    ## 15      6         4.0
    ## 16     15         5.5
    ## 17      5         2.5
    ## 
    ## $network
    ##   NetworkID NuFBL NuPosFBL NuNegFBL NuFFL NuCoFFL NuInCoFFL
    ## 1  BA_RBN_2     5        3        2     3       1         2
    ## 
    ## $transitionNetwork
    ## [1] FALSE
    ## 
    ## $Group_1
    ##    GroupID knockout_t1000_r1
    ## 1        2              0.50
    ## 2        0              0.00
    ## 3        6              0.00
    ## 4        4              1.00
    ## 5        1              0.25
    ## 6        9              0.50
    ## 7        7              1.00
    ## 8        8              0.50
    ## 9        5              1.00
    ## 10       3              0.00
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
amrn_rbns <- calSensitivity(amrn_rbns, set1, 1, "edge removal")

# for each random network, calculate structural measures of all nodes/edges
amrn_rbns <- findFBLs(amrn_rbns, maxLength = 10)
```

    ## [1] "Number of found FBLs:11"
    ## [1] "Number of found positive FBLs:4"
    ## [1] "Number of found negative FBLs:7"
    ## [1] "Number of found FBLs:17"
    ## [1] "Number of found positive FBLs:14"
    ## [1] "Number of found negative FBLs:3"

``` r
amrn_rbns <- findFFLs(amrn_rbns)
```

    ## [1] "Number of found FFLs:14"
    ## [1] "Number of found coherent FFLs:9"
    ## [1] "Number of found incoherent FFLs:5"
    ## [1] "Number of found FFLs:19"
    ## [1] "Number of found coherent FFLs:14"
    ## [1] "Number of found incoherent FFLs:5"

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
    ## 1      AG     7        2        5     6       0       1       5      5
    ## 2     AP1     2        2        0     4       2       2       0      5
    ## 3     AP3     7        2        5     8       0       4       4      7
    ## 4    EMF1     0        0        0     2       2       0       0      3
    ## 5     LFY     8        3        5    10       7       2       1      8
    ## 6     LUG     0        0        0     0       0       0       0      1
    ## 7      PI     6        2        4     8       1       3       4      7
    ## 8     SUP     0        0        0     1       1       0       0      2
    ## 9    TFL1     5        1        4     6       2       3       1      4
    ## 10    UFO     0        0        0     0       0       0       0      2
    ##    In_Degree Out_Degree  Closeness Betweenness Stress Eigenvector
    ## 1          4          1 0.02040816    8.833333     10  0.26294823
    ## 2          3          2 0.02083333    2.833333      4  0.38536936
    ## 3          5          2 0.02040816   12.333333     13  0.20595247
    ## 4          0          3 0.02500000    0.000000      0  0.39772356
    ## 5          3          5 0.02222222   14.666667     17  0.56478624
    ## 6          0          1 0.02222222    0.000000      0  0.09588555
    ## 7          5          2 0.01960784    5.333333      7  0.17941689
    ## 8          0          2 0.02500000    0.000000      0  0.34647957
    ## 9          2          2 0.01960784    0.000000      0  0.17941689
    ## 10         0          2 0.02500000    0.000000      0  0.26294823
    ## 
    ## $edges
    ##           EdgeID NuFBL NuPosFBL NuNegFBL NuFFL NuFFL_AB NuFFL_BC NuFFL_AC
    ## 1    AG (-1) LFY     7        2        5     1        0        1        0
    ## 2    AP1 (-1) AG     1        1        0     4        1        2        1
    ## 3    AP1 (1) LFY     1        1        0     2        1        0        1
    ## 4     AP3 (1) AG     5        1        4     2        0        2        0
    ## 5     AP3 (1) PI     2        1        1     2        0        2        0
    ## 6   EMF1 (-1) AG     0        0        0     1        0        0        1
    ## 7  EMF1 (-1) AP3     0        0        0     1        1        0        0
    ## 8   EMF1 (1) AP1     0        0        0     1        1        0        0
    ## 9  LFY (-1) TFL1     2        0        2     3        2        0        1
    ## 10    LFY (1) AG     1        0        1     2        0        1        1
    ## 11   LFY (1) AP1     2        2        0     1        1        0        0
    ## 12   LFY (1) AP3     1        0        1     3        2        0        1
    ## 13    LFY (1) PI     2        1        1     4        2        1        1
    ## 14  LUG (-1) AP3     0        0        0     0        0        0        0
    ## 15    PI (1) AP3     3        1        2     3        0        2        1
    ## 16   PI (1) TFL1     3        1        2     2        1        1        0
    ## 17  SUP (-1) LFY     0        0        0     1        1        0        0
    ## 18   SUP (-1) PI     0        0        0     1        0        0        1
    ## 19 TFL1 (-1) AP3     3        1        2     4        1        2        1
    ## 20  TFL1 (-1) PI     2        0        2     3        1        1        1
    ## 21   UFO (1) AP1     0        0        0     0        0        0        0
    ## 22    UFO (1) PI     0        0        0     0        0        0        0
    ##    Degree Betweenness
    ## 1      13   13.833333
    ## 2      10    2.000000
    ## 3      13    5.833333
    ## 4      12   12.000000
    ## 5      14    5.333333
    ## 6       8    1.833333
    ## 7      10    2.333333
    ## 8       8    1.833333
    ## 9      12    4.166667
    ## 10     13    2.000000
    ## 11     13    7.000000
    ## 12     15    3.500000
    ## 13     15    3.000000
    ## 14      8    6.000000
    ## 15     14    5.500000
    ## 16     11    4.833333
    ## 17     10    4.000000
    ## 18      9    2.000000
    ## 19     11    4.000000
    ## 20     11    1.000000
    ## 21      7    3.000000
    ## 22      9    3.000000
    ## 
    ## $network
    ##    NetworkID NuFBL NuPosFBL NuNegFBL NuFFL NuCoFFL NuInCoFFL
    ## 1 AMRN_RBN_1    11        4        7    14       9         5
    ## 
    ## $transitionNetwork
    ## [1] FALSE
    ## 
    ## $Group_1
    ##          GroupID edgeremoval_t1000_r1
    ## 1     LFY (1) PI          0.001953125
    ## 2     AP3 (1) PI          0.078125000
    ## 3     UFO (1) PI          0.000000000
    ## 4     PI (1) AP3          0.000000000
    ## 5  TFL1 (-1) AP3          0.000000000
    ## 6   EMF1 (1) AP1          0.062500000
    ## 7    SUP (-1) PI          0.000000000
    ## 8   LUG (-1) AP3          0.000000000
    ## 9   SUP (-1) LFY          0.078125000
    ## 10   AP1 (-1) AG          0.000000000
    ## 11   AP1 (1) LFY          0.484375000
    ## 12   UFO (1) AP1          0.078125000
    ## 13    AP3 (1) AG          0.000000000
    ## 14   AG (-1) LFY          0.031250000
    ## 15    LFY (1) AG          0.000000000
    ## 16  EMF1 (-1) AG          0.015625000
    ## 17 EMF1 (-1) AP3          0.078125000
    ## 18  TFL1 (-1) PI          0.000000000
    ## 19   PI (1) TFL1          0.984375000
    ## 20   LFY (1) AP3          0.500000000
    ## 21   LFY (1) AP1          0.234375000
    ## 22 LFY (-1) TFL1          0.017578125
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
    ## 1      AG    10       10        0     6       0       2       4      5
    ## 2     AP1    13       10        3     5       0       3       2      5
    ## 3     AP3    12       10        2     8       1       3       4      7
    ## 4    EMF1     0        0        0     2       2       0       0      3
    ## 5     LFY    14       11        3    12       7       3       2      8
    ## 6     LUG     0        0        0     0       0       0       0      1
    ## 7      PI    11        9        2     8       2       3       3      7
    ## 8     SUP     0        0        0     1       1       0       0      2
    ## 9    TFL1     8        7        1     4       1       2       1      4
    ## 10    UFO     0        0        0     2       2       0       0      2
    ##    In_Degree Out_Degree  Closeness Betweenness Stress Eigenvector
    ## 1          4          1 0.01960784    2.833333      5   0.1110199
    ## 2          3          2 0.02083333    5.500000      7   0.2476891
    ## 3          5          2 0.02083333    9.666667     14   0.2913886
    ## 4          0          3 0.02564103    0.000000      0   0.3276253
    ## 5          3          5 0.02222222   13.166667     18   0.5390777
    ## 6          0          1 0.02272727    0.000000      0   0.1306070
    ## 7          5          2 0.02083333    6.833333     10   0.3722339
    ## 8          0          2 0.02380952    0.000000      0   0.2974507
    ## 9          2          2 0.02040816    2.000000      3   0.1803687
    ## 10         0          2 0.02500000    0.000000      0   0.4084706
    ## 
    ## $edges
    ##           EdgeID NuFBL NuPosFBL NuNegFBL NuFFL NuFFL_AB NuFFL_BC NuFFL_AC
    ## 1    AG (-1) AP1    10       10        0     2        0        2        0
    ## 2    AP1 (-1) PI     9        7        2     2        0        2        0
    ## 3   AP1 (1) TFL1     4        3        1     1        0        1        0
    ## 4     AP3 (1) AG     4        4        0     3        0        2        1
    ## 5    AP3 (1) LFY     8        6        2     2        1        1        0
    ## 6  EMF1 (-1) AP1     0        0        0     2        1        0        1
    ## 7   EMF1 (-1) PI     0        0        0     1        0        0        1
    ## 8    EMF1 (1) AG     0        0        0     1        1        0        0
    ## 9  LFY (-1) TFL1     4        4        0     3        2        0        1
    ## 10    LFY (1) AG     3        3        0     3        1        1        1
    ## 11   LFY (1) AP1     3        0        3     3        2        0        1
    ## 12   LFY (1) AP3     2        2        0     3        1        1        1
    ## 13    LFY (1) PI     2        2        0     3        1        1        1
    ## 14  LUG (-1) AP3     0        0        0     0        0        0        0
    ## 15    PI (1) AP3     5        4        1     4        1        2        1
    ## 16    PI (1) LFY     6        5        1     3        1        1        1
    ## 17  SUP (-1) AP3     0        0        0     1        0        0        1
    ## 18   SUP (-1) PI     0        0        0     1        1        0        0
    ## 19  TFL1 (-1) AG     3        3        0     2        0        1        1
    ## 20 TFL1 (-1) AP3     5        4        1     2        1        1        0
    ## 21   UFO (1) LFY     0        0        0     2        1        0        1
    ## 22    UFO (1) PI     0        0        0     2        1        0        1
    ##    Degree Betweenness
    ## 1      10    7.833333
    ## 2      12    5.500000
    ## 3       9    5.000000
    ## 4      12    4.833333
    ## 5      15    9.833333
    ## 6       8    2.000000
    ## 7      10    3.000000
    ## 8       8    1.000000
    ## 9      12    6.000000
    ## 10     13    2.500000
    ## 11     13    4.666667
    ## 12     15    1.500000
    ## 13     15    3.500000
    ## 14      8    6.000000
    ## 15     14    4.000000
    ## 16     15    7.833333
    ## 17      9    3.666667
    ## 18      9    2.333333
    ## 19      9    3.500000
    ## 20     11    3.500000
    ## 21     10    4.500000
    ## 22      9    1.500000
    ## 
    ## $network
    ##    NetworkID NuFBL NuPosFBL NuNegFBL NuFFL NuCoFFL NuInCoFFL
    ## 1 AMRN_RBN_2    17       14        3    19      14         5
    ## 
    ## $transitionNetwork
    ## [1] FALSE
    ## 
    ## $Group_1
    ##          GroupID edgeremoval_t1000_r1
    ## 1   EMF1 (-1) PI          0.000000000
    ## 2     LFY (1) PI          0.968750000
    ## 3    SUP (-1) PI          0.000000000
    ## 4    AP1 (-1) PI          0.000000000
    ## 5     PI (1) AP3          0.007812500
    ## 6     UFO (1) PI          0.025390625
    ## 7   SUP (-1) AP3          0.093750000
    ## 8  LFY (-1) TFL1          0.045898438
    ## 9     PI (1) LFY          0.039062500
    ## 10   AG (-1) AP1          0.050781250
    ## 11   EMF1 (1) AG          0.019531250
    ## 12  AP1 (1) TFL1          0.925781250
    ## 13   LFY (1) AP3          0.468750000
    ## 14   LFY (1) AP1          0.968750000
    ## 15  TFL1 (-1) AG          0.001953125
    ## 16 EMF1 (-1) AP1          0.000000000
    ## 17 TFL1 (-1) AP3          0.000000000
    ## 18    LFY (1) AG          0.041015625
    ## 19   UFO (1) LFY          0.072265625
    ## 20   AP3 (1) LFY          0.296875000
    ## 21    AP3 (1) AG          0.019531250
    ## 22  LUG (-1) AP3          0.062500000
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
