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

In addition, we must initialize the Java Virtual Machine (JVM) with a *Maximum Java heap size* via the function *initJVM*. This function must be called before any RMut functions can be used. The following command will initialize the JVM with the maximum Java heap size of 8GB (in case of large-scale networks analysis, we could set the Java heap size to a larger value):

*&gt; initJVM("8G")*

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

``` r
initJVM("8G")
```

    ## [1] "The Java Virtual Machine is successfully initialized!"

    ## [1] TRUE

``` r
showOpencl()
```

    ## Your system has 1 installed OpenCL platform(s):
    ## 1. Intel(R) OpenCL
    ##   PROFILE = FULL_PROFILE
    ##   VERSION = OpenCL 2.1 
    ##   VENDOR = Intel(R) Corporation
    ##   EXTENSIONS = cl_intel_dx9_media_sharing cl_khr_3d_image_writes cl_khr_byte_addressable_store cl_khr_d3d11_sharing cl_khr_depth_images cl_khr_dx9_media_sharing cl_khr_fp64 cl_khr_gl_sharing cl_khr_global_int32_base_atomics cl_khr_global_int32_extended_atomics cl_khr_icd cl_khr_local_int32_base_atomics cl_khr_local_int32_extended_atomics cl_khr_spir
    ##  1 CPU device(s) found on the platform:
    ##  1. Intel(R) Core(TM) i3-6006U CPU @ 2.00GHz
    ##  DEVICE_VENDOR = Intel(R) Corporation
    ##  DEVICE_VERSION = OpenCL 1.2 (Build 611)
    ##  CL_DEVICE_MAX_COMPUTE_UNITS: 4
    ##  1 GPU device(s) found on the platform:
    ##  1. Intel(R) HD Graphics 520
    ##  DEVICE_VENDOR = Intel(R) Corporation
    ##  DEVICE_VERSION = OpenCL 2.1 NEO 
    ##  CL_DEVICE_MAX_COMPUTE_UNITS: 23

``` r
setOpencl("gpu")
```

    ## Enabled OpenCL computation based on the device: Intel(R) HD Graphics 520.

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
    ## 2       AG               1.0000000              0.12262370
    ## 3      AP1               0.9687500              0.13518880
    ## 4      LFY               0.9062500              0.16064453
    ## 5      AP3               0.7617188              0.08886719
    ## 6      SUP               0.0000000              0.00000000
    ## 7      LUG               0.0000000              0.00000000
    ## 8      UFO               0.0000000              0.00000000
    ## 9     EMF1               0.0000000              0.00000000
    ## 10    TFL1               0.4687500              0.05335286
    ##    ruleflip_t1000_r2_macro ruleflip_t1000_r2_bitws
    ## 1                0.9707031              0.10488281
    ## 2                1.0000000              0.12177734
    ## 3                0.9687500              0.12900391
    ## 4                0.9062500              0.14690755
    ## 5                0.9707031              0.10488281
    ## 6                0.0000000              0.00000000
    ## 7                0.0000000              0.00000000
    ## 8                0.0000000              0.00000000
    ## 9                0.0000000              0.00000000
    ## 10               0.4687500              0.05458984

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
    ## 1     UFO (1) PI                 0.01757812                0.003222656
    ## 2  TFL1 (-1) LFY                 0.12500000                0.015755208
    ## 3  EMF1 (1) TFL1                 0.46875000                0.053352865
    ## 4     AP3 (1) PI                 0.02539062                0.006152344
    ## 5  EMF1 (-1) AP1                 0.00000000                0.000000000
    ## 6    AP1 (-1) AG                 0.03125000                0.005794271
    ## 7    LFY (1) AP1                 0.42187500                0.074804688
    ## 8   SUP (-1) AP3                 0.01562500                0.003710938
    ## 9  EMF1 (-1) LFY                 0.00000000                0.000000000
    ## 10    LFY (1) AG                 0.14062500                0.014062500
    ## 11     PI (1) PI                 0.00390625                0.000390625
    ## 12 LFY (-1) TFL1                 0.00000000                0.000000000
    ## 13    LFY (1) PI                 0.18164062                0.034375000
    ## 14  TFL1 (-1) AG                 0.01269531                0.003808594
    ## 15   LUG (-1) AG                 0.09375000                0.010188802
    ## 16   AP3 (1) AP3                 0.00000000                0.000000000
    ## 17    PI (1) AP3                 0.18945312                0.026269531
    ## 18   SUP (-1) PI                 0.01757812                0.003222656
    ## 19   LFY (1) AP3                 0.00390625                0.000390625
    ## 20   UFO (1) AP3                 0.01562500                0.003710938
    ## 21   AG (-1) AP1                 0.12500000                0.016178385
    ## 22   AP1 (1) LFY                 0.46875000                0.075358073

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
    ## 1     LUG (-1) AP1                   0.4843750                 0.065820313
    ## 2     LUG (-1) AP3                   0.9873047                 0.353027344
    ## 3    LFY (-1) EMF1                   0.4687500                 0.116048177
    ## 4       AG (1) AP3                   0.9873047                 0.353027344
    ## 5      AP3 (1) SUP                   0.5371094                 0.069531250
    ## 6     PI (-1) EMF1                   0.6191406                 0.116731771
    ## 7      AG (-1) SUP                   0.5625000                 0.072493490
    ## 8     LUG (1) TFL1                   0.2500000                 0.025000000
    ## 9      PI (-1) LFY                   0.2246094                 0.044303385
    ## 10    AP1 (-1) AP1                   0.5312500                 0.071126302
    ## 11      PI (1) AP1                   0.9687500                 0.128938802
    ## 12    LFY (-1) AP3                   0.9873047                 0.353027344
    ## 13     SUP (1) AP1                   0.4843750                 0.064322917
    ## 14     PI (-1) AP1                   0.2128906                 0.032649740
    ## 15     EMF1 (1) AG                   0.5000000                 0.072623698
    ## 16      AG (1) AP1                   0.3125000                 0.046516927
    ## 17    AP1 (-1) AP3                   0.9873047                 0.353027344
    ## 18    TFL1 (1) UFO                   0.5156250                 0.062597656
    ## 19   TFL1 (-1) LUG                   0.5253906                 0.061165365
    ## 20     UFO (1) LFY                   0.1093750                 0.015397135
    ## 21      AG (1) LFY                   0.9687500                 0.170817057
    ## 22      AG (1) LUG                   0.5937500                 0.073561198
    ## 23    AP1 (-1) SUP                   0.5937500                 0.059505208
    ## 24   SUP (-1) TFL1                   0.2500000                 0.025000000
    ## 25     SUP (1) LFY                   0.4843750                 0.097395833
    ## 26    UFO (1) TFL1                   0.2500000                 0.025000000
    ## 27   TFL1 (1) EMF1                   1.0000000                 0.127923177
    ## 28     AP3 (-1) PI                   1.0000000                 0.472753906
    ## 29     EMF1 (1) PI                   1.0000000                 0.472753906
    ## 30   TFL1 (-1) SUP                   0.5156250                 0.062597656
    ## 31    UFO (-1) LUG                   0.5000000                 0.061002604
    ## 32     PI (-1) AP3                   0.9873047                 0.353027344
    ## 33    EMF1 (1) LFY                   0.0000000                 0.000000000
    ## 34     AG (1) EMF1                   0.6250000                 0.116048177
    ## 35     TFL1 (1) PI                   1.0000000                 0.472753906
    ## 36     AP3 (-1) AG                   0.0937500                 0.011360677
    ## 37      AG (-1) PI                   0.9921875                 0.454003906
    ## 38    LUG (-1) LFY                   0.4843750                 0.099414063
    ## 39    LFY (-1) AP1                   0.0000000                 0.000000000
    ## 40    AG (-1) EMF1                   0.5000000                 0.129720052
    ## 41     LFY (-1) AG                   0.0937500                 0.010188802
    ## 42     LUG (1) SUP                   0.5000000                 0.054003906
    ## 43    LFY (-1) LFY                   0.1875000                 0.022298177
    ## 44    LFY (-1) UFO                   0.5937500                 0.060286458
    ## 45  EMF1 (-1) TFL1                   0.5000000                 0.050000000
    ## 46     AP1 (1) LUG                   0.5937500                 0.062890625
    ## 47     UFO (-1) PI                   1.0000000                 0.472753906
    ## 48     AP1 (1) SUP                   0.5937500                 0.053938802
    ## 49    LFY (-1) LUG                   0.5937500                 0.062988281
    ## 50      UFO (1) AG                   0.0468750                 0.004459635
    ## 51    LFY (1) TFL1                   0.5000000                 0.050000000
    ## 52    EMF1 (1) UFO                   0.5000000                 0.055566406
    ## 53     AP1 (1) AP1                   0.7812500                 0.058235677
    ## 54    LUG (-1) UFO                   0.5000000                 0.053515625
    ## 55     LUG (-1) PI                   1.0000000                 0.472753906
    ## 56     AP1 (-1) PI                   1.0000000                 0.449316406
    ## 57   LUG (-1) EMF1                   0.5000000                 0.113085938
    ## 58   AP3 (-1) TFL1                   0.5000000                 0.050000000
    ## 59   EMF1 (-1) SUP                   0.5000000                 0.055566406
    ## 60     LUG (1) LFY                   0.1093750                 0.013085937
    ## 61    SUP (-1) LFY                   0.1093750                 0.015397135
    ## 62    AP3 (-1) LFY                   0.0781250                 0.010611979
    ## 63    AP1 (1) TFL1                   0.5000000                 0.050000000
    ## 64      AP1 (1) PI                   1.0000000                 0.445735677
    ## 65     SUP (1) LUG                   0.5000000                 0.060904948
    ## 66     AG (1) TFL1                   0.5000000                 0.050000000
    ## 67     AG (-1) UFO                   0.5625000                 0.072623698
    ## 68    SUP (-1) SUP                   1.0000000                 0.056770833
    ## 69     LFY (-1) PI                   1.0000000                 0.472753906
    ## 70    LFY (1) EMF1                   0.4687500                 0.116048177
    ## 71    UFO (-1) AP1                   0.4843750                 0.070865885
    ## 72    AP1 (-1) UFO                   0.5937500                 0.059505208
    ## 73     AP3 (1) AP1                   0.2167969                 0.028938802
    ## 74      PI (1) UFO                   0.5351562                 0.073339844
    ## 75     AG (-1) LFY                   0.1718750                 0.023046875
    ## 76   AP3 (-1) EMF1                   0.6191406                 0.116731771
    ## 77    AP3 (1) TFL1                   0.0000000                 0.000000000
    ## 78      PI (1) LUG                   0.5175781                 0.062337240
    ## 79    LUG (-1) LUG                   1.0000000                 0.061490885
    ## 80     LFY (1) LUG                   0.5937500                 0.062890625
    ## 81   TFL1 (-1) UFO                   0.5156250                 0.062597656
    ## 82     UFO (1) AP1                   0.1093750                 0.014322917
    ## 83       AG (1) AG                   0.0000000                 0.000000000
    ## 84    TFL1 (1) AP3                   0.9873047                 0.353027344
    ## 85    LFY (-1) SUP                   0.5937500                 0.063281250
    ## 86    AP3 (-1) UFO                   0.5390625                 0.070605469
    ## 87  TFL1 (-1) EMF1                   0.6250000                 0.082291667
    ## 88   UFO (-1) EMF1                   0.5000000                 0.115397135
    ## 89    AP3 (-1) AP3                   0.9873047                 0.353027344
    ## 90       AG (1) PI                   0.9921875                 0.454003906
    ## 91    AP1 (-1) LUG                   0.5937500                 0.062890625
    ## 92     PI (-1) UFO                   0.5351562                 0.073339844
    ## 93     AG (-1) AP3                   0.9873047                 0.353027344
    ## 94    EMF1 (1) AP3                   0.9873047                 0.353027344
    ## 95     PI (-1) LUG                   0.5058594                 0.062500000
    ## 96    UFO (-1) AP3                   0.9873047                 0.353027344
    ## 97     AP3 (1) LUG                   0.5058594                 0.062500000
    ## 98    TFL1 (1) LFY                   0.0000000                 0.000000000
    ## 99    UFO (1) EMF1                   0.5000000                 0.114322917
    ## 100   TFL1 (1) AP1                   0.0625000                 0.007291667
    ## 101   UFO (-1) LFY                   0.1093750                 0.014322917
    ## 102    AP3 (1) UFO                   0.5390625                 0.070605469
    ## 103     AG (1) UFO                   0.5625000                 0.072493490
    ## 104    LFY (1) SUP                   0.5937500                 0.060286458
    ## 105     AP3 (1) AG                   0.1074219                 0.017805990
    ## 106  LUG (-1) TFL1                   0.2500000                 0.041634115
    ## 107  UFO (-1) TFL1                   0.2500000                 0.025000000
    ## 108     AG (1) SUP                   0.5625000                 0.072623698
    ## 109     PI (-1) PI                   1.0000000                 0.472753906
    ## 110  TFL1 (-1) AP3                   0.9873047                 0.353027344
    ## 111    SUP (1) AP3                   0.9873047                 0.353027344
    ## 112     SUP (1) PI                   1.0000000                 0.472753906
    ## 113    TFL1 (1) AG                   0.5000000                 0.072623698
    ## 114   AG (-1) TFL1                   0.0000000                 0.000000000
    ## 115   PI (-1) TFL1                   0.5000000                 0.050000000
    ## 116 TFL1 (-1) TFL1                   0.3750000                 0.037500000
    ## 117  TFL1 (1) TFL1                   0.5000000                 0.041015625
    ## 118    PI (1) EMF1                   0.4960938                 0.127376302
    ## 119   TFL1 (1) LUG                   0.5253906                 0.061165365
    ## 120   EMF1 (1) AP1                   0.2187500                 0.029720052
    ## 121   AP1 (-1) LFY                   0.0000000                 0.000000000
    ## 122  EMF1 (-1) AP3                   0.9873047                 0.353027344
    ## 123    PI (-1) SUP                   0.5527344                 0.074023438
    ## 124    PI (1) TFL1                   0.0000000                 0.000000000
    ## 125   SUP (1) TFL1                   0.2500000                 0.025000000
    ## 126      PI (1) AG                   0.1132812                 0.018489583
    ## 127     LUG (1) AG                   0.0937500                 0.010188802
    ## 128    AP1 (1) AP3                   0.9873047                 0.353027344
    ## 129    SUP (-1) AG                   0.5000000                 0.061946615
    ## 130    UFO (1) LUG                   0.5000000                 0.061002604
    ## 131 EMF1 (-1) EMF1                   0.0000000                 0.000000000
    ## 132     LUG (1) PI                   1.0000000                 0.472753906
    ## 133    LUG (1) LUG                   1.0000000                 0.061490885
    ## 134   EMF1 (1) LUG                   0.5000000                 0.061165365
    ## 135    AP3 (1) LFY                   0.0781250                 0.010611979
    ## 136   UFO (-1) SUP                   0.5000000                 0.055566406
    ## 137  AP1 (-1) EMF1                   0.4687500                 0.116048177
    ## 138   SUP (-1) AP1                   0.4843750                 0.070865885
    ## 139    LUG (1) AP3                   0.9873047                 0.353027344
    ## 140  SUP (-1) EMF1                   0.5000000                 0.114322917
    ## 141     AP1 (1) AG                   0.8876953                 0.090006510
    ## 142    LFY (1) UFO                   0.5937500                 0.060286458
    ## 143    UFO (-1) AG                   0.0468750                 0.004459635
    ## 144   AP3 (-1) SUP                   0.5371094                 0.069531250
    ## 145  TFL1 (-1) AP1                   0.6875000                 0.071875000
    ## 146   EMF1 (1) SUP                   0.5000000                 0.055566406
    ## 147   SUP (1) EMF1                   0.5000000                 0.115397135
    ## 148     PI (1) LFY                   0.2148438                 0.028157552
    ## 149     AG (-1) AG                   0.0937500                 0.010188802
    ## 150  EMF1 (-1) LUG                   0.5000000                 0.061165365
    ## 151  EMF1 (-1) UFO                   0.5000000                 0.051953125
    ## 152     PI (-1) AG                   0.1132812                 0.018489583
    ## 153  AP1 (-1) TFL1                   0.0000000                 0.000000000
    ## 154    LUG (1) AP1                   0.4843750                 0.065820313
    ## 155   SUP (-1) LUG                   0.5000000                 0.061002604
    ## 156    AG (-1) LUG                   0.5937500                 0.073561198
    ## 157    SUP (1) SUP                   1.0000000                 0.056770833
    ## 158    UFO (1) UFO                   1.0000000                 0.056770833
    ## 159     SUP (1) AG                   0.5000000                 0.061946615
    ## 160    LFY (1) LFY                   0.0625000                 0.008463542
    ## 161   AP3 (1) EMF1                   0.6191406                 0.116731771
    ## 162   AP3 (-1) LUG                   0.5175781                 0.062337240
    ## 163   EMF1 (-1) AG                   0.5000000                 0.050000000
    ## 164   TFL1 (-1) PI                   1.0000000                 0.472753906
    ## 165   AP3 (-1) AP1                   0.2167969                 0.028938802
    ## 166   EMF1 (-1) PI                   1.0000000                 0.472753906
    ## 167   TFL1 (1) SUP                   0.5156250                 0.062597656
    ## 168    UFO (1) SUP                   0.5000000                 0.051953125
    ## 169    SUP (1) UFO                   0.5000000                 0.055566406
    ## 170   SUP (-1) UFO                   0.5000000                 0.055566406
    ## 171     PI (1) SUP                   0.5351562                 0.073339844
    ## 172    AP1 (1) UFO                   0.5937500                 0.053938802
    ## 173   AP1 (1) EMF1                   0.7187500                 0.129720052
    ## 174   LUG (-1) SUP                   0.5000000                 0.053515625
    ## 175    LUG (1) UFO                   0.5000000                 0.053515625
    ## 176  EMF1 (1) EMF1                   1.0000000                 0.129720052
    ## 177   UFO (-1) UFO                   0.0000000                 0.000000000
    ## 178   LUG (1) EMF1                   0.5000000                 0.116634115

As shown above, we firstly need to generate a set of initial-states by the function *generateStates*. Then by the function *generateGroups*, we continue to generate three sets of node/edge groups whose their sensitivity would be calculated. Finally, the sensitivity values are stored in the same data frame of node/edge groups. The data frame has one column for group identifiers (lists of nodes/edges), and some next columns containing their sensitivity values according to each set of random update-rules. For example, the mutation *rule-flip* used two sets of Nested Canalyzing rules, thus resulted in two corresponding sets of sensitivity values. RMut automatically generates a file of Boolean logics for each set, or uses existing files in the working directory of RMut. Here, two rule files "*AMRN\_rules\_0*" and "*AMRN\_rules\_1*" are generated. A user can manually create or modify these rule files before the calculation. In addition, the column names which contain the sequence "*macro*" or "*bitws*" denote the macro-distance and bitwise-distance sensitivity measures, respectively.

Attractor cycles identification
-------------------------------

Via *findAttractors* function, the landscape of the network state transitions along with attractor cycles would be identified. The returned transition network object has same structures with the normal network object resulted from *loadNetwork* function (see section "*loadNetwork* function"). An example is demonstrated as follows:

``` r
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
    ## [1] "D:/HCStore/Projects/R/RMut/vignettes"

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
    ## [1] "D:/HCStore/Projects/R/RMut/vignettes"

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

    ## [1] "Number of found FBLs:6"
    ## [1] "Number of found positive FBLs:1"
    ## [1] "Number of found negative FBLs:5"
    ## [1] "Number of found FBLs:3"
    ## [1] "Number of found positive FBLs:3"
    ## [1] "Number of found negative FBLs:0"

``` r
ba_rbns <- findFFLs(ba_rbns)
```

    ## [1] "Number of found FFLs:3"
    ## [1] "Number of found coherent FFLs:2"
    ## [1] "Number of found incoherent FFLs:1"
    ## [1] "Number of found FFLs:6"
    ## [1] "Number of found coherent FFLs:3"
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
    ## 1       0     0        0        0     1       0       0       1      2
    ## 2       1     2        0        2     3       2       0       1      5
    ## 3       2     5        1        4     2       0       1       1     10
    ## 4       3     3        0        3     1       0       1       0      5
    ## 5       4     1        0        1     1       0       1       0      2
    ## 6       5     1        1        0     0       0       0       0      2
    ## 7       6     1        0        1     0       0       0       0      2
    ## 8       7     1        0        1     0       0       0       0      2
    ## 9       8     1        0        1     0       0       0       0      2
    ## 10      9     0        0        0     1       1       0       0      2
    ##    In_Degree Out_Degree  Closeness Betweenness Stress Eigenvector
    ## 1          2          0 0.01111111           0      0   0.0000000
    ## 2          2          3 0.04166667          22     22   0.4150287
    ## 3          5          5 0.04545455          42     42   0.5533716
    ## 4          3          2 0.03703704          23     23   0.2766858
    ## 5          1          1 0.03703704           0      0   0.2766858
    ## 6          1          1 0.03448276           0      0   0.2766858
    ## 7          1          1 0.03448276           0      0   0.2766858
    ## 8          1          1 0.03448276           0      0   0.2766858
    ## 9          1          1 0.02941176           0      0   0.1383429
    ## 10         0          2 0.05263158           0      0   0.3458572
    ## 
    ## $edges
    ##      EdgeID NuFBL NuPosFBL NuNegFBL NuFFL NuFFL_AB NuFFL_BC NuFFL_AC
    ## 1  1 (-1) 0     0        0        0     1        0        0        1
    ## 2  1 (-1) 4     1        0        1     1        1        0        0
    ## 3   1 (1) 2     1        0        1     2        1        0        1
    ## 4  2 (-1) 0     0        0        0     1        0        1        0
    ## 5  2 (-1) 6     1        0        1     0        0        0        0
    ## 6  2 (-1) 7     1        0        1     0        0        0        0
    ## 7   2 (1) 3     2        0        2     0        0        0        0
    ## 8   2 (1) 5     1        1        0     0        0        0        0
    ## 9  3 (-1) 1     2        0        2     1        0        1        0
    ## 10 3 (-1) 8     1        0        1     0        0        0        0
    ## 11 4 (-1) 2     1        0        1     1        0        1        0
    ## 12  5 (1) 2     1        1        0     0        0        0        0
    ## 13  6 (1) 2     1        0        1     0        0        0        0
    ## 14  7 (1) 2     1        0        1     0        0        0        0
    ## 15  8 (1) 3     1        0        1     0        0        0        0
    ## 16 9 (-1) 1     0        0        0     1        0        0        1
    ## 17 9 (-1) 3     0        0        0     1        1        0        0
    ##    Degree Betweenness
    ## 1       7           4
    ## 2       7           8
    ## 3      15          18
    ## 4      12           5
    ## 5      12           8
    ## 6      12           8
    ## 7      15          21
    ## 8      12           8
    ## 9      10          23
    ## 10      7           8
    ## 11     12           8
    ## 12     12           8
    ## 13     12           8
    ## 14     12           8
    ## 15      7           8
    ## 16      7           7
    ## 17      7           2
    ## 
    ## $network
    ##   NetworkID NuFBL NuPosFBL NuNegFBL NuFFL NuCoFFL NuInCoFFL
    ## 1  BA_RBN_1     6        1        5     3       2         1
    ## 
    ## $transitionNetwork
    ## [1] FALSE
    ## 
    ## $Group_1
    ##    GroupID knockout_t1000_r1_macro knockout_t1000_r1_bitws
    ## 1        1                     0.5                    0.15
    ## 2        2                     0.0                    0.00
    ## 3        3                     0.0                    0.00
    ## 4        5                     0.0                    0.00
    ## 5        4                     0.5                    0.05
    ## 6        6                     1.0                    0.10
    ## 7        9                     0.5                    0.20
    ## 8        0                     0.5                    0.05
    ## 9        8                     1.0                    0.10
    ## 10       7                     1.0                    0.10
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
    ## 1       0     3        3        0     3       1       1       1      8
    ## 2       1     0        0        0     2       0       1       1      3
    ## 3       2     0        0        0     1       1       0       0      4
    ## 4       3     2        2        0     1       1       0       0      4
    ## 5       4     1        1        0     0       0       0       0      4
    ## 6       5     1        1        0     1       0       1       0      3
    ## 7       6     0        0        0     0       0       0       0      2
    ## 8       7     0        0        0     1       0       0       1      2
    ## 9       8     0        0        0     0       0       0       0      2
    ## 10      9     0        0        0     0       0       0       0      2
    ##    In_Degree Out_Degree  Closeness Betweenness Stress Eigenvector
    ## 1          4          4 0.02173913        23.0     26   0.4366771
    ## 2          2          1 0.01234568         0.5      1   0.0000000
    ## 3          0          4 0.04545455         0.0      0   0.4760523
    ## 4          2          2 0.02083333         5.5      7   0.4366771
    ## 5          3          1 0.02000000         6.5      8   0.2698813
    ## 6          2          1 0.02040816         5.0      5   0.2698813
    ## 7          1          1 0.02222222         1.0      1   0.1667958
    ## 8          2          0 0.01111111         0.0      0   0.0000000
    ## 9          0          2 0.02380952         0.0      0   0.4366771
    ## 10         1          1 0.02173913         0.5      1   0.1667958
    ## 
    ## $edges
    ##      EdgeID NuFBL NuPosFBL NuNegFBL NuFFL NuFFL_AB NuFFL_BC NuFFL_AC
    ## 1  0 (-1) 3     2        2        0     0        0        0        0
    ## 2  0 (-1) 4     1        1        0     0        0        0        0
    ## 3  0 (-1) 7     0        0        0     1        0        0        1
    ## 4   0 (1) 1     0        0        0     2        1        1        0
    ## 5   1 (1) 7     0        0        0     1        0        1        0
    ## 6  2 (-1) 9     0        0        0     0        0        0        0
    ## 7   2 (1) 0     0        0        0     1        1        0        0
    ## 8   2 (1) 1     0        0        0     1        0        0        1
    ## 9   2 (1) 6     0        0        0     0        0        0        0
    ## 10 3 (-1) 0     1        1        0     1        0        0        1
    ## 11 3 (-1) 5     1        1        0     1        1        0        0
    ## 12 4 (-1) 0     1        1        0     0        0        0        0
    ## 13  5 (1) 0     1        1        0     1        0        1        0
    ## 14 6 (-1) 5     0        0        0     0        0        0        0
    ## 15 8 (-1) 4     0        0        0     0        0        0        0
    ## 16  8 (1) 3     0        0        0     0        0        0        0
    ## 17  9 (1) 4     0        0        0     0        0        0        0
    ##    Degree Betweenness
    ## 1      12         9.0
    ## 2      12         4.5
    ## 3      10         7.5
    ## 4      11         7.0
    ## 5       5         1.5
    ## 6       6         1.5
    ## 7      12         3.0
    ## 8       7         1.5
    ## 9       6         2.0
    ## 10     12         5.5
    ## 11      7         5.0
    ## 12     12        11.5
    ## 13     11        10.0
    ## 14      5         7.0
    ## 15      6         2.5
    ## 16      6         3.5
    ## 17      6         6.5
    ## 
    ## $network
    ##   NetworkID NuFBL NuPosFBL NuNegFBL NuFFL NuCoFFL NuInCoFFL
    ## 1  BA_RBN_2     3        3        0     6       3         3
    ## 
    ## $transitionNetwork
    ## [1] FALSE
    ## 
    ## $Group_1
    ##    GroupID knockout_t1000_r1_macro knockout_t1000_r1_bitws
    ## 1        1                    0.00              0.00000000
    ## 2        4                    0.50              0.05000000
    ## 3        6                    0.50              0.08671875
    ## 4        2                    0.50              0.17500000
    ## 5        0                    0.00              0.00000000
    ## 6        5                    0.25              0.02500000
    ## 7        3                    0.50              0.07500000
    ## 8        7                    1.00              0.10000000
    ## 9        8                    0.50              0.17500000
    ## 10       9                    0.50              0.05000000
    ## 
    ## attr(,"class")
    ## [1] "list"    "NetInfo"

``` r
output(ba_rbns)
```

    ## [1] "All output files get created in the working directory:"
    ## [1] "D:/HCStore/Projects/R/RMut/vignettes"

*Example 2*

``` r
# Example 2: generate random networks based on "Shuffle 2" model #
##################################################################

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

    ## [1] "Number of found FBLs:7"
    ## [1] "Number of found positive FBLs:3"
    ## [1] "Number of found negative FBLs:4"
    ## [1] "Number of found FBLs:18"
    ## [1] "Number of found positive FBLs:13"
    ## [1] "Number of found negative FBLs:5"

``` r
amrn_rbns <- findFFLs(amrn_rbns)
```

    ## [1] "Number of found FFLs:20"
    ## [1] "Number of found coherent FFLs:10"
    ## [1] "Number of found incoherent FFLs:10"
    ## [1] "Number of found FFLs:18"
    ## [1] "Number of found coherent FFLs:14"
    ## [1] "Number of found incoherent FFLs:4"

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
    ## 1      AG     4        3        1     6       0       2       4      5
    ## 2     AP1     6        3        3     6       0       3       3      5
    ## 3     AP3     6        3        3     9       1       4       4      7
    ## 4    EMF1     0        0        0     3       3       0       0      3
    ## 5     LFY     0        0        0    12       9       3       0      8
    ## 6     LUG     0        0        0     0       0       0       0      1
    ## 7      PI     5        2        3     9       1       3       5      7
    ## 8     SUP     0        0        0     1       1       0       0      2
    ## 9    TFL1     4        1        3     4       1       2       1      4
    ## 10    UFO     0        0        0     1       1       0       0      2
    ##    In_Degree Out_Degree  Closeness Betweenness Stress Eigenvector
    ## 1          4          1 0.01724138         1.5      2   0.1207879
    ## 2          3          2 0.01785714         4.5      6   0.1950682
    ## 3          5          2 0.01785714         5.5      8   0.2126736
    ## 4          0          3 0.02564103         0.0      0   0.4895675
    ## 5          3          5 0.02222222        10.0     12   0.5285297
    ## 6          0          1 0.02439024         0.0      0   0.3001782
    ## 7          5          2 0.01785714         5.0      8   0.1793903
    ## 8          0          2 0.02040816         0.0      0   0.2226726
    ## 9          2          2 0.01785714         1.5      2   0.2226726
    ## 10         0          2 0.02500000         0.0      0   0.4020629
    ## 
    ## $edges
    ##           EdgeID NuFBL NuPosFBL NuNegFBL NuFFL NuFFL_AB NuFFL_BC NuFFL_AC
    ## 1    AG (-1) AP3     4        3        1     2        0        2        0
    ## 2    AP1 (-1) AG     2        2        0     2        0        2        0
    ## 3   AP1 (1) TFL1     4        1        3     1        0        1        0
    ## 4    AP3 (1) AP1     3        2        1     2        0        1        1
    ## 5     AP3 (1) PI     3        1        2     4        1        3        0
    ## 6   EMF1 (-1) AG     0        0        0     2        1        0        1
    ## 7  EMF1 (-1) AP3     0        0        0     1        0        0        1
    ## 8   EMF1 (1) LFY     0        0        0     2        2        0        0
    ## 9  LFY (-1) TFL1     0        0        0     3        2        0        1
    ## 10    LFY (1) AG     0        0        0     3        1        1        1
    ## 11   LFY (1) AP1     0        0        0     3        2        0        1
    ## 12   LFY (1) AP3     0        0        0     4        2        1        1
    ## 13    LFY (1) PI     0        0        0     4        2        1        1
    ## 14  LUG (-1) LFY     0        0        0     0        0        0        0
    ## 15     PI (1) AG     2        1        1     2        0        1        1
    ## 16    PI (1) AP1     3        1        2     3        1        2        0
    ## 17  SUP (-1) AP3     0        0        0     1        1        0        0
    ## 18   SUP (-1) PI     0        0        0     1        0        0        1
    ## 19 TFL1 (-1) AP3     2        0        2     2        1        1        0
    ## 20  TFL1 (-1) PI     2        1        1     2        0        1        1
    ## 21   UFO (1) LFY     0        0        0     1        1        0        0
    ## 22    UFO (1) PI     0        0        0     1        0        0        1
    ##    Degree Betweenness
    ## 1      12         5.5
    ## 2      10         2.0
    ## 3       9         6.5
    ## 4      12         6.5
    ## 5      14         3.0
    ## 6       8         1.0
    ## 7      10         2.0
    ## 8      11         3.0
    ## 9      12         4.0
    ## 10     13         2.5
    ## 11     13         3.0
    ## 12     15         3.0
    ## 13     15         2.5
    ## 14      9         6.0
    ## 15     12         5.0
    ## 16     12         4.0
    ## 17      9         2.0
    ## 18      9         3.0
    ## 19     11         2.0
    ## 20     11         3.5
    ## 21     10         4.0
    ## 22      9         2.0
    ## 
    ## $network
    ##    NetworkID NuFBL NuPosFBL NuNegFBL NuFFL NuCoFFL NuInCoFFL
    ## 1 AMRN_RBN_1     7        3        4    20      10        10
    ## 
    ## $transitionNetwork
    ## [1] FALSE
    ## 
    ## $Group_1
    ##          GroupID edgeremoval_t1000_r1_macro edgeremoval_t1000_r1_bitws
    ## 1     LFY (1) AG                     0.0000                 0.00000000
    ## 2   TFL1 (-1) PI                     0.0000                 0.00000000
    ## 3   LUG (-1) LFY                     0.1250                 0.01250000
    ## 4    AG (-1) AP3                     0.0000                 0.00000000
    ## 5      PI (1) AG                     0.0000                 0.00000000
    ## 6    LFY (1) AP1                     0.0000                 0.00000000
    ## 7    SUP (-1) PI                     0.0000                 0.00000000
    ## 8     LFY (1) PI                     0.0000                 0.00000000
    ## 9  TFL1 (-1) AP3                     0.0000                 0.00000000
    ## 10    PI (1) AP1                     0.1250                 0.01250000
    ## 11  EMF1 (1) LFY                     0.1250                 0.02701823
    ## 12  SUP (-1) AP3                     0.0000                 0.00000000
    ## 13 LFY (-1) TFL1                     0.0000                 0.00000000
    ## 14   UFO (1) LFY                     0.1250                 0.01250000
    ## 15   AP1 (-1) AG                     0.0000                 0.00000000
    ## 16  EMF1 (-1) AG                     0.0000                 0.00000000
    ## 17    UFO (1) PI                     0.0000                 0.00000000
    ## 18   LFY (1) AP3                     0.2500                 0.03395996
    ## 19    AP3 (1) PI                     0.2500                 0.03125000
    ## 20   AP3 (1) AP1                     0.0000                 0.00000000
    ## 21 EMF1 (-1) AP3                     0.0625                 0.01875000
    ## 22  AP1 (1) TFL1                     0.8750                 0.08750000
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
    ## 1      AG     8        7        1     4       0       1       3      5
    ## 2     AP1     9        4        5     4       2       1       1      5
    ## 3     AP3    11        7        4     8       0       4       4      7
    ## 4    EMF1     0        0        0     2       2       0       0      3
    ## 5     LFY    16       11        5    11       6       3       2      8
    ## 6     LUG     0        0        0     0       0       0       0      1
    ## 7      PI    13       10        3    10       1       5       4      7
    ## 8     SUP     0        0        0     1       1       0       0      2
    ## 9    TFL1    11        9        2     4       2       1       1      4
    ## 10    UFO     0        0        0     1       1       0       0      2
    ##    In_Degree Out_Degree  Closeness Betweenness Stress Eigenvector
    ## 1          4          1 0.01960784         4.5      6   0.1542383
    ## 2          3          2 0.02083333         8.0     10   0.3780549
    ## 3          5          2 0.02083333         6.5      9   0.2171642
    ## 4          0          3 0.02564103         0.0      0   0.2867426
    ## 5          3          5 0.02222222        11.5     15   0.5952191
    ## 6          0          1 0.02272727         0.0      0   0.1542383
    ## 7          5          2 0.02083333         4.5      7   0.3314349
    ## 8          0          2 0.02380952         0.0      0   0.1515242
    ## 9          2          2 0.02083333         5.0      7   0.3780549
    ## 10         0          2 0.02439024         0.0      0   0.2238167
    ## 
    ## $edges
    ##           EdgeID NuFBL NuPosFBL NuNegFBL NuFFL NuFFL_AB NuFFL_BC NuFFL_AC
    ## 1   AG (-1) TFL1     8        7        1     1        0        1        0
    ## 2   AP1 (-1) LFY     5        0        5     2        1        0        1
    ## 3     AP1 (1) PI     4        4        0     3        1        1        1
    ## 4     AP3 (1) AG     5        5        0     3        0        3        0
    ## 5    AP3 (1) AP1     6        2        4     1        0        1        0
    ## 6  EMF1 (-1) AP3     0        0        0     2        1        0        1
    ## 7   EMF1 (-1) PI     0        0        0     1        1        0        0
    ## 8    EMF1 (1) AG     0        0        0     1        0        0        1
    ## 9  LFY (-1) TFL1     3        2        1     2        1        0        1
    ## 10    LFY (1) AG     3        2        1     2        1        0        1
    ## 11   LFY (1) AP1     3        2        1     2        1        0        1
    ## 12   LFY (1) AP3     4        3        1     4        2        1        1
    ## 13    LFY (1) PI     3        2        1     4        1        2        1
    ## 14  LUG (-1) AP1     0        0        0     0        0        0        0
    ## 15    PI (1) AP3     7        4        3     4        0        3        1
    ## 16    PI (1) LFY     6        6        0     3        1        2        0
    ## 17   SUP (-1) AG     0        0        0     1        0        0        1
    ## 18  SUP (-1) AP3     0        0        0     1        1        0        0
    ## 19 TFL1 (-1) LFY     5        5        0     2        1        0        1
    ## 20  TFL1 (-1) PI     6        4        2     3        1        1        1
    ## 21   UFO (1) AP3     0        0        0     1        0        0        1
    ## 22    UFO (1) PI     0        0        0     1        1        0        0
    ##    Degree Betweenness
    ## 1       9         9.5
    ## 2      13         8.5
    ## 3      12         4.5
    ## 4      12         4.0
    ## 5      12         7.5
    ## 6      10         2.0
    ## 7      10         2.0
    ## 8       8         2.0
    ## 9      12         4.5
    ## 10     13         4.5
    ## 11     13         3.5
    ## 12     15         3.0
    ## 13     15         1.0
    ## 14      6         6.0
    ## 15     14         4.0
    ## 16     15         5.5
    ## 17      7         3.0
    ## 18      9         3.0
    ## 19     12         6.5
    ## 20     11         3.5
    ## 21      9         3.5
    ## 22      9         2.5
    ## 
    ## $network
    ##    NetworkID NuFBL NuPosFBL NuNegFBL NuFFL NuCoFFL NuInCoFFL
    ## 1 AMRN_RBN_2    18       13        5    18      14         4
    ## 
    ## $transitionNetwork
    ## [1] FALSE
    ## 
    ## $Group_1
    ##          GroupID edgeremoval_t1000_r1_macro edgeremoval_t1000_r1_bitws
    ## 1   AP1 (-1) LFY                 0.00390625                0.002148438
    ## 2     AP1 (1) PI                 0.02148438                0.008463542
    ## 3    EMF1 (1) AG                 0.00000000                0.000000000
    ## 4    AP3 (1) AP1                 0.00000000                0.000000000
    ## 5   EMF1 (-1) PI                 0.00000000                0.000000000
    ## 6    LFY (1) AP1                 0.00000000                0.000000000
    ## 7   TFL1 (-1) PI                 0.00000000                0.000000000
    ## 8    SUP (-1) AG                 0.00000000                0.000000000
    ## 9   SUP (-1) AP3                 0.00000000                0.000000000
    ## 10  LUG (-1) AP1                 0.00000000                0.000000000
    ## 11 EMF1 (-1) AP3                 0.00000000                0.000000000
    ## 12   UFO (1) AP3                 0.00000000                0.000000000
    ## 13    UFO (1) PI                 0.00000000                0.000000000
    ## 14    LFY (1) PI                 0.02929688                0.008203125
    ## 15 TFL1 (-1) LFY                 0.00000000                0.000000000
    ## 16  AG (-1) TFL1                 0.00000000                0.000000000
    ## 17    PI (1) AP3                 0.12500000                0.012500000
    ## 18    PI (1) LFY                 0.76562500                0.208170573
    ## 19    AP3 (1) AG                 0.00000000                0.000000000
    ## 20    LFY (1) AG                 0.50000000                0.100000000
    ## 21 LFY (-1) TFL1                 0.00000000                0.000000000
    ## 22   LFY (1) AP3                 0.00000000                0.000000000
    ## 
    ## attr(,"class")
    ## [1] "list"    "NetInfo"

``` r
output(amrn_rbns)
```

    ## [1] "All output files get created in the working directory:"
    ## [1] "D:/HCStore/Projects/R/RMut/vignettes"

References
==========

1.  Barabasi A-L, Albert R (1999) Emergence of Scaling in Random Networks. Science 286: 509-512. doi: 10.1126/science.286.5439.509

2.  Le D-H, Kwon Y-K (2011) NetDS: A Cytoscape plugin to analyze the robustness of dynamics and feedforward/feedback loop structures of biological networks. Bioinformatics.

3.  Trinh H-C, Le D-H, Kwon Y-K (2014) PANET: A GPU-Based Tool for Fast Parallel Analysis of Robustness Dynamics and Feed-Forward/Feedback Loop Structures in Large-Scale Biological Networks. PLoS ONE 9: e103010.

4.  Koschutzki D, Schwobbermeyer H, Schreiber F (2007) Ranking of network elements based on functional substructures. Journal of Theoretical Biology 248: 471-479.
