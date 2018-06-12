
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



# Func: create a Network information object
NetInfo <- function(a_name = "Network 1", a_nodes, a_edges, is_transitionNetwork) {
  df_net <- data.frame(NetworkID = a_name, stringsAsFactors = FALSE)
  me = list(name = a_name, nodes = a_nodes, edges = a_edges,
            network = df_net, transitionNetwork = is_transitionNetwork)
  # Set the name for the new class
  class(me) <- append(class(me), "NetInfo")
  return(me)
}

# Func: get the network information
getNetworkInfos <- function(networkName) {
  netData <- .jnew("mod.jmut.core.comp.NetData")
  infos <- .jcall(netData, "[Ljava/lang/String;", "getNetworkInfos", as.character(networkName))

  # listArr <- sapply(infos, .jevalArray)
  # nodes <- unlist(listArr[1])
  # edges <- unlist(listArr[2])

  list_data <- extractInfos(infos, 1, 1)
  # print(paste("Number of nodes:", list_data[1], sep = "", collapse = ""))
  # print(paste("Number of edges:", list_data[2], sep = "", collapse = ""))

  nodes <- unlist(list_data[3])
  edges <- unlist(list_data[4])

  df_node <- data.frame(NodeID = nodes, stringsAsFactors = FALSE)
  df_edge <- data.frame(EdgeID = edges, stringsAsFactors = FALSE)
  netw <- NetInfo(networkName, df_node, df_edge, FALSE)
  return (netw)
}

#' Loads a network from a file.
#'
#' \code{loadNetwork} loads a network from a file and returns the network object.
#'
#' This function loads a network from a Tab-separated values text file and returns the network object.
#' The file format contains three columns:  source, interaction type, and target.
#' "Source" and "target" are gene/protein identifiers that are used to define nodes,
#' while "interaction type" labels the edges connecting each pair of nodes.
#' The returned network object contains the network name, three data frames used for storing
#' the nodes/edges and network attributes, respectively.
#' @export
#' @seealso \code{\link{output}}, \code{\link{createRBNs}}, \code{\link{calSensitivity}}
#' @name loadNetwork
#' @param pathToFile The path points to a file
#' @return The network object
#' @usage
#' loadNetwork(pathToFile)
#' @examples
#' amrn <- loadNetwork("D:\\AMRN.sif")
#' print(amrn)

loadNetwork <- function(pathToFile) {
  netData <- .jnew("mod.jmut.core.comp.NetData")
  fileName <- .jcall(netData, "S", "loadNetwork", as.character(pathToFile))

  #Get nodes and edges information
  netw <- getNetworkInfos(fileName)

  return (netw)
}

# Load inbuilt network
loadInbuiltNetwork <- function(network) {
  # Convert the network data frame to 1D array of strings
  # print("Go into loadInbuiltNetwork ...")
  netName <- network$Source[1]
  numEdges <- length(network$Source)

  edges <- c(netName, (numEdges - 1))
  edges <- append(edges, network$Source[2:numEdges])
  edges <- append(edges, network$Interaction[2:numEdges])
  edges <- append(edges, network$Target[2:numEdges])

  netData <- .jnew("mod.jmut.core.comp.NetData")
  fileName <- .jcall(netData, "S", "loadInbuiltNetwork", .jarray(edges))


  #Get nodes and edges information
  netw <- getNetworkInfos(fileName)

  return (netw)
}

# OpenCL section --------------------------------------------------------------------------------------------->>>
#' Shows OpenCL information.
#'
#' \code{showOpencl} gets OpenCL information and prints them to the console screen.
#'
#' This function gets OpenCL information and prints them to the console screen.
#' For ex., installed OpenCL platforms and its corresponding CPU/GPU devices.
#' @export
#' @seealso \code{\link{setOpencl}}
#' @name showOpencl
#' @return A string of OpenCL information
#' @usage
#' showOpencl()
#' @examples
#' showOpencl()
#'
showOpencl <- function() {
  calc <- .jnew("mod.jmut.core.Calc")
  infoBytes <- .jcall(calc, "[B", "getOpenCLInfo")

  #infos <- gsub("[^[:alnum:]///' ]", "", infos)
  #iconv(infos, to = 'UTF-8')

  remove <- c(as.raw(0))
  infoBytes <- infoBytes[! infoBytes %in% remove]
  infos <- rawToChar(infoBytes)
  cat(infos)
}

#' Enables or disables OpenCL computation.
#'
#' \code{setOpencl} enables or disables OpenCL computation.
#'
#' This function enables OpenCL computation by selecting a CPU/GPU device and utilizing all of its cores for further computation.
#' Thus, all tasks will be executed in parallel.
#' About the parameter \code{deviceType}, there exists three options: \'none\' means disable OpenCL,
#' \'cpu\' means selecting a CPU device and \'gpu\' means using a GPU device.
#' @export
#' @seealso \code{\link{showOpencl}}
#' @name setOpencl
#' @param deviceType The type of OpenCL device, including three options: \'none\', \'cpu\' and \'gpu\'
#' @return Information of the successfully selected device
#' @usage
#' setOpencl(deviceType)
#' @examples
#' showOpencl()
#' setOpencl("gpu")
#' setOpencl("cpu")
#' setOpencl("none")
#'
setOpencl <- function(deviceType) {
  calc <- .jnew("mod.jmut.core.Calc")
  infoBytes <- .jcall(calc, "[B", "setOpenCL", as.character(deviceType))

  remove <- c(as.raw(0))
  infoBytes <- infoBytes[! infoBytes %in% remove]
  infos <- rawToChar(infoBytes)
  cat(infos)
}

# Print a message for a general error
printGeneralError <- function() {
  print("Fail to execute the calculation. Please check all inputed parameters or restart R environment!")
}

# Print a message for a specific error
printError <- function(errCode) {
  if(errCode == 0)
    print("The network is not exist!")

  else if(errCode == 1)
    print("Length of the initial state must be equal to number of nodes in the network!")

  else if(errCode == 2)
    print("The set of initial states is not exist!")

  else if(errCode == 3)
    print("The group of nodes/edges is not exist in the network!")

  else if(errCode == 4)
    print(paste("Fail to initialize the Java Virtual Machine! ",
                "Please check the maximum amount of memory supported by your system.",
                sep = "", collapse = ""))
}

#' Print out the sensitivity values of node/edge groups
#'
#' Print out the sensitivity values of node/edge groups in a network
#'
#' This function prints out the sensitivity values of node/edge groups in a specific network.
#' And the parameter \code{groupSet}
#' has same meaning as in the \code{\link{calSensitivity}} function.
#'
#' @export
#' @seealso \code{\link{calSensitivity}}, \code{\link{generateStates}}, \code{\link{generateGroups}}, \code{\link{generateGroup}}, \code{\link{findFBLs}}, \code{\link{findFFLs}}, \code{\link{calCentrality}}, \code{\link{findAttractors}}
#' @name printSensitivity
#' @param network A network used for the outputting
#' @param groupSet The indexing number of node/edge groups for whose sensitivity values are calculated. Default is 0 which specify the latest generated groups.
#' @return None
#' @usage
#' printSensitivity(network, groupSet = 0)
#' @examples
#' data(amrn)
#'
#' # generate 1000 random initial-states
#' states <- generateStates(amrn, 1000)
#' print(states)
#'
#' # generate all possible groups each containing a single node in the HSN network
#' amrn <- generateGroups(amrn, "all", 1, 0)
#'
#' # calculate sensitivity values of all nodes against the knockout mutation
#' amrn <- calSensitivity(amrn, states, "knockout")
#'
#' # view the calculated sensitivity values and export all results to files
#' printSensitivity(amrn)
printSensitivity <- function(network, groupSet = 0) {
  if(groupSet == 0) {
    groupSet <- length(network) - 5
    if(groupSet <= 0)   {
      print("Please generate node/edge groups for the sensitivity calculation!")
      return ()
    }
  }

  print(network[[5 + groupSet]])
}

# Determine if the single network or not
isSingleNetwork <- function(networks) {
  cnames <- class(networks)
  if(length(cnames) == 2) {
    if(cnames[2] == "NetInfo") {
      return (TRUE)
    }
  }

  return (FALSE)
}

# Determine if a list of networks or not
isListNetworks <- function(networks) {
  cnames <- class(networks)
  if(length(cnames) == 1) {
    if(cnames[1] == "list") {
      return (TRUE)
    }
  }

  return (FALSE)
}

#' Generate random initial-states.
#'
#' Generate random initial-states for a network or a set of networks.
#'
#' This function generates random initial-states for a network or a set of networks.
#' The initial-states would be used to analyze the dynamics of the examined networks,
#' for ex., calculating sensitivity or searching attractors.
#'
#' @export
#' @seealso \code{\link{calSensitivity}}, \code{\link{findAttractors}}
#' @name generateStates
#' @param numNodes Number of nodes in each initial-state or a network object
#' @param numStates Number of random initial-states to be generated. If set to "all", all possible initial-states would be generated. For the large networks, we should use a specific value becaused of memory limitation.
#' @return An identifier for accessing the generated initial-states. The identifier would be used as a parameter of the functions of calculating sensitivity and finding attractors.
#' @usage
#' generateStates(numNodes, numStates)
#' @examples
#' # Generate a set of 200 initial-states each containing 10 Boolean nodes
#' set1 <- generateStates(10, 200)
#' print(set1)
#'
#' # Generate all possible initial-states each containing 10 Boolean nodes
#' set2 <- generateStates(10, "all")
#' print(set2)

generateStates <- function(numNodes, numStates) {
  if(is.data.frame(numNodes)) {
    numNodes <- loadInbuiltNetwork(numNodes)
  }
  if(isSingleNetwork(numNodes)) {
    numNodes <- numNodes$name
  }

  netData <- .jnew("mod.jmut.core.comp.NetData")
  infos <- .jcall(netData, "Ljava/lang/String;", "generateInitialStates", as.character(numNodes), as.character(numStates))

  if(is.jnull(infos)) {
    printGeneralError()
    return (-1)
  }

  return (infos)
}

#' Generate a specific initial-state.
#'
#' Generate a specific initial-state for a network.
#'
#' This function generates a specific initial-state for a network.
#' The initial-state would be used to analyze the dynamics of the examined network,
#' for ex., calculating sensitivity or searching attractors.
#' @export
#' @seealso \code{\link{calSensitivity}}, \code{\link{findAttractors}}
#' @name generateState
#' @param network The network used for the generation
#' @param state A binary string with one entry for each node of the network in alphabetical order
#' @return An identifier for accessing the generated initial-state. The identifier would be used as a parameter of the functions of calculating sensitivity and finding attractors.
#' @usage
#' generateState(network, state)
#' @examples
#' data(amrn)
#' state1 <- generateState(amrn, "1010101111")
#' print(state1)

generateState <- function(network, state) {

  if(is.data.frame(network)) {
    network <- loadInbuiltNetwork(network)
  }

  netData <- .jnew("mod.jmut.core.comp.NetData")
  id <- .jcall(netData, "Ljava/lang/String;", "setInitialState", as.character(network$name), as.character(state))

  if(is.jnull(id)) {
    printError(0)
    return (NULL)
  }

  if(id == -1) {
    printError(1)
    return (NULL)
  }

  #Print out the state with nodes
  a <- strsplit(state, split="")
  a <- unlist(a)
  nodes <- network$nodes$NodeID

  df <- data.frame(NodeID = nodes, State = a, stringsAsFactors = FALSE)
  print(df)

  return (id)
}

#' Generate random node/edge groups.
#'
#' Generate random groups of node/edge in a network or in a set of networks.
#'
#' This function generates random groups of elements in a network or in a set of networks.
#' The groups would be used to analyze the dynamics of the examined networks,
#' for ex., calculating sensitivity,  perturbing a network, or restoring a network to the origin.
#' Each element group contains only nodes, only edges, or a combination of nodes/edges.
#'
#' @export
#' @seealso \code{\link{calSensitivity}}, \code{\link{perturb}}, \code{\link{restore}}
#' @name generateGroups
#' @param networks A network or a set of networks contain the generated groups
#' @param numGroups Number of random groups to be generated for each network. If set to "all", all possible groups would be generated.
#' @param nodeSize Number of nodes in each group, default is 1
#' @param edgeSize Number of edges in each group, default is 0
#' @param newEdges If TRUE, new edges would be created for each group. Otherwise, existing edges of the networks are selected for each group.
#' @return The updated network objects including generated groups
#' @usage
#' generateGroups(networks, numGroups, nodeSize = 1, edgeSize = 0, newEdges = FALSE)
#' @examples
#' data(amrn)
#' # Generate all possible groups each containing a single node in the AMRN network
#' amrn <- generateGroups(amrn, "all", 1, 0)
#' print(amrn$Group_1)
#'
#' # Generate all possible groups each containing a single edge in the AMRN network
#' amrn <- generateGroups(amrn, "all", 0, 1)
#' print(amrn$Group_2)
#'
#' # Generate all possible groups each containing a new edge (the edge did not exist in the AMRN network)
#' amrn <- generateGroups(amrn, "all", 0, 1, TRUE)
#' print(amrn$Group_3)

generateGroups <- function(networks, numGroups, nodeSize = 1, edgeSize = 0, newEdges = FALSE, start = -1) {
  if(is.data.frame(networks)) {
    networks <- loadInbuiltNetwork(networks)
  }

  if(isSingleNetwork(networks)) {
    networks <- generateGroups1(networks, numGroups, nodeSize, edgeSize, newEdges, start)
    return (networks)
  }
  else if(isListNetworks(networks)) {
    numNetworks <- length(networks)
    for(i in 1:numNetworks) {
      networks[[i]] <- generateGroups1(networks[[i]], numGroups, nodeSize, edgeSize, newEdges, start)
    }

    return (networks)
  }

  return (NULL)
}

generateGroups1 <- function(network, numGroups, nodeSize, edgeSize, newEdges = FALSE, start) {
  netData <- .jnew("mod.jmut.core.comp.NetData")
  groupsName <- .jcall(netData, "Ljava/lang/String;", "generateGroups", as.character(network$name), as.character(numGroups),
                  as.integer(nodeSize), as.integer(edgeSize), as.logical(newEdges), as.integer(start))

  if(is.jnull(groupsName)) {
    printGeneralError()
    return (network)
  }

  #Retrieve the newly generated groups
  infos <- .jcall(netData, "[Ljava/lang/String;", "getMutatedGroups", as.character(network$name), as.character(groupsName))
  list_data <- extractInfos(infos, 1, 0)

  print(paste("Number of possibly mutated groups:", list_data[1], sep = "", collapse = ""))
  groups <- unlist(list_data[3])
  df_groups <- data.frame(GroupID = groups, stringsAsFactors = FALSE)
  network[[length(network) + 1]] <- df_groups

  #groupsName <- paste("Group_", length(network) - 5, sep = "", collapse = "")
  names(network)[length(network)] <- groupsName

  return (network)
}

#' Generate a specific group of nodes/edges.
#'
#' Generate a specific group of nodes/edges in a network.
#'
#' This function generates a specific group of elements in a network.
#' The group would be used to analyze the dynamics of the examined network,
#' for ex., calculating sensitivity,  perturbing the network, or restoring the network to the origin.
#' The element group contains only nodes, only edges, or a combination of nodes/edges.
#'
#' @export
#' @seealso \code{\link{calSensitivity}}, \code{\link{perturb}}, \code{\link{restore}}
#' @name generateGroup
#' @param network The network contains the generated group
#' @param nodes A list of nodes in the generated group
#' @param edges A list of edges in the generated group
#' @return The updated network object including the generated group
#' @usage
#' generateGroup(network, nodes, edges = "")
#' @examples
#' data(amrn)
#' # Generate a group of two nodes and two edges in the AMRN network
#' amrn <- generateGroup(amrn, nodes = "AG, SUP", edges = "UFO (1) PI, LUG (-1) PI")
#' print(amrn$Group_1)
generateGroup <- function(network, nodes, edges = "") {
  if(is.data.frame(network)) {
    network <- loadInbuiltNetwork(network)
  }

  netData <- .jnew("mod.jmut.core.comp.NetData")
  groupsName <- .jcall(netData, "Ljava/lang/String;", "generateSpecificGroup", as.character(network$name), as.character(nodes),
                       as.character(edges))

  if(is.jnull(groupsName)) {
    printError(0)
    return (network)
  }

  if(groupsName == "-1") {
    printGeneralError()
    return (network)
  }

  #Retrieve the newly generated groups
  infos <- .jcall(netData, "[Ljava/lang/String;", "getMutatedGroups", as.character(network$name), as.character(groupsName))
  list_data <- extractInfos(infos, 1, 0)

  groups <- unlist(list_data[3])
  df_groups <- data.frame(GroupID = groups, stringsAsFactors = FALSE)
  network[[length(network) + 1]] <- df_groups

  names(network)[length(network)] <- groupsName

  return (network)
}

#' Perturb a set of node/edge groups.
#'
#' Perturb a set of node/edge groups in a network.
#'
#' This function perturbs a set of node/edge groups in a network.
#' Two parameters \code{groupSet}, and \code{mutateMethod}
#' have same meaning as in the \code{\link{calSensitivity}} function.
#'
#' @export
#' @seealso \code{\link{restore}}, \code{\link{generateGroups}}, \code{\link{generateGroup}}, \code{\link{calSensitivity}}, \code{\link{findAttractors}}
#' @name perturb
#' @param network The network contains the node/edge groups
#' @param groupSet The indexing number of node/edge groups in the network
#' @param mutateMethod The method of mutation to be performed, default is "rule flip"
#' @return None. Error messages or information would be outputed to the screen.
#' @usage
#' perturb(network, groupSet, mutateMethod = "rule flip")
#' @examples
#' data(amrn)
#' # Generate a group of two nodes and two edges in the AMRN network
#' amrn <- generateGroup(amrn, nodes = "AG, SUP", edges = "UFO (1) PI, LUG (-1) PI")
#' print(amrn$Group_1)
#'
#' # Generate a specific initial-state for the AMRN network
#' state1 <- generateState(amrn, "1110011011")
#'
#' # Find the original transition network (before making perturbations)
#' transNet <- findAttractors(amrn, state1)
#' print(transNet)
#'
#' # Perturb the group with overexpression mutation,
#' #  in this case only two nodes (AG, SUP) of the group are affected by the mutation.
#' perturb(amrn, 1, "overexpression")
#'
#' # Continuously perturb the group with edge-removal mutation,
#' #  in this case only two edges of the group are removed by the mutation.
#' perturb(amrn, 1, "edge removal")
#'
#' # Continuously perturb the group with "state-flip" mutation,
#' #  thus only two nodes (AG, SUP) of the group are affected by the mutation.
#' perturb(amrn, 1, "state flip")
#'
#' # Find the perturbed transition network
#' perturbed_transNet <- findAttractors(amrn, state1)
#' print(perturbed_transNet)
perturb <- function(network, groupSet, mutateMethod = "rule flip") {

  if(is.data.frame(network)) {
    network <- loadInbuiltNetwork(network)
  }

  calc <- .jnew("mod.jmut.core.Calc")
  errCode <- .jcall(calc, "Ljava/lang/String;", "perturb", as.character(network$name), as.integer(groupSet),
                        as.character(mutateMethod))

  if(is.jnull(errCode)) {
    printError(0)
    return (NULL)
  }

  if(errCode == "-2") {
    printError(2)
    return (NULL)
  }

  if(errCode == "-1") {
    printError(3)
    return (NULL)
  }

  print("Perturb the specified group successfully!")
  return (errCode)
}

#' Restore a set of node/edge groups.
#'
#' Restore a set of node/edge groups in a network.
#'
#' This function restores a set of node/edge groups in a network to its normal condition.
#' And the parameter \code{groupSet}
#' has same meaning as in the \code{\link{calSensitivity}} function.
#'
#' @export
#' @seealso \code{\link{perturb}}, \code{\link{generateGroups}}, \code{\link{generateGroup}}, \code{\link{calSensitivity}}, \code{\link{findAttractors}}
#' @name restore
#' @param network The network contains the node/edge groups
#' @param groupSet The indexing number of node/edge groups in the network
#' @return None. Error messages or information would be outputed to the screen.
#' @usage
#' restore(network, groupSet)
#' @examples
#' data(amrn)
#' # Generate a group of two nodes in the AMRN network
#' amrn <- generateGroup(amrn, nodes = "AG, SUP")
#' print(amrn$Group_1)
#'
#' # Generate a specific initial-state for the AMRN network
#' state1 <- generateState(amrn, "1110011011")
#'
#' # Find the original transition network (before making perturbations)
#' transNet <- findAttractors(amrn, state1)
#' print(transNet)
#'
#' # Perturb the group with overexpression mutation
#' perturb(amrn, 1, "overexpression")
#'
#' # Continuously perturb the group with "state-flip" mutation
#' perturb(amrn, 1, "state flip")
#'
#' # Find the perturbed transition network
#' perturbed_transNet <- findAttractors(amrn, state1)
#' print(perturbed_transNet)
#'
#' # Restore the group from previous mutations
#' restore(amrn, 1)
#'
#' # Find again the original transition network, it should be same with the "transNet" network
#' origin_transNet <- findAttractors(amrn, state1)
#' print(origin_transNet)
restore <- function(network, groupSet) {

  if(is.data.frame(network)) {
    network <- loadInbuiltNetwork(network)
  }

  calc <- .jnew("mod.jmut.core.Calc")
  errCode <- .jcall(calc, "Ljava/lang/String;", "restore", as.character(network$name), as.integer(groupSet))

  if(is.jnull(errCode)) {
    printError(0)
    return (NULL)
  }

  if(errCode == "-2") {
    printError(2)
    return (NULL)
  }

  if(errCode == "-1") {
    printError(3)
    return (NULL)
  }

  print("Restore the specified group successfully!")
  return (errCode)
}

#' Generate a default set of update-rules.
#'
#' Generate a default set of update-rules for a network.
#'
#' This function generates a default set of update-rules for a network.
#' The rules would be used to analyze the dynamics of the examined network, for ex., calculating sensitivity, searching attractors.
#' The type of random update-rules can be specified by the parameter \code{ruleType}:
#' 0 means only Conjunction rules, 1 means only Disjunction rules and 2 means random Nested Canalyzing rules.
#'
#' @export
#' @seealso \code{\link{findAttractors}}, \code{\link{perturb}}, \code{\link{restore}}
#' @name generateRule
#' @param network The network used for the generation
#' @param ruleType Type of random update-rules, default is 0
#' @return The string "ok" if success, otherwise NULL object
#' @usage
#' generateRule(network, ruleType = 0L)
#' @examples
#' data(amrn)
#' # Generate a set of random Nested Canalyzing rules
#' generateRule(amrn, 2)
#'
#' # Generate a specific initial-state for the AMRN network
#' state1 <- generateState(amrn, "1110011011")
#'
#' att <- findAttractors(amrn, state1)
#' print(att)

generateRule <- function(network, ruleType = 0L) {

  if(is.data.frame(network)) {
    network <- loadInbuiltNetwork(network)
  }

  netData <- .jnew("mod.jmut.core.comp.NetData")
  errCode <- .jcall(netData, "Ljava/lang/String;", "generateCurrentRule", as.character(network$name), as.integer(ruleType))

  if(is.jnull(errCode)) {
    printError(0)
    return (NULL)
  }

  if(errCode == "-1") {
    printGeneralError()
    return (NULL)
  }

  print("Generate a default set of update-rules successfully!")
  return (errCode)
}

#' Initialize the Java Virtual Machine.
#'
#' \code{initJVM} initializes the Java Virtual Machine (JVM).
#' This function must be called before any RMut functions can be used.
#'
#' This function initializes the JVM with a parameter of the maximum Java heap size \code{maxHeapSize}.
#' The parameter is a string composed of a number and followed by a letter K, or M, or G
#' (K indicates kilobytes, M indicates megabytes, G indicates gigabytes).
#' @export
#' @seealso \code{\link{setOpencl}}, \code{\link{showOpencl}}
#' @name initJVM
#' @param maxHeapSize The maximum Java heap size. Default is "1G" (means 1 gigabytes).
#' @return TRUE denotes successful initialization, and FALSE indicates failure.
#' @usage
#' initJVM(maxHeapSize)
#' @examples
#' initJVM("1G")
#'
initJVM <- function(maxHeapSize = "1G") {
  jvm_heap <- paste("-Xmx", maxHeapSize, sep = "", collapse = "")

  ret <- .jinit(parameters=jvm_heap)
  if(ret != 0) {
    printError(4)
    return (FALSE)
  }

  ret <- .jpackage("RMut", lib.loc = RMut_libname)
  if(ret != TRUE) {
    printError(4)
    return (FALSE)
  }

  print("The Java Virtual Machine is successfully initialized!")
  return (TRUE)
}
