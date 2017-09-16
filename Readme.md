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

``` r
library(RMut)
amrn <- loadNetwork("networks/AMRN.sif")
print(amrn)
```

    ## $name
    ## [1] "AMRN.sif"
    ## 
    ## $nodes
    ##    NodeID
    ## 1      AG
    ## 2     AP1
    ## 3     AP3
    ## 4    EMF1
    ## 5     LFY
    ## 6     LUG
    ## 7      PI
    ## 8     SUP
    ## 9    TFL1
    ## 10    UFO
    ## 
    ## $edges
    ##           EdgeID
    ## 1    AG (-1) AP1
    ## 2    AP1 (-1) AG
    ## 3    AP1 (1) LFY
    ## 4    AP3 (1) AP3
    ## 5     AP3 (1) PI
    ## 6  EMF1 (-1) AP1
    ## 7  EMF1 (-1) LFY
    ## 8  EMF1 (1) TFL1
    ## 9  LFY (-1) TFL1
    ## 10    LFY (1) AG
    ## 11   LFY (1) AP1
    ## 12   LFY (1) AP3
    ## 13    LFY (1) PI
    ## 14   LUG (-1) AG
    ## 15    PI (1) AP3
    ## 16     PI (1) PI
    ## 17  SUP (-1) AP3
    ## 18   SUP (-1) PI
    ## 19  TFL1 (-1) AG
    ## 20 TFL1 (-1) LFY
    ## 21   UFO (1) AP3
    ## 22    UFO (1) PI
    ## 
    ## $network
    ##   NetworkID
    ## 1  AMRN.sif
    ## 
    ## $transitionNetwork
    ## [1] FALSE
    ## 
    ## attr(,"class")
    ## [1] "list"    "NetInfo"

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

Two kinds of sensitivity measures are computed: macro-distance and bitwise-distance sensitivity measures. In addition, we note that multiple sets of random Nested Canalyzing rules could be specified, and thus resulted in multiple sensitivity values for each node/edge. Here, we show an example of some sensitivity types:

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

    ##    GroupID ruleflip_t1000_r1_macro ruleflip_t1000_r1_bitws
    ## 1       PI               0.7988281              0.10511068
    ## 2      AP3               0.7617188              0.08886719
    ## 3       AG               1.0000000              0.12262370
    ## 4      SUP               0.0000000              0.00000000
    ## 5      LUG               0.0000000              0.00000000
    ## 6     TFL1               0.4687500              0.05335286
    ## 7     EMF1               0.0000000              0.00000000
    ## 8      AP1               0.9687500              0.13518880
    ## 9      LFY               0.9062500              0.16064453
    ## 10     UFO               0.0000000              0.00000000
    ##    ruleflip_t1000_r2_macro ruleflip_t1000_r2_bitws
    ## 1                0.9707031              0.10488281
    ## 2                0.9707031              0.10488281
    ## 3                1.0000000              0.12177734
    ## 4                0.0000000              0.00000000
    ## 5                0.0000000              0.00000000
    ## 6                0.4687500              0.05458984
    ## 7                0.0000000              0.00000000
    ## 8                0.9687500              0.12900391
    ## 9                0.9062500              0.14690755
    ## 10               0.0000000              0.00000000

``` r
# generate all possible groups each containing a single edge in the AMRN network
amrn <- generateGroups(amrn, "all", 0, 1)
```

    ## [1] "Number of possibly mutated groups:22"

``` r
amrn <- calSensitivity(amrn, set1, "edge removal")
print(amrn$Group_2)
```

    ##          GroupID edgeremoval_t1000_r1_macro edgeremoval_t1000_r1_bitws
    ## 1   SUP (-1) AP3                 0.01562500                0.003710938
    ## 2     LFY (1) AG                 0.14062500                0.014062500
    ## 3    AP1 (1) LFY                 0.46875000                0.075358073
    ## 4  EMF1 (-1) LFY                 0.00000000                0.000000000
    ## 5     LFY (1) PI                 0.18164062                0.034375000
    ## 6    LFY (1) AP3                 0.00390625                0.000390625
    ## 7    LFY (1) AP1                 0.42187500                0.074804688
    ## 8    SUP (-1) PI                 0.01757812                0.003222656
    ## 9  EMF1 (-1) AP1                 0.00000000                0.000000000
    ## 10  TFL1 (-1) AG                 0.01269531                0.003808594
    ## 11   LUG (-1) AG                 0.09375000                0.010188802
    ## 12    AP3 (1) PI                 0.02539062                0.006152344
    ## 13 EMF1 (1) TFL1                 0.46875000                0.053352865
    ## 14     PI (1) PI                 0.00390625                0.000390625
    ## 15    UFO (1) PI                 0.01757812                0.003222656
    ## 16   AP1 (-1) AG                 0.03125000                0.005794271
    ## 17   AG (-1) AP1                 0.12500000                0.016178385
    ## 18   AP3 (1) AP3                 0.00000000                0.000000000
    ## 19    PI (1) AP3                 0.18945312                0.026269531
    ## 20 LFY (-1) TFL1                 0.00000000                0.000000000
    ## 21   UFO (1) AP3                 0.01562500                0.003710938
    ## 22 TFL1 (-1) LFY                 0.12500000                0.015755208

``` r
# generate all possible groups each containing a new edge (not exist in the AMRN network)
amrn <- generateGroups(amrn, "all", 0, 1, TRUE)
```

    ## [1] "Number of possibly mutated groups:178"

``` r
amrn <- calSensitivity(amrn, set1, "edge addition")
print(amrn$Group_3)
```

    ##            GroupID edgeaddition_t1000_r1_macro edgeaddition_t1000_r1_bitws
    ## 1       AG (1) AP3                 0.987304688                 0.353027344
    ## 2      AP3 (1) LUG                 0.505859375                 0.062500000
    ## 3   TFL1 (-1) EMF1                 0.625000000                 0.082291667
    ## 4     PI (-1) EMF1                 0.619140625                 0.116731771
    ## 5      PI (-1) UFO                 0.552734375                 0.074023438
    ## 6       AG (-1) PI                 0.992187500                 0.438509115
    ## 7    AP1 (-1) EMF1                 0.468750000                 0.116048177
    ## 8     EMF1 (1) AP3                 0.987304688                 0.353027344
    ## 9    EMF1 (-1) SUP                 0.500000000                 0.055566406
    ## 10      SUP (1) PI                 1.000000000                 0.472753906
    ## 11    TFL1 (1) SUP                 0.515625000                 0.062597656
    ## 12    AP1 (-1) LFY                 0.218750000                 0.029720052
    ## 13    TFL1 (1) UFO                 0.509765625                 0.057031250
    ## 14     UFO (1) LUG                 0.500000000                 0.060904948
    ## 15    LUG (-1) SUP                 0.500000000                 0.053515625
    ## 16    SUP (1) EMF1                 0.500000000                 0.115397135
    ## 17    PI (-1) TFL1                 0.500000000                 0.050000000
    ## 18    EMF1 (1) UFO                 0.500000000                 0.051953125
    ## 19   EMF1 (-1) LUG                 0.500000000                 0.060742188
    ## 20   TFL1 (-1) AP3                 0.987304688                 0.353027344
    ## 21   AP3 (-1) EMF1                 0.619140625                 0.116731771
    ## 22     AG (-1) LFY                 0.203125000                 0.028776042
    ## 23   TFL1 (-1) UFO                 0.509765625                 0.057031250
    ## 24   TFL1 (-1) LUG                 0.500000000                 0.060742188
    ## 25  EMF1 (-1) EMF1                 1.000000000                 0.129720052
    ## 26      AG (1) UFO                 0.562500000                 0.072493490
    ## 27   TFL1 (1) TFL1                 0.500000000                 0.027799479
    ## 28     LFY (1) SUP                 0.593750000                 0.060286458
    ## 29      PI (1) SUP                 0.552734375                 0.074023438
    ## 30     UFO (1) AP1                 0.484375000                 0.064322917
    ## 31   LUG (-1) TFL1                 0.250000000                 0.038085938
    ## 32      AP1 (1) AG                 0.218750000                 0.029720052
    ## 33     EMF1 (1) PI                 1.000000000                 0.472753906
    ## 34   EMF1 (-1) UFO                 0.500000000                 0.055566406
    ## 35    SUP (-1) UFO                 0.500000000                 0.055566406
    ## 36     UFO (1) SUP                 0.500000000                 0.055566406
    ## 37      AG (1) LUG                 0.593750000                 0.073561198
    ## 38      AP3 (1) AG                 0.005859375                 0.001757813
    ## 39   TFL1 (1) EMF1                 1.000000000                 0.127923177
    ## 40      AG (1) AP1                 0.921875000                 0.124804687
    ## 41    UFO (-1) UFO                 1.000000000                 0.056770833
    ## 42    AG (-1) TFL1                 0.500000000                 0.050000000
    ## 43    UFO (-1) AP3                 0.987304688                 0.353027344
    ## 44      AG (1) SUP                 0.562500000                 0.072493490
    ## 45   SUP (-1) EMF1                 0.500000000                 0.115397135
    ## 46      SUP (1) AG                 0.500000000                 0.060677083
    ## 47   AP3 (-1) TFL1                 0.000000000                 0.000000000
    ## 48   SUP (-1) TFL1                 0.250000000                 0.025000000
    ## 49     AG (1) TFL1                 0.000000000                 0.000000000
    ## 50    LUG (-1) UFO                 0.500000000                 0.053515625
    ## 51     SUP (1) UFO                 0.500000000                 0.051953125
    ## 52      AG (1) LFY                 0.968750000                 0.170817057
    ## 53    EMF1 (-1) AG                 0.500000000                 0.050000000
    ## 54    AG (-1) EMF1                 0.500000000                 0.129720052
    ## 55   TFL1 (-1) AP1                 0.062500000                 0.007291667
    ## 56    LUG (-1) LFY                 0.109375000                 0.016634115
    ## 57     AG (-1) LUG                 0.531250000                 0.058886719
    ## 58      LUG (1) PI                 1.000000000                 0.472753906
    ## 59    SUP (-1) LFY                 0.109375000                 0.015397135
    ## 60    AP3 (-1) AP1                 0.216796875                 0.028938802
    ## 61    LFY (-1) AP1                 0.968750000                 0.132845052
    ## 62     LUG (1) UFO                 0.500000000                 0.054003906
    ## 63     AG (-1) AP3                 0.987304688                 0.353027344
    ## 64    UFO (1) TFL1                 0.250000000                 0.025000000
    ## 65    EMF1 (1) LUG                 0.500000000                 0.060742188
    ## 66    LUG (-1) AP1                 0.484375000                 0.069368490
    ## 67    UFO (1) EMF1                 0.500000000                 0.115397135
    ## 68    SUP (-1) AP1                 0.484375000                 0.064322917
    ## 69     LUG (-1) PI                 1.000000000                 0.472753906
    ## 70     AG (-1) SUP                 0.562500000                 0.072623698
    ## 71       PI (1) AG                 0.005859375                 0.001757813
    ## 72     LFY (1) UFO                 0.593750000                 0.063281250
    ## 73    LFY (-1) LFY                 0.062500000                 0.008463542
    ## 74     AP3 (1) AP1                 0.216796875                 0.028938802
    ## 75    EMF1 (1) AP1                 0.000000000                 0.000000000
    ## 76     LFY (-1) AG                 0.093750000                 0.010188802
    ## 77   TFL1 (-1) SUP                 0.515625000                 0.062597656
    ## 78       AG (1) PI                 0.992187500                 0.438509115
    ## 79    LUG (-1) LUG                 1.000000000                 0.061490885
    ## 80  TFL1 (-1) TFL1                 0.375000000                 0.037500000
    ## 81     PI (-1) LFY                 0.083984375                 0.011458333
    ## 82    LFY (-1) UFO                 0.593750000                 0.060286458
    ## 83    EMF1 (1) LFY                 0.218750000                 0.029720052
    ## 84    LFY (-1) AP3                 0.987304688                 0.353027344
    ## 85     PI (-1) LUG                 0.517578125                 0.062337240
    ## 86    LFY (-1) LUG                 0.593750000                 0.062890625
    ## 87    TFL1 (1) AP3                 0.987304688                 0.353027344
    ## 88    EMF1 (1) SUP                 0.500000000                 0.055566406
    ## 89      PI (1) AP1                 0.070312500                 0.010058594
    ## 90     LFY (-1) PI                 1.000000000                 0.472753906
    ## 91     AP1 (1) AP1                 0.531250000                 0.071126302
    ## 92     PI (1) EMF1                 0.496093750                 0.127376302
    ## 93     TFL1 (1) PI                 1.000000000                 0.472753906
    ## 94    TFL1 (1) LUG                 0.525390625                 0.061165365
    ## 95     AP3 (1) LFY                 0.265625000                 0.057177734
    ## 96    AP1 (-1) AP3                 0.987304688                 0.353027344
    ## 97     AP1 (1) UFO                 0.593750000                 0.059505208
    ## 98      PI (-1) AG                 0.093750000                 0.011360677
    ## 99    TFL1 (-1) PI                 1.000000000                 0.472753906
    ## 100    TFL1 (1) AG                 0.000000000                 0.000000000
    ## 101   LFY (1) TFL1                 0.468750000                 0.053352865
    ## 102    AP3 (-1) PI                 1.000000000                 0.472753906
    ## 103   AP1 (1) EMF1                 0.718750000                 0.129720052
    ## 104    PI (-1) AP1                 0.214843750                 0.028157552
    ## 105   LFY (1) EMF1                 0.468750000                 0.116048177
    ## 106    PI (1) TFL1                 0.500000000                 0.050000000
    ## 107   AP3 (1) EMF1                 0.619140625                 0.116731771
    ## 108    PI (-1) SUP                 0.552734375                 0.074023438
    ## 109    UFO (1) LFY                 0.109375000                 0.015397135
    ## 110    LFY (1) LFY                 0.062500000                 0.008463542
    ## 111    SUP (1) AP1                 0.109375000                 0.014322917
    ## 112   UFO (-1) LFY                 0.109375000                 0.015397135
    ## 113   UFO (-1) AP1                 0.109375000                 0.014322917
    ## 114    AP1 (1) AP3                 0.987304688                 0.353027344
    ## 115    AP1 (1) LUG                 0.593750000                 0.062988281
    ## 116    LUG (1) LFY                 0.484375000                 0.119824219
    ## 117   AP1 (1) TFL1                 0.000000000                 0.000000000
    ## 118    AP3 (1) UFO                 0.539062500                 0.070605469
    ## 119    LUG (1) AP1                 0.109375000                 0.013085937
    ## 120     AP1 (1) PI                 1.000000000                 0.445735677
    ## 121  LUG (-1) EMF1                 0.500000000                 0.113085938
    ## 122    UFO (-1) PI                 1.000000000                 0.472753906
    ## 123   SUP (-1) LUG                 0.500000000                 0.060904948
    ## 124     LUG (1) AG                 0.000000000                 0.000000000
    ## 125   TFL1 (1) LFY                 0.218750000                 0.029720052
    ## 126   LUG (1) TFL1                 0.250000000                 0.041634115
    ## 127  EMF1 (-1) AP3                 0.987304688                 0.353027344
    ## 128   AP3 (-1) LFY                 0.265625000                 0.057177734
    ## 129  UFO (-1) EMF1                 0.500000000                 0.115397135
    ## 130   AP3 (-1) UFO                 0.539062500                 0.070605469
    ## 131   UFO (-1) SUP                 0.500000000                 0.051953125
    ## 132     PI (1) LUG                 0.505859375                 0.062500000
    ## 133    AP3 (1) SUP                 0.539062500                 0.070605469
    ## 134     PI (1) UFO                 0.535156250                 0.073339844
    ## 135  UFO (-1) TFL1                 0.250000000                 0.025000000
    ## 136    LFY (1) LUG                 0.593750000                 0.062988281
    ## 137  EMF1 (1) EMF1                 1.000000000                 0.129720052
    ## 138   AP3 (-1) LUG                 0.517578125                 0.062337240
    ## 139   AP3 (1) TFL1                 0.000000000                 0.000000000
    ## 140   AP1 (-1) AP1                 0.781250000                 0.058235677
    ## 141    AG (1) EMF1                 0.625000000                 0.116048177
    ## 142   SUP (-1) SUP                 0.000000000                 0.000000000
    ## 143   UFO (-1) LUG                 0.500000000                 0.060904948
    ## 144    UFO (-1) AG                 0.046875000                 0.005729167
    ## 145   AP1 (-1) LUG                 0.593750000                 0.062988281
    ## 146    AG (-1) UFO                 0.562500000                 0.072493490
    ## 147     PI (1) LFY                 0.224609375                 0.044303385
    ## 148   AP3 (-1) SUP                 0.537109375                 0.069531250
    ## 149   AP1 (-1) SUP                 0.593750000                 0.059505208
    ## 150    AP1 (-1) PI                 1.000000000                 0.449316406
    ## 151    SUP (1) AP3                 0.987304688                 0.353027344
    ## 152   LUG (-1) AP3                 0.987304688                 0.353027344
    ## 153      AG (1) AG                 0.093750000                 0.010188802
    ## 154     AG (-1) AG                 0.000000000                 0.000000000
    ## 155     PI (-1) PI                 1.000000000                 0.472753906
    ## 156   AP3 (-1) AP3                 0.987304688                 0.353027344
    ## 157  LFY (-1) EMF1                 0.468750000                 0.116048177
    ## 158  AP1 (-1) TFL1                 0.000000000                 0.000000000
    ## 159    SUP (1) LFY                 0.109375000                 0.014322917
    ## 160   AP1 (-1) UFO                 0.593750000                 0.053938802
    ## 161    SUP (-1) AG                 0.046875000                 0.005729167
    ## 162    SUP (1) SUP                 1.000000000                 0.056770833
    ## 163    LUG (1) SUP                 0.500000000                 0.053515625
    ## 164   EMF1 (-1) PI                 1.000000000                 0.472753906
    ## 165    AP3 (-1) AG                 0.005859375                 0.001757813
    ## 166    LUG (1) LUG                 0.000000000                 0.000000000
    ## 167    LUG (1) AP3                 0.987304688                 0.353027344
    ## 168 EMF1 (-1) TFL1                 0.000000000                 0.000000000
    ## 169   SUP (1) TFL1                 0.250000000                 0.025000000
    ## 170     UFO (1) AG                 0.046875000                 0.005729167
    ## 171   TFL1 (1) AP1                 0.218750000                 0.029720052
    ## 172    SUP (1) LUG                 0.500000000                 0.060904948
    ## 173    PI (-1) AP3                 0.987304688                 0.353027344
    ## 174    AP1 (1) SUP                 0.593750000                 0.053938802
    ## 175    EMF1 (1) AG                 0.093750000                 0.010188802
    ## 176    UFO (1) UFO                 1.000000000                 0.056770833
    ## 177   LUG (1) EMF1                 0.500000000                 0.116634115
    ## 178   LFY (-1) SUP                 0.593750000                 0.063281250

As shown above, we firstly need to generate a set of initial-states by the function *generateStates*. Then by the function *generateGroups*, we continue to generate three sets of node/edge groups whose their sensitivity would be calculated. Finally, the sensitivity values are stored in the same data frame of node/edge groups. The data frame has one column for group identifiers (lists of nodes/edges), and some next columns containing their sensitivity values according to each set of random update-rules. For example, the mutation *rule-flip* used two sets of Nested Canalyzing rules, thus resulted in two corresponding sets of sensitivity values. RMut automatically generates a file of Boolean logics for each set, or uses existing files in the working directory of RMut. Here, two rule files "*AMRN\_rules\_0*" and "*AMRN\_rules\_1*" are generated. A user can manually create or modify these rule files before the calculation. In addition, the column names which contain the sequence "*macro*" or "*bitws*" denote the macro-distance and bitwise-distance sensitivity measures, respectively.

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

    ## [1] "Number of found FBLs:9"
    ## [1] "Number of found positive FBLs:5"
    ## [1] "Number of found negative FBLs:4"
    ## [1] "Number of found FBLs:5"
    ## [1] "Number of found positive FBLs:3"
    ## [1] "Number of found negative FBLs:2"

``` r
ba_rbns <- findFFLs(ba_rbns)
```

    ## [1] "Number of found FFLs:4"
    ## [1] "Number of found coherent FFLs:4"
    ## [1] "Number of found incoherent FFLs:0"
    ## [1] "Number of found FFLs:6"
    ## [1] "Number of found coherent FFLs:2"
    ## [1] "Number of found incoherent FFLs:4"

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
    ## 1       0     4        2        2     1       1       0       0      3
    ## 2       1     9        5        4     4       0       3       1     10
    ## 3       2     4        2        2     0       0       0       0      2
    ## 4       3     3        1        2     2       0       1       1      3
    ## 5       4     4        0        4     3       3       0       0      4
    ## 6       5     1        1        0     0       0       0       0      2
    ## 7       6     6        2        4     1       0       0       1      4
    ## 8       7     2        2        0     0       0       0       0      2
    ## 9       8     0        0        0     1       0       0       1      2
    ## 10      9     4        0        4     0       0       0       0      2
    ##    In_Degree Out_Degree  Closeness Betweenness Stress Eigenvector
    ## 1          1          2 0.05882353           8      8   0.4068578
    ## 2          5          5 0.07142857          46     47   0.5276199
    ## 3          1          1 0.04166667           7      7   0.2114731
    ## 4          2          1 0.04545455           0      0   0.2742418
    ## 5          1          3 0.05555556           9     10   0.4167849
    ## 6          1          1 0.04545455           0      0   0.2742418
    ## 7          2          2 0.04545455          20     20   0.2551428
    ## 8          1          1 0.04761905           5      6   0.2742418
    ## 9          2          0 0.01111111           0      0   0.0000000
    ## 10         1          1 0.04166667           8      9   0.2166330
    ## 
    ## $edges
    ##      EdgeID NuFBL NuPosFBL NuNegFBL NuFFL NuFFL_AB NuFFL_BC NuFFL_AC
    ## 1  0 (-1) 1     1        1        0     1        1        0        0
    ## 2  0 (-1) 6     3        1        2     1        0        0        1
    ## 3  1 (-1) 2     4        2        2     0        0        0        0
    ## 4  1 (-1) 5     1        1        0     0        0        0        0
    ## 5  1 (-1) 8     0        0        0     1        0        1        0
    ## 6   1 (1) 3     1        1        0     1        0        1        0
    ## 7   1 (1) 6     3        1        2     1        0        1        0
    ## 8   2 (1) 0     4        2        2     0        0        0        0
    ## 9   3 (1) 1     3        1        2     1        0        1        0
    ## 10 4 (-1) 1     2        0        2     3        2        0        1
    ## 11 4 (-1) 3     2        0        2     2        1        0        1
    ## 12  4 (1) 8     0        0        0     1        0        0        1
    ## 13 5 (-1) 1     1        1        0     0        0        0        0
    ## 14 6 (-1) 7     2        2        0     0        0        0        0
    ## 15  6 (1) 9     4        0        4     0        0        0        0
    ## 16 7 (-1) 1     2        2        0     0        0        0        0
    ## 17  9 (1) 4     4        0        4     0        0        0        0
    ##    Degree Betweenness
    ## 1      13         9.0
    ## 2       7         8.0
    ## 3      12        15.0
    ## 4      12         8.0
    ## 5      12         6.5
    ## 6      13         5.5
    ## 7      14        20.0
    ## 8       5        16.0
    ## 9      13         9.0
    ## 10     14        13.0
    ## 11      7         2.5
    ## 12      6         2.5
    ## 13     12         9.0
    ## 14      6        13.0
    ## 15      6        16.0
    ## 16     12        14.0
    ## 17      6        17.0
    ## 
    ## $network
    ##   NetworkID NuFBL NuPosFBL NuNegFBL NuFFL NuCoFFL NuInCoFFL
    ## 1  BA_RBN_1     9        5        4     4       4         0
    ## 
    ## $transitionNetwork
    ## [1] FALSE
    ## 
    ## $Group_1
    ##    GroupID knockout_t1000_r1_macro knockout_t1000_r1_bitws
    ## 1        6             0.000000000             0.000000000
    ## 2        7             1.000000000             0.100000000
    ## 3        4             0.003906250             0.003125000
    ## 4        2             1.000000000             0.200000000
    ## 5        0             1.000000000             0.100000000
    ## 6        3             0.000000000             0.000000000
    ## 7        1             0.000000000             0.000000000
    ## 8        8             0.000000000             0.000000000
    ## 9        5             1.000000000             0.100000000
    ## 10       9             0.001953125             0.001367187
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
    ## 1       0     3        2        1     3       3       0       0      7
    ## 2       1     0        0        0     2       0       1       1      3
    ## 3       2     0        0        0     1       0       0       1      2
    ## 4       3     1        1        0     0       0       0       0      2
    ## 5       4     4        2        2     5       2       2       1      8
    ## 6       5     2        1        1     0       0       0       0      2
    ## 7       6     2        1        1     3       1       1       1      4
    ## 8       7     1        0        1     1       0       1       0      2
    ## 9       8     0        0        0     2       0       0       2      2
    ## 10      9     1        1        0     1       0       1       0      2
    ##    In_Degree Out_Degree  Closeness Betweenness Stress Eigenvector
    ## 1          2          5 0.07692308          23     23   0.6193718
    ## 2          2          1 0.01234568           4      4   0.0000000
    ## 3          2          0 0.01111111           0      0   0.0000000
    ## 4          1          1 0.04761905           0      0   0.3596641
    ## 5          3          5 0.06666667          32     32   0.4472384
    ## 6          1          1 0.05000000          11     11   0.3596641
    ## 7          2          2 0.04545455           8      8   0.2597077
    ## 8          1          1 0.03448276           0      0   0.1508101
    ## 9          2          0 0.01111111           0      0   0.0000000
    ## 10         1          1 0.04761905           0      0   0.2597077
    ## 
    ## $edges
    ##      EdgeID NuFBL NuPosFBL NuNegFBL NuFFL NuFFL_AB NuFFL_BC NuFFL_AC
    ## 1  0 (-1) 1     0        0        0     2        1        0        1
    ## 2  0 (-1) 2     0        0        0     1        0        0        1
    ## 3  0 (-1) 3     1        1        0     0        0        0        0
    ## 4  0 (-1) 9     1        1        0     1        1        0        0
    ## 5   0 (1) 4     1        0        1     2        1        0        1
    ## 6  1 (-1) 2     0        0        0     1        0        1        0
    ## 7  3 (-1) 0     1        1        0     0        0        0        0
    ## 8  4 (-1) 5     2        1        1     0        0        0        0
    ## 9  4 (-1) 7     1        0        1     1        1        0        0
    ## 10  4 (1) 1     0        0        0     1        0        1        0
    ## 11  4 (1) 6     1        1        0     2        1        0        1
    ## 12  4 (1) 8     0        0        0     2        0        1        1
    ## 13  5 (1) 0     2        1        1     0        0        0        0
    ## 14  6 (1) 4     2        1        1     1        1        0        0
    ## 15  6 (1) 8     0        0        0     2        0        1        1
    ## 16  7 (1) 6     1        0        1     1        0        1        0
    ## 17  9 (1) 4     1        1        0     1        0        1        0
    ##    Degree Betweenness
    ## 1      10           3
    ## 2       9           3
    ## 3       9           6
    ## 4       9           6
    ## 5      15          14
    ## 6       5           5
    ## 7       9           9
    ## 8      10          17
    ## 9      10           6
    ## 10     11           8
    ## 11     12           5
    ## 12     10           5
    ## 13      9          20
    ## 14     12          15
    ## 15      6           2
    ## 16      6           9
    ## 17     10           9
    ## 
    ## $network
    ##   NetworkID NuFBL NuPosFBL NuNegFBL NuFFL NuCoFFL NuInCoFFL
    ## 1  BA_RBN_2     5        3        2     6       2         4
    ## 
    ## $transitionNetwork
    ## [1] FALSE
    ## 
    ## $Group_1
    ##    GroupID knockout_t1000_r1_macro knockout_t1000_r1_bitws
    ## 1        7               1.0000000             0.115364583
    ## 2        1               0.0781250             0.004427083
    ## 3        0               0.4218750             0.120052083
    ## 4        3               0.9531250             0.287239583
    ## 5        5               1.0000000             0.214322917
    ## 6        4               0.1093750             0.025781250
    ## 7        9               0.9531250             0.090950521
    ## 8        6               0.0781250             0.019531250
    ## 9        8               0.0078125             0.007031250
    ## 10       2               0.9531250             0.089388021
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

    ## [1] "Number of found FBLs:14"
    ## [1] "Number of found positive FBLs:9"
    ## [1] "Number of found negative FBLs:5"
    ## [1] "Number of found FBLs:13"
    ## [1] "Number of found positive FBLs:4"
    ## [1] "Number of found negative FBLs:9"

``` r
amrn_rbns <- findFFLs(amrn_rbns)
```

    ## [1] "Number of found FFLs:14"
    ## [1] "Number of found coherent FFLs:9"
    ## [1] "Number of found incoherent FFLs:5"
    ## [1] "Number of found FFLs:21"
    ## [1] "Number of found coherent FFLs:11"
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
    ## 1      AG     4        2        2     4       0       2       2      5
    ## 2     AP1     9        6        3     6       0       2       4      5
    ## 3     AP3     9        6        3     4       1       1       2      7
    ## 4    EMF1     0        0        0     2       2       0       0      3
    ## 5     LFY    12        8        4    11       7       3       1      8
    ## 6     LUG     0        0        0     0       0       0       0      1
    ## 7      PI    10        7        3     7       1       2       4      7
    ## 8     SUP     0        0        0     2       2       0       0      2
    ## 9    TFL1     4        3        1     3       0       3       0      4
    ## 10    UFO     0        0        0     0       0       0       0      2
    ##    In_Degree Out_Degree  Closeness Betweenness Stress Eigenvector
    ## 1          4          1 0.01960784         2.0      2   0.1458650
    ## 2          3          2 0.02000000         2.0      4   0.2917300
    ## 3          5          2 0.02083333        11.5     14   0.3521492
    ## 4          0          3 0.02564103         0.0      0   0.2917300
    ## 5          3          5 0.02222222        15.5     20   0.5584335
    ## 6          0          1 0.02272727         0.0      0   0.1458650
    ## 7          5          2 0.02083333         8.0     11   0.3521492
    ## 8          0          2 0.02500000         0.0      0   0.3771757
    ## 9          2          2 0.02083333         1.0      1   0.2062842
    ## 10         0          2 0.02439024         0.0      0   0.2062842
    ## 
    ## $edges
    ##            EdgeID NuFBL NuPosFBL NuNegFBL NuFFL NuFFL_AB NuFFL_BC NuFFL_AC
    ## 1      AG (-1) PI     4        2        2     2        0        2        0
    ## 2    AP1 (-1) AP3     5        2        3     1        0        1        0
    ## 3      AP1 (1) PI     4        4        0     1        0        1        0
    ## 4     AP3 (1) AP1     3        2        1     2        0        1        1
    ## 5     AP3 (1) LFY     6        4        2     1        1        0        0
    ## 6    EMF1 (-1) AG     0        0        0     2        1        0        1
    ## 7  EMF1 (-1) TFL1     0        0        0     1        1        0        0
    ## 8     EMF1 (1) PI     0        0        0     1        0        0        1
    ## 9   LFY (-1) TFL1     4        3        1     2        2        0        0
    ## 10     LFY (1) AG     2        1        1     2        1        0        1
    ## 11    LFY (1) AP1     2        1        1     5        2        2        1
    ## 12    LFY (1) AP3     2        2        0     2        1        0        1
    ## 13     LFY (1) PI     2        1        1     3        1        1        1
    ## 14   LUG (-1) AP3     0        0        0     0        0        0        0
    ## 15     PI (1) AP1     4        3        1     2        0        1        1
    ## 16     PI (1) LFY     6        4        2     2        1        1        0
    ## 17   SUP (-1) LFY     0        0        0     2        1        0        1
    ## 18    SUP (-1) PI     0        0        0     2        1        0        1
    ## 19   TFL1 (-1) AG     2        1        1     2        0        2        0
    ## 20  TFL1 (-1) AP3     2        2        0     1        0        1        0
    ## 21     UFO (1) AG     0        0        0     0        0        0        0
    ## 22    UFO (1) AP3     0        0        0     0        0        0        0
    ##    Degree Betweenness
    ## 1      12         7.0
    ## 2      12         3.5
    ## 3      12         3.5
    ## 4      12         5.0
    ## 5      15        11.5
    ## 6       8         1.0
    ## 7       7         2.0
    ## 8      10         3.0
    ## 9      12         8.0
    ## 10     13         6.0
    ## 11     13         1.5
    ## 12     15         3.0
    ## 13     15         2.0
    ## 14      8         6.0
    ## 15     12         4.5
    ## 16     15         8.5
    ## 17     10         4.5
    ## 18      9         1.5
    ## 19      9         2.0
    ## 20     11         4.0
    ## 21      7         2.0
    ## 22      9         4.0
    ## 
    ## $network
    ##    NetworkID NuFBL NuPosFBL NuNegFBL NuFFL NuCoFFL NuInCoFFL
    ## 1 AMRN_RBN_1    14        9        5    14       9         5
    ## 
    ## $transitionNetwork
    ## [1] FALSE
    ## 
    ## $Group_1
    ##           GroupID edgeremoval_t1000_r1_macro edgeremoval_t1000_r1_bitws
    ## 1   TFL1 (-1) AP3                0.149414062               0.0276041667
    ## 2     AP3 (1) LFY                0.466796875               0.1372395833
    ## 3     AP3 (1) AP1                0.024414062               0.0073242187
    ## 4     SUP (-1) PI                0.059570312               0.0105143229
    ## 5     LFY (1) AP3                0.501953125               0.0883138021
    ## 6    SUP (-1) LFY                0.072265625               0.0158528646
    ## 7    AP1 (-1) AP3                0.021484375               0.0056966146
    ## 8      PI (1) AP1                0.026367188               0.0038411458
    ## 9      AG (-1) PI                0.103515625               0.0121744792
    ## 10    EMF1 (1) PI                0.015625000               0.0025390625
    ## 11    LFY (1) AP1                0.088867188               0.0146484375
    ## 12  LFY (-1) TFL1                0.017578125               0.0068359375
    ## 13   LUG (-1) AP3                0.028320312               0.0043619792
    ## 14   EMF1 (-1) AG                0.078125000               0.0068359375
    ## 15    UFO (1) AP3                0.068359375               0.0171223958
    ## 16 EMF1 (-1) TFL1                0.484375000               0.0613932292
    ## 17     UFO (1) AG                0.001953125               0.0001953125
    ## 18     LFY (1) PI                0.234375000               0.0258138021
    ## 19   TFL1 (-1) AG                0.000000000               0.0000000000
    ## 20     PI (1) LFY                0.000000000               0.0000000000
    ## 21     LFY (1) AG                0.000000000               0.0000000000
    ## 22     AP1 (1) PI                0.007812500               0.0023437500
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
    ## 1      AG     6        3        3     5       0       1       4      5
    ## 2     AP1     7        2        5     6       1       3       2      5
    ## 3     AP3    11        2        9     8       0       3       5      7
    ## 4    EMF1     0        0        0     3       3       0       0      3
    ## 5     LFY     8        3        5    12       8       4       0      8
    ## 6     LUG     0        0        0     0       0       0       0      1
    ## 7      PI    10        3        7     9       1       4       4      7
    ## 8     SUP     0        0        0     1       1       0       0      2
    ## 9    TFL1    10        3        7     3       1       1       1      4
    ## 10    UFO     0        0        0     1       1       0       0      2
    ##    In_Degree Out_Degree  Closeness Betweenness Stress Eigenvector
    ## 1          4          1 0.01923077    3.166667      6   0.1035715
    ## 2          3          2 0.02040816    3.000000      5   0.1726192
    ## 3          5          2 0.02040816   14.500000     21   0.2416668
    ## 4          0          3 0.02564103    0.000000      0   0.5005956
    ## 5          3          5 0.02222222    7.666667     12   0.5523813
    ## 6          0          1 0.02222222    0.000000      0   0.1208334
    ## 7          5          2 0.02040816    8.333333     14   0.2071430
    ## 8          0          2 0.02325581    0.000000      0   0.1898811
    ## 9          2          2 0.02083333    8.333333     13   0.3797622
    ## 10         0          2 0.02500000    0.000000      0   0.3279764
    ## 
    ## $edges
    ##           EdgeID NuFBL NuPosFBL NuNegFBL NuFFL NuFFL_AB NuFFL_BC NuFFL_AC
    ## 1     AG (-1) PI     6        3        3     1        0        1        0
    ## 2    AP1 (-1) AG     2        1        1     2        0        1        1
    ## 3    AP1 (1) AP3     5        1        4     3        1        2        0
    ## 4     AP3 (1) AG     2        0        2     2        0        2        0
    ## 5   AP3 (1) TFL1     9        2        7     1        0        1        0
    ## 6  EMF1 (-1) AP3     0        0        0     1        0        0        1
    ## 7  EMF1 (-1) LFY     0        0        0     2        2        0        0
    ## 8    EMF1 (1) PI     0        0        0     2        1        0        1
    ## 9  LFY (-1) TFL1     1        1        0     2        1        0        1
    ## 10    LFY (1) AG     2        2        0     3        1        1        1
    ## 11   LFY (1) AP1     2        0        2     3        2        0        1
    ## 12   LFY (1) AP3     1        0        1     4        2        1        1
    ## 13    LFY (1) PI     2        0        2     5        2        2        1
    ## 14  LUG (-1) AP3     0        0        0     0        0        0        0
    ## 15    PI (1) AP1     5        2        3     3        1        2        0
    ## 16    PI (1) AP3     5        1        4     3        0        2        1
    ## 17  SUP (-1) AP1     0        0        0     1        0        0        1
    ## 18   SUP (-1) PI     0        0        0     1        1        0        0
    ## 19 TFL1 (-1) LFY     8        3        5     1        1        0        0
    ## 20  TFL1 (-1) PI     2        0        2     2        0        1        1
    ## 21    UFO (1) AG     0        0        0     1        0        0        1
    ## 22   UFO (1) LFY     0        0        0     1        1        0        0
    ##    Degree Betweenness
    ## 1      12    8.166667
    ## 2      10    3.500000
    ## 3      12    4.500000
    ## 4      12    4.666667
    ## 5      11   14.833333
    ## 6      10    2.000000
    ## 7      11    2.500000
    ## 8      10    1.500000
    ## 9      12    2.500000
    ## 10     13    2.500000
    ## 11     13    3.666667
    ## 12     15    2.500000
    ## 13     15    1.500000
    ## 14      8    6.000000
    ## 15     12    4.833333
    ## 16     14    8.500000
    ## 17      7    3.500000
    ## 18      9    2.500000
    ## 19     12    9.666667
    ## 20     11    3.666667
    ## 21      7    1.500000
    ## 22     10    4.500000
    ## 
    ## $network
    ##    NetworkID NuFBL NuPosFBL NuNegFBL NuFFL NuCoFFL NuInCoFFL
    ## 1 AMRN_RBN_2    13        4        9    21      11        10
    ## 
    ## $transitionNetwork
    ## [1] FALSE
    ## 
    ## $Group_1
    ##          GroupID edgeremoval_t1000_r1_macro edgeremoval_t1000_r1_bitws
    ## 1  EMF1 (-1) LFY                0.250000000                0.067187500
    ## 2    AP1 (1) AP3                0.212890625                0.044433594
    ## 3    UFO (1) LFY                0.250000000                0.058333333
    ## 4   SUP (-1) AP1                0.011718750                0.003515625
    ## 5     LFY (1) PI                0.460937500                0.053038194
    ## 6   AP3 (1) TFL1                0.843750000                0.107356771
    ## 7  LFY (-1) TFL1                0.191406250                0.046981376
    ## 8     UFO (1) AG                0.000000000                0.000000000
    ## 9   LUG (-1) AP3                0.005859375                0.001204427
    ## 10    PI (1) AP3                0.005859375                0.001204427
    ## 11   AP1 (-1) AG                0.082031250                0.016601562
    ## 12    AG (-1) PI                0.066406250                0.008593750
    ## 13  TFL1 (-1) PI                0.070312500                0.013085937
    ## 14   LFY (1) AP3                0.244140625                0.049357096
    ## 15 TFL1 (-1) LFY                0.121093750                0.029492187
    ## 16    AP3 (1) AG                0.148437500                0.031510417
    ## 17   LFY (1) AP1                0.019531250                0.004654948
    ## 18   SUP (-1) PI                0.000000000                0.000000000
    ## 19   EMF1 (1) PI                0.000000000                0.000000000
    ## 20 EMF1 (-1) AP3                0.000000000                0.000000000
    ## 21    LFY (1) AG                0.105468750                0.010937500
    ## 22    PI (1) AP1                0.119140625                0.019075521
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
