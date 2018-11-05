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

Firstly, the *devtools* package must be installed by typing the following commands into the R console:

*&gt; install.packages("devtools")*

More details about the *devtools* package could be found in the website <https://github.com/r-lib/devtools>.

Next, the *RMut* package should be properly installed into the R environment by typing the following commands:

*&gt; install.packages("rJava")*

*&gt; devtools::install\_github("csclab/RMut", INSTALL\_opts="--no-multiarch")*

We note that the new version of *devtools* package uses the keyword *INSTALL\_opts* to specify additional installation options instead of the old keyword *args*. Though all of core algorithms written in Java, the *rJava* package must be installed in the R environment before the *RMut* installation. After installation, the RMut package can be loaded via

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

    ## [1] "Please firstly initialize the Java Virtual Machine by using the function 'initJVM(maxHeapSize)'."

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
-   *cchs*

    The cell cycle pathway of the species Homo sapiens (CCHS) with 161 nodes and 223 links.
-   *ccsn*

    The canonical cell signaling network (CCSN) with 771 nodes and 1633 links.
-   *hsn*

    The large-scale human signaling network (HSN) with 1192 nodes and 3102 links.

All original network files (Tab-separated values text files) could be downloaded in the folder *vignettes/networks* of the RMut website <https://github.com/csclab/RMut>.

WikiPathways network files conversion
-------------------------------------

A user could retrieve pathways in WikiPathways database [https://www.wikipathways.org/index.php/WikiPathways](https://www.wikipathways.org) as a SIF file by wikiPathways plugin [http://apps.cytoscape.org/apps/wikipathways](wikipathways%20plugin) of the Cytoscape software <https://cytoscape.org/>. The version of Cytoscape should be greater than or equal 3.6.1.

Firstly, the pathway could be loaded into Cytoscape by some steps indicated in the Figure 2 and 3.

![Import network from public databases](https://github.com/csclab/RMut/blob/master/vignettes/wikiPath2SIF_1.png)

![Select and import a pathway from WikiPathways database](https://github.com/csclab/RMut/blob/master/vignettes/wikiPath2SIF_2.png)

After that, we select the "Edge Table" tab and detach it for easy modification (Figure 4).

![Select and detach the "Edge Table" tab](https://github.com/csclab/RMut/blob/master/vignettes/wikiPath2SIF_3.png)

There does not exist relationship types in the attribute or column *interaction* (activation, inhibition, or neutral), thus we must update them based on some existing columns as follows:

-   *activation* interaction (value is *1*)

    In case at least one of the corresponding columns *WP.type* or *Source Arrow Shape* has the value "mim-conversion" or "Arrow".

-   *inhibition* interaction (value is *-1*)

    In case at least one of the corresponding columns *WP.type* or *Source Arrow Shape* has the value "mim-inhibition" or "TBar".

-   *neutral* interaction (value is *0*)

    In case both the corresponding columns *WP.type* and *Source Arrow Shape* has the value "Line", or the corresponding column *WP.type* is empty.

For each type of interaction, we select the rows or interactions that satisfy the above conditions, and then modify the values of the column *interaction* as a way like Figure 5.

![Update relationship types in the attribute "interaction"](https://github.com/csclab/RMut/blob/master/vignettes/wikiPath2SIF_4_5.png)

To repeat this step for other types, we deselect edges by clicking in the empty space of the network visualization panel. Finally, we export the pathway to SIF file format by the following menu: *File | Export | Network...* . We might need to remove wrong rows of interactions (missing the interaction type) in the SIF file by a spreadsheet software like Microsoft Excel (Figure 6).

![Remove wrong rows of interactions which have not an interaction type)](https://github.com/csclab/RMut/blob/master/vignettes/wikiPath2SIF_6.png)

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
    ## 1     EMF1               0.0000000              0.00000000
    ## 2      SUP               0.0000000              0.00000000
    ## 3      LFY               0.9062500              0.16064453
    ## 4      AP1               0.9687500              0.13518880
    ## 5       AG               1.0000000              0.12262370
    ## 6      UFO               0.0000000              0.00000000
    ## 7      AP3               0.7617188              0.08886719
    ## 8     TFL1               0.4687500              0.05335286
    ## 9       PI               0.7988281              0.10511068
    ## 10     LUG               0.0000000              0.00000000
    ##    ruleflip_t1000_r2_macro ruleflip_t1000_r2_bitws
    ## 1                0.0000000              0.00000000
    ## 2                0.0000000              0.00000000
    ## 3                0.9062500              0.14690755
    ## 4                0.9687500              0.12900391
    ## 5                1.0000000              0.12177734
    ## 6                0.0000000              0.00000000
    ## 7                0.9707031              0.10488281
    ## 8                0.4687500              0.05458984
    ## 9                0.9707031              0.10488281
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
    ## 1    SUP (-1) PI                 0.01757812                0.003222656
    ## 2  EMF1 (-1) AP1                 0.00000000                0.000000000
    ## 3   SUP (-1) AP3                 0.01562500                0.003710938
    ## 4   TFL1 (-1) AG                 0.01269531                0.003808594
    ## 5     AP3 (1) PI                 0.02539062                0.006152344
    ## 6     UFO (1) PI                 0.01757812                0.003222656
    ## 7    UFO (1) AP3                 0.01562500                0.003710938
    ## 8      PI (1) PI                 0.00390625                0.000390625
    ## 9    AP1 (-1) AG                 0.03125000                0.005794271
    ## 10   LFY (1) AP3                 0.00390625                0.000390625
    ## 11   LUG (-1) AG                 0.09375000                0.010188802
    ## 12   AP1 (1) LFY                 0.46875000                0.075358073
    ## 13    LFY (1) AG                 0.14062500                0.014062500
    ## 14   AP3 (1) AP3                 0.00000000                0.000000000
    ## 15   LFY (1) AP1                 0.42187500                0.074804688
    ## 16   AG (-1) AP1                 0.12500000                0.016178385
    ## 17 EMF1 (1) TFL1                 0.46875000                0.053352865
    ## 18    LFY (1) PI                 0.18164062                0.034375000
    ## 19 TFL1 (-1) LFY                 0.12500000                0.015755208
    ## 20    PI (1) AP3                 0.18945312                0.026269531
    ## 21 EMF1 (-1) LFY                 0.00000000                0.000000000
    ## 22 LFY (-1) TFL1                 0.00000000                0.000000000

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
    ## 1    LUG (-1) TFL1                  0.25000000                 0.038085938
    ## 2     LFY (-1) AP1                  0.21875000                 0.029720052
    ## 3    EMF1 (1) EMF1                  1.00000000                 0.129720052
    ## 4      AG (1) TFL1                  0.50000000                 0.079720052
    ## 5      LFY (1) LFY                  0.78125000                 0.082812500
    ## 6      PI (-1) SUP                  0.55273438                 0.074023438
    ## 7     EMF1 (-1) AG                  0.50000000                 0.050000000
    ## 8        AG (1) AG                  0.94726562                 0.060514323
    ## 9     AP1 (-1) UFO                  0.59375000                 0.053938802
    ## 10    SUP (-1) LUG                  0.50000000                 0.060904948
    ## 11    AP1 (-1) LFY                  0.96875000                 0.212923177
    ## 12    EMF1 (1) SUP                  0.50000000                 0.055566406
    ## 13    PI (-1) EMF1                  0.61914062                 0.116731771
    ## 14     SUP (1) AP1                  0.10937500                 0.015397135
    ## 15    AG (-1) EMF1                  0.62500000                 0.116048177
    ## 16   LFY (-1) EMF1                  0.46875000                 0.116048177
    ## 17    UFO (-1) SUP                  0.50000000                 0.051953125
    ## 18    TFL1 (1) LFY                  0.21875000                 0.029720052
    ## 19    TFL1 (-1) PI                  1.00000000                 0.472753906
    ## 20     SUP (1) LUG                  0.50000000                 0.060904948
    ## 21    AG (-1) TFL1                  0.00000000                 0.000000000
    ## 22     AP1 (1) LUG                  0.59375000                 0.062890625
    ## 23     AG (-1) UFO                  0.56250000                 0.072493490
    ## 24      PI (1) UFO                  0.53515625                 0.073339844
    ## 25     SUP (1) AP3                  0.98730469                 0.353027344
    ## 26      PI (-1) PI                  1.00000000                 0.472753906
    ## 27   EMF1 (-1) SUP                  0.50000000                 0.055566406
    ## 28    SUP (-1) LFY                  0.10937500                 0.015397135
    ## 29    AP3 (-1) AP1                  0.08007812                 0.011197917
    ## 30      AP1 (1) PI                  1.00000000                 0.449316406
    ## 31    EMF1 (1) LFY                  0.21875000                 0.029720052
    ## 32    PI (-1) TFL1                  0.50000000                 0.050000000
    ## 33  TFL1 (-1) EMF1                  0.62500000                 0.082291667
    ## 34    LFY (-1) UFO                  0.59375000                 0.063281250
    ## 35    UFO (-1) AP3                  0.98730469                 0.353027344
    ## 36     UFO (1) LFY                  0.48437500                 0.097395833
    ## 37     LFY (1) UFO                  0.59375000                 0.060286458
    ## 38     SUP (1) SUP                  1.00000000                 0.056770833
    ## 39     AP1 (1) AP3                  0.98730469                 0.353027344
    ## 40    AP3 (-1) LUG                  0.50585938                 0.062500000
    ## 41    LFY (-1) LUG                  0.59375000                 0.062988281
    ## 42    AP1 (-1) LUG                  0.59375000                 0.062988281
    ## 43     AP3 (-1) PI                  1.00000000                 0.472753906
    ## 44     PI (-1) LFY                  0.22460938                 0.044303385
    ## 45     LFY (-1) AG                  0.00000000                 0.000000000
    ## 46      AG (1) AP1                  0.92187500                 0.124804687
    ## 47      PI (1) LUG                  0.51757812                 0.062337240
    ## 48    LUG (-1) LUG                  0.00000000                 0.000000000
    ## 49      AP1 (1) AG                  0.00000000                 0.000000000
    ## 50   UFO (-1) TFL1                  0.25000000                 0.025000000
    ## 51    TFL1 (1) AP1                  0.68750000                 0.071875000
    ## 52    AP1 (-1) AP3                  0.98730469                 0.353027344
    ## 53     AP3 (1) LUG                  0.51757812                 0.062337240
    ## 54   TFL1 (1) EMF1                  0.62500000                 0.082291667
    ## 55   TFL1 (-1) AP1                  0.46875000                 0.083626302
    ## 56     UFO (1) AP1                  0.10937500                 0.014322917
    ## 57    SUP (-1) UFO                  0.50000000                 0.055566406
    ## 58     LUG (-1) PI                  1.00000000                 0.472753906
    ## 59    AP1 (-1) SUP                  0.59375000                 0.059505208
    ## 60    EMF1 (1) LUG                  0.50000000                 0.061165365
    ## 61     AP1 (1) SUP                  0.59375000                 0.059505208
    ## 62      AG (1) SUP                  0.56250000                 0.072623698
    ## 63      AP3 (1) AG                  0.09375000                 0.011360677
    ## 64    LUG (-1) AP3                  0.98730469                 0.353027344
    ## 65     EMF1 (1) PI                  1.00000000                 0.472753906
    ## 66     AG (-1) SUP                  0.56250000                 0.072623698
    ## 67     PI (-1) AP3                  0.98730469                 0.353027344
    ## 68     AP3 (1) AP1                  0.20703125                 0.031770833
    ## 69      LUG (1) PI                  1.00000000                 0.472753906
    ## 70    UFO (1) EMF1                  0.50000000                 0.114322917
    ## 71     AG (-1) AP3                  0.98730469                 0.353027344
    ## 72    AP3 (-1) SUP                  0.53906250                 0.070605469
    ## 73     LFY (-1) PI                  1.00000000                 0.472753906
    ## 74   AP1 (-1) EMF1                  0.46875000                 0.116048177
    ## 75    UFO (-1) LFY                  0.48437500                 0.097395833
    ## 76    AP3 (-1) AP3                  0.98730469                 0.353027344
    ## 77  TFL1 (-1) TFL1                  0.37500000                 0.037500000
    ## 78    EMF1 (1) AP1                  0.50000000                 0.050000000
    ## 79  EMF1 (-1) EMF1                  1.00000000                 0.129720052
    ## 80  EMF1 (-1) TFL1                  0.50000000                 0.050000000
    ## 81   AP1 (-1) TFL1                  0.21875000                 0.029882813
    ## 82    AP1 (1) EMF1                  0.71875000                 0.129720052
    ## 83     PI (-1) LUG                  0.50585938                 0.062500000
    ## 84    SUP (1) EMF1                  0.50000000                 0.115397135
    ## 85     AG (-1) LUG                  0.53125000                 0.058886719
    ## 86   TFL1 (-1) LUG                  0.52539062                 0.061165365
    ## 87   AP3 (-1) TFL1                  0.09960938                 0.015104167
    ## 88   SUP (-1) TFL1                  0.25000000                 0.025000000
    ## 89   UFO (-1) EMF1                  0.50000000                 0.115397135
    ## 90     AG (1) EMF1                  0.50000000                 0.129720052
    ## 91   TFL1 (-1) UFO                  0.50976562                 0.057031250
    ## 92     LUG (1) LUG                  0.00000000                 0.000000000
    ## 93     AG (-1) LFY                  0.17187500                 0.023046875
    ## 94     LUG (1) UFO                  0.50000000                 0.054003906
    ## 95     UFO (1) SUP                  0.50000000                 0.051953125
    ## 96   TFL1 (1) TFL1                  0.37500000                 0.037500000
    ## 97    AP3 (-1) UFO                  0.53906250                 0.070605469
    ## 98     AP3 (1) LFY                  0.26562500                 0.057177734
    ## 99     AP3 (1) SUP                  0.53710938                 0.069531250
    ## 100    UFO (1) UFO                  0.00000000                 0.000000000
    ## 101    TFL1 (1) PI                  1.00000000                 0.472753906
    ## 102   SUP (1) TFL1                  0.25000000                 0.025000000
    ## 103     AG (1) LUG                  0.53125000                 0.058886719
    ## 104   AP1 (1) TFL1                  0.46875000                 0.069173177
    ## 105     PI (-1) AG                  0.99609375                 0.120670573
    ## 106   AP3 (-1) LFY                  0.07812500                 0.010611979
    ## 107      PI (1) AG                  0.99609375                 0.120670573
    ## 108   LFY (1) EMF1                  0.46875000                 0.116048177
    ## 109  TFL1 (-1) SUP                  0.50976562                 0.057031250
    ## 110  TFL1 (-1) AP3                  0.98730469                 0.353027344
    ## 111    PI (1) EMF1                  0.49609375                 0.127376302
    ## 112   UFO (-1) UFO                  1.00000000                 0.056770833
    ## 113   LUG (-1) AP1                  0.10937500                 0.016634115
    ## 114   LUG (-1) UFO                  0.50000000                 0.053515625
    ## 115  SUP (-1) EMF1                  0.50000000                 0.114322917
    ## 116   LFY (1) TFL1                  0.50000000                 0.050000000
    ## 117   AP1 (-1) AP1                  0.18750000                 0.022298177
    ## 118   TFL1 (1) UFO                  0.51562500                 0.062597656
    ## 119     PI (1) LFY                  0.22460938                 0.044303385
    ## 120  EMF1 (-1) LUG                  0.50000000                 0.061165365
    ## 121   EMF1 (-1) PI                  1.00000000                 0.472753906
    ## 122    PI (-1) AP1                  0.21484375                 0.028157552
    ## 123     SUP (1) AG                  0.50000000                 0.060677083
    ## 124    SUP (1) LFY                  0.10937500                 0.014322917
    ## 125    UFO (-1) AG                  0.50000000                 0.061946615
    ## 126   LUG (1) EMF1                  0.50000000                 0.116634115
    ## 127   UFO (-1) LUG                  0.50000000                 0.060904948
    ## 128     AG (1) LFY                  0.12500000                 0.016048177
    ## 129    LFY (1) SUP                  0.59375000                 0.063281250
    ## 130   LFY (-1) AP3                  0.98730469                 0.353027344
    ## 131   LUG (1) TFL1                  0.25000000                 0.038085938
    ## 132     SUP (1) PI                  1.00000000                 0.472753906
    ## 133   SUP (-1) SUP                  1.00000000                 0.056770833
    ## 134   TFL1 (1) LUG                  0.50000000                 0.060742188
    ## 135    LUG (1) AP3                  0.98730469                 0.353027344
    ## 136  EMF1 (-1) AP3                  0.98730469                 0.353027344
    ## 137    LUG (1) LFY                  0.10937500                 0.013085937
    ## 138    LFY (1) LUG                  0.59375000                 0.062988281
    ## 139    UFO (-1) PI                  1.00000000                 0.472753906
    ## 140  LUG (-1) EMF1                  0.50000000                 0.113085938
    ## 141   SUP (-1) AP1                  0.10937500                 0.014322917
    ## 142   LFY (-1) LFY                  0.06250000                 0.008463542
    ## 143    AP1 (1) UFO                  0.59375000                 0.059505208
    ## 144    SUP (1) UFO                  0.50000000                 0.051953125
    ## 145     AG (-1) PI                  0.99218750                 0.454003906
    ## 146     PI (1) SUP                  0.55273438                 0.074023438
    ## 147   UFO (1) TFL1                  0.25000000                 0.025000000
    ## 148    PI (-1) UFO                  0.53515625                 0.073339844
    ## 149    AP1 (-1) PI                  1.00000000                 0.449316406
    ## 150   AP3 (1) EMF1                  0.49804688                 0.128548177
    ## 151    LUG (1) SUP                  0.50000000                 0.054003906
    ## 152    AP1 (1) AP1                  0.18750000                 0.022298177
    ## 153   LUG (-1) LFY                  0.48437500                 0.119824219
    ## 154     LUG (1) AG                  0.00000000                 0.000000000
    ## 155     UFO (1) AG                  0.04687500                 0.004459635
    ## 156   LFY (-1) SUP                  0.59375000                 0.063281250
    ## 157  AP3 (-1) EMF1                  0.61914062                 0.116731771
    ## 158   EMF1 (1) UFO                  0.50000000                 0.051953125
    ## 159   LUG (-1) SUP                  0.50000000                 0.053515625
    ## 160   TFL1 (1) AP3                  0.98730469                 0.353027344
    ## 161    PI (1) TFL1                  0.00000000                 0.000000000
    ## 162    SUP (-1) AG                  0.50000000                 0.060677083
    ## 163   TFL1 (1) SUP                  0.51562500                 0.062597656
    ## 164   UFO (-1) AP1                  0.10937500                 0.014322917
    ## 165   EMF1 (1) AP3                  0.98730469                 0.353027344
    ## 166     AG (1) UFO                  0.56250000                 0.072623698
    ## 167    AP3 (1) UFO                  0.53710938                 0.069531250
    ## 168     PI (1) AP1                  0.96875000                 0.128938802
    ## 169    EMF1 (1) AG                  0.09375000                 0.010188802
    ## 170    LUG (1) AP1                  0.48437500                 0.065820313
    ## 171    TFL1 (1) AG                  0.00000000                 0.000000000
    ## 172    UFO (1) LUG                  0.50000000                 0.060904948
    ## 173  EMF1 (-1) UFO                  0.50000000                 0.051953125
    ## 174      AG (1) PI                  0.99218750                 0.438509115
    ## 175     AG (-1) AG                  0.94726562                 0.060514323
    ## 176    AP3 (-1) AG                  0.09375000                 0.011360677
    ## 177     AG (1) AP3                  0.98730469                 0.353027344
    ## 178   AP3 (1) TFL1                  0.00000000                 0.000000000

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

*File | Import | Network | File...* or using the shortcut keys *Ctrl/Cmd + L* (*Figure 7(a)*)

![Import network (a) and nodes/edges attributes (b) in Cytoscape software](https://github.com/csclab/RMut/blob/master/vignettes/transition_menu.png)

In next steps, we import two CSV files of nodes/edges attributes via *File | Import | Table | File...* menu (*Figure 7(b)*). For the nodes attributes file, we should select *String* data type for the column *NetworkState* (*Figure 8*). For the edges attributes file, we must select *Edge Table Columns* in the drop-down list beside the text *Import Data as:* (*Figure 9*).

![Nodes attributes importing dialog](https://github.com/csclab/RMut/blob/master/vignettes/transition_menu_attr_node.png)

![Edges attributes importing dialog](https://github.com/csclab/RMut/blob/master/vignettes/transition_menu_attr_edge.png)

After importing, we select *Style* panel and modify the node and edge styles a little to highlight all attractor cycles. For node style, select *Red* color in *Fill Color* property for the nodes that belong to an attractor (*Figure 10(a)*). Regards to edge style, select *Red* color in *Stroke Color* property and change *Width* property to a larger value (optional) for the edges that connect two states of an attractor (*Figure 10(b)*).

![Nodes (a) and edges (b) style modification](https://github.com/csclab/RMut/blob/master/vignettes/style_node_edge.png)

As a result, *Figure 11* shows the modified transition network with clearer indication of attractor cycles.

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

    ## [1] "Number of found FBLs:9"
    ## [1] "Number of found positive FBLs:6"
    ## [1] "Number of found negative FBLs:3"
    ## [1] "Number of found FBLs:5"
    ## [1] "Number of found positive FBLs:2"
    ## [1] "Number of found negative FBLs:3"

``` r
ba_rbns <- findFFLs(ba_rbns)
```

    ## [1] "Number of found FFLs:5"
    ## [1] "Number of found coherent FFLs:4"
    ## [1] "Number of found incoherent FFLs:1"
    ## [1] "Number of found FFLs:5"
    ## [1] "Number of found coherent FFLs:2"
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
    ## 1       0     7        4        3     2       2       0       0      7
    ## 2       1     7        4        3     2       0       1       1      6
    ## 3       2     6        4        2     3       1       1       1      7
    ## 4       3     3        3        0     0       0       0       0      2
    ## 5       4     1        1        0     0       0       0       0      2
    ## 6       5     1        1        0     0       0       0       0      2
    ## 7       6     0        0        0     1       0       0       1      2
    ## 8       7     3        0        3     0       0       0       0      2
    ## 9       8     2        1        1     1       0       1       0      2
    ## 10      9     1        1        0     0       0       0       0      2
    ##    In_Degree Out_Degree  Closeness Betweenness Stress Eigenvector
    ## 1          3          4 0.07142857          33     45   0.6107663
    ## 2          2          4 0.05882353          34     47   0.4102573
    ## 3          4          3 0.05000000          31     41   0.2928724
    ## 4          1          1 0.04761905           7     14   0.3178939
    ## 5          1          1 0.03703704           2      2   0.1524353
    ## 6          1          1 0.03571429           0      0   0.1524353
    ## 7          2          0 0.01111111           0      0   0.0000000
    ## 8          1          1 0.04761905           7     14   0.3178939
    ## 9          1          1 0.04000000           0      0   0.1524353
    ## 10         1          1 0.04545455           0      0   0.3178939
    ## 
    ## $edges
    ##      EdgeID NuFBL NuPosFBL NuNegFBL NuFFL NuFFL_AB NuFFL_BC NuFFL_AC
    ## 1  0 (-1) 8     2        1        1     1        1        0        0
    ## 2   0 (1) 1     2        1        1     1        0        0        1
    ## 3   0 (1) 2     2        1        1     2        1        0        1
    ## 4   0 (1) 9     1        1        0     0        0        0        0
    ## 5  1 (-1) 6     0        0        0     1        0        1        0
    ## 6   1 (1) 3     3        3        0     0        0        0        0
    ## 7   1 (1) 4     1        1        0     0        0        0        0
    ## 8   1 (1) 7     3        0        3     0        0        0        0
    ## 9  2 (-1) 5     1        1        0     0        0        0        0
    ## 10 2 (-1) 6     0        0        0     1        0        0        1
    ## 11  2 (1) 1     5        3        2     2        1        1        0
    ## 12  3 (1) 0     3        3        0     0        0        0        0
    ## 13  4 (1) 2     1        1        0     0        0        0        0
    ## 14 5 (-1) 2     1        1        0     0        0        0        0
    ## 15 7 (-1) 0     3        0        3     0        0        0        0
    ## 16 8 (-1) 2     2        1        1     1        0        1        0
    ## 17  9 (1) 0     1        1        0     0        0        0        0
    ##    Degree Betweenness
    ## 1       9           8
    ## 2      13          16
    ## 3      14          10
    ## 4       9           8
    ## 5       8           3
    ## 6       8          15
    ## 7       8          10
    ## 8       8          15
    ## 9       9           8
    ## 10      9           6
    ## 11     13          26
    ## 12      9          16
    ## 13      9          11
    ## 14      9           9
    ## 15      9          16
    ## 16      9           9
    ## 17      9           9
    ## 
    ## $network
    ##   NetworkID NuFBL NuPosFBL NuNegFBL NuFFL NuCoFFL NuInCoFFL
    ## 1  BA_RBN_1     9        6        3     5       4         1
    ## 
    ## $transitionNetwork
    ## [1] FALSE
    ## 
    ## $Group_1
    ##    GroupID knockout_t1000_r1_macro knockout_t1000_r1_bitws
    ## 1        1             0.000000000             0.000000000
    ## 2        5             1.000000000             0.100000000
    ## 3        8             1.000000000             0.100000000
    ## 4        3             0.000000000             0.000000000
    ## 5        2             0.000000000             0.000000000
    ## 6        4             0.000000000             0.000000000
    ## 7        6             1.000000000             0.100000000
    ## 8        0             0.000000000             0.000000000
    ## 9        7             0.001953125             0.001757813
    ## 10       9             0.000000000             0.000000000
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
    ## 1       0     3        1        2     3       2       0       1      6
    ## 2       1     4        1        3     2       1       1       0      6
    ## 3       2     3        1        2     3       1       2       0      5
    ## 4       3     0        0        0     1       0       0       1      2
    ## 5       4     0        0        0     1       0       0       1      2
    ## 6       5     2        1        1     1       0       1       0      4
    ## 7       6     2        1        1     0       0       0       0      3
    ## 8       7     0        0        0     1       0       0       1      2
    ## 9       8     1        1        0     0       0       0       0      2
    ## 10      9     1        1        0     0       0       0       0      2
    ##    In_Degree Out_Degree  Closeness Betweenness Stress Eigenvector
    ## 1          3          3 0.04761905          28     31   0.2517363
    ## 2          2          4 0.07142857          21     23   0.6370092
    ## 3          1          4 0.06250000          19     19   0.4004477
    ## 4          2          0 0.01111111           0      0   0.0000000
    ## 5          2          0 0.01111111           0      0   0.0000000
    ## 6          2          2 0.04347826          13     13   0.2616514
    ## 7          1          2 0.05000000           5      5   0.4999300
    ## 8          2          0 0.01111111           0      0   0.0000000
    ## 9          1          1 0.03846154           2      4   0.1582508
    ## 10         1          1 0.03225806           0      0   0.1644838
    ## 
    ## $edges
    ##      EdgeID NuFBL NuPosFBL NuNegFBL NuFFL NuFFL_AB NuFFL_BC NuFFL_AC
    ## 1  0 (-1) 3     0        0        0     1        0        0        1
    ## 2   0 (1) 2     3        1        2     2        2        0        0
    ## 3   0 (1) 7     0        0        0     1        0        0        1
    ## 4  1 (-1) 0     1        0        1     1        0        0        1
    ## 5  1 (-1) 4     0        0        0     1        0        1        0
    ## 6  1 (-1) 6     2        1        1     0        0        0        0
    ## 7   1 (1) 5     1        0        1     1        1        0        0
    ## 8  2 (-1) 7     0        0        0     1        0        1        0
    ## 9   2 (1) 1     3        1        2     1        1        0        0
    ## 10  2 (1) 3     0        0        0     1        0        1        0
    ## 11  2 (1) 4     0        0        0     1        0        0        1
    ## 12 5 (-1) 0     1        0        1     1        0        1        0
    ## 13 5 (-1) 9     1        1        0     0        0        0        0
    ## 14  6 (1) 1     1        0        1     0        0        0        0
    ## 15  6 (1) 8     1        1        0     0        0        0        0
    ## 16 8 (-1) 0     1        1        0     0        0        0        0
    ## 17 9 (-1) 5     1        1        0     0        0        0        0
    ##    Degree Betweenness
    ## 1       8           6
    ## 2      11          25
    ## 3       8           6
    ## 4      12           7
    ## 5       8           2
    ## 6       9          11
    ## 7      10          10
    ## 8       7           1
    ## 9      11          21
    ## 10      7           1
    ## 11      7           5
    ## 12     10          16
    ## 13      6           6
    ## 14      9           6
    ## 15      5           8
    ## 16      8          11
    ## 17      6           9
    ## 
    ## $network
    ##   NetworkID NuFBL NuPosFBL NuNegFBL NuFFL NuCoFFL NuInCoFFL
    ## 1  BA_RBN_2     5        2        3     5       2         3
    ## 
    ## $transitionNetwork
    ## [1] FALSE
    ## 
    ## $Group_1
    ##    GroupID knockout_t1000_r1_macro knockout_t1000_r1_bitws
    ## 1        3                0.953125              0.08183594
    ## 2        8                1.000000              0.26175130
    ## 3        1                0.953125              0.17916667
    ## 4        7                0.953125              0.01878255
    ## 5        0                0.953125              0.17916667
    ## 6        4                1.000000              0.08802083
    ## 7        2                0.953125              0.17916667
    ## 8        9                1.000000              0.28030599
    ## 9        5                0.296875              0.08567708
    ## 10       6                1.000000              0.36822917
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

    ## [1] "Number of found FBLs:12"
    ## [1] "Number of found positive FBLs:7"
    ## [1] "Number of found negative FBLs:5"
    ## [1] "Number of found FBLs:14"
    ## [1] "Number of found positive FBLs:7"
    ## [1] "Number of found negative FBLs:7"

``` r
amrn_rbns <- findFFLs(amrn_rbns)
```

    ## [1] "Number of found FFLs:16"
    ## [1] "Number of found coherent FFLs:9"
    ## [1] "Number of found incoherent FFLs:7"
    ## [1] "Number of found FFLs:17"
    ## [1] "Number of found coherent FFLs:7"
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
    ## 1      AG     5        4        1     6       0       1       5      5
    ## 2     AP1     9        4        5     6       1       2       3      5
    ## 3     AP3     6        4        2     7       0       5       2      7
    ## 4    EMF1     0        0        0     4       4       0       0      3
    ## 5     LFY    11        7        4    13       7       4       2      8
    ## 6     LUG     0        0        0     0       0       0       0      1
    ## 7      PI     6        3        3     8       2       2       4      7
    ## 8     SUP     0        0        0     1       1       0       0      2
    ## 9    TFL1     4        3        1     3       1       2       0      4
    ## 10    UFO     0        0        0     0       0       0       0      2
    ##    In_Degree Out_Degree  Closeness Betweenness Stress Eigenvector
    ## 1          4          1 0.01923077         2.5      4   0.1333853
    ## 2          3          2 0.02083333         5.0      6   0.2980483
    ## 3          5          2 0.02040816         8.0     10   0.2260582
    ## 4          0          3 0.02564103         0.0      0   0.5058865
    ## 5          3          5 0.02222222        13.5     15   0.5326012
    ## 6          0          1 0.02222222         0.0      0   0.1011676
    ## 7          5          2 0.02083333        11.0     13   0.3717398
    ## 8          0          2 0.02439024         0.0      0   0.2675320
    ## 9          2          2 0.02040816         2.0      2   0.1608614
    ## 10         0          2 0.02500000         0.0      0   0.2383545
    ## 
    ## $edges
    ##           EdgeID NuFBL NuPosFBL NuNegFBL NuFFL NuFFL_AB NuFFL_BC NuFFL_AC
    ## 1    AG (-1) AP1     5        4        1     1        0        1        0
    ## 2   AP1 (-1) LFY     8        4        4     2        1        1        0
    ## 3     AP1 (1) AG     1        0        1     2        0        1        1
    ## 4     AP3 (1) AG     2        2        0     2        0        2        0
    ## 5     AP3 (1) PI     4        2        2     3        0        3        0
    ## 6  EMF1 (-1) LFY     0        0        0     3        2        0        1
    ## 7   EMF1 (-1) PI     0        0        0     2        1        0        1
    ## 8   EMF1 (1) AP3     0        0        0     2        1        0        1
    ## 9  LFY (-1) TFL1     4        3        1     2        2        0        0
    ## 10    LFY (1) AG     1        1        0     3        1        1        1
    ## 11   LFY (1) AP1     1        0        1     3        1        1        1
    ## 12   LFY (1) AP3     3        2        1     4        2        1        1
    ## 13    LFY (1) PI     2        1        1     3        1        1        1
    ## 14  LUG (-1) AP3     0        0        0     0        0        0        0
    ## 15    PI (1) AP1     3        0        3     3        1        1        1
    ## 16    PI (1) LFY     3        3        0     3        1        1        1
    ## 17  SUP (-1) AP3     0        0        0     1        1        0        0
    ## 18   SUP (-1) PI     0        0        0     1        0        0        1
    ## 19  TFL1 (-1) AG     1        1        0     2        0        1        1
    ## 20 TFL1 (-1) AP3     3        2        1     2        1        1        0
    ## 21    UFO (1) PI     0        0        0     0        0        0        0
    ## 22  UFO (1) TFL1     0        0        0     0        0        0        0
    ##    Degree Betweenness
    ## 1      10         7.5
    ## 2      13         8.5
    ## 3      10         1.5
    ## 4      12         4.5
    ## 5      14         8.5
    ## 6      11         3.0
    ## 7      10         1.5
    ## 8      10         1.5
    ## 9      12         8.0
    ## 10     13         2.0
    ## 11     13         1.5
    ## 12     15         4.0
    ## 13     15         3.0
    ## 14      8         6.0
    ## 15     12         5.0
    ## 16     15        11.0
    ## 17      9         2.0
    ## 18      9         4.0
    ## 19      9         3.5
    ## 20     11         3.5
    ## 21      9         3.0
    ## 22      6         3.0
    ## 
    ## $network
    ##    NetworkID NuFBL NuPosFBL NuNegFBL NuFFL NuCoFFL NuInCoFFL
    ## 1 AMRN_RBN_1    12        7        5    16       9         7
    ## 
    ## $transitionNetwork
    ## [1] FALSE
    ## 
    ## $Group_1
    ##          GroupID edgeremoval_t1000_r1_macro edgeremoval_t1000_r1_bitws
    ## 1     PI (1) AP1                   0.000000                 0.00000000
    ## 2     UFO (1) PI                   0.000000                 0.00000000
    ## 3  EMF1 (-1) LFY                   0.000000                 0.00000000
    ## 4    LFY (1) AP3                   0.062500                 0.00625000
    ## 5     LFY (1) PI                   0.000000                 0.00000000
    ## 6    LFY (1) AP1                   0.000000                 0.00000000
    ## 7   AP1 (-1) LFY                   0.000000                 0.00000000
    ## 8     AP3 (1) PI                   0.109375                 0.01386719
    ## 9  LFY (-1) TFL1                   0.000000                 0.00000000
    ## 10  SUP (-1) AP3                   0.000000                 0.00000000
    ## 11  TFL1 (-1) AG                   0.000000                 0.00000000
    ## 12    AP3 (1) AG                   0.000000                 0.00000000
    ## 13  EMF1 (-1) PI                   0.000000                 0.00000000
    ## 14  EMF1 (1) AP3                   0.000000                 0.00000000
    ## 15  UFO (1) TFL1                   0.500000                 0.05000000
    ## 16   AG (-1) AP1                   0.000000                 0.00000000
    ## 17    LFY (1) AG                   0.000000                 0.00000000
    ## 18    PI (1) LFY                   0.500000                 0.07500000
    ## 19   SUP (-1) PI                   0.000000                 0.00000000
    ## 20 TFL1 (-1) AP3                   0.000000                 0.00000000
    ## 21    AP1 (1) AG                   0.000000                 0.00000000
    ## 22  LUG (-1) AP3                   0.000000                 0.00000000
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
    ## 1      AG     5        2        3     4       0       1       3      5
    ## 2     AP1     4        2        2     5       0       4       1      5
    ## 3     AP3    12        6        6     9       2       2       5      7
    ## 4    EMF1     0        0        0     4       4       0       0      3
    ## 5     LFY    12        7        5    13       7       4       2      8
    ## 6     LUG     0        0        0     0       0       0       0      1
    ## 7      PI     9        4        5     6       0       3       3      7
    ## 8     SUP     0        0        0     1       1       0       0      2
    ## 9    TFL1     8        3        5     5       1       2       2      4
    ## 10    UFO     0        0        0     1       1       0       0      2
    ##    In_Degree Out_Degree  Closeness Betweenness Stress Eigenvector
    ## 1          4          1 0.01886792         2.0      2  0.09294331
    ## 2          3          2 0.02083333         3.5      4  0.21093770
    ## 3          5          2 0.02083333        16.5     17  0.38578631
    ## 4          0          3 0.02564103         0.0      0  0.50229317
    ## 5          3          5 0.02222222        10.5     13  0.54324582
    ## 6          0          1 0.02222222         0.0      0  0.09294331
    ## 7          5          2 0.02040816        11.0     12  0.21093770
    ## 8          0          2 0.02380952         0.0      0  0.13389596
    ## 9          2          2 0.02083333         0.5      1  0.33230812
    ## 10         0          2 0.02439024         0.0      0  0.26292836
    ## 
    ## $edges
    ##           EdgeID NuFBL NuPosFBL NuNegFBL NuFFL NuFFL_AB NuFFL_BC NuFFL_AC
    ## 1     AG (-1) PI     5        2        3     1        0        1        0
    ## 2    AP1 (-1) AG     2        1        1     2        0        2        0
    ## 3    AP1 (1) AP3     2        1        1     2        0        2        0
    ## 4    AP3 (1) LFY     6        5        1     3        1        1        1
    ## 5   AP3 (1) TFL1     6        1        5     3        1        1        1
    ## 6  EMF1 (-1) AP1     0        0        0     2        1        0        1
    ## 7  EMF1 (-1) LFY     0        0        0     3        2        0        1
    ## 8   EMF1 (1) AP3     0        0        0     2        1        0        1
    ## 9  LFY (-1) TFL1     2        2        0     3        1        1        1
    ## 10    LFY (1) AG     2        1        1     2        1        0        1
    ## 11   LFY (1) AP1     4        2        2     3        2        1        0
    ## 12   LFY (1) AP3     2        1        1     3        1        1        1
    ## 13    LFY (1) PI     2        1        1     4        2        1        1
    ## 14   LUG (-1) PI     0        0        0     0        0        0        0
    ## 15     PI (1) AG     1        0        1     1        0        1        0
    ## 16    PI (1) AP3     8        4        4     2        0        2        0
    ## 17   SUP (-1) AG     0        0        0     1        0        0        1
    ## 18  SUP (-1) AP1     0        0        0     1        1        0        0
    ## 19 TFL1 (-1) LFY     6        2        4     2        1        1        0
    ## 20  TFL1 (-1) PI     2        1        1     2        0        1        1
    ## 21   UFO (1) AP3     0        0        0     1        0        0        1
    ## 22    UFO (1) PI     0        0        0     1        1        0        0
    ##    Degree Betweenness
    ## 1      12         7.0
    ## 2      10         2.5
    ## 3      12         6.0
    ## 4      15        13.5
    ## 5      11         8.0
    ## 6       8         1.5
    ## 7      11         3.0
    ## 8      10         1.5
    ## 9      12         1.5
    ## 10     13         3.0
    ## 11     13         7.0
    ## 12     15         1.5
    ## 13     15         2.5
    ## 14      8         6.0
    ## 15     12         3.5
    ## 16     14        12.5
    ## 17      7         2.0
    ## 18      7         4.0
    ## 19     12         3.0
    ## 20     11         2.5
    ## 21      9         4.0
    ## 22      9         2.0
    ## 
    ## $network
    ##    NetworkID NuFBL NuPosFBL NuNegFBL NuFFL NuCoFFL NuInCoFFL
    ## 1 AMRN_RBN_2    14        7        7    17       7        10
    ## 
    ## $transitionNetwork
    ## [1] FALSE
    ## 
    ## $Group_1
    ##          GroupID edgeremoval_t1000_r1_macro edgeremoval_t1000_r1_bitws
    ## 1   AP3 (1) TFL1                1.000000000               0.1000000000
    ## 2  EMF1 (-1) AP1                0.250000000               0.0500000000
    ## 3   EMF1 (1) AP3                0.001953125               0.0005859375
    ## 4  LFY (-1) TFL1                0.000000000               0.0000000000
    ## 5    LFY (1) AP3                0.000000000               0.0000000000
    ## 6   SUP (-1) AP1                0.250000000               0.0250000000
    ## 7  EMF1 (-1) LFY                0.001953125               0.0009765625
    ## 8  TFL1 (-1) LFY                0.000000000               0.0000000000
    ## 9     UFO (1) PI                0.000000000               0.0000000000
    ## 10   UFO (1) AP3                0.000000000               0.0000000000
    ## 11   LUG (-1) PI                0.000000000               0.0000000000
    ## 12    PI (1) AP3                0.000000000               0.0000000000
    ## 13   AP1 (1) AP3                0.000000000               0.0000000000
    ## 14    LFY (1) PI                0.500000000               0.0750000000
    ## 15   AP3 (1) LFY                0.500000000               0.1000000000
    ## 16     PI (1) AG                0.000000000               0.0000000000
    ## 17   AP1 (-1) AG                0.250000000               0.0250000000
    ## 18   LFY (1) AP1                0.000000000               0.0000000000
    ## 19  TFL1 (-1) PI                0.000000000               0.0000000000
    ## 20    LFY (1) AG                0.000000000               0.0000000000
    ## 21   SUP (-1) AG                0.250000000               0.0250000000
    ## 22    AG (-1) PI                0.000000000               0.0000000000
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
