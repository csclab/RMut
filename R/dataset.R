
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



#' Arabidopsis morphogenesis regulatory network.
#'
#' The Arabidopsis morphogenesis regulatory network (AMRN) with 10 nodes and 22 links.
#' This regulatory network is known to robustly control the process of flower development.
#'
#' @usage
#' data(amrn)
#' @format A data frame with 22 rows and 3 variables:
#' \describe{
#'   \item{\code{Source}}{the identifier of the source node}
#'   \item{\code{Interaction}}{interaction type of the edge}
#'   \item{\code{Target}}{the identifier of the target node}
#'   ...
#' }
#' @source \url{http://www.ncbi.nlm.nih.gov/pubmed/10487867}
"amrn"

#' Cell differentiation regulatory network.
#'
#' The cell differentiation regulatory network (CDRN) with 9 nodes and 15 links.
#' CDRN has seven positive and two negative FBLs is found to robustly
#' induce quiescence, terminal differentiation, and apoptosis.
#'
#' @usage
#' data(cdrn)
#' @format A data frame with 15 rows and 3 variables:
#' \describe{
#'   \item{\code{Source}}{the identifier of the source node}
#'   \item{\code{Interaction}}{interaction type of the edge}
#'   \item{\code{Target}}{the identifier of the target node}
#'   ...
#' }
#' @source \url{http://www.ncbi.nlm.nih.gov/pubmed/11082279}
"cdrn"

#' Cell cycle pathway of the species Homo sapiens.
#'
#' The cell cycle pathway of the species Homo sapiens (CCHS) with 161 nodes and 223 links.
#' The cell cycle is the series of events that takes place in a cell
#' leading to its division and duplication (replication).
#'
#' @usage
#' data(cchs)
#' @format A data frame with 223 rows and 3 variables:
#' \describe{
#'   \item{\code{Source}}{the identifier of the source node}
#'   \item{\code{Interaction}}{interaction type of the edge}
#'   \item{\code{Target}}{the identifier of the target node}
#'   ...
#' }
#' @source \url{https://www.ncbi.nlm.nih.gov/pubmed/9733515}
"cchs"

#' Canonical cell signaling network.
#'
#' The canonical cell signaling network (CCSN) with 771 nodes and 1633 links.
#' The network was obtained from \url{http://stke.sciencemag.org/}, and all the neutral interactions were excluded.
#'
#' @usage
#' data(ccsn)
#' @format A data frame with 1633 rows and 3 variables:
#' \describe{
#'   \item{\code{Source}}{the identifier of the source node}
#'   \item{\code{Interaction}}{interaction type of the edge}
#'   \item{\code{Target}}{the identifier of the target node}
#'   ...
#' }
#' @source \url{http://bioinformatics.oxfordjournals.org/content/24/17/1926.long}
"ccsn"

#' Human signaling network.
#'
#' The large-scale human signaling network (HSN) with 1192 nodes and 3102 links.
#' Based on the network, some general principles were provided for understanding protein evolution in the context of signaling networks.
#'
#' @usage
#' data(hsn)
#' @format A data frame with 3102 rows and 3 variables:
#' \describe{
#'   \item{\code{Source}}{the identifier of the source node}
#'   \item{\code{Interaction}}{interaction type of the edge}
#'   \item{\code{Target}}{the identifier of the target node}
#'   ...
#' }
#' @source \url{http://www.ncbi.nlm.nih.gov/pubmed/19226461}
"hsn"

