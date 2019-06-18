#' A Reference Class which represents a fitted TMoE model.
#'
#' ModelMRHLP represents a [TMoE][ModelTMoE] model for which parameters have
#' been estimated.
#'
#' @usage NULL
#' @field paramTMoE A [ParamTMoE][ParamTMoE] object. It contains the estimated values of the parameters.
#' @field statTMoE A [StatTMoE][StatTMoE] object. It contains all the statistics associated to the TMoE model.
#' @seealso [ParamTMoE], [StatTMoE]
#' @export
ModelTMoE <- setRefClass(
  "ModelTMoE",
  fields = list(
    paramTMoE = "ParamTMoE",
    statTMoE = "StatTMoE"
  ),
  methods = list(
    plot = function() {

      plot.default(paramTMoE$fData$X, paramTMoE$fData$Y, ylab = "y", xlab = "x", cex = 0.7, pch = 3)
      title(main = "Estimated mean and experts")
      for (k in 1:paramTMoE$K) {
        lines(paramTMoE$fData$X, statTMoE$Ey_k[, k], col = "red", lty = "dotted", lwd = 1.5)
      }
      lines(paramTMoE$fData$X, statTMoE$Ey, col = "red", lwd = 1.5)


      colorsvec = rainbow(paramTMoE$K)
      plot.default(paramTMoE$fData$X, statTMoE$piik[, 1], type = "l", xlab = "x", ylab = "Mixing probabilities", col = colorsvec[1])
      title(main = "Mixing probabilities")
      for (k in 2:paramTMoE$K) {
        lines(paramTMoE$fData$X, statTMoE$piik[, k], col = colorsvec[k])
      }

      # Data, Estimated mean functions and 2*sigma confidence regions
      plot.default(paramTMoE$fData$X, paramTMoE$fData$Y, ylab = "y", xlab = "x", cex = 0.7, pch = 3)
      title(main = "Estimated mean and confidence regions")
      lines(paramTMoE$fData$X, statTMoE$Ey, col = "red", lwd = 1.5)
      lines(paramTMoE$fData$X, statTMoE$Ey - 2 * sqrt(statTMoE$Vary), col = "red", lty = "dotted", lwd = 1.5)
      lines(paramTMoE$fData$X, statTMoE$Ey + 2 * sqrt(statTMoE$Vary), col = "red", lty = "dotted", lwd = 1.5)

      # Obtained partition
      plot.default(paramTMoE$fData$X, paramTMoE$fData$Y, ylab = "y", xlab = "x", cex = 0.7, pch = 3)
      title(main = "Estimated experts and clusters")
      for (k in 1:paramTMoE$K) {
        lines(paramTMoE$fData$X, statTMoE$Ey_k[, k], col = colorsvec[k], lty = "dotted", lwd = 1.5)
      }
      for (k in 1:paramTMoE$K) {
        index <- statTMoE$klas == k
        points(paramTMoE$fData$X[index], paramTMoE$fData$Y[index, ], col = colorsvec[k], cex = 0.7, pch = 3)
      }

      # Observed data log-likelihood
      plot.default(unlist(statTMoE$stored_loglik), type = "l", col = "blue", xlab = "EM iteration number", ylab = "Observed data log-likelihood")
      title(main = "Log-Likelihood")

    }
  )
)
