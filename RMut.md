Setup guide
===========

To run and utilize all functions of package, three following installations should be conducted in sequence:

Java SE Development Kit
-----------------------

Core algorithms of package were written in Java, thus a Java SE Development Kit (JDK) is required to run the package. The JDK is available at:

<http://www.oracle.com/technetwork/java/javase/downloads/index.html>.

The version of JDK should be greater than or equal to 8.

RMut package
------------

The package should be properly installed into the R environment by typing the following command into the R console:

*&gt; install.packages("RMut")*

Though all of core algorithms written in Java, the package must be additionally installed in the R environment as well. Normally, the dependent package would be also installed by the above command. Otherwise, we should install it manually in a similar way to RMut. After installation, the RMut package can be loaded via

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

    ![AMD APP SDK installation guide](amd_sdk.tif)

After installation, OpenCL information can be outputed via the function . Then we can enable OpenCL computation on a CPU/GPU device via the function :

The above functions show installed OpenCL platforms with their corresponding CPU/GPU devices, and try to select an graphics card for OpenCL computing.

Loading networks
================

Networks can be loaded in two ways using RMut:

 function
---------

The function creates a network from a Tab-separated values text file. The file format contains three columns:

-    and : are gene/protein identifiers that are used to define nodes
-   : labels the edges connecting each pair of nodes

The function returned a network object which contains:

-   The network name
-   Three data frames used for storing attributes of the nodes/edges and the network itself, respectively

Here is an example:

Finally, the loaded network object has five components:

-   : a string variable represents the network identifier, *AMRN.sif* in this case.
-   : a data frame which initially contains one column for node identifiers.

    In this example network, there exists 10 nodes. Additional columns for other node-based attributes would be inserted later.

-   : a data frame which initially contains one column for edge identifiers.

    In this example, there exists 22 edges. Additional columns for other edge-based attributes would be inserted later.

-   : a data frame which initially contains one column for the network identifier ( in this case).

    Additional columns for other network-based attributes would be inserted later, such as total number of feedback/feed-forward loops.

-   : a Boolean variable denotes whether the network is a transition network or not, in this case the value is .

    The function returns a transition network object in which the variable has a value . For all other cases, the variable has a value .

 function
---------

In addition, the package provides some example networks that could be simply loaded by command. For ex.,

``` r
library(RMut)
```

    ## Loading required package: rJava

    ## Warning: package 'rJava' was built under R version 3.3.2

``` r
data(amrn)
```

The package supplied four example datasets from small-scale to large-scale real biological networks:

-   

    The Arabidopsis morphogenesis regulatory network (AMRN) with 10 nodes and 22 links.
-   

    The cell differentiation regulatory network (CDRN) with 9 nodes and 15 links.
-   

    The canonical cell signaling network (CCSN) with 771 nodes and 1633 links.
-   

    The large-scale human signaling network (HSN) with 1192 nodes and 3102 links.

Dynamics analyses
=================

The package utilizes a Boolean network model with synchronous updating scheme, and provides two types of useful analyses of Boolean dynamics in real biological networks or random networks:

Sensitivity analyses
--------------------

Via function, this package computes nodal/edgetic sensitivity against many types of mutations in terms of Boolean dynamics. We classified ten well-known mutations into two types (refer to RMut paper for more details):

-    mutations: state-flip, rule-flip, outcome-shuffle, knockout and overexpression

-    mutations: edge-removal, edge-attenuation, edge-addition, edge-sign-switch, and edge-reverse

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
    ## 1       AG         1.0000000         1.0000000
    ## 2      UFO         0.0000000         0.0000000
    ## 3     EMF1         0.0000000         0.0000000
    ## 4     TFL1         0.4687500         0.4687500
    ## 5      SUP         0.0000000         0.0000000
    ## 6       PI         0.7988281         0.9707031
    ## 7      AP1         0.9687500         0.9687500
    ## 8      LUG         0.0000000         0.0000000
    ## 9      AP3         0.7617188         0.9707031
    ## 10     LFY         0.9062500         0.9062500

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
    ## 1  EMF1 (-1) LFY           0.00000000
    ## 2     PI (1) AP3           0.18945312
    ## 3  EMF1 (-1) AP1           0.00000000
    ## 4     AP3 (1) PI           0.02539062
    ## 5  EMF1 (1) TFL1           0.46875000
    ## 6    AP1 (1) LFY           0.46875000
    ## 7    LUG (-1) AG           0.09375000
    ## 8    AG (-1) AP1           0.12500000
    ## 9   SUP (-1) AP3           0.01562500
    ## 10  TFL1 (-1) AG           0.01269531
    ## 11   LFY (1) AP3           0.00390625
    ## 12 LFY (-1) TFL1           0.00000000
    ## 13    LFY (1) PI           0.18164062
    ## 14   AP1 (-1) AG           0.03125000
    ## 15   AP3 (1) AP3           0.00000000
    ## 16     PI (1) PI           0.00390625
    ## 17   LFY (1) AP1           0.42187500
    ## 18    LFY (1) AG           0.14062500
    ## 19   SUP (-1) PI           0.01757812
    ## 20 TFL1 (-1) LFY           0.12500000
    ## 21   UFO (1) AP3           0.01562500
    ## 22    UFO (1) PI           0.01757812

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
    ## 1      AP3 (1) SUP           0.537109375
    ## 2     EMF1 (-1) AG           0.500000000
    ## 3      LUG (1) LFY           0.484375000
    ## 4       PI (1) UFO           0.552734375
    ## 5     AP3 (-1) AP1           0.080078125
    ## 6     AP3 (-1) LUG           0.505859375
    ## 7     AG (-1) EMF1           0.500000000
    ## 8      AP3 (1) AP1           0.968750000
    ## 9      LUG (1) SUP           0.500000000
    ## 10      AG (1) LFY           0.125000000
    ## 11     UFO (1) LFY           0.484375000
    ## 12    AP1 (-1) SUP           0.593750000
    ## 13    UFO (-1) AP3           0.000000000
    ## 14     LFY (1) LFY           0.531250000
    ## 15    LUG (-1) LUG           1.000000000
    ## 16    AP1 (-1) AP1           0.781250000
    ## 17    TFL1 (1) AP3           0.005859375
    ## 18     UFO (-1) AG           0.046875000
    ## 19     LFY (-1) PI           0.017578125
    ## 20     SUP (1) LUG           0.500000000
    ## 21    SUP (1) EMF1           0.500000000
    ## 22      LUG (1) AG           0.000000000
    ## 23   UFO (-1) TFL1           0.250000000
    ## 24     LUG (1) LUG           0.000000000
    ## 25    UFO (-1) LFY           0.109375000
    ## 26     UFO (1) SUP           0.500000000
    ## 27   AP1 (-1) TFL1           0.000000000
    ## 28    PI (-1) TFL1           0.000000000
    ## 29     PI (-1) LFY           0.214843750
    ## 30     AP1 (-1) PI           0.006835938
    ## 31    LFY (-1) AP3           0.005859375
    ## 32      SUP (1) PI           0.017578125
    ## 33      PI (-1) AG           0.093750000
    ## 34      AG (1) AP1           0.000000000
    ## 35    AP3 (1) EMF1           0.498046875
    ## 36   AP1 (-1) EMF1           0.468750000
    ## 37     LFY (1) LUG           0.593750000
    ## 38  TFL1 (-1) TFL1           0.500000000
    ## 39    TFL1 (1) LUG           0.525390625
    ## 40     EMF1 (1) AG           0.500000000
    ## 41    AP1 (-1) AP3           0.000000000
    ## 42    LFY (1) TFL1           0.500000000
    ## 43       PI (1) AG           0.005859375
    ## 44      PI (1) SUP           0.552734375
    ## 45    LUG (1) EMF1           0.500000000
    ## 46      AG (1) LUG           0.531250000
    ## 47    AP1 (-1) LUG           0.593750000
    ## 48     LFY (1) UFO           0.593750000
    ## 49    TFL1 (1) UFO           0.515625000
    ## 50      PI (-1) PI           0.525390625
    ## 51     AG (-1) LUG           0.593750000
    ## 52    SUP (-1) UFO           0.500000000
    ## 53      PI (1) LUG           0.505859375
    ## 54   LUG (-1) TFL1           0.250000000
    ## 55      SUP (1) AG           0.500000000
    ## 56   UFO (-1) EMF1           0.500000000
    ## 57    UFO (-1) LUG           0.500000000
    ## 58     UFO (1) LUG           0.500000000
    ## 59   TFL1 (1) TFL1           0.375000000
    ## 60    EMF1 (-1) PI           0.500000000
    ## 61    TFL1 (1) AP1           0.218750000
    ## 62     SUP (1) UFO           0.500000000
    ## 63     AP3 (-1) AG           0.005859375
    ## 64     AP1 (1) LUG           0.593750000
    ## 65    EMF1 (1) UFO           0.500000000
    ## 66   TFL1 (-1) AP3           0.525390625
    ## 67   EMF1 (-1) AP3           0.494140625
    ## 68      AG (-1) AG           0.578125000
    ## 69    EMF1 (1) AP1           0.218750000
    ## 70    UFO (1) TFL1           0.250000000
    ## 71     AP3 (1) LUG           0.505859375
    ## 72     PI (1) TFL1           0.500000000
    ## 73   EMF1 (-1) SUP           0.500000000
    ## 74    LFY (1) EMF1           0.718750000
    ## 75     TFL1 (1) PI           0.525390625
    ## 76    SUP (-1) LFY           0.484375000
    ## 77    AG (-1) TFL1           0.500000000
    ## 78    LFY (-1) AP1           0.218750000
    ## 79  EMF1 (-1) EMF1           0.000000000
    ## 80    SUP (-1) AP1           0.109375000
    ## 81    TFL1 (1) SUP           0.509765625
    ## 82  TFL1 (-1) EMF1           1.000000000
    ## 83     PI (-1) UFO           0.535156250
    ## 84   EMF1 (-1) LUG           0.500000000
    ## 85    AP1 (-1) UFO           0.593750000
    ## 86    AP3 (-1) AP3           0.005859375
    ## 87    TFL1 (1) LFY           0.000000000
    ## 88    UFO (1) EMF1           0.500000000
    ## 89      PI (1) AP1           0.214843750
    ## 90      AG (1) UFO           0.562500000
    ## 91    LUG (1) TFL1           0.250000000
    ## 92   AP3 (-1) EMF1           0.498046875
    ## 93     UFO (-1) PI           0.500000000
    ## 94      AP3 (1) AG           0.005859375
    ## 95     AG (1) TFL1           0.000000000
    ## 96      AP1 (1) AG           0.887695312
    ## 97    AP3 (1) TFL1           0.000000000
    ## 98    EMF1 (1) LFY           0.218750000
    ## 99     LUG (1) AP1           0.484375000
    ## 100     UFO (1) AG           0.500000000
    ## 101    LFY (1) SUP           0.593750000
    ## 102      AG (1) PI           0.117187500
    ## 103    LUG (1) AP3           0.002929688
    ## 104    LUG (1) UFO           0.500000000
    ## 105   LUG (-1) LFY           0.109375000
    ## 106    AG (-1) SUP           0.562500000
    ## 107    AG (-1) LFY           0.171875000
    ## 108     AG (1) SUP           0.562500000
    ## 109    AP3 (1) UFO           0.539062500
    ## 110    LFY (-1) AG           0.968750000
    ## 111   AP1 (1) TFL1           0.500000000
    ## 112    UFO (1) AP1           0.484375000
    ## 113   EMF1 (1) SUP           0.500000000
    ## 114     PI (1) LFY           0.968750000
    ## 115   SUP (-1) SUP           1.000000000
    ## 116   LFY (-1) LFY           0.531250000
    ## 117   LUG (-1) AP1           0.484375000
    ## 118  SUP (-1) EMF1           0.500000000
    ## 119  LUG (-1) EMF1           0.500000000
    ## 120    PI (-1) AP3           0.994140625
    ## 121   AP3 (-1) SUP           0.539062500
    ## 122   LFY (-1) SUP           0.593750000
    ## 123  LFY (-1) EMF1           0.718750000
    ## 124    UFO (1) UFO           0.000000000
    ## 125  TFL1 (1) EMF1           1.000000000
    ## 126    AG (-1) AP3           0.117187500
    ## 127   AP1 (-1) LFY           0.968750000
    ## 128    SUP (-1) AG           0.046875000
    ## 129  TFL1 (-1) UFO           0.515625000
    ## 130    AP3 (1) LFY           0.265625000
    ## 131  TFL1 (-1) LUG           0.500000000
    ## 132   LFY (-1) UFO           0.593750000
    ## 133  TFL1 (-1) AP1           0.218750000
    ## 134   UFO (-1) UFO           1.000000000
    ## 135   EMF1 (1) LUG           0.500000000
    ## 136      AG (1) AG           0.947265625
    ## 137    SUP (1) LFY           0.109375000
    ## 138   LFY (-1) LUG           0.593750000
    ## 139   SUP (1) TFL1           0.250000000
    ## 140 EMF1 (-1) TFL1           0.500000000
    ## 141   PI (-1) EMF1           0.619140625
    ## 142   AP1 (1) EMF1           0.718750000
    ## 143    TFL1 (1) AG           0.550781250
    ## 144   UFO (-1) SUP           0.500000000
    ## 145    PI (-1) AP1           0.070312500
    ## 146     AG (-1) PI           0.000000000
    ## 147   LUG (-1) AP3           0.002929688
    ## 148   LUG (-1) UFO           0.500000000
    ## 149   TFL1 (-1) PI           0.023437500
    ## 150  AP3 (-1) TFL1           0.000000000
    ## 151   LUG (-1) SUP           0.500000000
    ## 152  EMF1 (-1) UFO           0.500000000
    ## 153  TFL1 (-1) SUP           0.509765625
    ## 154  SUP (-1) TFL1           0.250000000
    ## 155   UFO (-1) AP1           0.484375000
    ## 156    PI (1) EMF1           0.619140625
    ## 157    AP1 (1) AP1           0.062500000
    ## 158    AG (-1) UFO           0.562500000
    ## 159  EMF1 (1) EMF1           0.000000000
    ## 160   AP3 (-1) UFO           0.537109375
    ## 161   EMF1 (1) AP3           0.005859375
    ## 162    LUG (-1) PI           0.009765625
    ## 163    AP1 (1) AP3           0.212890625
    ## 164    SUP (1) AP3           0.500000000
    ## 165    SUP (1) SUP           0.000000000
    ## 166    AP1 (1) UFO           0.593750000
    ## 167    EMF1 (1) PI           0.494140625
    ## 168     AG (1) AP3           0.000000000
    ## 169     LUG (1) PI           0.497070312
    ## 170    PI (-1) SUP           0.535156250
    ## 171   AP3 (-1) LFY           0.078125000
    ## 172    AP3 (-1) PI           0.003906250
    ## 173    AG (1) EMF1           0.625000000
    ## 174    SUP (1) AP1           0.109375000
    ## 175    AP1 (1) SUP           0.593750000
    ## 176     AP1 (1) PI           0.010742188
    ## 177    PI (-1) LUG           0.505859375
    ## 178   SUP (-1) LUG           0.500000000

As shown above, we firstly need to generate a set of initial-states by the function . Then by the function , we continue to generate three sets of node/edge groups whose their sensitivity would be calculated. Finally, the sensitivity values are stored in the same data frame of node/edge groups. The data frame has one column for group identifiers (lists of nodes/edges), and some next columns containing their sensitivity values according to each set of random update-rules. For example, the mutation used two sets of Nested Canalyzing rules, thus resulted in two corresponding sets of sensitivity values.

Attractor cycles identification
-------------------------------

Via function, the landscape of the network state transitions along with attractor cycles would be identified. The returned transition network object has same structures with the normal network object resulted from function (see section " function"). An example is demonstrated as follows:

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

As shown in the example, there exists some different points inside two nodes/edges's data frames of the object compared to those of normal network objects:

-   :

    The first column is also used for node identifiers, but in this case they represent *states* of the analyzed network . There exists 1024 nodes which are equivalent to 1024 network states of .

    Additional columns are described as follows:
    -   : value *1* denotes the network state belongs to an attractor, otherwises *0*.
    -   : specifies the network state of the node.
-   :

    The first column is also used for edge identifiers, but in this case they represent *transition links* of the analyzed network . Each edge identifier has a string *(1)* which denotes a directed link between two node identifiers. There exists 1024 edges which are equivalent to 1024 transition links of .

    Additional columns are described as follows:
    -   : value *1* means that the transition link connects two network states of an attractor, otherwises *0*.

We take the node as an example. Its corresponding network state is *0000000101* which represents Boolean values of all nodes in alphabetical order of the analyzed network :

    ## [1] "Number of found FBLs:4"
    ## [1] "Number of found positive FBLs:4"
    ## [1] "Number of found negative FBLs:0"

    ## AG      AP1     AP3     EMF1    LFY     LUG     PI      SUP     TFL1    UFO

    ## 0       0       0       0       0       0       0       1       0       1

Moreover, the value *1* means that belongs to an attractor. And the data frame also shows a transition link with value 1. It means that is a fixed point attractor.

Finally, the resulted transition network could be exported by the function (see section ""). Three CSV files were outputed for the transition network itself and nodes/edges attributes with the following names: , and , respectively. Then, those resulted files could be further loaded and analyzed by other softwares with powerful visualization functions like Cytoscape. For more information on Cytoscape, please refer to <http://www.cytoscape.org/>. In this tutorial, we used Cytoscape version 3.4.0.

The transition network is written as a SIF file (\*.**sif**). The SIF file could be loaded to Cytoscape with the following menu:

 or using the shortcut keys (*Figure 2(a)*)

![Import network (a) and nodes/edges attributes (b) in Cytoscape software](transition_menu.tif)

In next steps, we import two CSV files of nodes/edges attributes via menu (*Figure 2(b)*). For the nodes attributes file, we should select data type for the column (*Figure 3*). For the edges attributes file, we must select in the drop-down list beside the text (*Figure 4*).

![Nodes attributes importing dialog](transition_menu_attr_node.bmp)

![Edges attributes importing dialog](transition_menu_attr_edge.bmp)

After importing, we select panel and modify the node and edge styles a little to highlight all attractor cycles. For node style, select *Red* color in property for the nodes that belong to an attractor (*Figure 5(a)*). Regards to edge style, select *Red* color in property and change property to a larger value (optional) for the edges that connect two states of an attractor (*Figure 5(b)*).

![Nodes (a) and edges (b) style modification](style_node_edge.tif)

As a result, *Figure 6* shows the modified transition network with clearer indication of attractor cycles.

![The transition network of AMRN](amrn_attractors.tif)

Structural characteristics computation
======================================

Feedback/Feed-forward loops search
----------------------------------

Via and , the package supports methods of searching feedback/feed-forward loops (FBLs/FFLs), respectively, for all nodes/edges in a network. The following is an example R code for the search:

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

-   : number of feedback loops involving the node/edge

-   , : number of positive and negative feedback loops, respectively, involving the node/edge

-   : number of feed-forward loops involving the node/edge

-   , and : number of feed-forward loops with role A, B and C, respectively, involving the node

-   , and : number of feed-forward loops with role AB, BC and AC, respectively, involving the edge

In the data frame, , , , , and denote total numbers of FBLs, positive/negative FBLs, FFLs and coherent/incoherent FFLs in the network, respectively.

Centrality measures computation
-------------------------------

The function calculates node-/edge-based centralities of a network such as Degree, In-/Out-Degree, Closeness, Betweenness, Stress, Eigenvector, Edge Degree and Edge Betweenness. An example is demonstrated as follows:

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

Via function, all examined attributes of the networks and their nodes/edges will be exported to CSV files. The structure of these networks are also exported as Tab-separated values text files (.SIF extension). The following is an example R code for the output:

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

The methods of dynamics and structure analysis described in the above sections (except the function due to memory limitation) could also be applied to a set of networks, not limited to a single network. The RMut package provides the function to generate a set of random networks using a generation model from among four models (refer to the literature in the References section for more details):

-   Barabasi-Albert (BA) model \[1\]

-   Erdos-Renyi (ER) variant model \[2\]

-   Two shuffling models (Shuffle 1 and Shuffle 2) \[3\]

Here, we show two examples of generating a set of random networks and analyzing dynamics-related sensitivity and structural characteristic of those networks:

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

    ## [1] "Number of found FBLs:10"
    ## [1] "Number of found positive FBLs:8"
    ## [1] "Number of found negative FBLs:2"
    ## [1] "Number of found FBLs:5"
    ## [1] "Number of found positive FBLs:2"
    ## [1] "Number of found negative FBLs:3"

``` r
ba_rbns <- findFFLs(ba_rbns)
```

    ## [1] "Number of found FFLs:3"
    ## [1] "Number of found coherent FFLs:1"
    ## [1] "Number of found incoherent FFLs:2"
    ## [1] "Number of found FFLs:5"
    ## [1] "Number of found coherent FFLs:1"
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
    ## 1       0     8        6        2     1       1       0       0      6
    ## 2       1     9        7        2     0       0       0       0      7
    ## 3       2     4        2        2     1       0       0       1      3
    ## 4       3     6        5        1     0       0       0       0      4
    ## 5       4     1        1        0     0       0       0       0      3
    ## 6       5     4        3        1     0       0       0       0      3
    ## 7       6     0        0        0     0       0       0       0      2
    ## 8       7     2        2        0     0       0       0       0      2
    ## 9       8     2        2        0     0       0       0       0      2
    ## 10      9     2        2        0     1       0       1       0      2
    ##    In_Degree Out_Degree  Closeness Betweenness Stress Eigenvector
    ## 1          2          4 0.04166667        34.0     43   0.4321169
    ## 2          4          3 0.04347826        36.5     43   0.5401461
    ## 3          2          1 0.03448276         9.0     11   0.2700731
    ## 4          2          2 0.03571429        13.0     17   0.3781023
    ## 5          2          1 0.03333334         2.0      2   0.2700731
    ## 6          2          1 0.03448276         9.5     14   0.2160585
    ## 7          0          2 0.04761905         0.0      0   0.2430658
    ## 8          1          1 0.03030303         3.0      3   0.1890511
    ## 9          1          1 0.03448276         2.0      4   0.2700731
    ## 10         1          1 0.02941176         0.0      0   0.1350365
    ## 
    ## $edges
    ##      EdgeID NuFBL NuPosFBL NuNegFBL NuFFL NuFFL_AB NuFFL_BC NuFFL_AC
    ## 1  0 (-1) 7     2        2        0     0        0        0        0
    ## 2  0 (-1) 8     2        2        0     0        0        0        0
    ## 3   0 (1) 2     2        0        2     1        0        0        1
    ## 4   0 (1) 9     2        2        0     1        1        0        0
    ## 5  1 (-1) 3     4        3        1     0        0        0        0
    ## 6   1 (1) 0     4        3        1     0        0        0        0
    ## 7   1 (1) 4     1        1        0     0        0        0        0
    ## 8  2 (-1) 1     4        2        2     0        0        0        0
    ## 9  3 (-1) 1     2        2        0     0        0        0        0
    ## 10  3 (1) 5     4        3        1     0        0        0        0
    ## 11  4 (1) 1     1        1        0     0        0        0        0
    ## 12 5 (-1) 0     4        3        1     0        0        0        0
    ## 13 6 (-1) 4     0        0        0     0        0        0        0
    ## 14 6 (-1) 5     0        0        0     0        0        0        0
    ## 15  7 (1) 3     2        2        0     0        0        0        0
    ## 16 8 (-1) 1     2        2        0     0        0        0        0
    ## 17 9 (-1) 2     2        2        0     1        0        1        0
    ##    Degree Betweenness
    ## 1       8        12.0
    ## 2       8        11.0
    ## 3       9        10.0
    ## 4       8         9.0
    ## 5      11        11.0
    ## 6      13        25.5
    ## 7      10         8.0
    ## 8      10        17.0
    ## 9      11         8.5
    ## 10      7        12.5
    ## 11     10        10.0
    ## 12      9        17.5
    ## 13      5         3.0
    ## 14      5         6.0
    ## 15      6        11.0
    ## 16      9        10.0
    ## 17      5         8.0
    ## 
    ## $network
    ##   NetworkID NuFBL NuPosFBL NuNegFBL NuFFL NuCoFFL NuInCoFFL
    ## 1  BA_RBN_1    10        8        2     3       1         2
    ## 
    ## $transitionNetwork
    ## [1] FALSE
    ## 
    ## $Group_1
    ##    GroupID knockout_t1000_r1
    ## 1        1         0.9140625
    ## 2        9         0.9140625
    ## 3        7         0.7753906
    ## 4        6         0.5000000
    ## 5        5         0.2851562
    ## 6        2         0.6894531
    ## 7        4         0.4570312
    ## 8        3         0.6015625
    ## 9        0         0.9140625
    ## 10       8         0.7753906
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
    ## 1       0     3        1        2     3       1       2       0      7
    ## 2       1     3        1        2     3       0       2       1      7
    ## 3       2     3        1        2     2       2       0       0      4
    ## 4       3     0        0        0     2       0       0       2      3
    ## 5       4     0        0        0     1       0       0       1      2
    ## 6       5     1        0        1     0       0       0       0      2
    ## 7       6     3        1        2     0       0       0       0      3
    ## 8       7     1        1        0     0       0       0       0      2
    ## 9       8     2        1        1     0       0       0       0      2
    ## 10      9     0        0        0     1       1       0       0      2
    ##    In_Degree Out_Degree  Closeness Betweenness Stress Eigenvector
    ## 1          2          5 0.04761905        15.5     17   0.5903235
    ## 2          4          3 0.03225806        24.5     26   0.2235822
    ## 3          1          3 0.04347826        22.0     24   0.5176261
    ## 4          3          0 0.01111111         0.0      0   0.0000000
    ## 5          2          0 0.01111111         0.0      0   0.0000000
    ## 6          1          1 0.02631579         0.0      0   0.1421934
    ## 7          2          1 0.03448276        21.0     22   0.3291988
    ## 8          1          1 0.03571429         0.0      0   0.3754327
    ## 9          1          1 0.02941176        15.0     15   0.2093632
    ## 10         0          2 0.03448276         0.0      0   0.1421934
    ## 
    ## $edges
    ##      EdgeID NuFBL NuPosFBL NuNegFBL NuFFL NuFFL_AB NuFFL_BC NuFFL_AC
    ## 1  0 (-1) 1     1        0        1     2        1        1        0
    ## 2  0 (-1) 3     0        0        0     1        0        0        1
    ## 3  0 (-1) 7     1        1        0     0        0        0        0
    ## 4   0 (1) 4     0        0        0     1        0        1        0
    ## 5   0 (1) 6     1        0        1     0        0        0        0
    ## 6  1 (-1) 3     0        0        0     2        0        2        0
    ## 7  1 (-1) 8     2        1        1     0        0        0        0
    ## 8   1 (1) 5     1        0        1     0        0        0        0
    ## 9  2 (-1) 0     2        0        2     2        2        0        0
    ## 10 2 (-1) 1     1        1        0     1        0        0        1
    ## 11  2 (1) 4     0        0        0     1        0        0        1
    ## 12 5 (-1) 1     1        0        1     0        0        0        0
    ## 13  6 (1) 2     3        1        2     0        0        0        0
    ## 14 7 (-1) 0     1        1        0     0        0        0        0
    ## 15  8 (1) 6     2        1        1     0        0        0        0
    ## 16  9 (1) 1     0        0        0     1        1        0        0
    ## 17  9 (1) 3     0        0        0     1        0        0        1
    ##    Degree Betweenness
    ## 1      14         6.0
    ## 2      10         3.5
    ## 3       9         7.0
    ## 4       9         2.0
    ## 5      10         5.0
    ## 6      10         3.5
    ## 7       9        22.0
    ## 8       9         7.0
    ## 9      11        14.5
    ## 10     11         9.5
    ## 11      6         6.0
    ## 12      9         8.0
    ## 13      7        29.0
    ## 14      9         8.0
    ## 15      5        23.0
    ## 16      9         8.0
    ## 17      5         1.0
    ## 
    ## $network
    ##   NetworkID NuFBL NuPosFBL NuNegFBL NuFFL NuCoFFL NuInCoFFL
    ## 1  BA_RBN_2     5        2        3     5       1         4
    ## 
    ## $transitionNetwork
    ## [1] FALSE
    ## 
    ## $Group_1
    ##    GroupID knockout_t1000_r1
    ## 1        0          0.359375
    ## 2        4          0.359375
    ## 3        8          0.406250
    ## 4        7          1.000000
    ## 5        6          0.437500
    ## 6        9          0.500000
    ## 7        3          0.359375
    ## 8        5          1.000000
    ## 9        1          1.000000
    ## 10       2          0.625000
    ## 
    ## attr(,"class")
    ## [1] "list"    "NetInfo"

``` r
output(ba_rbns)
```

    ## [1] "All output files get created in the working directory:"
    ## [1] "D:/HCStore/R_Projects/RMut/vignettes"

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

    ## [1] "Number of found FBLs:9"
    ## [1] "Number of found positive FBLs:4"
    ## [1] "Number of found negative FBLs:5"
    ## [1] "Number of found FBLs:14"
    ## [1] "Number of found positive FBLs:8"
    ## [1] "Number of found negative FBLs:6"

``` r
amrn_rbns <- findFFLs(amrn_rbns)
```

    ## [1] "Number of found FFLs:18"
    ## [1] "Number of found coherent FFLs:8"
    ## [1] "Number of found incoherent FFLs:10"
    ## [1] "Number of found FFLs:17"
    ## [1] "Number of found coherent FFLs:10"
    ## [1] "Number of found incoherent FFLs:7"

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
    ## 1      AG     4        0        4     7       0       1       6      5
    ## 2     AP1     2        1        1     6       1       5       0      5
    ## 3     AP3     6        2        4     9       1       4       4      7
    ## 4    EMF1     0        0        0     3       3       0       0      3
    ## 5     LFY     7        4        3    11       7       3       1      8
    ## 6     LUG     0        0        0     0       0       0       0      1
    ## 7      PI     7        3        4    10       1       3       6      7
    ## 8     SUP     0        0        0     2       2       0       0      2
    ## 9    TFL1     2        1        1     2       1       1       0      4
    ## 10    UFO     0        0        0     1       1       0       0      2
    ##    In_Degree Out_Degree  Closeness Betweenness Stress Eigenvector
    ## 1          4          1 0.01851852         1.5      3  0.09461319
    ## 2          3          2 0.02040816         1.5      3  0.24604021
    ## 3          5          2 0.02000000         7.5     10  0.19689186
    ## 4          0          3 0.02500000         0.0      0  0.36427085
    ## 5          3          5 0.02222222        18.0     21  0.56116271
    ## 6          0          1 0.02272727         0.0      0  0.15142702
    ## 7          5          2 0.02083333        13.5     17  0.31512250
    ## 8          0          2 0.02500000         0.0      0  0.42108467
    ## 9          2          2 0.02083333         5.0      6  0.31512250
    ## 10         0          2 0.02325581         0.0      0  0.21284384
    ## 
    ## $edges
    ##           EdgeID NuFBL NuPosFBL NuNegFBL NuFFL NuFFL_AB NuFFL_BC NuFFL_AC
    ## 1    AG (-1) AP3     4        0        4     1        0        1        0
    ## 2    AP1 (-1) PI     1        0        1     3        0        2        1
    ## 3    AP1 (1) AP3     1        1        0     4        1        3        0
    ## 4     AP3 (1) AG     1        0        1     2        0        1        1
    ## 5     AP3 (1) PI     5        2        3     4        1        3        0
    ## 6  EMF1 (-1) AP1     0        0        0     2        2        0        0
    ## 7   EMF1 (-1) PI     0        0        0     1        0        0        1
    ## 8   EMF1 (1) AP3     0        0        0     2        1        0        1
    ## 9  LFY (-1) TFL1     2        1        1     1        1        0        0
    ## 10    LFY (1) AG     1        0        1     4        1        2        1
    ## 11   LFY (1) AP1     2        1        1     2        2        0        0
    ## 12   LFY (1) AP3     1        1        0     3        2        0        1
    ## 13    LFY (1) PI     1        1        0     3        1        1        1
    ## 14 LUG (-1) TFL1     0        0        0     0        0        0        0
    ## 15     PI (1) AG     1        0        1     3        0        2        1
    ## 16    PI (1) LFY     6        3        3     2        1        1        0
    ## 17  SUP (-1) LFY     0        0        0     2        1        0        1
    ## 18   SUP (-1) PI     0        0        0     2        1        0        1
    ## 19  TFL1 (-1) AG     1        0        1     2        0        1        1
    ## 20 TFL1 (-1) LFY     1        1        0     1        1        0        0
    ## 21   UFO (1) AP1     0        0        0     1        1        0        0
    ## 22   UFO (1) AP3     0        0        0     1        0        0        1
    ##    Degree Betweenness
    ## 1      12         6.5
    ## 2      12         5.0
    ## 3      12         1.5
    ## 4      12         3.0
    ## 5      14         9.5
    ## 6       8         1.0
    ## 7      10         3.5
    ## 8      10         1.5
    ## 9      12         8.0
    ## 10     13         1.5
    ## 11     13         7.0
    ## 12     15         3.5
    ## 13     15         3.0
    ## 14      5         6.0
    ## 15     12         3.0
    ## 16     15        15.5
    ## 17     10         4.5
    ## 18      9         1.5
    ## 19      9         3.0
    ## 20     12         7.0
    ## 21      7         2.5
    ## 22      9         3.5
    ## 
    ## $network
    ##    NetworkID NuFBL NuPosFBL NuNegFBL NuFFL NuCoFFL NuInCoFFL
    ## 1 AMRN_RBN_1     9        4        5    18       8        10
    ## 
    ## $transitionNetwork
    ## [1] FALSE
    ## 
    ## $Group_1
    ##          GroupID edgeremoval_t1000_r1
    ## 1      PI (1) AG           0.00000000
    ## 2    AP1 (1) AP3           0.00000000
    ## 3    AP1 (-1) PI           0.00000000
    ## 4   EMF1 (1) AP3           0.00000000
    ## 5     AP3 (1) PI           0.25000000
    ## 6    SUP (-1) PI           0.00000000
    ## 7   TFL1 (-1) AG           0.00000000
    ## 8  LUG (-1) TFL1           0.50000000
    ## 9  LFY (-1) TFL1           0.00000000
    ## 10    LFY (1) AG           0.00000000
    ## 11   UFO (1) AP3           0.00000000
    ## 12    PI (1) LFY           0.43750000
    ## 13   LFY (1) AP1           0.25000000
    ## 14 EMF1 (-1) AP1           0.00000000
    ## 15   LFY (1) AP3           0.30859375
    ## 16    LFY (1) PI           0.00000000
    ## 17 TFL1 (-1) LFY           0.00000000
    ## 18    AP3 (1) AG           0.00000000
    ## 19   UFO (1) AP1           0.00000000
    ## 20  EMF1 (-1) PI           0.03515625
    ## 21   AG (-1) AP3           0.00000000
    ## 22  SUP (-1) LFY           0.00000000
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
    ## 1      AG     7        6        1     4       0       1       3      5
    ## 2     AP1     9        6        3     5       1       2       2      5
    ## 3     AP3     7        5        2     7       0       5       2      7
    ## 4    EMF1     0        0        0     3       3       0       0      3
    ## 5     LFY    11        7        4    11       7       3       1      8
    ## 6     LUG     0        0        0     0       0       0       0      1
    ## 7      PI    10        5        5     9       0       3       6      7
    ## 8     SUP     0        0        0     1       1       0       0      2
    ## 9    TFL1     8        4        4     3       1       1       1      4
    ## 10    UFO     0        0        0     2       2       0       0      2
    ##    In_Degree Out_Degree  Closeness Betweenness Stress Eigenvector
    ## 1          4          1 0.01960784         7.0      9   0.1624282
    ## 2          3          2 0.02083333         7.0     11   0.3662291
    ## 3          5          2 0.02040816         8.5     10   0.1793598
    ## 4          0          3 0.02500000         0.0      0   0.2589086
    ## 5          3          5 0.02222222         9.5     13   0.5837649
    ## 6          0          1 0.02222222         0.0      0   0.0795488
    ## 7          5          2 0.02040816         8.0     12   0.2419770
    ## 8          0          2 0.02380952         0.0      0   0.1515882
    ## 9          2          2 0.02083333         3.0      5   0.3662291
    ## 10         0          2 0.02500000         0.0      0   0.4213368
    ## 
    ## $edges
    ##           EdgeID NuFBL NuPosFBL NuNegFBL NuFFL NuFFL_AB NuFFL_BC NuFFL_AC
    ## 1    AG (-1) AP1     7        6        1     1        0        1        0
    ## 2   AP1 (-1) LFY     5        4        1     2        1        1        0
    ## 3     AP1 (1) PI     4        2        2     2        0        1        1
    ## 4     AP3 (1) AG     5        4        1     3        0        3        0
    ## 5     AP3 (1) PI     2        1        1     2        0        2        0
    ## 6   EMF1 (-1) AG     0        0        0     1        0        0        1
    ## 7  EMF1 (-1) AP3     0        0        0     3        2        0        1
    ## 8    EMF1 (1) PI     0        0        0     2        1        0        1
    ## 9  LFY (-1) TFL1     2        2        0     2        1        0        1
    ## 10    LFY (1) AG     2        2        0     2        1        0        1
    ## 11   LFY (1) AP1     2        0        2     3        1        1        1
    ## 12   LFY (1) AP3     3        2        1     3        2        0        1
    ## 13    LFY (1) PI     2        1        1     5        2        2        1
    ## 14  LUG (-1) AP3     0        0        0     0        0        0        0
    ## 15    PI (1) AP3     4        3        1     2        0        2        0
    ## 16   PI (1) TFL1     6        2        4     1        0        1        0
    ## 17   SUP (-1) AG     0        0        0     1        0        0        1
    ## 18  SUP (-1) AP3     0        0        0     1        1        0        0
    ## 19 TFL1 (-1) LFY     6        3        3     1        1        0        0
    ## 20  TFL1 (-1) PI     2        1        1     2        0        1        1
    ## 21   UFO (1) AP1     0        0        0     2        1        0        1
    ## 22   UFO (1) LFY     0        0        0     2        1        0        1
    ##    Degree Betweenness
    ## 1      10        12.0
    ## 2      13         7.5
    ## 3      12         4.5
    ## 4      12         6.5
    ## 5      14         7.0
    ## 6       8         2.5
    ## 7      10         1.0
    ## 8      10         2.5
    ## 9      12         3.0
    ## 10     13         4.0
    ## 11     13         2.5
    ## 12     15         3.5
    ## 13     15         1.5
    ## 14      8         6.0
    ## 15     14         4.0
    ## 16     11         9.0
    ## 17      7         3.0
    ## 18      9         3.0
    ## 19     12         6.5
    ## 20     11         1.5
    ## 21      7         1.5
    ## 22     10         4.5
    ## 
    ## $network
    ##    NetworkID NuFBL NuPosFBL NuNegFBL NuFFL NuCoFFL NuInCoFFL
    ## 1 AMRN_RBN_2    14        8        6    17      10         7
    ## 
    ## $transitionNetwork
    ## [1] FALSE
    ## 
    ## $Group_1
    ##          GroupID edgeremoval_t1000_r1
    ## 1   SUP (-1) AP3           0.07812500
    ## 2    UFO (1) LFY           0.50000000
    ## 3  EMF1 (-1) AP3           0.07128906
    ## 4  TFL1 (-1) LFY           0.20312500
    ## 5     AP1 (1) PI           0.00781250
    ## 6  LFY (-1) TFL1           0.06835938
    ## 7     LFY (1) AG           0.25781250
    ## 8     PI (1) AP3           0.00781250
    ## 9     AP3 (1) PI           0.25000000
    ## 10  TFL1 (-1) PI           0.01171875
    ## 11   SUP (-1) AG           0.14453125
    ## 12   LFY (1) AP1           0.45703125
    ## 13   UFO (1) AP1           0.00000000
    ## 14  AP1 (-1) LFY           0.49218750
    ## 15   LFY (1) AP3           0.12109375
    ## 16  EMF1 (-1) AG           0.12304688
    ## 17  LUG (-1) AP3           0.06250000
    ## 18   EMF1 (1) PI           0.06933594
    ## 19    LFY (1) PI           0.00781250
    ## 20   AG (-1) AP1           0.22265625
    ## 21    AP3 (1) AG           0.01953125
    ## 22   PI (1) TFL1           0.99218750
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
