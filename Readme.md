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
amrn <- calSensitivity(amrn, set1, 1, "rule flip", numRuleSets = 2)
print(amrn$Group_1)
```

    ##    GroupID ruleflip_t1000_r1 ruleflip_t1000_r2
    ## 1      LFY         0.9062500         0.9062500
    ## 2     TFL1         0.4687500         0.4687500
    ## 3     EMF1         0.0000000         0.0000000
    ## 4       AG         1.0000000         1.0000000
    ## 5      AP1         0.9687500         0.9687500
    ## 6      SUP         0.0000000         0.0000000
    ## 7      AP3         0.7617188         0.9707031
    ## 8      LUG         0.0000000         0.0000000
    ## 9       PI         0.7988281         0.9707031
    ## 10     UFO         0.0000000         0.0000000

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
    ## 1    LFY (1) AP1           0.42187500
    ## 2  EMF1 (-1) AP1           0.00000000
    ## 3    LFY (1) AP3           0.00390625
    ## 4  TFL1 (-1) LFY           0.12500000
    ## 5      PI (1) PI           0.00390625
    ## 6    AP3 (1) AP3           0.00000000
    ## 7  EMF1 (-1) LFY           0.00000000
    ## 8   SUP (-1) AP3           0.01562500
    ## 9  LFY (-1) TFL1           0.00000000
    ## 10    LFY (1) AG           0.14062500
    ## 11   AG (-1) AP1           0.12500000
    ## 12 EMF1 (1) TFL1           0.46875000
    ## 13    UFO (1) PI           0.01757812
    ## 14   SUP (-1) PI           0.01757812
    ## 15  TFL1 (-1) AG           0.01269531
    ## 16   LUG (-1) AG           0.09375000
    ## 17   UFO (1) AP3           0.01562500
    ## 18   AP1 (1) LFY           0.46875000
    ## 19    PI (1) AP3           0.18945312
    ## 20    AP3 (1) PI           0.02539062
    ## 21   AP1 (-1) AG           0.03125000
    ## 22    LFY (1) PI           0.18164062

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
    ## 1     SUP (-1) AP1           0.109375000
    ## 2    TFL1 (-1) AP1           0.218750000
    ## 3    EMF1 (-1) AP3           0.987304688
    ## 4     UFO (-1) UFO           1.000000000
    ## 5      LUG (1) LUG           0.000000000
    ## 6      PI (-1) LFY           0.214843750
    ## 7      TFL1 (1) AG           0.093750000
    ## 8     AP3 (-1) UFO           0.537109375
    ## 9    SUP (-1) EMF1           0.500000000
    ## 10    LFY (1) TFL1           0.468750000
    ## 11     LUG (1) AP1           0.109375000
    ## 12    LUG (-1) AP3           0.987304688
    ## 13    TFL1 (1) AP1           0.468750000
    ## 14   EMF1 (1) EMF1           1.000000000
    ## 15      PI (1) SUP           0.552734375
    ## 16      PI (1) AP1           0.214843750
    ## 17    UFO (-1) AP3           0.987304688
    ## 18   AP3 (-1) TFL1           0.500000000
    ## 19    SUP (-1) UFO           0.500000000
    ## 20   TFL1 (-1) SUP           0.515625000
    ## 21    UFO (-1) AP1           0.109375000
    ## 22    EMF1 (1) LFY           0.468750000
    ## 23   TFL1 (-1) AP3           0.987304688
    ## 24    LUG (-1) UFO           0.500000000
    ## 25     AG (-1) LUG           0.593750000
    ## 26     AP3 (-1) PI           1.000000000
    ## 27      LUG (1) PI           1.000000000
    ## 28      AG (1) AP3           0.987304688
    ## 29   TFL1 (-1) LUG           0.525390625
    ## 30      AG (-1) PI           0.992187500
    ## 31    SUP (1) EMF1           0.500000000
    ## 32    TFL1 (1) SUP           0.509765625
    ## 33    AP1 (1) EMF1           0.718750000
    ## 34   AP1 (-1) TFL1           0.000000000
    ## 35     SUP (-1) AG           0.046875000
    ## 36     EMF1 (1) AG           0.093750000
    ## 37     LFY (1) SUP           0.593750000
    ## 38    AP3 (1) EMF1           0.498046875
    ## 39     PI (-1) UFO           0.552734375
    ## 40    LFY (-1) LFY           0.187500000
    ## 41    EMF1 (-1) PI           1.000000000
    ## 42     AP3 (1) UFO           0.539062500
    ## 43     SUP (1) LFY           0.484375000
    ## 44    AP3 (-1) LUG           0.517578125
    ## 45    SUP (-1) LFY           0.484375000
    ## 46     AP1 (1) UFO           0.593750000
    ## 47   EMF1 (-1) LUG           0.500000000
    ## 48    LUG (-1) SUP           0.500000000
    ## 49   UFO (-1) TFL1           0.250000000
    ## 50     AP3 (1) AP1           0.968750000
    ## 51    AP3 (-1) LFY           0.078125000
    ## 52    AP1 (-1) AP3           0.987304688
    ## 53    LUG (1) EMF1           0.500000000
    ## 54    AP1 (1) TFL1           0.218750000
    ## 55   AP1 (-1) EMF1           0.468750000
    ## 56     SUP (1) AP3           0.987304688
    ## 57     AG (1) TFL1           0.500000000
    ## 58      PI (1) UFO           0.552734375
    ## 59     LFY (-1) AG           0.968750000
    ## 60    PI (-1) TFL1           0.094726562
    ## 61    TFL1 (1) LFY           0.218750000
    ## 62    AP1 (-1) SUP           0.593750000
    ## 63      AG (1) AP1           0.312500000
    ## 64    EMF1 (1) UFO           0.500000000
    ## 65      LUG (1) AG           0.093750000
    ## 66     LFY (1) LUG           0.593750000
    ## 67     AG (-1) LFY           0.203125000
    ## 68    TFL1 (1) UFO           0.515625000
    ## 69    AP3 (-1) AP3           0.987304688
    ## 70    TFL1 (1) LUG           0.525390625
    ## 71      AG (1) LUG           0.531250000
    ## 72    AG (-1) TFL1           0.000000000
    ## 73      AP1 (1) PI           1.000000000
    ## 74    SUP (-1) SUP           1.000000000
    ## 75     LUG (1) UFO           0.500000000
    ## 76     LUG (1) SUP           0.500000000
    ## 77    TFL1 (1) AP3           0.987304688
    ## 78    LFY (1) EMF1           0.718750000
    ## 79       PI (1) AG           0.996093750
    ## 80      PI (1) LUG           0.517578125
    ## 81     UFO (1) AP1           0.484375000
    ## 82    UFO (-1) LUG           0.500000000
    ## 83     UFO (1) SUP           0.500000000
    ## 84   SUP (-1) TFL1           0.250000000
    ## 85    AP1 (-1) LFY           0.218750000
    ## 86  TFL1 (-1) EMF1           1.000000000
    ## 87    EMF1 (1) SUP           0.500000000
    ## 88      AG (1) SUP           0.562500000
    ## 89     UFO (1) LFY           0.109375000
    ## 90     EMF1 (1) PI           1.000000000
    ## 91    AP1 (-1) LUG           0.593750000
    ## 92    AP1 (-1) AP1           0.187500000
    ## 93     LFY (-1) PI           1.000000000
    ## 94      AG (-1) AG           0.578125000
    ## 95     AP1 (1) LUG           0.593750000
    ## 96     LUG (1) LFY           0.484375000
    ## 97    LFY (-1) SUP           0.593750000
    ## 98    AP3 (1) TFL1           0.000000000
    ## 99    SUP (-1) LUG           0.500000000
    ## 100  TFL1 (1) TFL1           0.500000000
    ## 101  LUG (-1) EMF1           0.500000000
    ## 102 EMF1 (-1) TFL1           0.000000000
    ## 103      AG (1) PI           0.992187500
    ## 104    UFO (1) UFO           1.000000000
    ## 105    UFO (1) LUG           0.500000000
    ## 106   UFO (1) EMF1           0.500000000
    ## 107    PI (1) TFL1           0.000000000
    ## 108  EMF1 (-1) SUP           0.500000000
    ## 109    AP3 (1) SUP           0.539062500
    ## 110    SUP (1) SUP           1.000000000
    ## 111   LFY (-1) UFO           0.593750000
    ## 112     PI (-1) AG           0.113281250
    ## 113 TFL1 (-1) TFL1           0.375000000
    ## 114  LFY (-1) EMF1           0.468750000
    ## 115   AP3 (-1) SUP           0.539062500
    ## 116   TFL1 (-1) PI           1.000000000
    ## 117  UFO (-1) EMF1           0.500000000
    ## 118    PI (-1) SUP           0.535156250
    ## 119     AG (1) LFY           0.171875000
    ## 120    PI (1) EMF1           0.619140625
    ## 121   EMF1 (1) AP3           0.987304688
    ## 122   AP1 (-1) UFO           0.593750000
    ## 123    AG (1) EMF1           0.500000000
    ## 124     AP3 (1) AG           0.005859375
    ## 125     SUP (1) PI           1.000000000
    ## 126    AP3 (-1) AG           0.005859375
    ## 127   LFY (-1) AP3           0.987304688
    ## 128   EMF1 (1) LUG           0.500000000
    ## 129  TFL1 (-1) UFO           0.515625000
    ## 130    LFY (1) LFY           0.781250000
    ## 131    TFL1 (1) PI           1.000000000
    ## 132    SUP (1) LUG           0.500000000
    ## 133    AG (-1) SUP           0.562500000
    ## 134    AG (-1) AP3           0.987304688
    ## 135  TFL1 (1) EMF1           0.625000000
    ## 136   UFO (1) TFL1           0.250000000
    ## 137    PI (-1) AP3           0.987304688
    ## 138    PI (-1) AP1           0.070312500
    ## 139     UFO (1) AG           0.046875000
    ## 140   AG (-1) EMF1           0.625000000
    ## 141   EMF1 (1) AP1           0.218750000
    ## 142    LUG (-1) PI           1.000000000
    ## 143    SUP (1) UFO           0.500000000
    ## 144     PI (-1) PI           1.000000000
    ## 145    SUP (1) AP1           0.109375000
    ## 146   LUG (-1) LFY           0.109375000
    ## 147   UFO (-1) SUP           0.500000000
    ## 148     PI (1) LFY           0.968750000
    ## 149   AP3 (-1) AP1           0.216796875
    ## 150  AP3 (-1) EMF1           0.619140625
    ## 151   LUG (-1) AP1           0.109375000
    ## 152   LFY (-1) AP1           0.125000000
    ## 153    LFY (1) UFO           0.593750000
    ## 154     AP1 (1) AG           0.000000000
    ## 155    LUG (1) AP3           0.987304688
    ## 156    UFO (-1) AG           0.500000000
    ## 157    AP1 (1) SUP           0.593750000
    ## 158    AP1 (-1) PI           1.000000000
    ## 159     AG (1) UFO           0.562500000
    ## 160    AG (-1) UFO           0.562500000
    ## 161     SUP (1) AG           0.500000000
    ## 162    UFO (-1) PI           1.000000000
    ## 163   EMF1 (-1) AG           0.000000000
    ## 164    AP3 (1) LFY           0.078125000
    ## 165  EMF1 (-1) UFO           0.500000000
    ## 166      AG (1) AG           0.578125000
    ## 167   LUG (1) TFL1           0.250000000
    ## 168    AP1 (1) AP1           0.062500000
    ## 169   LFY (-1) LUG           0.593750000
    ## 170   LUG (-1) LUG           0.000000000
    ## 171    AP3 (1) LUG           0.517578125
    ## 172   SUP (1) TFL1           0.250000000
    ## 173   UFO (-1) LFY           0.484375000
    ## 174    AP1 (1) AP3           0.987304688
    ## 175  LUG (-1) TFL1           0.250000000
    ## 176   PI (-1) EMF1           0.496093750
    ## 177 EMF1 (-1) EMF1           1.000000000
    ## 178    PI (-1) LUG           0.505859375

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

    ## [1] "Number of found FBLs:6"
    ## [1] "Number of found positive FBLs:3"
    ## [1] "Number of found negative FBLs:3"
    ## [1] "Number of found FBLs:14"
    ## [1] "Number of found positive FBLs:5"
    ## [1] "Number of found negative FBLs:9"

``` r
ba_rbns <- findFFLs(ba_rbns)
```

    ## [1] "Number of found FFLs:7"
    ## [1] "Number of found coherent FFLs:1"
    ## [1] "Number of found incoherent FFLs:6"
    ## [1] "Number of found FFLs:3"
    ## [1] "Number of found coherent FFLs:0"
    ## [1] "Number of found incoherent FFLs:3"

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
    ## 1       0     3        1        2     3       1       1       1      4
    ## 2       1     3        2        1     1       1       0       0      4
    ## 3       2     4        2        2     2       1       1       0      4
    ## 4       3     6        3        3     3       0       2       1      7
    ## 5       4     0        0        0     2       0       0       2      3
    ## 6       5     3        1        2     0       0       0       0      3
    ## 7       6     3        2        1     0       0       0       0      2
    ## 8       7     1        1        0     0       0       0       0      2
    ## 9       8     0        0        0     1       1       0       0      3
    ## 10      9     0        0        0     0       0       0       0      2
    ##    In_Degree Out_Degree  Closeness Betweenness Stress Eigenvector
    ## 1          2          2 0.02857143    9.333333     16   0.2418950
    ## 2          2          2 0.02777778   15.500000     24   0.3913943
    ## 3          2          2 0.02941176    9.666667     19   0.3913943
    ## 4          4          3 0.03125000   29.666667     43   0.3913943
    ## 5          3          0 0.01111111    0.000000      0   0.0000000
    ## 6          1          2 0.02777778   11.500000     16   0.3913943
    ## 7          1          1 0.02500000    6.000000      8   0.2418950
    ## 8          1          1 0.02702703    1.833333      4   0.2418950
    ## 9          0          3 0.05555556    0.000000      0   0.3913943
    ## 10         1          1 0.02941176    2.500000      3   0.2418950
    ## 
    ## $edges
    ##      EdgeID NuFBL NuPosFBL NuNegFBL NuFFL NuFFL_AB NuFFL_BC NuFFL_AC
    ## 1  0 (-1) 4     0        0        0     1        0        0        1
    ## 2   0 (1) 3     3        1        2     2        1        1        0
    ## 3   1 (1) 0     1        0        1     1        0        0        1
    ## 4   1 (1) 2     2        2        0     1        1        0        0
    ## 5  2 (-1) 0     2        1        1     2        1        1        0
    ## 6  2 (-1) 3     2        1        1     1        0        0        1
    ## 7  3 (-1) 5     3        1        2     0        0        0        0
    ## 8   3 (1) 4     0        0        0     2        0        2        0
    ## 9   3 (1) 6     3        2        1     0        0        0        0
    ## 10 5 (-1) 2     2        0        2     0        0        0        0
    ## 11 5 (-1) 7     1        1        0     0        0        0        0
    ## 12 6 (-1) 1     3        2        1     0        0        0        0
    ## 13  7 (1) 3     1        1        0     0        0        0        0
    ## 14 8 (-1) 4     0        0        0     1        0        0        1
    ## 15  8 (1) 3     0        0        0     1        1        0        0
    ## 16  8 (1) 9     0        0        0     0        0        0        0
    ## 17 9 (-1) 1     0        0        0     0        0        0        0
    ##    Degree Betweenness
    ## 1       7    4.833333
    ## 2      11   11.500000
    ## 3       8   13.500000
    ## 4       8    9.000000
    ## 5       8    3.833333
    ## 6      11   12.833333
    ## 7      10   19.500000
    ## 8      10    3.166667
    ## 9       9   14.000000
    ## 10      7    8.666667
    ## 11      5    9.833333
    ## 12      6   13.000000
    ## 13      9    8.833333
    ## 14      6    1.000000
    ## 15     10    4.500000
    ## 16      5    3.500000
    ## 17      6   10.500000
    ## 
    ## $network
    ##   NetworkID NuFBL NuPosFBL NuNegFBL NuFFL NuCoFFL NuInCoFFL
    ## 1  BA_RBN_1     6        3        3     7       1         6
    ## 
    ## $transitionNetwork
    ## [1] FALSE
    ## 
    ## $Group_1
    ##    GroupID knockout_t1000_r1
    ## 1        8               0.5
    ## 2        6               0.0
    ## 3        2               0.0
    ## 4        9               0.5
    ## 5        3               0.0
    ## 6        4               0.0
    ## 7        0               0.5
    ## 8        5               1.0
    ## 9        7               0.0
    ## 10       1               0.5
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
    ## 1       0    12        5        7     1       0       0       1      6
    ## 2       1    13        5        8     1       1       0       0      8
    ## 3       2     4        1        3     0       0       0       0      4
    ## 4       3     5        1        4     0       0       0       0      3
    ## 5       4     8        2        6     1       0       1       0      3
    ## 6       5     3        1        2     0       0       0       0      2
    ## 7       6     3        1        2     0       0       0       0      2
    ## 8       7     1        0        1     0       0       0       0      2
    ## 9       8     3        2        1     0       0       0       0      2
    ## 10      9     4        1        3     0       0       0       0      2
    ##    In_Degree Out_Degree  Closeness Betweenness Stress Eigenvector
    ## 1          2          4 0.05555556       43.00     58   0.5113487
    ## 2          5          3 0.06250000       50.50     69   0.5116587
    ## 3          2          2 0.05000000       18.25     25   0.3212049
    ## 4          1          2 0.04545455        8.00     14   0.3038400
    ## 5          2          1 0.04166667        8.00     14   0.2464463
    ## 6          1          1 0.04347826        2.25      9   0.2465957
    ## 7          1          1 0.04347826        2.25      9   0.2465957
    ## 8          1          1 0.03571429        0.00      0   0.1548058
    ## 9          1          1 0.04347826        2.25      9   0.2465957
    ## 10         1          1 0.03571429        0.50      1   0.1187756
    ## 
    ## $edges
    ##      EdgeID NuFBL NuPosFBL NuNegFBL NuFFL NuFFL_AB NuFFL_BC NuFFL_AC
    ## 1  0 (-1) 2     3        1        2     0        0        0        0
    ## 2  0 (-1) 5     3        1        2     0        0        0        0
    ## 3  0 (-1) 8     3        2        1     0        0        0        0
    ## 4   0 (1) 6     3        1        2     0        0        0        0
    ## 5  1 (-1) 0     4        3        1     1        0        0        1
    ## 6  1 (-1) 4     4        1        3     1        1        0        0
    ## 7   1 (1) 3     5        1        4     0        0        0        0
    ## 8  2 (-1) 7     1        0        1     0        0        0        0
    ## 9   2 (1) 1     3        1        2     0        0        0        0
    ## 10 3 (-1) 1     1        0        1     0        0        0        0
    ## 11 3 (-1) 9     4        1        3     0        0        0        0
    ## 12 4 (-1) 0     8        2        6     1        0        1        0
    ## 13  5 (1) 1     3        1        2     0        0        0        0
    ## 14 6 (-1) 1     3        1        2     0        0        0        0
    ## 15  7 (1) 2     1        0        1     0        0        0        0
    ## 16 8 (-1) 1     3        2        1     0        0        0        0
    ## 17  9 (1) 4     4        1        3     0        0        0        0
    ##    Degree Betweenness
    ## 1      10       18.25
    ## 2       8       11.25
    ## 3       8       11.25
    ## 4       8       11.25
    ## 5      14       35.00
    ## 6      11        7.50
    ## 7      11       17.00
    ## 8       6        9.00
    ## 9      12       18.25
    ## 10     11        7.50
    ## 11      5        9.50
    ## 12      9       17.00
    ## 13     10       11.25
    ## 14     10       11.25
    ## 15      6        9.00
    ## 16     10       11.25
    ## 17      5        9.50
    ## 
    ## $network
    ##   NetworkID NuFBL NuPosFBL NuNegFBL NuFFL NuCoFFL NuInCoFFL
    ## 1  BA_RBN_2    14        5        9     3       0         3
    ## 
    ## $transitionNetwork
    ## [1] FALSE
    ## 
    ## $Group_1
    ##    GroupID knockout_t1000_r1
    ## 1        6        0.00000000
    ## 2        2        1.00000000
    ## 3        0        0.82421875
    ## 4        9        1.00000000
    ## 5        8        1.00000000
    ## 6        5        1.00000000
    ## 7        7        1.00000000
    ## 8        4        1.00000000
    ## 9        3        0.26171875
    ## 10       1        0.02148438
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

    ## [1] "Number of found FBLs:4"
    ## [1] "Number of found positive FBLs:1"
    ## [1] "Number of found negative FBLs:3"
    ## [1] "Number of found FBLs:10"
    ## [1] "Number of found positive FBLs:8"
    ## [1] "Number of found negative FBLs:2"

``` r
amrn_rbns <- findFFLs(amrn_rbns)
```

    ## [1] "Number of found FFLs:19"
    ## [1] "Number of found coherent FFLs:7"
    ## [1] "Number of found incoherent FFLs:12"
    ## [1] "Number of found FFLs:16"
    ## [1] "Number of found coherent FFLs:8"
    ## [1] "Number of found incoherent FFLs:8"

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
    ## 1      AG     2        0        2     8       0       2       6      5
    ## 2     AP1     1        0        1     5       1       3       1      5
    ## 3     AP3     2        1        1    10       2       4       4      7
    ## 4    EMF1     0        0        0     3       3       0       0      3
    ## 5     LFY     1        0        1    12       8       3       1      8
    ## 6     LUG     0        0        0     0       0       0       0      1
    ## 7      PI     3        1        2    10       1       3       6      7
    ## 8     SUP     0        0        0     1       1       0       0      2
    ## 9    TFL1     0        0        0     4       1       3       0      4
    ## 10    UFO     0        0        0     1       1       0       0      2
    ##    In_Degree Out_Degree  Closeness Betweenness Stress Eigenvector
    ## 1          4          1 0.01369863    0.500000      1  0.07162713
    ## 2          3          2 0.02083333    2.333333      3  0.37504450
    ## 3          5          2 0.01388889    2.833333      5  0.11589513
    ## 4          0          3 0.02564103    0.000000      0  0.60683476
    ## 5          3          5 0.02222222    9.833333     12  0.49093963
    ## 6          0          1 0.02439024    0.000000      0  0.30341738
    ## 7          5          2 0.01388889    4.000000      5  0.11589513
    ## 8          0          2 0.01785714    0.000000      0  0.14325425
    ## 9          2          2 0.01562500    0.500000      1  0.11589513
    ## 10         0          2 0.02439024    0.000000      0  0.30341738
    ## 
    ## $edges
    ##           EdgeID NuFBL NuPosFBL NuNegFBL NuFFL NuFFL_AB NuFFL_BC NuFFL_AC
    ## 1     AG (-1) PI     2        0        2     2        0        2        0
    ## 2   AP1 (-1) LFY     1        0        1     2        1        1        0
    ## 3     AP1 (1) PI     0        0        0     3        0        2        1
    ## 4     AP3 (1) AG     1        0        1     5        1        3        1
    ## 5     AP3 (1) PI     1        1        0     3        1        1        1
    ## 6  EMF1 (-1) AP1     0        0        0     2        1        0        1
    ## 7  EMF1 (-1) AP3     0        0        0     1        0        0        1
    ## 8   EMF1 (1) LFY     0        0        0     3        2        0        1
    ## 9  LFY (-1) TFL1     0        0        0     2        2        0        0
    ## 10    LFY (1) AG     0        0        0     2        1        0        1
    ## 11   LFY (1) AP1     1        0        1     2        1        1        0
    ## 12   LFY (1) AP3     0        0        0     4        2        1        1
    ## 13    LFY (1) PI     0        0        0     4        2        1        1
    ## 14  LUG (-1) LFY     0        0        0     0        0        0        0
    ## 15     PI (1) AG     1        0        1     3        0        2        1
    ## 16    PI (1) AP3     2        1        1     2        1        1        0
    ## 17  SUP (-1) AP3     0        0        0     1        0        0        1
    ## 18 SUP (-1) TFL1     0        0        0     1        1        0        0
    ## 19  TFL1 (-1) AG     0        0        0     2        0        1        1
    ## 20 TFL1 (-1) AP3     0        0        0     3        1        2        0
    ## 21   UFO (1) AP1     0        0        0     1        1        0        0
    ## 22    UFO (1) PI     0        0        0     1        0        0        1
    ##    Degree Betweenness
    ## 1      12    2.500000
    ## 2      13    5.000000
    ## 3      12    2.333333
    ## 4      12    2.000000
    ## 5      14    2.833333
    ## 6       8    1.333333
    ## 7      10    1.833333
    ## 8      11    2.833333
    ## 9      12    5.000000
    ## 10     13    3.000000
    ## 11     13    2.000000
    ## 12     15    2.500000
    ## 13     15    2.333333
    ## 14      9    6.000000
    ## 15     12    2.500000
    ## 16     14    3.500000
    ## 17      9    2.500000
    ## 18      6    1.500000
    ## 19      9    2.000000
    ## 20     11    1.500000
    ## 21      7    3.000000
    ## 22      9    3.000000
    ## 
    ## $network
    ##    NetworkID NuFBL NuPosFBL NuNegFBL NuFFL NuCoFFL NuInCoFFL
    ## 1 AMRN_RBN_1     4        1        3    19       7        12
    ## 
    ## $transitionNetwork
    ## [1] FALSE
    ## 
    ## $Group_1
    ##          GroupID edgeremoval_t1000_r1
    ## 1  EMF1 (-1) AP3                0.125
    ## 2    UFO (1) AP1                0.000
    ## 3     LFY (1) AG                0.000
    ## 4     PI (1) AP3                0.000
    ## 5     AP3 (1) AG                0.000
    ## 6     AG (-1) PI                0.000
    ## 7    LFY (1) AP1                0.250
    ## 8      PI (1) AG                0.000
    ## 9  TFL1 (-1) AP3                0.000
    ## 10    UFO (1) PI                0.000
    ## 11  TFL1 (-1) AG                0.000
    ## 12  LUG (-1) LFY                0.250
    ## 13    LFY (1) PI                0.000
    ## 14    AP3 (1) PI                0.000
    ## 15 SUP (-1) TFL1                0.375
    ## 16 LFY (-1) TFL1                0.125
    ## 17 EMF1 (-1) AP1                0.125
    ## 18  AP1 (-1) LFY                0.000
    ## 19   LFY (1) AP3                0.000
    ## 20    AP1 (1) PI                0.000
    ## 21  SUP (-1) AP3                0.000
    ## 22  EMF1 (1) LFY                0.250
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
    ## 1      AG     4        2        2     6       0       3       3      5
    ## 2     AP1     4        4        0     5       1       2       2      5
    ## 3     AP3     2        2        0     5       2       2       1      7
    ## 4    EMF1     0        0        0     3       3       0       0      3
    ## 5     LFY     8        6        2    13       7       4       2      8
    ## 6     LUG     0        0        0     0       0       0       0      1
    ## 7      PI     9        7        2    10       1       2       7      7
    ## 8     SUP     0        0        0     0       0       0       0      2
    ## 9    TFL1     2        1        1     3       1       2       0      4
    ## 10    UFO     0        0        0     0       0       0       0      2
    ##    In_Degree Out_Degree  Closeness Betweenness Stress Eigenvector
    ## 1          4          1 0.01960784   0.3333333      1   0.1402917
    ## 2          3          2 0.02000000   2.0000000      3   0.2013319
    ## 3          5          2 0.02083333  10.0000001     14   0.3751328
    ## 4          0          3 0.02564103   0.0000000      0   0.4590995
    ## 5          3          5 0.02222222  16.1666666     19   0.5397470
    ## 6          0          1 0.02272727   0.0000000      0   0.1632183
    ## 7          5          2 0.02083333  11.6666667     14   0.3224395
    ## 8          0          2 0.02439024   0.0000000      0   0.2508167
    ## 9          2          2 0.02040816   1.8333334      3   0.2013319
    ## 10         0          2 0.02439024   0.0000000      0   0.2508167
    ## 
    ## $edges
    ##           EdgeID NuFBL NuPosFBL NuNegFBL NuFFL NuFFL_AB NuFFL_BC NuFFL_AC
    ## 1     AG (-1) PI     4        2        2     3        0        3        0
    ## 2    AP1 (-1) AG     2        2        0     2        1        1        0
    ## 3     AP1 (1) PI     2        2        0     2        0        1        1
    ## 4    AP3 (1) LFY     1        1        0     3        1        1        1
    ## 5     AP3 (1) PI     1        1        0     3        1        1        1
    ## 6   EMF1 (-1) AG     0        0        0     1        0        0        1
    ## 7  EMF1 (-1) LFY     0        0        0     3        2        0        1
    ## 8   EMF1 (1) AP3     0        0        0     2        1        0        1
    ## 9  LFY (-1) TFL1     2        1        1     2        2        0        0
    ## 10    LFY (1) AG     1        0        1     3        1        1        1
    ## 11   LFY (1) AP1     2        2        0     4        2        1        1
    ## 12   LFY (1) AP3     2        2        0     2        1        1        0
    ## 13    LFY (1) PI     1        1        0     3        1        1        1
    ## 14  LUG (-1) AP3     0        0        0     0        0        0        0
    ## 15    PI (1) AP1     2        2        0     2        0        1        1
    ## 16    PI (1) LFY     7        5        2     2        1        1        0
    ## 17  SUP (-1) AP1     0        0        0     0        0        0        0
    ## 18  SUP (-1) AP3     0        0        0     0        0        0        0
    ## 19  TFL1 (-1) AG     1        0        1     2        1        1        0
    ## 20  TFL1 (-1) PI     1        1        0     2        0        1        1
    ## 21   UFO (1) AP3     0        0        0     0        0        0        0
    ## 22  UFO (1) TFL1     0        0        0     0        0        0        0
    ##    Degree Betweenness
    ## 1      12    5.333333
    ## 2      10    2.500000
    ## 3      12    4.500000
    ## 4      15   10.333333
    ## 5      14    4.666667
    ## 6       8    1.333333
    ## 7      11    3.333333
    ## 8      10    1.333333
    ## 9      12    8.000000
    ## 10     13    3.500000
    ## 11     13    3.333333
    ## 12     15    5.000000
    ## 13     15    1.333333
    ## 14      8    6.000000
    ## 15     12    5.166667
    ## 16     15   11.500000
    ## 17      7    2.500000
    ## 18      9    3.500000
    ## 19      9    2.000000
    ## 20     11    4.833333
    ## 21      9    3.166667
    ## 22      6    2.833333
    ## 
    ## $network
    ##    NetworkID NuFBL NuPosFBL NuNegFBL NuFFL NuCoFFL NuInCoFFL
    ## 1 AMRN_RBN_2    10        8        2    16       8         8
    ## 
    ## $transitionNetwork
    ## [1] FALSE
    ## 
    ## $Group_1
    ##          GroupID edgeremoval_t1000_r1
    ## 1   EMF1 (-1) AG          0.000000000
    ## 2   SUP (-1) AP1          0.006835938
    ## 3  EMF1 (-1) LFY          0.027343750
    ## 4    AP1 (-1) AG          0.013671875
    ## 5    LFY (1) AP1          0.000000000
    ## 6   LUG (-1) AP3          0.006835938
    ## 7     LFY (1) AG          0.250000000
    ## 8   UFO (1) TFL1          0.500000000
    ## 9   TFL1 (-1) PI          0.008789062
    ## 10   AP3 (1) LFY          0.000000000
    ## 11    AP3 (1) PI          0.087890625
    ## 12  EMF1 (1) AP3          0.000000000
    ## 13    AP1 (1) PI          0.002929688
    ## 14   LFY (1) AP3          0.416992188
    ## 15   UFO (1) AP3          0.020507812
    ## 16    LFY (1) PI          0.000000000
    ## 17    AG (-1) PI          0.002929688
    ## 18    PI (1) AP1          0.000000000
    ## 19    PI (1) LFY          0.120117188
    ## 20  TFL1 (-1) AG          0.000000000
    ## 21 LFY (-1) TFL1          0.020507812
    ## 22  SUP (-1) AP3          0.006835938
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
