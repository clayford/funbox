#' Confidence ellipse for multivariate multiple regression models
#'
#' Function that plots a confidence ellipse for two responses in a  multivariate multiple regression model fitted with \code{lm}. The ellipse is created using the \code{ellipse} function from the car package.
#'
#' @param mod The fitted \code{lm} model object
#' @param newdata A required data frame in which to look for variables with which to predict.
#' @param level The confidence level. Default is 0.95
#' @param ggplot logical indicating if plot should be created using ggplot2. Default is TRUE. Other plot is created with base graphics.
#'
#' @returns A plot with one response on the x-axis and the other on the y-axis, with a single point representing the predicted mean values for both responses and an ellipse indicating the uncertainty in the prediction.
#'
#' @importFrom graphics points
#' @importFrom stats delete.response model.frame model.matrix na.pass predict qf resid terms
#' @export
#'
#' @references Johnson R and Wichern D (2007). Applied Multivariate Statistical Analysis, Sixth Edition. Prentice-Hall. (page 399)
#'
#' Fox J, Weisberg S (2019). _An R Companion to Applied Regression_, Third edition. Sage, Thousand Oaks CA. <https://www.john-fox.ca/Companion/>.
#'
#' @examples
#' m <- lm(cbind(TOT, AMI) ~ GEN + AMT, data = ami)
#' nd <- data.frame(GEN = 1, AMT = 1200)
#' confidence_ellipse(mod = m, newdata = nd)
#'
confidence_ellipse <- function(mod, newdata, level = 0.95, ggplot = TRUE){
  # labels
  lev_lbl <- paste0(level * 100, "%")
  resps <- colnames(mod$coefficients)
  title <- paste(lev_lbl, "confidence ellipse for", resps[1], "and", resps[2])

  # prediction
  p <- predict(mod, newdata)

  # center of ellipse
  cent <- c(p[1,1],p[1,2])

  # shape of ellipse
  Z <- model.matrix(mod)
  Y <- mod$model[[1]]
  n <- nrow(Y)
  m <- ncol(Y)
  r <- ncol(Z) - 1
  S <- crossprod(resid(mod))/(n-r-1)

  # radius of circle generating the ellipse
  # see Johnson and Wichern (2007), p. 399
  tt <- terms(mod)
  Terms <- delete.response(tt)
  mf <- model.frame(Terms, newdata, na.action = na.pass,
                    xlev = mod$xlevels)
  z0 <- model.matrix(Terms, mf, contrasts.arg = mod$contrasts)
  rad <- sqrt((m*(n-r-1)/(n-r-m)) * qf(level,m,n-r-m) *
                z0 %*% solve(t(Z)%*%Z) %*% t(z0))

  # generate ellipse using ellipse function in car package
  ell_points <- car::ellipse(center = c(cent), shape = S,
                             radius = c(rad), draw = FALSE)

  # ggplot2 plot
  if(ggplot){
    ell_points_df <- as.data.frame(ell_points)
    ggplot2::ggplot(ell_points_df, ggplot2::aes(.data[["x"]], .data[["y"]])) +
      ggplot2::geom_path() +
      ggplot2::geom_point(ggplot2::aes(x = .data[[resps[1]]],
                                       y = .data[[resps[2]]]),
                          data = data.frame(p)) +
      ggplot2::labs(x = resps[1], y = resps[2],
                    title = title)
  } else {
    # base R plot
    plot(ell_points, type = "l",
         xlab = resps[1], ylab = resps[2],
         main = title)
    points(x = cent[1], y = cent[2])
  }
}
