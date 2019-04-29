source("R/utils.R")
source("R/IRLS.R")

ParamTMoE <- setRefClass(
  "ParamTMoE",
  fields = list(
    alpha = "matrix",
    beta = "matrix",
    sigma = "matrix",
    delta = "matrix"
  ),
  methods = list(
    initParam = function(modelTMoE, phiAlpha, phiBeta, try_EM, segmental = FALSE) {
      alpha <<- matrix(runif((modelTMoE$q + 1) * (modelTMoE$K - 1)), nrow = modelTMoE$q + 1, ncol = modelTMoE$K - 1) #initialisation aléatoire du vercteur param�tre du IRLS

      #Initialise the regression parameters (coeffecients and variances):
      if (segmental == FALSE) {
        Zik <- zeros(modelTMoE$n, modelTMoE$K)

        klas <- floor(modelTMoE$K * matrix(runif(modelTMoE$n), modelTMoE$n)) + 1

        Zik[klas %*% ones(1, modelTMoE$K) == ones(modelTMoE$n, 1) %*% seq(modelTMoE$K)] <- 1

        Tauik <- Zik

        #beta <<- matrix(0, modelRHLP$p + 1, modelRHLP$K)
        #sigma <<- matrix(0, modelRHLP$K)

        for (k in 1:modelTMoE$K) {
          Xk <- phiBeta$XBeta * (sqrt(Tauik[, k] %*% ones(1, modelTMoE$p + 1)))
          yk <- modelTMoE$Y * sqrt(Tauik[, k])

          beta[, k] <<- solve(t(Xk) %*% Xk) %*% t(Xk) %*% yk

          sigma[k] <<- sum(Tauik[, k] * ((modelTMoE$Y - phiBeta$XBeta %*% beta[, k]) ^ 2)) / sum(Tauik[, k])
        }
      }
      else{
        #segmental : segment uniformly the data and estimate the parameters
        nk <- round(modelTMoE$n / modelTMoE$K) - 1

        for (k in 1:modelTMoE$K) {
          i <- (k - 1) * nk + 1
          j <- (k * nk)
          yk <- matrix(modelTMoE$Y[i:j])
          Xk <- phiBeta$XBeta[i:j,]

          beta[, k] <<- solve(t(Xk) %*% Xk) %*% (t(Xk) %*% yk)

          muk <- Xk %*% beta[, k]

          sigma[k] <<- t(yk - muk) %*% (yk - muk) / length(yk)
        }
      }

      if (try_EM == 1) {
        alpha <<- zeros(modelTMoE$q + 1, modelTMoE$K - 1)
      }

      # Initialize the skewness parameter Lambdak (by equivalence delta)
      delta <<- 50 * rand(1, modelTMoE$K)

    },

    MStep = function(modelTMoE, statTMoE, phiAlpha, phiBeta, verbose_IRLS) {
      # M-Step

      res_irls <- IRLS(tauijk = statTMoE$tik, phiW = phiAlpha$XBeta, Wg_init = alpha, verbose_IRLS = verbose_IRLS)
      statTMoE$piik <- res_irls$piik
      reg_irls <- res_irls$reg_irls

      alpha <<- res_irls$W

      for (k in 1:modelTMoE$K) {
        #update the regression coefficients

        Xbeta <- phiBeta$XBeta * (sqrt(statTMoE$tik[,k] * statTMoE$Wik[,k] ) * ones(1, modelTMoE$p+1))
        yk <- modelTMoE$Y * sqrt(statTMoE$tik[,k] * statTMoE$Wik[,k])

        #update the regression coefficients
        beta[, k] <<- solve((t(Xbeta) %*% Xbeta)) %*% (t(tauik_Xbeta) %*% yk)

        # update the variances sigma2k
        sigma[k] <<- sum(statTMoE$tik[, k] * statTMoE$Wik[,k] * ((modelTMoE$Y - phiBeta$XBeta %*% beta[, k])^2)) / sum(statTMoE$tik[,k])

        # if ECM (use an additional E-Step with the updatated betak and sigma2k
        dik <- (modelTMoE$Y - phiBeta$XBeta %*% beta[, k]) / sqrt(sigma[k])


        # update the deltak (the skewness parameter)
        delta[k] <<- uniroot(f <- function(dlt) {
          sigma[k] * dlt * (1 - dlt ^ 2) * sum(statTMoE$tik[, k]) + (1 + dlt ^ 2) * sum(statTMoE$tik[, k] * (modelTMoE$Y - phiBeta$XBeta %*% beta[, k]) * statTMoE$E1ik[, k])
          - dlt * sum(statTMoE$tik[, k] * (statTMoE$E2ik[, k] + (modelTMoE$Y - phiBeta$XBeta %*% beta[, k]) ^ 2))
        }, c(-1, 1))$root

        delta[k] <<- uniroot(f <- function(dlt) {
          psigamma(dlt/2) + log(dlt/2) +1 + (1/sum(statTMoE$tik[, k])) * sum(statTMoE$tik[, k] * (log(statTMoE$Wik[,k]) - statTMoE$Wik[,k]))
                                             +psigamma((delta[k] + 1)/2) - log((delta[k] + 1)/2)
        }, c(-1, 1))$root

      }

      return(reg_irls)
    }
  )
)

ParamTMoE <- function(modelTMoE) {
  alpha <- matrix(0, modelTMoE$q + 1, modelTMoE$K - 1)
  beta <- matrix(NA, modelTMoE$p + 1, modelTMoE$K)
  sigma <- matrix(NA, 1, modelTMoE$K)
  delta <- matrix(NA, modelTMoE$K)
  new("ParamTMoE", alpha = alpha, beta = beta, sigma = sigma, delta = delta)
}
