Setup guide
===========

To run and utilize all functions of *RMut* package, three following installations should be conducted in sequence:

Java SE Development Kit
-----------------------

Core algorithms of *RMut* package were written in Java, thus a Java SE Development Kit (JDK) is required to run the package. The JDK is available at:

<http://www.oracle.com/technetwork/java/javase/downloads/index.html>.

Two following kinds of JDK can be used alternatively:

-   Old series

    Java SE 8u201 / Java SE 8u202 or higher version

-   New series

    Java SE 11.0.2(LTS) or higher version

RMut package
------------

Firstly, the *devtools* package must be installed by typing the following commands into the R console:

*&gt; install.packages("devtools")*

More details about the *devtools* package could be found in the website <https://github.com/r-lib/devtools>.

Make sure you have Java Development Kit installed and correctly registered in R. If in doubt, run the command *R CMD javareconf* as root or administrator permission.

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

    <https://www.nvidia.com/Download/index.aspx?lang=en-us>

-   AMD graphics cards

    The OpenCL GPU runtime library is included in the drivers of your AMD cards. The drivers could be in the driver CD or available at

    <https://www.amd.com/en/support>

-   CPU devices only (No graphics cards)

    At the time of developing this R package, CPU devices from AMD are no longer supported as OpenCL device. For Intel CPU devices, the OpenCL runtime library is available at:

    <https://software.intel.com/en-us/articles/opencl-drivers>

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

A user could retrieve pathways in WikiPathways database [(https://www.wikipathways.org)](https://www.wikipathways.org/index.php/WikiPathways) as a SIF file by the [wikiPathways plugin](http://apps.cytoscape.org/apps/wikipathways) of the [Cytoscape software](https://cytoscape.org/). The version of Cytoscape should be greater than or equal 3.6.1.

Firstly, the pathway could be loaded into Cytoscape by some steps indicated in the Figure 1 and 2.

![Import network from public databases](https://github.com/csclab/RMut/blob/master/vignettes/wikiPath2SIF_1.png)

![Select and import a pathway from WikiPathways database](https://github.com/csclab/RMut/blob/master/vignettes/wikiPath2SIF_2.png)

After that, we select the "Edge Table" tab and detach it for easy modification (Figure 3).

![Select and detach the "Edge Table" tab](https://github.com/csclab/RMut/blob/master/vignettes/wikiPath2SIF_3.png)

There does not exist relationship types in the attribute or column *interaction* (activation, inhibition, or neutral), thus we must update them based on some existing columns as follows:

-   *activation* interaction (value is *1*)

    In case at least one of the corresponding columns *WP.type* or *Source Arrow Shape* has the value "mim-conversion" or "Arrow".

-   *inhibition* interaction (value is *-1*)

    In case at least one of the corresponding columns *WP.type* or *Source Arrow Shape* has the value "mim-inhibition" or "TBar".

-   *neutral* interaction (value is *0*)

    In case both the corresponding columns *WP.type* and *Source Arrow Shape* has the value "Line", or the corresponding column *WP.type* is empty.

For each type of interaction, we select the rows or interactions that satisfy the above conditions, and then modify the values of the column *interaction* as a way like Figure 4.

![Update relationship types in the attribute "interaction"](https://github.com/csclab/RMut/blob/master/vignettes/wikiPath2SIF_4_5.png)

To repeat this step for other types, we deselect edges by clicking in the empty space of the network visualization panel. Finally, we export the pathway to SIF file format by the following menu: *File | Export | Network...* . We might need to remove wrong rows of interactions (missing the interaction type) in the SIF file by a spreadsheet software like Microsoft Excel (Figure 5).

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
    ## 1     TFL1               0.4687500              0.05335286
    ## 2       PI               0.7988281              0.10511068
    ## 3      SUP               0.0000000              0.00000000
    ## 4     EMF1               0.0000000              0.00000000
    ## 5      LFY               0.9062500              0.16064453
    ## 6      AP1               0.9687500              0.13518880
    ## 7      LUG               0.0000000              0.00000000
    ## 8      UFO               0.0000000              0.00000000
    ## 9      AP3               0.7617188              0.08886719
    ## 10      AG               1.0000000              0.12262370
    ##    ruleflip_t1000_r2_macro ruleflip_t1000_r2_bitws
    ## 1                0.4687500              0.05458984
    ## 2                0.9707031              0.10488281
    ## 3                0.0000000              0.00000000
    ## 4                0.0000000              0.00000000
    ## 5                0.9062500              0.14690755
    ## 6                0.9687500              0.12900391
    ## 7                0.0000000              0.00000000
    ## 8                0.0000000              0.00000000
    ## 9                0.9707031              0.10488281
    ## 10               1.0000000              0.12177734

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
    ## 1     LFY (1) AG                 0.14062500                0.014062500
    ## 2    LFY (1) AP1                 0.42187500                0.074804688
    ## 3     LFY (1) PI                 0.18164062                0.034375000
    ## 4  TFL1 (-1) LFY                 0.12500000                0.015755208
    ## 5     PI (1) AP3                 0.18945312                0.026269531
    ## 6  LFY (-1) TFL1                 0.00000000                0.000000000
    ## 7    SUP (-1) PI                 0.01757812                0.003222656
    ## 8      PI (1) PI                 0.00390625                0.000390625
    ## 9    LUG (-1) AG                 0.09375000                0.010188802
    ## 10  TFL1 (-1) AG                 0.01269531                0.003808594
    ## 11    UFO (1) PI                 0.01757812                0.003222656
    ## 12    AP3 (1) PI                 0.02539062                0.006152344
    ## 13   AP1 (-1) AG                 0.03125000                0.005794271
    ## 14 EMF1 (-1) LFY                 0.00000000                0.000000000
    ## 15   UFO (1) AP3                 0.01562500                0.003710938
    ## 16   AG (-1) AP1                 0.12500000                0.016178385
    ## 17  SUP (-1) AP3                 0.01562500                0.003710938
    ## 18 EMF1 (1) TFL1                 0.46875000                0.053352865
    ## 19   LFY (1) AP3                 0.00390625                0.000390625
    ## 20 EMF1 (-1) AP1                 0.00000000                0.000000000
    ## 21   AP3 (1) AP3                 0.00000000                0.000000000
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
    ## 1     LUG (1) TFL1                  0.25000000                 0.025000000
    ## 2    TFL1 (-1) LUG                  0.52539062                 0.061165365
    ## 3     TFL1 (1) UFO                  0.51562500                 0.062597656
    ## 4     LUG (-1) UFO                  0.50000000                 0.054003906
    ## 5       AG (1) LUG                  0.59375000                 0.073561198
    ## 6       PI (-1) PI                  1.00000000                 0.472753906
    ## 7    UFO (-1) EMF1                  0.50000000                 0.115397135
    ## 8    AP1 (-1) EMF1                  0.46875000                 0.116048177
    ## 9      SUP (1) UFO                  0.50000000                 0.051953125
    ## 10   EMF1 (-1) AP3                  0.98730469                 0.353027344
    ## 11   EMF1 (1) EMF1                  1.00000000                 0.129720052
    ## 12     SUP (1) AP1                  0.10937500                 0.015397135
    ## 13    LFY (1) TFL1                  0.00000000                 0.000000000
    ## 14    TFL1 (1) LFY                  0.84375000                 0.136295573
    ## 15     AP3 (1) UFO                  0.53710938                 0.069531250
    ## 16       AG (1) PI                  0.99218750                 0.438509115
    ## 17     LUG (1) SUP                  0.50000000                 0.054003906
    ## 18     UFO (1) SUP                  0.50000000                 0.055566406
    ## 19     AP3 (-1) AG                  0.09375000                 0.011360677
    ## 20    SUP (-1) AP1                  0.48437500                 0.064322917
    ## 21    LUG (1) EMF1                  0.50000000                 0.116634115
    ## 22      PI (1) LFY                  0.08398438                 0.011458333
    ## 23    TFL1 (1) SUP                  0.50976562                 0.057031250
    ## 24     AG (-1) LFY                  0.20312500                 0.028776042
    ## 25     AG (1) EMF1                  0.62500000                 0.116048177
    ## 26    EMF1 (1) UFO                  0.50000000                 0.055566406
    ## 27    AP1 (-1) SUP                  0.59375000                 0.059505208
    ## 28    AG (-1) TFL1                  0.12109375                 0.021074219
    ## 29    AP3 (-1) SUP                  0.53906250                 0.070605469
    ## 30    EMF1 (1) LFY                  0.21875000                 0.029720052
    ## 31     PI (-1) LFY                  0.96875000                 0.201041667
    ## 32     AG (-1) SUP                  0.56250000                 0.072493490
    ## 33     AP1 (1) UFO                  0.59375000                 0.053938802
    ## 34   AP3 (-1) TFL1                  0.50000000                 0.050000000
    ## 35     AG (1) TFL1                  0.12109375                 0.021074219
    ## 36     AG (-1) LUG                  0.59375000                 0.073561198
    ## 37     SUP (1) AP3                  0.98730469                 0.353027344
    ## 38     PI (-1) SUP                  0.55273438                 0.074023438
    ## 39    SUP (1) TFL1                  0.25000000                 0.025000000
    ## 40    SUP (-1) UFO                  0.50000000                 0.051953125
    ## 41     PI (1) EMF1                  0.61914062                 0.116731771
    ## 42    UFO (-1) LFY                  0.10937500                 0.015397135
    ## 43     LUG (-1) PI                  1.00000000                 0.472753906
    ## 44    AG (-1) EMF1                  0.50000000                 0.129720052
    ## 45   TFL1 (-1) AP1                  0.46875000                 0.083626302
    ## 46   TFL1 (-1) AP3                  0.98730469                 0.353027344
    ## 47    AP3 (1) TFL1                  0.50000000                 0.050000000
    ## 48    AP1 (-1) LUG                  0.59375000                 0.062988281
    ## 49    LFY (-1) LFY                  0.18750000                 0.022298177
    ## 50     AG (-1) UFO                  0.56250000                 0.072493490
    ## 51      AP3 (1) AG                  0.10742188                 0.017805990
    ## 52     LUG (1) LUG                  0.00000000                 0.000000000
    ## 53    AP1 (1) TFL1                  0.50000000                 0.050000000
    ## 54     UFO (1) LUG                  0.50000000                 0.060904948
    ## 55    LUG (-1) SUP                  0.50000000                 0.053515625
    ## 56      PI (-1) AG                  0.09375000                 0.011360677
    ## 57      PI (1) AP1                  0.96875000                 0.128938802
    ## 58    LUG (-1) LUG                  0.00000000                 0.000000000
    ## 59    UFO (-1) UFO                  0.00000000                 0.000000000
    ## 60   EMF1 (-1) UFO                  0.50000000                 0.055566406
    ## 61     AP3 (1) SUP                  0.53710938                 0.069531250
    ## 62    TFL1 (1) AP1                  0.21875000                 0.029720052
    ## 63    AP3 (-1) AP1                  0.21679688                 0.028938802
    ## 64   EMF1 (-1) SUP                  0.50000000                 0.051953125
    ## 65     UFO (-1) AG                  0.04687500                 0.005729167
    ## 66    AP3 (-1) LUG                  0.50585938                 0.062500000
    ## 67     LUG (1) UFO                  0.50000000                 0.054003906
    ## 68      PI (1) UFO                  0.55273438                 0.074023438
    ## 69      AG (1) AP3                  0.98730469                 0.353027344
    ## 70      AG (-1) PI                  0.99218750                 0.438509115
    ## 71      AP1 (1) AG                  0.00000000                 0.000000000
    ## 72    SUP (-1) LUG                  0.50000000                 0.060904948
    ## 73   LFY (-1) EMF1                  0.71875000                 0.129720052
    ## 74    EMF1 (-1) PI                  1.00000000                 0.472753906
    ## 75     LUG (1) AP3                  0.98730469                 0.353027344
    ## 76      UFO (1) AG                  0.50000000                 0.060677083
    ## 77  EMF1 (-1) EMF1                  1.00000000                 0.129720052
    ## 78    EMF1 (1) SUP                  0.50000000                 0.055566406
    ## 79   LUG (-1) TFL1                  0.25000000                 0.025000000
    ## 80     LFY (-1) PI                  1.00000000                 0.472753906
    ## 81     AP3 (1) AP1                  0.21679688                 0.028938802
    ## 82    LFY (1) EMF1                  0.71875000                 0.129720052
    ## 83     LFY (1) SUP                  0.59375000                 0.063281250
    ## 84      LUG (1) AG                  0.50000000                 0.059537760
    ## 85    UFO (-1) SUP                  0.50000000                 0.051953125
    ## 86     SUP (-1) AG                  0.04687500                 0.005729167
    ## 87    EMF1 (1) AP3                  0.98730469                 0.353027344
    ## 88   SUP (-1) TFL1                  0.25000000                 0.025000000
    ## 89    UFO (-1) LUG                  0.50000000                 0.060904948
    ## 90    AP3 (-1) LFY                  0.21679688                 0.028938802
    ## 91    TFL1 (1) AP3                  0.98730469                 0.353027344
    ## 92     TFL1 (1) AG                  0.50000000                 0.072623698
    ## 93     AP3 (1) LUG                  0.50585938                 0.062500000
    ## 94     EMF1 (1) AG                  0.09375000                 0.010188802
    ## 95    LFY (-1) AP3                  0.98730469                 0.353027344
    ## 96     LUG (1) AP1                  0.48437500                 0.069368490
    ## 97      AP1 (1) PI                  1.00000000                 0.449316406
    ## 98     AG (-1) AP3                  0.98730469                 0.353027344
    ## 99  TFL1 (-1) EMF1                  1.00000000                 0.127923177
    ## 100   TFL1 (1) LUG                  0.50000000                 0.060742188
    ## 101    LUG (1) LFY                  0.10937500                 0.013085937
    ## 102    AP1 (1) AP1                  0.78125000                 0.058235677
    ## 103    UFO (1) AP1                  0.10937500                 0.014322917
    ## 104   TFL1 (-1) PI                  1.00000000                 0.472753906
    ## 105     PI (1) SUP                  0.53515625                 0.073339844
    ## 106    LFY (1) UFO                  0.59375000                 0.063281250
    ## 107     AG (1) SUP                  0.56250000                 0.072493490
    ## 108   LUG (-1) AP3                  0.98730469                 0.353027344
    ## 109   LFY (-1) AP1                  0.00000000                 0.000000000
    ## 110   AP3 (-1) UFO                  0.53710938                 0.069531250
    ## 111    AP3 (1) LFY                  0.96875000                 0.195182292
    ## 112    PI (-1) AP3                  0.98730469                 0.353027344
    ## 113   LFY (-1) SUP                  0.59375000                 0.060286458
    ## 114  SUP (-1) EMF1                  0.50000000                 0.114322917
    ## 115  TFL1 (-1) UFO                  0.51562500                 0.062597656
    ## 116   UFO (1) TFL1                  0.25000000                 0.025000000
    ## 117    UFO (1) UFO                  1.00000000                 0.056770833
    ## 118    UFO (-1) PI                  1.00000000                 0.472753906
    ## 119   AP1 (1) EMF1                  0.46875000                 0.116048177
    ## 120      PI (1) AG                  0.09375000                 0.011360677
    ## 121     AG (-1) AG                  0.09375000                 0.010188802
    ## 122   UFO (1) EMF1                  0.50000000                 0.115397135
    ## 123    TFL1 (1) PI                  1.00000000                 0.472753906
    ## 124     AG (1) AP1                  0.31250000                 0.046516927
    ## 125    UFO (1) LFY                  0.10937500                 0.014322917
    ## 126    AP1 (1) SUP                  0.59375000                 0.053938802
    ## 127    PI (-1) LUG                  0.51757812                 0.062337240
    ## 128    AP1 (-1) PI                  1.00000000                 0.449316406
    ## 129    LFY (1) LUG                  0.59375000                 0.062890625
    ## 130   UFO (-1) AP1                  0.48437500                 0.064322917
    ## 131  TFL1 (1) EMF1                  1.00000000                 0.127923177
    ## 132      AG (1) AG                  0.00000000                 0.000000000
    ## 133     AG (1) UFO                  0.56250000                 0.072493490
    ## 134    AP1 (1) AP3                  0.98730469                 0.353027344
    ## 135   SUP (-1) LFY                  0.10937500                 0.014322917
    ## 136    LFY (1) LFY                  0.18750000                 0.022298177
    ## 137   AP3 (1) EMF1                  0.61914062                 0.116731771
    ## 138   AP3 (-1) AP3                  0.98730469                 0.353027344
    ## 139   SUP (-1) SUP                  1.00000000                 0.056770833
    ## 140   EMF1 (-1) AG                  0.50000000                 0.050000000
    ## 141    PI (1) TFL1                  0.00000000                 0.000000000
    ## 142    AP3 (-1) PI                  1.00000000                 0.472753906
    ## 143   LUG (-1) LFY                  0.48437500                 0.119824219
    ## 144   AP1 (-1) AP3                  0.98730469                 0.353027344
    ## 145   AP1 (-1) UFO                  0.59375000                 0.053938802
    ## 146     AG (1) LFY                  0.96875000                 0.170817057
    ## 147  AP1 (-1) TFL1                  0.46875000                 0.069173177
    ## 148    SUP (1) LFY                  0.10937500                 0.015397135
    ## 149     SUP (1) PI                  1.00000000                 0.472753906
    ## 150    LFY (-1) AG                  0.00000000                 0.000000000
    ## 151   LFY (-1) UFO                  0.59375000                 0.063281250
    ## 152  TFL1 (-1) SUP                  0.50976562                 0.057031250
    ## 153    SUP (1) LUG                  0.50000000                 0.061002604
    ## 154   SUP (1) EMF1                  0.50000000                 0.115397135
    ## 155  LUG (-1) EMF1                  0.50000000                 0.113085938
    ## 156   AP1 (-1) AP1                  0.78125000                 0.058235677
    ## 157     SUP (1) AG                  0.04687500                 0.005729167
    ## 158  UFO (-1) TFL1                  0.25000000                 0.025000000
    ## 159    PI (-1) AP1                  0.21484375                 0.028157552
    ## 160     PI (1) LUG                  0.50585938                 0.062500000
    ## 161    EMF1 (1) PI                  1.00000000                 0.472753906
    ## 162    SUP (1) SUP                  0.00000000                 0.000000000
    ## 163   UFO (-1) AP3                  0.98730469                 0.353027344
    ## 164   EMF1 (1) LUG                  0.50000000                 0.061165365
    ## 165    PI (-1) UFO                  0.55273438                 0.074023438
    ## 166   PI (-1) TFL1                  0.50000000                 0.050000000
    ## 167   EMF1 (1) AP1                  0.46875000                 0.085188802
    ## 168   AP1 (-1) LFY                  0.96875000                 0.212923177
    ## 169    AP1 (1) LUG                  0.59375000                 0.062890625
    ## 170   LFY (-1) LUG                  0.59375000                 0.062890625
    ## 171   LUG (-1) AP1                  0.48437500                 0.065820313
    ## 172  EMF1 (-1) LUG                  0.50000000                 0.060742188
    ## 173 EMF1 (-1) TFL1                  0.50000000                 0.050000000
    ## 174  TFL1 (1) TFL1                  0.50000000                 0.041015625
    ## 175 TFL1 (-1) TFL1                  0.50000000                 0.041015625
    ## 176  AP3 (-1) EMF1                  0.61914062                 0.116731771
    ## 177   PI (-1) EMF1                  0.49609375                 0.127376302
    ## 178     LUG (1) PI                  1.00000000                 0.472753906

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

*File | Import | Network | File...* or using the shortcut keys *Ctrl/Cmd + L* (*Figure 6(a)*)

![Import network (a) and nodes/edges attributes (b) in Cytoscape software](https://github.com/csclab/RMut/blob/master/vignettes/transition_menu.png)

In next steps, we import two CSV files of nodes/edges attributes via *File | Import | Table | File...* menu (*Figure 6(b)*). For the nodes attributes file, we should select *String* data type for the column *NetworkState* (*Figure 7*). For the edges attributes file, we must select *Edge Table Columns* in the drop-down list beside the text *Import Data as:* (*Figure 8*).

![Nodes attributes importing dialog](https://github.com/csclab/RMut/blob/master/vignettes/transition_menu_attr_node.png)

![Edges attributes importing dialog](https://github.com/csclab/RMut/blob/master/vignettes/transition_menu_attr_edge.png)

After importing, we select *Style* panel and modify the node and edge styles a little to highlight all attractor cycles. For node style, select *Red* color in *Fill Color* property for the nodes that belong to an attractor (*Figure 9(a)*). Regards to edge style, select *Red* color in *Stroke Color* property and change *Width* property to a larger value (optional) for the edges that connect two states of an attractor (*Figure 9(b)*).

![Nodes (a) and edges (b) style modification](https://github.com/csclab/RMut/blob/master/vignettes/style_node_edge.png)

As a result, *Figure 10* shows the modified transition network with clearer indication of attractor cycles.

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

    ## [1] "Number of found FBLs:5"
    ## [1] "Number of found positive FBLs:2"
    ## [1] "Number of found negative FBLs:3"
    ## [1] "Number of found FBLs:8"
    ## [1] "Number of found positive FBLs:4"
    ## [1] "Number of found negative FBLs:4"

``` r
ba_rbns <- findFFLs(ba_rbns)
```

    ## [1] "Number of found FFLs:2"
    ## [1] "Number of found coherent FFLs:2"
    ## [1] "Number of found incoherent FFLs:0"
    ## [1] "Number of found FFLs:3"
    ## [1] "Number of found coherent FFLs:2"
    ## [1] "Number of found incoherent FFLs:1"

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
    ## 1       0     4        1        3     1       0       0       1     10
    ## 2       1     1        1        0     2       2       0       0      5
    ## 3       2     1        1        0     2       0       2       0      4
    ## 4       3     0        0        0     1       0       0       1      2
    ## 5       4     1        1        0     0       0       0       0      2
    ## 6       5     1        0        1     0       0       0       0      3
    ## 7       6     1        0        1     0       0       0       0      2
    ## 8       7     1        1        0     0       0       0       0      2
    ## 9       8     1        0        1     0       0       0       0      2
    ## 10      9     0        0        0     0       0       0       0      2
    ##    In_Degree Out_Degree  Closeness Betweenness Stress Eigenvector
    ## 1          6          4 0.02173913        27.5     28   0.3944053
    ## 2          1          4 0.07142857         8.5      9   0.4657739
    ## 3          1          3 0.06250000         1.0      1   0.4319677
    ## 4          2          0 0.01111111         0.0      0   0.0000000
    ## 5          1          1 0.02000000         0.0      0   0.3155243
    ## 6          1          2 0.02083333         4.5      5   0.3155243
    ## 7          1          1 0.02000000         0.0      0   0.3155243
    ## 8          1          1 0.04761905         1.5      2   0.2065933
    ## 9          1          1 0.02000000         0.0      0   0.3155243
    ## 10         2          0 0.01111111         0.0      0   0.0000000
    ## 
    ## $edges
    ##      EdgeID NuFBL NuPosFBL NuNegFBL NuFFL NuFFL_AB NuFFL_BC NuFFL_AC
    ## 1  0 (-1) 5     1        0        1     0        0        0        0
    ## 2  0 (-1) 6     1        0        1     0        0        0        0
    ## 3  0 (-1) 8     1        0        1     0        0        0        0
    ## 4   0 (1) 4     1        1        0     0        0        0        0
    ## 5  1 (-1) 9     0        0        0     0        0        0        0
    ## 6   1 (1) 0     0        0        0     1        0        0        1
    ## 7   1 (1) 2     1        1        0     2        2        0        0
    ## 8   1 (1) 3     0        0        0     1        0        0        1
    ## 9   2 (1) 0     0        0        0     1        0        1        0
    ## 10  2 (1) 3     0        0        0     1        0        1        0
    ## 11  2 (1) 7     1        1        0     0        0        0        0
    ## 12  4 (1) 0     1        1        0     0        0        0        0
    ## 13 5 (-1) 9     0        0        0     0        0        0        0
    ## 14  5 (1) 0     1        0        1     0        0        0        0
    ## 15  6 (1) 0     1        0        1     0        0        0        0
    ## 16  7 (1) 1     1        1        0     0        0        0        0
    ## 17  8 (1) 0     1        0        1     0        0        0        0
    ##    Degree Betweenness
    ## 1      13        11.5
    ## 2      12         7.0
    ## 3      12         7.0
    ## 4      12         7.0
    ## 5       7         2.5
    ## 6      15        10.0
    ## 7       9         3.0
    ## 8       7         2.0
    ## 9      14         5.5
    ## 10      6         1.0
    ## 11      6         3.5
    ## 12     12         5.0
    ## 13      5         5.5
    ## 14     13         4.0
    ## 15     12         5.0
    ## 16      7        10.5
    ## 17     12         5.0
    ## 
    ## $network
    ##   NetworkID NuFBL NuPosFBL NuNegFBL NuFFL NuCoFFL NuInCoFFL
    ## 1  BA_RBN_1     5        2        3     2       2         0
    ## 
    ## $transitionNetwork
    ## [1] FALSE
    ## 
    ## $Group_1
    ##    GroupID knockout_t1000_r1_macro knockout_t1000_r1_bitws
    ## 1        0               0.5000000              0.12479492
    ## 2        4               0.5000000              0.01821289
    ## 3        3               0.5000000              0.02563477
    ## 4        7               0.8750000              0.25433594
    ## 5        8               1.0000000              0.08764648
    ## 6        6               1.0000000              0.20013672
    ## 7        1               0.8750000              0.25433594
    ## 8        2               0.8750000              0.25433594
    ## 9        5               1.0000000              0.23144531
    ## 10       9               0.2460938              0.07265625
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
    ## 1       0     5        1        4     1       0       1       0      9
    ## 2       1     5        3        2     1       0       0       1      6
    ## 3       2     4        2        2     2       1       0       1      5
    ## 4       3     2        1        1     1       0       1       0      2
    ## 5       4     1        0        1     0       0       0       0      2
    ## 6       5     1        1        0     0       0       0       0      2
    ## 7       6     1        0        1     0       0       0       0      2
    ## 8       7     0        0        0     1       1       0       0      2
    ## 9       8     2        2        0     0       0       0       0      2
    ## 10      9     1        1        0     0       0       0       0      2
    ##    In_Degree Out_Degree  Closeness Betweenness Stress Eigenvector
    ## 1          5          4 0.04166667        41.5     44   0.5166002
    ## 2          3          3 0.04166667        35.0     38   0.4247917
    ## 3          3          2 0.03703704        29.0     31   0.3073286
    ## 4          1          1 0.03448276         0.0      0   0.2067254
    ## 5          1          1 0.03225806         0.0      0   0.2514041
    ## 6          1          1 0.03225806         0.0      0   0.2514041
    ## 7          1          1 0.03225806         0.0      0   0.2514041
    ## 8          0          2 0.05555556         0.0      0   0.4009660
    ## 9          1          1 0.03030303         2.5      5   0.1495618
    ## 10         1          1 0.03225806         0.0      0   0.2067254
    ## 
    ## $edges
    ##      EdgeID NuFBL NuPosFBL NuNegFBL NuFFL NuFFL_AB NuFFL_BC NuFFL_AC
    ## 1  0 (-1) 2     2        0        2     1        0        1        0
    ## 2  0 (-1) 5     1        1        0     0        0        0        0
    ## 3  0 (-1) 6     1        0        1     0        0        0        0
    ## 4   0 (1) 4     1        0        1     0        0        0        0
    ## 5  1 (-1) 0     2        0        2     0        0        0        0
    ## 6  1 (-1) 8     2        2        0     0        0        0        0
    ## 7  1 (-1) 9     1        1        0     0        0        0        0
    ## 8  2 (-1) 1     2        1        1     1        0        0        1
    ## 9  2 (-1) 3     2        1        1     1        1        0        0
    ## 10  3 (1) 1     2        1        1     1        0        1        0
    ## 11 4 (-1) 0     1        0        1     0        0        0        0
    ## 12 5 (-1) 0     1        1        0     0        0        0        0
    ## 13  6 (1) 0     1        0        1     0        0        0        0
    ## 14 7 (-1) 0     0        0        0     1        1        0        0
    ## 15  7 (1) 2     0        0        0     1        0        0        1
    ## 16  8 (1) 2     2        2        0     0        0        0        0
    ## 17 9 (-1) 1     1        1        0     0        0        0        0
    ##    Degree Betweenness
    ## 1      14        22.5
    ## 2      11         9.0
    ## 3      11         9.0
    ## 4      11         9.0
    ## 5      15        22.5
    ## 6       8        11.5
    ## 7       8         9.0
    ## 8      11        28.0
    ## 9       7         9.0
    ## 10      8         8.0
    ## 11     11         8.0
    ## 12     11         8.0
    ## 13     11         8.0
    ## 14     11         4.0
    ## 15      7         5.0
    ## 16      7        10.5
    ## 17      8         8.0
    ## 
    ## $network
    ##   NetworkID NuFBL NuPosFBL NuNegFBL NuFFL NuCoFFL NuInCoFFL
    ## 1  BA_RBN_2     8        4        4     3       2         1
    ## 
    ## $transitionNetwork
    ## [1] FALSE
    ## 
    ## $Group_1
    ##    GroupID knockout_t1000_r1_macro knockout_t1000_r1_bitws
    ## 1        9               0.8203125              0.28264974
    ## 2        0               0.4101562              0.09314453
    ## 3        7               0.5000000              0.20599609
    ## 4        5               1.0000000              0.20922526
    ## 5        3               0.7998047              0.20055339
    ## 6        8               0.8203125              0.15042318
    ## 7        6               1.0000000              0.16640625
    ## 8        1               0.6435547              0.21324870
    ## 9        2               0.4140625              0.10869141
    ## 10       4               0.4062500              0.01554687
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
    ## [1] "Number of found FBLs:11"
    ## [1] "Number of found positive FBLs:5"
    ## [1] "Number of found negative FBLs:6"

``` r
amrn_rbns <- findFFLs(amrn_rbns)
```

    ## [1] "Number of found FFLs:16"
    ## [1] "Number of found coherent FFLs:11"
    ## [1] "Number of found incoherent FFLs:5"
    ## [1] "Number of found FFLs:18"
    ## [1] "Number of found coherent FFLs:9"
    ## [1] "Number of found incoherent FFLs:9"

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
    ## 1      AG     1        0        1     0       0       0       0      5
    ## 2     AP1     7        3        4     8       1       3       4      5
    ## 3     AP3     7        5        2    10       2       4       4      7
    ## 4    EMF1     0        0        0     1       1       0       0      3
    ## 5     LFY     9        5        4     8       6       2       0      8
    ## 6     LUG     0        0        0     0       0       0       0      1
    ## 7      PI     9        5        4     8       1       2       5      7
    ## 8     SUP     0        0        0     1       1       0       0      2
    ## 9    TFL1     3        2        1     3       1       2       0      4
    ## 10    UFO     0        0        0     0       0       0       0      2
    ##    In_Degree Out_Degree  Closeness Betweenness Stress Eigenvector
    ## 1          4          1 0.02040816   6.8333334      9   0.2425356
    ## 2          3          2 0.02000000   0.8333333      2   0.2425356
    ## 3          5          2 0.02000000   3.5000000      5   0.2425356
    ## 4          0          3 0.02564103   0.0000000      0   0.3429972
    ## 5          3          5 0.02222222  20.1666667     24   0.5855328
    ## 6          0          1 0.02222222   0.0000000      0   0.1004615
    ## 7          5          2 0.02083333  12.1666667     15   0.3429972
    ## 8          0          2 0.02380952   0.0000000      0   0.2425356
    ## 9          2          2 0.02083333   0.5000000      1   0.3429972
    ## 10         0          2 0.02380952   0.0000000      0   0.2425356
    ## 
    ## $edges
    ##           EdgeID NuFBL NuPosFBL NuNegFBL NuFFL NuFFL_AB NuFFL_BC NuFFL_AC
    ## 1    AG (-1) LFY     1        0        1     0        0        0        0
    ## 2    AP1 (-1) PI     4        0        4     3        0        2        1
    ## 3    AP1 (1) AP3     3        3        0     2        1        1        0
    ## 4    AP3 (1) AP1     3        1        2     3        1        1        1
    ## 5     AP3 (1) PI     4        4        0     5        1        3        1
    ## 6   EMF1 (-1) AG     0        0        0     0        0        0        0
    ## 7  EMF1 (-1) AP3     0        0        0     1        0        0        1
    ## 8  EMF1 (1) TFL1     0        0        0     1        1        0        0
    ## 9  LFY (-1) TFL1     3        2        1     1        1        0        0
    ## 10    LFY (1) AG     1        0        1     0        0        0        0
    ## 11   LFY (1) AP1     2        1        1     4        2        1        1
    ## 12   LFY (1) AP3     2        1        1     4        2        1        1
    ## 13    LFY (1) PI     1        1        0     2        1        0        1
    ## 14   LUG (-1) AG     0        0        0     0        0        0        0
    ## 15    PI (1) AP1     2        1        1     3        0        2        1
    ## 16    PI (1) LFY     7        4        3     1        1        0        0
    ## 17  SUP (-1) AP3     0        0        0     1        1        0        0
    ## 18   SUP (-1) PI     0        0        0     1        0        0        1
    ## 19 TFL1 (-1) AP3     2        1        1     3        0        2        1
    ## 20 TFL1 (-1) LFY     1        1        0     1        1        0        0
    ## 21    UFO (1) AG     0        0        0     0        0        0        0
    ## 22    UFO (1) PI     0        0        0     0        0        0        0
    ##    Degree Betweenness
    ## 1      13   11.833333
    ## 2      12    4.000000
    ## 3      12    1.833333
    ## 4      12    3.000000
    ## 5      14    5.500000
    ## 6       8    1.500000
    ## 7      10    3.000000
    ## 8       7    1.500000
    ## 9      12    8.000000
    ## 10     13    6.000000
    ## 11     13    3.500000
    ## 12     15    4.166667
    ## 13     15    3.500000
    ## 14      6    6.000000
    ## 15     12    3.333333
    ## 16     15   13.833333
    ## 17      9    1.500000
    ## 18      9    4.500000
    ## 19     11    2.000000
    ## 20     12    3.500000
    ## 21      7    2.333333
    ## 22      9    3.666667
    ## 
    ## $network
    ##    NetworkID NuFBL NuPosFBL NuNegFBL NuFFL NuCoFFL NuInCoFFL
    ## 1 AMRN_RBN_1    12        7        5    16      11         5
    ## 
    ## $transitionNetwork
    ## [1] FALSE
    ## 
    ## $Group_1
    ##          GroupID edgeremoval_t1000_r1_macro edgeremoval_t1000_r1_bitws
    ## 1  TFL1 (-1) AP3                 0.25000000                0.035117188
    ## 2    LFY (1) AP3                 0.06250000                0.013009208
    ## 3     UFO (1) PI                 0.13085938                0.011445313
    ## 4   EMF1 (-1) AG                 0.08593750                0.010937500
    ## 5  EMF1 (1) TFL1                 0.42968750                0.092812500
    ## 6  LFY (-1) TFL1                 0.34375000                0.043750000
    ## 7   SUP (-1) AP3                 0.25000000                0.022656250
    ## 8    AG (-1) LFY                 0.84375000                0.123964844
    ## 9  EMF1 (-1) AP3                 0.08398438                0.014257812
    ## 10    UFO (1) AG                 0.12500000                0.016015625
    ## 11   AP1 (1) AP3                 0.00000000                0.000000000
    ## 12    PI (1) LFY                 0.13476562                0.019042969
    ## 13   AP1 (-1) PI                 0.07714844                0.011123047
    ## 14   LUG (-1) AG                 0.12500000                0.019667969
    ## 15    AP3 (1) PI                 0.20214844                0.028587705
    ## 16   LFY (1) AP1                 0.10156250                0.021875000
    ## 17    LFY (1) AG                 0.12500000                0.018593750
    ## 18    PI (1) AP1                 0.29882812                0.030131836
    ## 19    LFY (1) PI                 0.06835938                0.013598633
    ## 20   AP3 (1) AP1                 0.04687500                0.008398437
    ## 21   SUP (-1) PI                 0.01269531                0.002148438
    ## 22 TFL1 (-1) LFY                 0.43847656                0.060498047
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
    ## 1      AG     5        3        2     5       0       2       3      5
    ## 2     AP1     9        4        5     3       1       1       1      5
    ## 3     AP3     9        4        5     9       0       3       6      7
    ## 4    EMF1     0        0        0     3       3       0       0      3
    ## 5     LFY     8        4        4    11       7       4       0      8
    ## 6     LUG     0        0        0     0       0       0       0      1
    ## 7      PI     6        3        3    11       2       4       5      7
    ## 8     SUP     0        0        0     1       1       0       0      2
    ## 9    TFL1     3        2        1     2       1       1       0      4
    ## 10    UFO     0        0        0     0       0       0       0      2
    ##    In_Degree Out_Degree  Closeness Betweenness Stress Eigenvector
    ## 1          4          1 0.01886792    1.000000      1   0.1073948
    ## 2          3          2 0.02083333   13.000000     13   0.3552222
    ## 3          5          2 0.02040816   11.333333     13   0.2228961
    ## 4          0          3 0.02564103    0.000000      0   0.4626170
    ## 5          3          5 0.02222222   12.833333     17   0.5781183
    ## 6          0          1 0.02272727    0.000000      0   0.1711516
    ## 7          5          2 0.01960784    3.833333      8   0.1591393
    ## 8          0          2 0.02325581    0.000000      0   0.1840706
    ## 9          2          2 0.02083333    5.000000      7   0.3552222
    ## 10         0          2 0.02439024    0.000000      0   0.2228961
    ## 
    ## $edges
    ##           EdgeID NuFBL NuPosFBL NuNegFBL NuFFL NuFFL_AB NuFFL_BC NuFFL_AC
    ## 1    AG (-1) AP3     5        3        2     2        0        2        0
    ## 2   AP1 (-1) LFY     7        3        4     1        1        0        0
    ## 3     AP1 (1) PI     2        1        1     2        0        1        1
    ## 4     AP3 (1) AG     1        0        1     2        0        2        0
    ## 5    AP3 (1) AP1     8        4        4     1        0        1        0
    ## 6  EMF1 (-1) AP3     0        0        0     1        0        0        1
    ## 7   EMF1 (-1) PI     0        0        0     2        1        0        1
    ## 8   EMF1 (1) LFY     0        0        0     2        2        0        0
    ## 9  LFY (-1) TFL1     3        2        1     1        1        0        0
    ## 10    LFY (1) AG     1        1        0     2        1        0        1
    ## 11   LFY (1) AP1     1        0        1     2        1        0        1
    ## 12   LFY (1) AP3     1        0        1     4        2        1        1
    ## 13    LFY (1) PI     2        1        1     6        2        3        1
    ## 14 LUG (-1) TFL1     0        0        0     0        0        0        0
    ## 15     PI (1) AG     3        2        1     3        1        1        1
    ## 16    PI (1) AP3     3        1        2     5        1        3        1
    ## 17  SUP (-1) AP3     0        0        0     1        0        0        1
    ## 18   SUP (-1) PI     0        0        0     1        1        0        0
    ## 19 TFL1 (-1) LFY     1        1        0     1        1        0        0
    ## 20  TFL1 (-1) PI     2        1        1     2        0        1        1
    ## 21    UFO (1) AG     0        0        0     0        0        0        0
    ## 22   UFO (1) AP1     0        0        0     0        0        0        0
    ##    Degree Betweenness
    ## 1      12    6.000000
    ## 2      13   13.000000
    ## 3      12    5.000000
    ## 4      12    1.833333
    ## 5      12   14.500000
    ## 6      10    1.833333
    ## 7      10    1.333333
    ## 8      11    2.833333
    ## 9      12    8.000000
    ## 10     13    2.833333
    ## 11     13    3.500000
    ## 12     15    2.500000
    ## 13     15    1.000000
    ## 14      5    6.000000
    ## 15     12    3.333333
    ## 16     14    5.500000
    ## 17      9    4.500000
    ## 18      9    1.500000
    ## 19     12    6.000000
    ## 20     11    4.000000
    ## 21      7    2.000000
    ## 22      7    4.000000
    ## 
    ## $network
    ##    NetworkID NuFBL NuPosFBL NuNegFBL NuFFL NuCoFFL NuInCoFFL
    ## 1 AMRN_RBN_2    11        5        6    18       9         9
    ## 
    ## $transitionNetwork
    ## [1] FALSE
    ## 
    ## $Group_1
    ##          GroupID edgeremoval_t1000_r1_macro edgeremoval_t1000_r1_bitws
    ## 1    LFY (1) AP1                0.088867188                0.013481213
    ## 2    AG (-1) AP3                0.010742188                0.001953125
    ## 3   TFL1 (-1) PI                0.000000000                0.000000000
    ## 4    SUP (-1) PI                0.000000000                0.000000000
    ## 5    LFY (1) AP3                0.433593750                0.045755208
    ## 6   EMF1 (-1) PI                0.074218750                0.005403646
    ## 7     AP3 (1) AG                0.010742188                0.002571615
    ## 8  EMF1 (-1) AP3                0.000000000                0.000000000
    ## 9  LUG (-1) TFL1                0.481445312                0.067968750
    ## 10    LFY (1) PI                0.000000000                0.000000000
    ## 11  AP1 (-1) LFY                0.153320312                0.024251302
    ## 12     PI (1) AG                0.062500000                0.003841146
    ## 13    LFY (1) AG                0.011718750                0.001888021
    ## 14    UFO (1) AG                0.008789062                0.002343750
    ## 15    PI (1) AP3                0.190429688                0.024609375
    ## 16  SUP (-1) AP3                0.190429688                0.021712240
    ## 17 LFY (-1) TFL1                0.124023438                0.017903646
    ## 18   AP3 (1) AP1                0.170898438                0.021621094
    ## 19   UFO (1) AP1                0.098632812                0.013867187
    ## 20  EMF1 (1) LFY                0.373046875                0.052441406
    ## 21    AP1 (1) PI                0.000000000                0.000000000
    ## 22 TFL1 (-1) LFY                0.247070312                0.043033854
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
