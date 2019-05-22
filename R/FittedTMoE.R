FittedTMoE <- setRefClass(
  "FittedTMoE",
  fields = list(
    modelTMoE = "ModelTMoE",
    paramTMoE = "ParamTMoE",
    statTMoE = "StatTMoE"
  ),
  methods = list(
    plot = function() {

      plot.default(modelTMoE$X, modelTMoE$Y, ylab = "y", xlab = "x", cex = 0.7, pch = 3)
      title(main = "Estimated mean and experts")
      for (k in 1:modelTMoE$K) {
        lines(modelTMoE$X, statTMoE$Ey_k[, k], col = "red", lty = "dotted", lwd = 1.5)
      }
      lines(modelTMoE$X, statTMoE$Ey, col = "red", lwd = 1.5)


      colorsvec = rainbow(modelTMoE$K)
      plot.default(modelTMoE$X, statTMoE$piik[, 1], type = "l", xlab = "x", ylab = "Mixing probabilities", col = colorsvec[1])
      title(main = "Mixing probabilities")
      for (k in 2:modelTMoE$K) {
        lines(modelTMoE$X, statTMoE$piik[, k], col = colorsvec[k])
      }

      # Data, Estimated mean functions and 2*sigma confidence regions
      plot.default(modelTMoE$X, modelTMoE$Y, ylab = "y", xlab = "x", cex = 0.7, pch = 3)
      title(main = "Estimated mean and confidence regions")
      lines(modelTMoE$X, statTMoE$Ey, col = "red", lwd = 1.5)
      lines(modelTMoE$X, statTMoE$Ey - 2 * sqrt(statTMoE$Vary), col = "red", lty = "dotted", lwd = 1.5)
      lines(modelTMoE$X, statTMoE$Ey + 2 * sqrt(statTMoE$Vary), col = "red", lty = "dotted", lwd = 1.5)

      # Obtained partition
      plot.default(modelTMoE$X, modelTMoE$Y, ylab = "y", xlab = "x", cex = 0.7, pch = 3)
      title(main = "Estimated experts and clusters")
      for (k in 1:modelTMoE$K) {
        lines(modelTMoE$X, statTMoE$Ey_k[, k], col = colorsvec[k], lty = "dotted", lwd = 1.5)
      }
      for (k in 1:modelTMoE$K) {
        index <- statTMoE$klas == k
        points(modelTMoE$X[index], modelTMoE$Y[index, ], col = colorsvec[k], cex = 0.7, pch = 3)
      }

      # Observed data log-likelihood
      plot.default(unlist(statTMoE$stored_loglik), type = "l", col = "blue", xlab = "EM iteration number", ylab = "Observed data log-likelihood")
      title(main = "Log-Likelihood")

    }
  )
)

FittedTMoE <- function(modelTMoE, paramTMoE, statTMoE) {
  new("FittedTMoE", modelTMoE = modelTMoE, paramTMoE = paramTMoE, statTMoE = statTMoE)
}
