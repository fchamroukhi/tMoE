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
    plot = function(what = c("meancurve", "confregions", "clusters", "loglikelihood")) {

      what <- match.arg(what, several.ok = TRUE)

      oldpar <- par()[c("mfrow", "mai", "mgp")]
      on.exit(par(oldpar), add = TRUE)

      colorsvec = rainbow(paramTMoE$K)

      if (any(what == "meancurve")) {
        par(mfrow = c(2, 1), mai = c(0.6, 1, 0.5, 0.5), mgp = c(2, 1, 0))
        plot.default(paramTMoE$fData$X, paramTMoE$fData$Y, ylab = "y", xlab = "x", cex = 0.7, pch = 3)
        title(main = "Estimated mean and experts")
        for (k in 1:paramTMoE$K) {
          lines(paramTMoE$fData$X, statTMoE$Ey_k[, k], col = "red", lty = "dotted", lwd = 1.5)
        }
        lines(paramTMoE$fData$X, statTMoE$Ey, col = "red", lwd = 1.5)

        plot.default(paramTMoE$fData$X, statTMoE$piik[, 1], type = "l", xlab = "x", ylab = "Mixing probabilities", col = colorsvec[1])
        title(main = "Mixing probabilities")
        for (k in 2:paramTMoE$K) {
          lines(paramTMoE$fData$X, statTMoE$piik[, k], col = colorsvec[k])
        }
      }

      if (any(what == "confregions")) {
        # Data, Estimated mean functions and 2*sigma confidence regions
        par(mfrow = c(1, 1), mai = c(0.6, 1, 0.5, 0.5), mgp = c(2, 1, 0))
        plot.default(paramTMoE$fData$X, paramTMoE$fData$Y, ylab = "y", xlab = "x", cex = 0.7, pch = 3)
        title(main = "Estimated mean and confidence regions")
        lines(paramTMoE$fData$X, statTMoE$Ey, col = "red", lwd = 1.5)
        lines(paramTMoE$fData$X, statTMoE$Ey - 2 * sqrt(statTMoE$Vary), col = "red", lty = "dotted", lwd = 1.5)
        lines(paramTMoE$fData$X, statTMoE$Ey + 2 * sqrt(statTMoE$Vary), col = "red", lty = "dotted", lwd = 1.5)
      }

      if (any(what == "clusters")) {
        # Obtained partition
        par(mfrow = c(1, 1), mai = c(0.6, 1, 0.5, 0.5), mgp = c(2, 1, 0))
        plot.default(paramTMoE$fData$X, paramTMoE$fData$Y, ylab = "y", xlab = "x", cex = 0.7, pch = 3)
        title(main = "Estimated experts and clusters")
        for (k in 1:paramTMoE$K) {
          lines(paramTMoE$fData$X, statTMoE$Ey_k[, k], col = colorsvec[k], lty = "dotted", lwd = 1.5)
        }
        for (k in 1:paramTMoE$K) {
          index <- statTMoE$klas == k
          points(paramTMoE$fData$X[index], paramTMoE$fData$Y[index, ], col = colorsvec[k], cex = 0.7, pch = 3)
        }
      }

      if (any(what == "loglikelihood")) {
        # Observed data log-likelihood
        par(mfrow = c(1, 1), mai = c(0.6, 1, 0.5, 0.5), mgp = c(2, 1, 0))
        plot.default(unlist(statTMoE$stored_loglik), type = "l", col = "blue", xlab = "EM iteration number", ylab = "Observed data log-likelihood")
        title(main = "Log-Likelihood")
      }

    }
  )
)
