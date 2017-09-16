
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



extractInfos <- function(infos, numNodeFields, numEdgeFields, numNetwFields = 0L) {
  no_nodes <- as.integer(infos[1])
  no_edges <- as.integer(infos[2])

  list_data <- list(no_nodes, no_edges)
  list_index <- 3

  if(numNodeFields > 0) {
    for(i in 0:(numNodeFields - 1)) {
      fields <- infos[(3 + i*no_nodes):((i + 1)*no_nodes + 2)]
      list_data[[list_index]] <- fields
      list_index <- list_index + 1
    }
  }

  index <- numNodeFields*no_nodes + 3
  if(numEdgeFields > 0) {
    for(i in 0:(numEdgeFields - 1)) {
      fields <- infos[(index + i*no_edges):((i + 1)*no_edges + index - 1)]
      list_data[[list_index]] <- fields
      list_index <- list_index + 1
    }
  }

  index <- numNodeFields*no_nodes + 3 + numEdgeFields*no_edges
  if(numNetwFields > 0) {
    for(i in 0:(numNetwFields - 1)) {
      list_data[[list_index]] <- infos[index + i]
      list_index <- list_index + 1
    }
  }

  return(list_data)
}

# Exports the network
exportNetwork <- function(network) {
  edgeIDs <- network$edges$EdgeID

  for(i in 1:length(edgeIDs)) {
    s <- edgeIDs[i]
    s <- gsub(" \\(", "\t", s)
    s <- gsub("\\) ", "\t", s)
    edgeIDs[i] <- s
  }

  filename <- paste(network$name, ".sif", sep = "", collapse = "")
  write.table(edgeIDs, filename, row.names = FALSE, col.names = FALSE, quote = FALSE)
  return (filename)
}

#' Exports all node/edge/network attributes of a network or a set of networks.
#'
#' \code{output} writes all node/edge/network attributes of a network or a set of networks into CSV files.
#'
#' This function writes all node/edge/network attributes of a network or a set of networks into CSV files.
#' For each network, the function exports all data frames of the network object containing
#' structural attributes of the nodes/edges/network and sensitivity values of mutated groups.
#'
#' The CSV files were outputed with names as follows: \strong{\code{[network name]}_out_\code{[data-frame name]}.csv}.
#' The structure of these networks are also exported as Tab-separated values text files (.SIF extension).
#'
#' @export
#' @seealso \code{\link{loadNetwork}}, \code{\link{createRBNs}}
#' @name output
#' @param networks The network or the set of networks
#' @usage
#' output(networks)
#' @examples
#' data(amrn)
#' # Generate all possible initial-states each containing 10 Boolean nodes
#' set1 <- generateStates(10, "all")
#'
#' # Generate all possible groups each containing a single node in the AMRN network
#' amrn <- generateGroups(amrn, "all", 1, 0)
#' amrn <- calSensitivity(amrn, set1, "knockout")
#'
#' output(amrn)

output <- function(networks) {
  pathFiles <- paste("All output files get created in the working directory:", sep = "", collapse = "")
  print(pathFiles)
  print(getwd())

  if(isSingleNetwork(networks)) {
      output1(networks, networks$name, TRUE, FALSE)
  }
  else if(isListNetworks(networks)) {
      numNetworks <- length(networks)
      networkName <- networks[[1]]$name
      output1(networks[[1]], networkName, TRUE, FALSE)

      for(i in 2:numNetworks) {
        output1(networks[[i]], networkName, FALSE, TRUE)
      }
  }
}

output1 <- function(network, networkName, doColNames, doAppend) {
  # if(network$transitionNetwork == TRUE) {
    filename <- exportNetwork(network)
    # pathFiles <- paste("The transition network file '", filename, "' gets created in the working directory:",
    #                    sep = "", collapse = "")
    # print(pathFiles)
    # print(getwd())
  # }

  # write.table(network$nodes, paste(networkName, "_out_nodes.csv", sep = "", collapse = ""), sep = ",", row.names = FALSE, col.names = doColNames, append = doAppend)
  # write.table(network$edges, paste(networkName, "_out_edges.csv", sep = "", collapse = ""), sep = ",", row.names = FALSE, col.names = doColNames, append = doAppend)
  #
  # if(network$transitionNetwork == FALSE) {
  #   write.table(network$network, paste(networkName, "_out_net.csv", sep = "", collapse = ""), sep = ",", row.names = FALSE, col.names = doColNames, append = doAppend)
  # }

  for(name in names(network)) {
    if(is.data.frame(network[[name]]) && nrow(network[[name]]) > 0 && ncol(network[[name]]) > 1) {
      write.table(network[[name]], paste(networkName, "_out_", name, ".csv", sep = "", collapse = ""), sep = ",", row.names = FALSE, col.names = doColNames, append = doAppend)
    }
  }

}

