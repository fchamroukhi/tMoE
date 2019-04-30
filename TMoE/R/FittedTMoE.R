FittedTMoE <- setRefClass(
  "FittedTMoE",
  fields = list(
    modelTMoE = "ModelTMoE",
    paramTMoE = "ParamTMoE",
    statTMoE = "StatTMoE"
  ),
  methods = list(
    plot = function() {
      plot.default(modelTMoE$X, modelTMoE$Y, pch = "+", ylab = "y", xlab = "x")
      for (k in 1:modelTMoE$K) {
        lines(modelTMoE$X, statTMoE$Ey_k[, k], lty = "dotted", col = "red")
      }
      lines(modelTMoE$X, statTMoE$Ey, lwd = 2, col = "red")


      couleur = rainbow(modelTMoE$K)
      plot.default(modelTMoE$X, statTMoE$piik[, 1], type = "l", ylab = "Mixing probabilities", xlab = "x", col = couleur[1])
      for (k in 2:modelTMoE$K) {
        lines(modelTMoE$X, statTMoE$piik[, k], col = couleur[k])
      }

    }
  )
)

FittedTMoE <- function(modelTMoE, paramTMoE, statTMoE) {
  new("FittedTMoE", modelTMoE = modelTMoE, paramTMoE = paramTMoE, statTMoE = statTMoE)
}
