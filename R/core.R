
# Copyright 2017 Hung-Cuong Trinh and Yung-Keun Kwon
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


#' Compute sensitivity values of node/edge groups
#'
#' Computes sensitivity values of node/edge groups in a network or in a set of networks, and returns the network objects with newly calculated results.
#'
#' This function computes sensitivity values of node/edge groups in a specific network or in a set of networks.
#' Two kinds of sensitivity measures are computed: macro-distance and bitwise-distance sensitivity measures.
#'
#'    The calculation is based on a set of initial-states specified by an identifier \strong{\code{stateSet}}.
#' The node/edge groups in each network are determined by an indexing number \strong{\code{groupSet}}.
#' For example, the number \code{1} would point to the data frame of node/edge groups named \strong{\code{Group_1}}.
#' For mutation settings, there exist some embedded mutations:
#' "state flip", "rule flip", "outcome shuffle", "knockout", "overexpression",
#' "edge removal", "edge attenuation", "edge addition", "edge sign switch", and "edge reverse".
#' Besides, users can define their own mutation and apply here as shown in the below example.
#' Users can also set the operational time of the mutation as determined by the parameter \strong{\code{mutationTime}}.
#' Finally, synchronous updating scheme is used for calculating state transitions. Single or multiple sets of random update-rules are generated based on the
#' parameter \code{numRuleSets}.
#' A file containing user-defined rules could be specified by the parameter \code{ruleFile}.
#'
#'    For each network, the sensitivity values are stored in the same data frame of node/edge groups.
#' The data frame has one column for group identifiers (lists of nodes/edges),
#' and some next columns containing their sensitivity values according to each set of random update-rules.
#'
#' @export
#' @seealso \code{\link{generateStates}}, \code{\link{generateState}}, \code{\link{generateGroups}}, \code{\link{generateGroup}}, \code{\link{findFBLs}}, \code{\link{findFFLs}}, \code{\link{calCentrality}}, \code{\link{findAttractors}}
#' @name calSensitivity
#' @param networks A network or a set of networks used for the calculation
#' @param stateSet The identifier for accessing a set of initial-states
#' @param mutateMethod The method of mutation to be performed, default is "rule flip"
#' @param groupSet The indexing number of node/edge groups for whose sensitivity values are calculated. Default is 0 which specify the latest generated groups.
#' @param mutationTime The period of time in which the mutation occurs, default is 1000
#' @param numRuleSets Number of random Nested Canalyzing Function sets, default is 1
#' @param ruleFile The path points to a file containing user-defined Nested Canalyzing Function rules, default is NULL. In case the path is specified, the parameter \code{numRuleSets} is forced to 1.
#' @return The updated network objects including sensitivity values of the examined node/edge groups.
#' @usage
#' calSensitivity(networks, stateSet, mutateMethod = "rule flip",
#'                groupSet = 0, mutationTime = 1000L, numRuleSets = 1, ruleFile = NULL)
#' @examples
#' # load an example network, the large-scale human signaling network
#' data(hsn)
#'
#' # setup OpenCL for parallel computation
#' setOpencl("gpu")
#'
#' # generate 1000 random initial-states
#' states <- generateStates(hsn, 1000)
#' print(states)
#'
#' # generate all possible groups each containing a single node in the HSN network
#' hsn <- generateGroups(hsn, "all", 1, 0)
#'
#' # calculate sensitivity values of all nodes against the knockout mutation
#' hsn <- calSensitivity(hsn, states, "knockout")
#'
#' # calculate sensitivity values against a user-defined mutation, also use user-defined rules
#' hsn <- calSensitivity(hsn, states, "D:\\mod\\UserMutation.java", ruleFile="D:\\mod\\UserNCF.txt")
#'
#' # view the calculated sensitivity values and export all results to files
#' printSensitivity(hsn)
#' output(hsn)

calSensitivity <- function(networks, stateSet, mutateMethod = "rule flip", groupSet = 0,
                           mutationTime = 1000L, numRuleSets = 1, ruleFile = NULL) {
  if(is.data.frame(networks)) {
    networks <- loadInbuiltNetwork(networks)
  }

  if(isSingleNetwork(networks)) {
    networks <- calSensitivity1(networks, stateSet, groupSet, mutateMethod, mutationTime, numRuleSets, ruleFile)
    return (networks)
  }
  else if(isListNetworks(networks)) {
    numNetworks <- length(networks)
    for(i in 1:numNetworks) {
      networks[[i]] <- calSensitivity1(networks[[i]], stateSet, groupSet, mutateMethod, mutationTime, numRuleSets, ruleFile)
    }

    return (networks)
  }

  return (NULL)
}

calSensitivity1 <- function(network, stateSet, groupSet, mutateMethod = "rule flip",
                            mutationTime = 1000L, numRules = 1, ruleFile = NULL) {
  if(is.data.frame(network)) {
    network <- loadInbuiltNetwork(network)
  }

  if(groupSet == 0) {
    groupSet <- length(network) - 5
    if(groupSet <= 0)   {
      print("Please generate node/edge groups for the sensitivity calculation!")
      return (network)
    }
  }

  if(! is.null(ruleFile)) {
    numRules = 1
    print("[calSensitivity] Applying user-defined Nested Canalyzing Function rules.")

  } else {
    ruleFile = "---"
    #print("[calSensitivity] Applying random Nested Canalyzing Function rules.")
  }

  #init and call the corresponding JAVA function to Calculate sensitivity
  calc <- .jnew("mod.jmut.core.Calc")
  sensResults <- .jcall(calc, "[D", "calSensitivity", as.character(network$name), as.character(stateSet), as.integer(groupSet),
                        as.character(mutateMethod), as.integer(mutationTime), as.integer(numRules),
                        as.character(ruleFile))

  if(is.jnull(sensResults)) {
    printGeneralError()
    return (network)
  }
  sens <- extractInfos(sensResults, numRules, numRules)

  for(i in 1:numRules) {
    columnName <- paste(mutateMethod, "_t", mutationTime, sep = "", collapse = "")
    columnName <- paste(columnName, "_r", i, sep = "", collapse = "")
    columnName <- gsub("\\s", "", columnName)

    macroName <- paste(columnName, "_macro", sep = "", collapse = "")
    bitwsName <- paste(columnName, "_bitws", sep = "", collapse = "")

    network[[5 + groupSet]][, macroName] <- unlist(sens[i + 2])
    network[[5 + groupSet]][, bitwsName] <- unlist(sens[i + 2 + numRules])
    #network$network[, columnName] <- mean(network$mutatedGroups[[columnName]])
  }

  return (network)
}

#' Identifies attractors of a network.
#'
#' Identifies attractors of a network and returns the resulted transition network.
#'
#' This function searches attractors of a specific network, and
#' the returned results are stored in a Transition network object.
#' The calculation is based on a set of initial-states specified by an identifier \strong{\code{stateSet}}.
#' The current set of update-rules of the network is used with a synchronous updating scheme.
#'
#' @export
#' @seealso \code{\link{generateStates}}, \code{\link{generateState}}, \code{\link{generateRule}}, \code{\link{calSensitivity}}
#' @name findAttractors
#' @param network A network used for the attractors search
#' @param stateSet The identifier for accessing a set of initial-states
#' @return The resulted transition network.
#' @usage
#' findAttractors(network, stateSet)
#' @examples
#' data(amrn)
#' # Generate a set of random Nested Canalyzing rules
#' generateRule(amrn, 2)
#'
#' # Generate a specific initial-state for the AMRN network
#' state1 <- generateState(amrn, "1110011011")
#'
#' transNet <- findAttractors(amrn, state1)
#' print(transNet)
#' output(transNet)

findAttractors <- function(network, stateSet) {
  if(is.data.frame(network)) {
    network <- loadInbuiltNetwork(network)
  }

  calc <- .jnew("mod.jmut.core.Calc")
  infos <- .jcall(calc, "[Ljava/lang/String;", "findAttractors", as.character(network$name),
                        as.character(stateSet))

  if(is.jnull(infos)) {
    printGeneralError()
    return (network)
  }

  list_data <- extractInfos(infos, 3, 2, 1)
  print(paste("Number of found attractors:", list_data[8], sep = "", collapse = ""))
  print(paste("Number of transition nodes:", list_data[1], sep = "", collapse = ""))
  print(paste("Number of transition edges:", list_data[2], sep = "", collapse = ""))

  nodes <- unlist(list_data[3])
  nodes_attractor <- unlist(list_data[4])
  nodes_networkState <- unlist(list_data[5])
  edges <- unlist(list_data[6])
  edges_attractor <- unlist(list_data[7])

  transitionName <- paste(network$name, "_trans", sep = "", collapse = "")
  df_node <- data.frame(NodeID = nodes, Attractor = nodes_attractor, NetworkState = nodes_networkState, stringsAsFactors = FALSE)
  df_edge <- data.frame(EdgeID = edges, Attractor = edges_attractor, stringsAsFactors = FALSE)
  netw <- NetInfo(transitionName, df_node, df_edge, TRUE)

  return (netw)
}

#' Identifies feedback loops in a network or in a set of networks.
#'
#' Searches and counts feedback loops for all nodes/edges in a network or in a set of networks.
#'
#' This function searches feedback loops (FBLs) in a specific network or in a set of networks.
#' For each network, the returned results are stored in two corresponding data frames of node/edge attributes.
#' Each data frame has one column for node/edge identifiers, and three columns
#' contain corresponding number of involved FBLs and number of involved positive/negative FBLs.
#' Another data frame of the network object, "network" data frame,
#' contains total number of FBLs and total number of positive/negative FBLs in the network.
#' @export
#' @seealso \code{\link{findFFLs}}, \code{\link{calCentrality}}, \code{\link{calSensitivity}}
#' @name findFBLs
#' @param networks A network or a set of networks used for FBLs search
#' @param maxLength The maximal length of FBLs, default is 2
#' @return The updated network objects including number of FBLs for each node/edge.
#' @usage
#' findFBLs(networks, maxLength = 2L)
#' @examples
#' data(amrn)
#' amrn <- findFBLs(amrn, maxLength = 10)
#' print(amrn$nodes)
#' print(amrn$edges)
#' print(amrn$network)
findFBLs <- function(networks, maxLength = 2L) {
  if(is.data.frame(networks)) {
    networks <- loadInbuiltNetwork(networks)
  }

  if(isSingleNetwork(networks)) {
    networks <- findFBLs1(networks, maxLength)
    return (networks)
  }
  else if(isListNetworks(networks)) {
    numNetworks <- length(networks)
    for(i in 1:numNetworks) {
      networks[[i]] <- findFBLs1(networks[[i]], maxLength)
    }

    return (networks)
  }

  return (NULL)
}

findFBLs1 <- function(network, maxLength = 2L) {
  if(is.data.frame(network)) {
    network <- loadInbuiltNetwork(network)
  }

  calc <- .jnew("mod.jmut.core.Calc")
  infos <- .jcall(calc, "[I", "findFBLs", as.character(network$name),
                  as.integer(maxLength))

  if(is.jnull(infos)) {
    printGeneralError()
    return (network)
  }

  fbls <- extractInfos(infos, 3, 3, 3)
  # print(paste("Number of FBL nodes:", fbls[1], sep = "", collapse = ""))
  # print(paste("Number of FBL edges:", fbls[2], sep = "", collapse = ""))
  print(paste("Number of found FBLs:", fbls[9], sep = "", collapse = ""))
  print(paste("Number of found positive FBLs:", fbls[10], sep = "", collapse = ""))
  print(paste("Number of found negative FBLs:", fbls[11], sep = "", collapse = ""))
  network$network[, "NuFBL"] <- unlist(fbls[9])
  network$network[, "NuPosFBL"] <- unlist(fbls[10])
  network$network[, "NuNegFBL"] <- unlist(fbls[11])

  network$nodes[, "NuFBL"] <- unlist(fbls[3])
  network$nodes[, "NuPosFBL"] <- unlist(fbls[4])
  network$nodes[, "NuNegFBL"] <- unlist(fbls[5])

  network$edges[, "NuFBL"] <- unlist(fbls[6])
  network$edges[, "NuPosFBL"] <- unlist(fbls[7])
  network$edges[, "NuNegFBL"] <- unlist(fbls[8])

  return (network)
}

#' Identifies feedforward loops in a network or in a set of networks.
#'
#' Searches and counts feedforward loops for all nodes/edges in a network or in a set of networks.
#'
#' This function searches feedforward loops (FFLs) in a specific network or in a set of networks.
#' For each network, the returned results are stored in two corresponding data frames of node/edge attributes.
#' Each data frame has one column for node/edge identifiers, and four columns
#' contain corresponding number of all FFL motifs and number of FFL motifs
#' with three different roles A, B and C.
#' Another data frame of the network object, "network" data frame, contains total numbers of FFLs and coherent/incoherent FFLs in the network.
#'
#' @export
#' @seealso \code{\link{findFBLs}}, \code{\link{calCentrality}}, \code{\link{calSensitivity}}
#' @name findFFLs
#' @param networks A network or a set of networks used for FFLs search
#' @return The updated network objects including number of FFL motifs for each node/edge.
#' @usage
#' findFFLs(networks)
#' @examples
#' data(amrn)
#' amrn <- findFFLs(amrn)
#' print(amrn$nodes)
#' print(amrn$edges)
#' print(amrn$network)
findFFLs <- function(networks) {
  if(is.data.frame(networks)) {
    networks <- loadInbuiltNetwork(networks)
  }

  if(isSingleNetwork(networks)) {
    networks <- findFFLs1(networks)
    return (networks)
  }
  else if(isListNetworks(networks)) {
    numNetworks <- length(networks)
    for(i in 1:numNetworks) {
      networks[[i]] <- findFFLs1(networks[[i]])
    }

    return (networks)
  }

  return (NULL)
}

findFFLs1 <- function(network) {
  if(is.data.frame(network)) {
    network <- loadInbuiltNetwork(network)
  }

  calc <- .jnew("mod.jmut.core.Calc")
  infos <- .jcall(calc, "[I", "findFFLs", as.character(network$name),
                  as.integer(2L))

  if(is.jnull(infos)) {
    printGeneralError()
    return (network)
  }

  ffls <- extractInfos(infos, 4, 4, 3)
  # print(paste("Number of FFL nodes:", ffls[1], sep = "", collapse = ""))
  # print(paste("Number of FFL edges:", ffls[2], sep = "", collapse = ""))
  print(paste("Number of found FFLs:", ffls[11], sep = "", collapse = ""))
  print(paste("Number of found coherent FFLs:", ffls[12], sep = "", collapse = ""))
  print(paste("Number of found incoherent FFLs:", ffls[13], sep = "", collapse = ""))
  network$network[, "NuFFL"] <- unlist(ffls[11])
  network$network[, "NuCoFFL"] <- unlist(ffls[12])
  network$network[, "NuInCoFFL"] <- unlist(ffls[13])

  network$nodes[, "NuFFL"] <- unlist(ffls[3])
  network$nodes[, "NuFFL_A"] <- unlist(ffls[4])
  network$nodes[, "NuFFL_B"] <- unlist(ffls[5])
  network$nodes[, "NuFFL_C"] <- unlist(ffls[6])

  network$edges[, "NuFFL"] <- unlist(ffls[7])
  network$edges[, "NuFFL_AB"] <- unlist(ffls[8])
  network$edges[, "NuFFL_BC"] <- unlist(ffls[9])
  network$edges[, "NuFFL_AC"] <- unlist(ffls[10])

  return (network)
}

#' Calculate node-/edge-based centralities of a network or a set of networks.
#'
#' Calculate centrality measures for all nodes/edges in a network or in a set of networks.
#'
#' This function calculates node-/edge-based centralities of a specific network or a set of networks.
#' For each network, the returned results are stored in a data frame of the network object.
#' The data frame has one column for nodes/edges identifiers, and nine columns
#' contain corresponding values of some node-based centrality measures such as
#' Degree, In-/Out-Degree, Closeness, Betweenness, Stress and Eigenvector, and some edge-based measures like
#' Edge Degree and Edge Betweenness.
#' @export
#' @seealso \code{\link{findFBLs}}, \code{\link{findFFLs}}, \code{\link{calSensitivity}}
#' @name calCentrality
#' @param networks A network or a set of networks used for the calculation
#' @return The updated network objects including values of centrality measures for each node/edge.
#' @usage
#' calCentrality(networks)
#' @examples
#' data(amrn)
#' amrn <- calCentrality(amrn)
#' print(amrn$nodes)
#' print(amrn$edges)
calCentrality <- function(networks) {
  if(is.data.frame(networks)) {
    networks <- loadInbuiltNetwork(networks)
  }

  if(isSingleNetwork(networks)) {
    networks <- calCentrality1(networks)
    return (networks)
  }
  else if(isListNetworks(networks)) {
    numNetworks <- length(networks)
    for(i in 1:numNetworks) {
      networks[[i]] <- calCentrality1(networks[[i]])
    }

    return (networks)
  }

  return (NULL)
}

calCentrality1 <- function(network) {
  if(is.data.frame(network)) {
    network <- loadInbuiltNetwork(network)
  }

  calc <- .jnew("mod.jmut.core.Calc")
  infos <- .jcall(calc, "[D", "calCentrality", as.character(network$name))

  if(is.jnull(infos)) {
    printGeneralError()
    return (network)
  }

  cent <- extractInfos(infos, 7, 2)
  # print(paste("Number of Cent nodes:", cent[1], sep = "", collapse = ""))
  # print(paste("Number of Cent edges:", cent[2], sep = "", collapse = ""))

  network$nodes[, "Degree"] <- unlist(cent[3])
  network$nodes[, "In_Degree"] <- unlist(cent[4])
  network$nodes[, "Out_Degree"] <- unlist(cent[5])
  network$nodes[, "Closeness"] <- unlist(cent[6])
  network$nodes[, "Betweenness"] <- unlist(cent[7])
  network$nodes[, "Stress"] <- unlist(cent[8])
  network$nodes[, "Eigenvector"] <- unlist(cent[9])

  network$edges[, "Degree"] <- unlist(cent[10])
  network$edges[, "Betweenness"] <- unlist(cent[11])

  return (network)
}

#' Create a set of random networks.
#'
#' Create a set of random networks using different generation models.
#'
#' This function generates a set of random networks using a generation model from among four models:
#' Barabasi-Albert (BA) model [1], Erdos-Renyi (ER) variant model [2] and two shuffling models (Shuffle 1 and Shuffle 2) [3].
#' Refer to the literature in the References section for more details.
#' @references
#' 1. Barabasi A-L, Albert R (1999) Emergence of Scaling in Random Networks. Science 286: 509-512. doi: 10.1126/science.286.5439.509
#'
#' 2. Le D-H, Kwon Y-K (2011) NetDS: A Cytoscape plugin to analyze the robustness of dynamics and feedforward/feedback loop structures of biological networks. Bioinformatics.
#'
#' 3. Trinh H-C, Le D-H, Kwon Y-K (2014) PANET: A GPU-Based Tool for Fast Parallel Analysis of Robustness Dynamics and Feed-Forward/Feedback Loop Structures in Large-Scale Biological Networks. PLoS ONE 9: e103010.
#'
#' @export
#' @seealso \code{\link{loadNetwork}}, \code{\link{calSensitivity}}, \code{\link{generateStates}}, \code{\link{generateState}}, \code{\link{generateGroups}}, \code{\link{generateGroup}}, \code{\link{findFBLs}}, \code{\link{findFFLs}}, \code{\link{calCentrality}}
#' @name createRBNs
#' @param prexName The common prefix of generated random network names, default is "RBN_"
#' @param numNetworks The number of generated random networks, default is 10
#' @param model The specified generation model from among four models: BA, ER, Shuffle 1 and Shuffle 2. Default is "BA".
#' @param numNodes The number of nodes in a random network, default is 10
#' @param numEdges The number of edges in a random network, default is 20
#' @param probOfNegative The probability of negative links's assignment in a random network, default is 0.5
#' @param referedNetwork The specific reference network used for two shuffling models
#' @param shuffleRate The shuffling intensity of "Shuffle 2" model. The number of rewiring steps = (Shuffling intensity) x (number of edges). Default is 4.
#'
#' @return The generated random network objects.
#' @usage
#' createRBNs(prexName = "RBN_", numNetworks = 10, model = "BA",
#'            numNodes = 10, numEdges = 20, probOfNegative = 0.5,
#'            referedNetwork = NULL, shuffleRate = 4.0)
#' @examples
#' # Generate all possible initial-states each containing 10 Boolean nodes
#' set1 <- generateStates(10, "all")
#'
#' # Generate random networks based on BA model
#' ba_rbns <- createRBNs("BA_RBN_", 2, "BA", 10, 17)
#'
#' # For each random network, generate all possible groups each containing a single node
#' ba_rbns <- generateGroups(ba_rbns, "all", 1, 0)
#'
#' # For each random network, calculate sensitivity values of all nodes against "knockout" mutation
#' ba_rbns <- calSensitivity(ba_rbns, set1, "knockout")
#'
#' # For each random network, calculate structural measures of all nodes/edges
#' ba_rbns <- findFBLs(ba_rbns, maxLength = 10)
#' ba_rbns <- findFFLs(ba_rbns)
#' ba_rbns <- calCentrality(ba_rbns)
#'
#' print(ba_rbns)
#' output(ba_rbns)
createRBNs <- function(prexName = "RBN_", numNetworks = 10, model = "BA", numNodes = 10, numEdges = 20, probOfNegative = 0.5,
                       referedNetwork = NULL, shuffleRate = 4.0) {
  referedName <- "NULL"
  if(is.data.frame(referedNetwork)) {
    referedNetwork <- loadInbuiltNetwork(referedNetwork)
  }
  if(length(class(referedNetwork)) == 2) {
    if(class(referedNetwork)[2] == "NetInfo") {
      referedName <- referedNetwork$name
    }
  }

  calc <- .jnew("mod.jmut.core.Calc")
  succ <- .jcall(calc, "Z", "createRBNs", as.character(prexName), as.integer(numNetworks), as.character(model),
                 as.integer(numNodes), as.integer(numEdges), as.numeric(probOfNegative),
                 as.character(referedName), as.numeric(shuffleRate))
  if(succ == FALSE) {
    printGeneralError()
    return (NULL)
  }

  rbn_list <- list()
  for(i in 1:numNetworks) {
    netName <- paste(prexName, i, sep = "", collapse = "")
    netw <- getNetworkInfos(netName)
    rbn_list[[i]] <- netw
  }

  return (rbn_list)
}

#' Calculate all types of sensitivities.
#'
#' export
#'
calAllSensitivity <- function(network, mutationTime = 1000L,
                           numInsertedEdges = 1000L, numStates = 1000L, numRules = 1) {
  network <- calSensitivity(network, "state", "flip", mutationTime, 0, numInsertedEdges, numStates, numRules)
  network <- calSensitivity(network, "rule", "freeze", mutationTime, 0, numInsertedEdges, numStates, numRules)
  network <- calSensitivity(network, "rule", "freeze", mutationTime, 1, numInsertedEdges, numStates, numRules)
  network <- calSensitivity(network, "rule", "flip", mutationTime, 0, numInsertedEdges, numStates, numRules)
  network <- calSensitivity(network, "rule", "Permute outputs", mutationTime, 0, numInsertedEdges, numStates, numRules)

  network <- calSensitivity(network, "rule", "remove", mutationTime, 0, numInsertedEdges, numStates, numRules)
  network <- calSensitivity(network, "rule", "Insert", mutationTime, 0, numInsertedEdges, numStates, numRules)
  network <- calSensitivity(network, "rule", "attenuate", mutationTime, 0, numInsertedEdges, numStates, numRules)
  network <- calSensitivity(network, "rule", "Switch input", mutationTime, 0, numInsertedEdges, numStates, numRules)
  network <- calSensitivity(network, "rule", "Switch output", mutationTime, 0, numInsertedEdges, numStates, numRules)

  return (network)
}

